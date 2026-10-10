"""Toil accounting and capacity projection."""
from dataclasses import dataclass


@dataclass
class Toil:
    task: str
    per_occurrence_minutes: float
    occurrences_per_week: float

    @property
    def weekly_cost_minutes(self) -> float:
        return self.per_occurrence_minutes * self.occurrences_per_week


def rank_toil(items: list[Toil]) -> list[Toil]:
    return sorted(items, key=lambda t: t.weekly_cost_minutes, reverse=True)


def weeks_until_capacity_reached(
    current_demand: float, weekly_growth_rate: float, capacity: float
) -> float:
    weeks = 0.0
    demand = current_demand
    while demand < capacity:
        demand *= (1 + weekly_growth_rate)
        weeks += 1
    return weeks


if __name__ == "__main__":
    toil = [
        Toil("manual cert rotation", per_occurrence_minutes=45, occurrences_per_week=0.25),
        Toil("clear stuck job queue", per_occurrence_minutes=10, occurrences_per_week=12),
        Toil("manual staging refresh", per_occurrence_minutes=30, occurrences_per_week=2),
    ]
    for t in rank_toil(toil):
        print(f"{t.weekly_cost_minutes:6.1f} min/wk  {t.task}")
    w = weeks_until_capacity_reached(current_demand=6000, weekly_growth_rate=0.05, capacity=10000)
    print(f"\n~{w:.0f} weeks until demand meets capacity; add headroom before then")
