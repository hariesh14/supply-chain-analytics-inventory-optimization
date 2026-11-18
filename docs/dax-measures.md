# Power BI DAX Measures

The measures below reflect the logic implemented in the project. Confirm table and column names in your own Power BI model before copying.

## 1. Total Inventory Value

```dax
Total Inventory Value =
SUMX(
    'public inventory',
    'public inventory'[onhand_qty] *
    RELATED('public products'[unit_cost])
)
```

## 2. Total Products

```dax
Total Products =
DISTINCTCOUNT('public products'[productid])
```

## 3. Low Stock Products

```dax
Low Stock Products =
COUNTROWS(
    FILTER(
        'public inventory',
        'public inventory'[onhand_qty] <
        RELATED('public products'[reorderpoint])
    )
)
```

## 4. Products Requiring Reorder

If this measure uses the same condition as Low Stock Products, both measures will return the same count. Keep both only if they serve distinct report purposes; otherwise, consider removing the duplicate.

## 5. Suggested Reorder Quantity

```dax
Suggested Reorder Quantity =
SUMX(
    'public inventory',
    MAX(
        0,
        RELATED('public products'[target_stock]) -
        'public inventory'[onhand_qty]
    )
)
```

## 6. Total Procurement Spend

```dax
Total Procurement Spend =
SUMX(
    'public purchase_orders',
    'public purchase_orders'[orderqty] *
    'public purchase_orders'[unitcost]
)
```

## 7. Total Purchase Orders

```dax
Total Purchase Orders =
DISTINCTCOUNT('public purchase_orders'[purchaseorderid])
```

## 8. On-Time Delivery %

```dax
On-Time Delivery % =
DIVIDE(
    CALCULATE(
        COUNTROWS('public purchase_orders'),
        FILTER(
            'public purchase_orders',
            'public purchase_orders'[receiveddate] <=
            'public purchase_orders'[promiseddate]
        )
    ),
    COUNTROWS('public purchase_orders'),
    0
)
```

Format this measure as Percentage. Review how blank received dates are handled in your dataset; open orders may need to be excluded from the denominator for a more meaningful delivery KPI.
