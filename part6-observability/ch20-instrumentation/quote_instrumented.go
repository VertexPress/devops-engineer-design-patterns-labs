package quote

import (
	"context"
	"log/slog"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/metric"
)

var (
	tracer   = otel.Tracer("quote-service")
	meter    = otel.Meter("quote-service")
	reqCount metric.Int64Counter // registered at startup; see lab setup
)

// HandleQuote emits a trace span, a low-cardinality metric, and a structured
// log correlated by trace id.
func HandleQuote(ctx context.Context, req Request) (Quote, error) {
	ctx, span := tracer.Start(ctx, "HandleQuote")
	defer span.End()

	q, err := price(ctx, req)

	reqCount.Add(ctx, 1, metric.WithAttributes(
		attribute.String("route", "quote"),
		attribute.String("outcome", outcome(err)),
	))

	if err != nil {
		slog.ErrorContext(ctx, "quote failed",
			"route", "quote",
			"trace_id", span.SpanContext().TraceID().String(),
			"error", err.Error(),
		)
	}
	return q, err
}
