# SQL-Inventory-Aging-Report

This SQL Query extracts the aging report for inventory into the below 4 buckets to denote the time the inventory has been lying the warehouse.

0-90 days old 
91-180 days old
181-270 days old
271 – 365 days old

The warehouses use FIFO (first in first out) approach to manage inventory, i.e., the inventory that comes first will be sent out first. 
 
For example, on 20th May 2019, 250 units were inbounded into the FC. On 22nd May 2019, 8 units were shipped out (outbound) from the FC, reducing inventory on hand to 242 units. On 31st December, 120 units were further inbounded into the FC increasing the inventory on hand from 242 to 362.On 29th January 2020, 27 units were shipped out reducing the inventory on hand to 335 units.
On 29th January, of the 335 units on hands, 120 units were 0-90 days old (29 days old) and 215 units were 181-270 days old (254 days old).

Columns:
ID of the log entry
OnHandQuantity: Quantity in warehouse after an event
OnHandQuantityDelta: Change in on-hand quantity due to an event
event_type: Inbound – inventory being brought into the warehouse; Outbound – inventory being sent out of warehouse
event_datetime: date- time of event
The data is sorted with latest entry at top.
