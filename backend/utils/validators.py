# backend/utils/validators.py

import re

def is_valid_isbn(isbn):
    """
    Validates ISBN-10 or ISBN-13.
    """
    if not isbn:
        return False
    isbn = isbn.replace("-", "").replace(" ", "")
    if len(isbn) == 10:
        # ISBN-10 checksum
        total = 0
        for i, char in enumerate(isbn):
            if char.upper() == 'X' and i == 9:
                value = 10
            elif char.isdigit():
                value = int(char)
            else:
                return False
            total += value * (10 - i)
        return total % 11 == 0
    elif len(isbn) == 13:
        # ISBN-13 checksum
        total = 0
        for i, char in enumerate(isbn):
            if not char.isdigit():
                return False
            factor = 1 if i % 2 == 0 else 3
            total += int(char) * factor
        return total % 10 == 0
    else:
        return False

def is_positive_number(value):
    """
    Checks if value is a positive integer or float.
    """
    try:
        return float(value) > 0
    except (ValueError, TypeError):
        return False

def is_non_negative_integer(value):
    """
    Checks if value is an integer >= 0 (e.g., stock or quantity).
    """
    try:
        return int(value) >= 0
    except (ValueError, TypeError):
        return False

def is_non_empty_string(value):
    return isinstance(value, str) and bool(value.strip())