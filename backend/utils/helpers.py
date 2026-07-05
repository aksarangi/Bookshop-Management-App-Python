# backend/utils/helpers.py

from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP

def format_date(dt, fmt="%Y-%m-%d %H:%M:%S"):
    """
    Converts a datetime object to a formatted string.
    """
    if not dt:
        return None
    return dt.strftime(fmt)

def round_price(value, precision=2):
    """
    Rounds a price to 2 decimal places by default.
    """
    try:
        return float(Decimal(value).quantize(Decimal(f"1.{'0'*precision}"), rounding=ROUND_HALF_UP))
    except Exception:
        return 0.0

def safe_get(dct, key, default=None):
    """
    Safely gets a value from a dict, returns default if key not present.
    """
    if not isinstance(dct, dict):
        return default
    return dct.get(key, default)
