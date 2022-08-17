from enum import IntEnum


# Zero-based auto enum
class AutoEnum(IntEnum):
    def _generate_next_value_(name, start, count, last_values):
        for last_value in reversed(last_values):
            try:
                return last_value + 1
            except TypeError:
                pass
        else:
            return 0
