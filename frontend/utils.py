# frontend/utils.py
from tkinter import messagebox

# -----------------------------
# Message / Alert Helpers
# -----------------------------

def show_error(title, message):
    """Show an error popup."""
    messagebox.showerror(title, message)

# -----------------------------
# Formatting Helpers
# -----------------------------
def format_currency(value):
    """Format a float as currency string."""
    try:
        return f"₹{value:,.2f}"  # Indian Rupee formatting
    except:
        return str(value)

def truncate_text(text, length=50):
    """Shorten text for table display."""
    if text and len(text) > length:
        return text[:length] + "..."
    return text
