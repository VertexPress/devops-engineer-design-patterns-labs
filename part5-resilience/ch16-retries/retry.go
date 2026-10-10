package client

import (
	"context"
	"math/rand"
	"time"
)

type RetryBudget struct {
	ratio  float64
	tokens chan struct{}
}

func Call(ctx context.Context, b *RetryBudget, do func(context.Context) error) error {
	const maxAttempts = 3
	base := 50 * time.Millisecond

	var err error
	for attempt := 0; attempt < maxAttempts; attempt++ {
		tryCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
		err = do(tryCtx)
		cancel()
		if err == nil || !retryable(err) {
			return err
		}
		if attempt == maxAttempts-1 || !b.allow() {
			return err
		}
		backoff := base * (1 << attempt)
		sleep := time.Duration(rand.Int63n(int64(backoff)))
		select {
		case <-time.After(sleep):
		case <-ctx.Done():
			return ctx.Err()
		}
	}
	return err
}
