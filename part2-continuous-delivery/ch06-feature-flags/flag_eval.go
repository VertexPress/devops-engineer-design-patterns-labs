package quote

import "context"

// Flags is the minimal interface a flag provider must satisfy. The value is
// resolved at request time from a source outside the artifact (a config
// service, a flag platform), so flipping a flag needs no deploy.
type Flags interface {
	Enabled(ctx context.Context, key string, user User) bool
}

// Price computes a quote. The new pricing path ships inside this binary but
// stays dark until the flag is turned on. Deploying this code changes nothing
// a user sees; releasing the behavior is a separate act, flipping the flag.
func Price(ctx context.Context, flags Flags, user User, req Request) Quote {
	if flags.Enabled(ctx, "new-pricing-model", user) {
		return priceWithNewModel(req) // released only when the flag is on
	}
	return priceWithLegacyModel(req) // the default path, unchanged
}
