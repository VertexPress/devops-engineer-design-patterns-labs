package shed

import (
	"net/http"
)

type Limiter struct {
	highSlots chan struct{}
	allSlots  chan struct{}
}

func NewLimiter(total, reservedForHigh int) *Limiter {
	return &Limiter{
		highSlots: make(chan struct{}, reservedForHigh),
		allSlots:  make(chan struct{}, total),
	}
}

func (l *Limiter) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		high := priority(r) == "high"
		select {
		case l.allSlots <- struct{}{}:
			defer func() { <-l.allSlots }()
		default:
			if high {
				select {
				case l.highSlots <- struct{}{}:
					defer func() { <-l.highSlots }()
				default:
					shed(w)
					return
				}
			} else {
				shed(w)
				return
			}
		}
		next.ServeHTTP(w, r)
	})
}

func shed(w http.ResponseWriter) {
	w.Header().Set("Retry-After", "1")
	w.WriteHeader(http.StatusServiceUnavailable)
}
