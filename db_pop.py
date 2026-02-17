import csv
import random
from datetime import datetime, timedelta

# CONFIGURATION
NUM_WEEKS = 52
START_DATE = datetime(2025, 1, 1)
TARGET_REVENUE = 1_000_000
NUM_MENU_ITEMS = 20
NUM_EMPLOYEES = 8
NUM_INVENTORY_ITEMS = 25

# 3 peak sales days
PEAK_DAYS = [
    datetime(2025, 2, 14),
    datetime(2025, 7, 4),
    datetime(2025, 12, 25)
]

# HELPER FUNCTIONS
def random_time():
    hour = random.randint(10, 21)  # store hours 10AM–9PM
    minute = random.randint(0, 59)
    return hour, minute

# --- INVENTORY ---
inventory_items = []
for i in range(1, NUM_INVENTORY_ITEMS + 1):
    inventory_items.append([
        i,
        f"Ingredient_{i}",
        round(random.uniform(0.50, 5.00), 2),
        random.randint(500, 2000),
        random.randint(1, 5)
    ])

with open("inventory.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["inventoryID", "name", "cost", "inventoryNum", "useAverage"])
    writer.writerows(inventory_items)

# --- MENU (20 BOBA DRINKS) ---
drink_names = [
    "Classic Milk Tea", "Taro Milk Tea", "Matcha Milk Tea",
    "Thai Milk Tea", "Honeydew Milk Tea", "Brown Sugar Milk Tea",
    "Strawberry Milk Tea", "Mango Milk Tea", "Oolong Milk Tea",
    "Wintermelon Tea", "Passionfruit Tea", "Lychee Tea",
    "Peach Green Tea", "Coconut Milk Tea", "Almond Milk Tea",
    "Coffee Milk Tea", "Red Bean Milk Tea", "Pineapple Tea",
    "Guava Green Tea", "Caramel Milk Tea"
]

menu_items = []
# Tracker to count total units sold for each menu item
sales_tracker = {i + 1: 0 for i in range(NUM_MENU_ITEMS)}

for i in range(NUM_MENU_ITEMS):
    price = round(random.uniform(4.50, 7.50), 2)
    # [menuID, name, price, salesNum]
    menu_items.append([i + 1, drink_names[i], price, 0])

# --- MENU_ITEM (bridge table) ---
menu_item_bridge = []
bridge_id = 1
for menu_id in range(1, NUM_MENU_ITEMS + 1):
    ingredients_used = random.sample(range(1, NUM_INVENTORY_ITEMS + 1), random.randint(3, 6))
    for inv_id in ingredients_used:
        menu_item_bridge.append([bridge_id, inv_id, menu_id, random.randint(1, 3)])
        bridge_id += 1

with open("menu_item.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["ID", "inventoryID", "menuID", "itemQuantity"])
    writer.writerows(menu_item_bridge)

# --- EMPLOYEES ---
employees = []
# Tracker to count total orders processed by each employee
employee_order_tracker = {i + 1: 0 for i in range(NUM_EMPLOYEES)}

for i in range(1, NUM_EMPLOYEES + 1):
    employees.append([
        i,
        f"Employee_{i}",
        round(random.uniform(12, 20), 2),
        "Barista",
        0 # orderNum (will be updated later)
    ])

# --- ORDERS + ORDER_HISTORY ---
orders = []
order_history = []
order_id = 1
total_revenue = 0

current_date = START_DATE
end_date = START_DATE + timedelta(weeks=NUM_WEEKS)

while current_date < end_date:
    # base daily orders
    daily_orders = random.randint(150, 170)

    # boost peak days
    if any(current_date.date() == peak.date() for peak in PEAK_DAYS):
        daily_orders *= 3

    for _ in range(daily_orders):
        hour, minute = random_time()
        order_time = current_date.replace(hour=hour, minute=minute)

        employee_id = random.randint(1, NUM_EMPLOYEES)
        # Update employee tracker
        employee_order_tracker[employee_id] += 1

        num_items = random.randint(1, 3)
        selected_menu = random.sample(menu_items, num_items)

        order_total = 0
        for menu in selected_menu:
            quantity = random.randint(1, 2)
            line_total = quantity * menu[2]
            order_total += line_total

            # UPDATE SALES TRACKER FOR THE MENU ITEM
            sales_tracker[menu[0]] += quantity

            order_history.append([
                len(order_history) + 1,
                menu[0],
                order_id,
                quantity,
                menu[2]
            ])

        total_revenue += order_total

        orders.append([
            order_id,
            f"Customer_{order_id}",
            round(order_total, 2),
            employee_id,
            order_time.strftime("%Y-%m-%d %H:%M:%S")
        ])

        order_id += 1

    current_date += timedelta(days=1)

# --- FINAL SYNC: Update list values from trackers before writing ---

# Sync Sales Numbers to Menu List
for menu in menu_items:
    menu[3] = sales_tracker[menu[0]]

# Sync Order Counts to Employee List
for emp in employees:
    emp[4] = employee_order_tracker[emp[0]]

# --- WRITE FILES ---

print("Total Revenue Generated:", round(total_revenue, 2))

with open("menu.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["menuID", "name", "cost", "salesNum"])
    writer.writerows(menu_items)

with open("employee.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["employeeID", "name", "pay", "job", "orderNum"])
    writer.writerows(employees)

with open("order.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["orderID", "customerName", "costTotal", "employeeID", "orderDateTime"])
    writer.writerows(orders)

with open("order_history.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["ID", "menuID", "orderID", "quantity", "cost"])
    writer.writerows(order_history)

print("CSV files successfully generated.")