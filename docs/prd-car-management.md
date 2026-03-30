# Product Requirements Document (PRD)

## Car Rental System — Car Management Module

| Field | Details |
|---|---|
| **Document Version** | 1.0 |
| **Date** | 2026-03-29 |
| **Prepared by** | Product Owner |
| **Business Role** | Car Management Team (Service, Delivery & Pickup) |
| **Project** | Car Rental System (New Line of Business) |
| **Phase** | Planning & Requirement Analysis |
| **Status** | Draft |

---

## Table of Contents

1. [Overview](#1-overview)
2. [Fleet Inventory & Vehicle Setup](#2-fleet-inventory--vehicle-setup)
3. [Vehicle Availability & Booking Fulfillment](#3-vehicle-availability--booking-fulfillment)
4. [Pre-Rental Vehicle Inspection & Preparation](#4-pre-rental-vehicle-inspection--preparation)
5. [Delivery Operations](#5-delivery-operations)
6. [Pickup Operations](#6-pickup-operations)
7. [Vehicle Return Operations](#7-vehicle-return-operations)
8. [Vehicle Maintenance & Service](#8-vehicle-maintenance--service)
9. [Fuel Management](#9-fuel-management)
10. [Damage Management](#10-damage-management)
11. [Reporting & Operational Visibility](#11-reporting--operational-visibility)
12. [Constraints & Priorities](#12-constraints--priorities)
13. [Glossary](#13-glossary)

---

## 1. Overview

The Car Rental System introduces a **new line of business** alongside the existing car sales operation. This PRD captures the operational requirements gathered from the Car Management Team (covering vehicle service, delivery, and pickup) during the requirement analysis phase. The system must support end-to-end fleet operations — from vehicle setup and availability management through to delivery, pickup, return processing, maintenance scheduling, fuel tracking, and damage management — ensuring the rental fleet is operationally efficient, legally compliant, and customer-ready at all times.

### 1.1 Goals

- Maintain an accurate, real-time view of fleet availability across all rental locations.
- Automate vehicle assignment, maintenance scheduling, and inspection workflows.
- Provide structured processes for delivery, pickup, and return operations.
- Track vehicle condition, damage, and service history throughout the vehicle lifecycle.
- Ensure regulatory compliance for safety inspections and roadworthiness certifications.
- Deliver operational dashboards and alerts to support the Car Management Team's day-to-day activities.

### 1.2 Stakeholders

| Role | Responsibility |
|---|---|
| Car Management Team | Fleet operations, vehicle service, delivery, and pickup |
| Product Owner | Requirement definition and prioritization |
| IT / Engineering | System implementation |
| Customer Service Team | Booking management and customer communication |
| Accounting Team | Billing, damage charges, and cost tracking |
| External Service Providers | Third-party vehicle maintenance and repairs |

---

## 2. Fleet Inventory & Vehicle Setup

### 2.1 Initial Fleet Size & Growth Planning

- The system must support defining the **initial fleet size at launch**, with the ability to add vehicles progressively as the fleet grows over the first year.
- Fleet capacity planning data (projected vehicle count by category and location) must be configurable by administrators.

### 2.2 Vehicle Categories

The system must support the following vehicle categories (exact categories to be confirmed during implementation):

| Category | Examples |
|---|---|
| Economy | Small city cars |
| Compact | Mid-range hatchbacks |
| Mid-Size | Standard saloons |
| SUV | Sport Utility Vehicles |
| Luxury | Premium and executive vehicles |
| Electric Vehicles (EV) | Battery-electric vehicles |
| Vans | Cargo and passenger vans |

- New categories must be configurable without requiring system code changes.

### 2.3 Vehicle Attributes

The system must track the following attributes for each vehicle:

| Attribute | Description |
|---|---|
| Make | Vehicle manufacturer (e.g., Toyota, BMW) |
| Model | Vehicle model name |
| Year | Manufacturing year |
| Color | Exterior color |
| Fuel Type | Petrol, diesel, hybrid, electric |
| Transmission | Manual or automatic |
| Seating Capacity | Number of seats |
| License Plate | Current registration plate |
| VIN | Vehicle Identification Number |
| Mileage / Odometer | Current recorded mileage |
| Category | Assigned rental category |
| Location | Currently assigned rental branch |
| Status | Available, booked, in-service, under maintenance, retired |

### 2.4 Vehicle Transition from Car Sales Inventory

- A formal **handover process** must be defined and supported in the system for vehicles transitioning from the car sales inventory to the rental fleet.
- The handover record must capture: handover date, vehicle condition at handover, approving manager, and any preparation work completed.
- Once a vehicle is transferred to the rental fleet, it must be removed from the sales inventory to prevent dual listing.

### 2.5 Rental Locations

- The system must support **multiple rental locations** at launch, with the number of locations to be confirmed during implementation.
- Each location must have its own fleet allocation that is visible and manageable independently.
- Fleet distribution across locations must be configurable by administrators.

### 2.6 Inter-Location Vehicle Transfers

- The system **must** support transferring vehicles between rental locations.
- Each inter-location transfer must generate a **transfer record** capturing: origin location, destination location, transfer date, driver/staff responsible, vehicle condition at departure and arrival, and authorisation.
- A vehicle must be placed in an **in-transit** status during the transfer period, preventing it from being booked.

---

## 3. Vehicle Availability & Booking Fulfillment

### 3.1 Real-Time Availability

- Vehicle availability must be determined in **real-time**, reflecting the current status of every vehicle.
- Where technical constraints apply, a near-real-time refresh interval (maximum 5 minutes) is acceptable as a fallback.
- Availability must account for active bookings, maintenance schedules, in-transit status, and holds.

### 3.2 Vehicle Assignment

- The system must support **both automatic and manual vehicle assignment** modes:
  - **Automatic assignment**: The system assigns the most suitable available vehicle to a confirmed booking based on configurable criteria.
  - **Manual assignment**: Staff can override automatic assignment and select a specific vehicle from the available pool.

### 3.3 Automatic Assignment Criteria

The following criteria must be configurable for automatic vehicle assignment:

| Criteria | Description |
|---|---|
| Lowest Mileage | Prefer the vehicle with the least odometer reading |
| Location Match | Prefer vehicles at or nearest to the pickup location |
| Customer Preference | Match specific customer requests (e.g., colour, transmission) |
| Category Upgrade | Assign a higher category only when the requested category is unavailable |

### 3.4 Unavailability Handling

When no vehicle of the requested category is available:

- The system must offer the customer the option of an **upgrade** to a higher category (with or without additional charge, as configured).
- The system must allow staff to offer an **alternative category** at equivalent pricing.
- The system must support placing the customer on a **waitlist** for the requested category, with automatic notification when a vehicle becomes available.

### 3.5 Maintenance Blocks

- Vehicles scheduled for or currently undergoing **maintenance or inspection** must be automatically marked as **unavailable** and excluded from the bookable inventory.
- Maintenance blocks must propagate to the booking engine in real-time to prevent double booking.

### 3.6 Vehicle Holds & Priority Reservations

- The system must support placing a **hold** on a specific vehicle for VIP or corporate customers.
- Holds must be time-limited and managed by authorised staff only.
- Hold records must log: customer or account, vehicle, hold period, and authorising staff member.

---

## 4. Pre-Rental Vehicle Inspection & Preparation

### 4.1 Pre-Rental Preparation Checklist

The following preparation steps must be completed before a vehicle is handed over to a customer:

| Step | Description |
|---|---|
| Cleaning | Interior and exterior cleaned to standard |
| Fuel Top-Up | Fuel filled to the required level per the fuel policy |
| Safety Check | Tyres, lights, wipers, brakes, and fluid levels checked |
| Damage Inspection | Existing damage documented on the inspection form |
| Documentation | Registration, insurance, and any required documents in the vehicle |

- The system must **generate a pre-rental checklist** for staff to complete before each rental.
- Completed checklists must be stored against the booking record.

### 4.2 Vehicle Condition Documentation

- Pre-rental vehicle condition must be documented using a **digital inspection form** with the following elements:
  - Structured checklist (pass/fail per inspection item)
  - Standardised **damage diagram** to mark the location and type of existing damage
  - **Photo uploads** to capture visual evidence of existing damage
- All pre-rental condition records must be **linked to the corresponding booking**.

### 4.3 Customer Sign-Off

- The system must allow the **customer to review and digitally sign off** on the pre-rental vehicle condition before taking the vehicle.
- The signed condition record must be stored securely and linked to the booking for dispute resolution.
- Digital signature capture should be available both in-branch (on a tablet or kiosk) and remotely (via email or mobile link).

### 4.4 Failed Pre-Rental Inspection

- If a vehicle fails the pre-rental inspection:
  - The system must **remove the vehicle from the rental pool** immediately.
  - The system must **automatically generate a maintenance request** linked to the failed inspection.
  - The booking must be reassigned to an alternative vehicle or rescheduled.

---

## 5. Delivery Operations

### 5.1 Delivery Capability

- The system must support **vehicle delivery to customer locations** as a configurable service.
- Delivery may be enabled at launch or as a future phase; the system must be designed to accommodate both.

### 5.2 Delivery Task Information

Each delivery task must include the following information for the delivery driver:

| Field | Description |
|---|---|
| Customer Details | Name, contact number |
| Delivery Address | Full address with any access notes |
| Expected Delivery Window | Date and time window agreed with the customer |
| Vehicle Details | Make, model, registration, colour, VIN |
| Booking Reference | Linked rental booking number |
| Pre-Rental Checklist Status | Confirmation that the vehicle has passed preparation |

### 5.3 Delivery Task Assignment

- The system must support **both manual and automatic delivery task assignment**:
  - **Manual assignment**: A dispatcher assigns a delivery task to a specific driver.
  - **Automatic assignment**: The system assigns delivery tasks based on driver location and availability.

### 5.4 Real-Time Delivery Status Updates

- The delivery driver must be able to **update delivery status in real-time** via a mobile device, using a dedicated mobile interface or application.
- Status transitions to be supported:

| Status | Description |
|---|---|
| Assigned | Task assigned to driver |
| En Route | Driver has departed with the vehicle |
| Arrived | Driver has arrived at the delivery address |
| Delivered | Vehicle handed over to customer |
| Failed | Delivery could not be completed |

### 5.5 Delivery Confirmation

- Delivery confirmation must be recorded using one or more of the following methods:
  - **Customer signature** captured digitally on the driver's mobile device
  - **Photo** of the delivered vehicle at the customer's location
  - **GPS-stamped confirmation** recording the delivery location at the time of confirmation

### 5.6 Delivery Failure Handling

If a delivery cannot be completed (e.g., incorrect address or customer not available):

- The driver must be able to **log the failure reason** in the system.
- The system must trigger an **alert to the dispatcher** for immediate action.
- The customer must be **notified automatically** with rescheduling instructions.
- A **re-delivery task** must be creatable from the failed delivery record.

### 5.7 Route Optimisation

- For drivers handling **multiple deliveries** in the same area, the system should support **route optimisation** to minimise travel time.
- Route optimisation may integrate with a third-party mapping or routing service.

---

## 6. Pickup Operations

### 6.1 Standard Pickup Process

The standard vehicle pickup process must include the following steps:

| Step | Responsible Party |
|---|---|
| Customer arrival and booking check-in | Customer / Staff |
| Identity and documentation verification | Staff |
| Review and sign-off on vehicle condition report | Customer |
| Vehicle key and document handover | Staff |
| Booking status updated to active rental | System |

### 6.2 Online / Mobile Pre-Check-In

- The system must support **online or mobile pre-check-in** to allow customers to complete administrative steps before arriving at the rental location, reducing wait times.
- Pre-check-in tasks may include: confirming booking details, uploading or verifying identity documents, and reviewing the rental terms.

### 6.3 Identity & Documentation Checks

The following checks must be performed at pickup and supported by the system:

| Check | Description |
|---|---|
| Driving Licence | Validate licence number, expiry, and category |
| Booking Confirmation | Match customer to the booking record |
| Credit / Debit Card | Verify the payment card for pre-authorisation or deposit hold |

- The system must log the outcome of each check against the booking record.

### 6.4 Contactless & Self-Service Pickup

- The system must support a **contactless or self-service pickup** option as a configurable feature.
- Self-service pickup requires: pre-verified identity, digital contract acceptance, and a secure vehicle access mechanism (e.g., PIN code, mobile app unlock).
- Self-service availability may be enabled per location.

### 6.5 Pickup Documentation

At the point of pickup, the system must create or confirm the following records:

- Pre-rental vehicle condition form (completed and customer-signed)
- Rental agreement (linked to booking)
- Identity and documentation check log
- Pre-authorisation or deposit hold confirmation

### 6.6 Late Pickup Handling

- A configurable **grace period** must be defined for late customer arrivals (e.g., 30 minutes after the scheduled pickup time).
- After the grace period, the booking must be flagged as **at risk of cancellation**, triggering a staff notification.
- Beyond a configurable **auto-cancel threshold** (e.g., 60 minutes after scheduled pickup), the booking must be automatically cancelled unless staff intervene.
- Customers must receive automated notifications when their booking is at risk and when it is cancelled.

---

## 7. Vehicle Return Operations

### 7.1 Standard Return Process

The standard vehicle return process must include the following steps:

| Step | Description |
|---|---|
| Customer arrival notification | Customer notifies system of return (via app or in-person) |
| Post-rental vehicle inspection | Staff records vehicle condition at return |
| Fuel level check | Current fuel level recorded and compared to pickup level |
| Damage comparison | Return condition compared to pre-rental condition record |
| Mileage recording | Final odometer reading recorded |
| Cost finalisation | Any applicable charges (fuel, damage, late return) calculated |
| Customer receipt | Final rental cost confirmed and receipt issued |

### 7.2 Pre-Return Mobile Notification

- The system must support customers **indicating their return** via a mobile app before arriving at the return location.
- Pre-return notification enables staff to prepare the return bay and have the inspection checklist ready.

### 7.3 Post-Rental Condition Documentation

- Post-rental vehicle condition must be documented in the same structured format as the pre-rental inspection (digital form, damage diagram, photo uploads).
- The system must **automatically compare** the post-rental condition record against the pre-rental condition record, flagging any new damage.

### 7.4 Late Return Detection & Charges

- The system must **automatically detect late returns** by comparing the actual return time against the agreed return time.
- Late return fees must be calculated automatically based on a configurable rate schedule (e.g., hourly or daily excess charge).
- Late return charges must be applied to the customer's payment method and logged in the booking record.
- Staff must be able to override or waive late return fees with appropriate authorisation.

### 7.5 One-Way Rental (Different Return Location)

- The system must support **one-way rentals**, where the vehicle is returned to a different location from where it was picked up.
- One-way rentals must trigger an inter-location transfer task to reposition the vehicle to its home or required location.
- Additional one-way charges must be configurable and automatically applied at booking or return.

### 7.6 Final Cost Confirmation

- At return, the system must present the customer with a **final cost breakdown** including:
  - Base rental charge
  - Any upgrades or optional extras
  - Fuel surcharge (if applicable)
  - Late return fee (if applicable)
  - Damage charges (if applicable)
  - Applicable taxes
- The final amount must be confirmed with the customer before processing the final payment.

---

## 8. Vehicle Maintenance & Service

### 8.1 Maintenance Schedule Types

The system must support the following types of maintenance schedules:

| Type | Description |
|---|---|
| Routine Service (Mileage-Based) | Triggered at configured mileage intervals (e.g., every 10,000 km) |
| Routine Service (Time-Based) | Triggered at configured time intervals (e.g., every 6 months) |
| Annual Safety Inspection | Triggered by annual calendar date or regulatory requirement |
| Ad Hoc / Unplanned Repair | Manually logged when an unexpected issue arises |

### 8.2 Automated Maintenance Alerts

- The system must **automatically generate service alerts** when a vehicle approaches a configured maintenance threshold.
- Alerts must be sent to the Car Management Team and optionally to the branch manager.
- Dual triggers must be supported — the alert fires on whichever threshold (mileage or time) is reached first.

### 8.3 Maintenance Booking Blocks

- When a vehicle is **scheduled for maintenance**, the system must **automatically block it** from being booked during the maintenance window.
- If a booking overlaps with a newly created maintenance window, the system must flag the conflict and prompt staff to reassign the booking.

### 8.4 Maintenance Job Logging

Each maintenance job record must capture:

| Field | Description |
|---|---|
| Vehicle | Linked vehicle record (VIN and registration) |
| Type | Maintenance type (routine, inspection, ad hoc) |
| Date(s) | Start and completion date |
| Description | Description of work performed |
| Cost | Total maintenance cost |
| Service Provider | In-house team or external provider name |
| Parts Replaced | List of parts replaced with part numbers |
| Technician | Name of technician or workshop |
| Outcome | Pass / fail / further action required |

### 8.5 Mileage Tracking

- Vehicle mileage must be **recorded at every pickup and return**, creating a continuous odometer log.
- Mileage data must feed directly into the automated maintenance alert system.
- Where GPS tracking hardware is installed, integration with the GPS system for automated mileage updates must be supported.

### 8.6 Full Service History

- The system must maintain a **complete, auditable service history** for each vehicle, accessible to the Car Management Team.
- Service history records must not be deletable; they may only be amended with an audit trail.

### 8.7 Unplanned Repairs & Breakdown Management

- If a vehicle breaks down during a rental, the system must support:
  - Logging an **urgent repair request** by fleet operations staff
  - Linking the repair request to the active booking
  - Notifying the customer service team to arrange a replacement vehicle
  - Tracking the vehicle's out-of-service status until the repair is completed

### 8.8 External Service Providers

- The system must support tracking maintenance jobs handled by **external service providers**.
- External service orders must capture: provider name, contact details, job reference, estimated completion date, and cost.
- Actual cost and completion details must be updateable upon job closure.

---

## 9. Fuel Management

### 9.1 Fuel Policy

The system must support the following fuel policies, configurable per rental category or booking type:

| Policy | Description |
|---|---|
| Full-to-Full | Customer receives the vehicle full and must return it full |
| Full-to-Empty | Customer receives the vehicle full; no obligation to refuel on return |
| Prepaid Fuel | Customer pays for a full tank upfront at a fixed rate |

- The applicable fuel policy must be recorded on each booking and displayed at pickup and return.

### 9.2 Fuel Level Recording

- Fuel levels must be **recorded at vehicle pickup and at return**, expressed as a standardised fraction (e.g., Full, 3/4, 1/2, 1/4, Empty) or as an estimated litre value.
- Fuel level records must be linked to the booking and captured as part of the vehicle inspection.

### 9.3 Automatic Fuel Surcharge Calculation

- Under the **full-to-full** policy, if the vehicle is returned with less fuel than it was collected with, the system must **automatically calculate and apply a fuel surcharge**.
- The surcharge must be based on the estimated fuel shortfall volume multiplied by a configurable per-litre rate, plus an optional refuelling handling fee.

### 9.4 Fuel Cost Tracking per Vehicle

- The system must support tracking **fuel costs per vehicle** for fleet cost analysis purposes.
- This includes fuel costs incurred during delivery drives, repositioning, and preparation.

### 9.5 Electric Vehicle (EV) Charging Management

- For electric vehicles, the system must track **battery charge level** at pickup and return (expressed as a percentage).
- The system must support logging charging events, including charging duration and cost.
- EV-specific charging policies must be configurable (e.g., minimum charge level at handover, charging fee structure).

---

## 10. Damage Management

### 10.1 Post-Rental Damage Identification

- After each rental return, the post-rental inspection record must be reviewed against the pre-rental record.
- Any discrepancy must be flagged automatically by the system as a **potential new damage event** requiring staff review.

### 10.2 Damage Documentation Standards

New damage must be documented using:

| Method | Description |
|---|---|
| Standardised Damage Codes | A predefined taxonomy of damage types (e.g., scratch, dent, crack, stain) |
| Photo Uploads | Photos of the damaged area |
| Written Description | Free-text description of the damage |
| Damage Diagram | Location of damage marked on a standardised vehicle diagram |
| Cost Estimate | Initial repair cost estimate entered by staff or imported from a repair system |

### 10.3 Damage-to-Rental Linkage

- All damage records must be **linked to the specific rental** during which the damage is believed to have occurred.
- The system must link the damage to the responsible customer for liability tracking.
- The linkage must be based on the comparison of pre-rental and post-rental inspection records.

### 10.4 Repair Cost Estimation

- Staff must be able to **enter or update repair cost estimates** directly in the system.
- Future integration with an external repair cost estimation tool or body shop management system should be architecturally considered.
- Approved cost estimates must trigger the damage charge workflow.

### 10.5 Damage Charges

- Once a damage cost is approved, the system must **initiate a damage charge** against the customer's payment method on file.
- Damage charges must be:
  - Linked to the original rental booking
  - Visible in the customer's transaction history
  - Reported to the Accounting Team for reconciliation
- Staff must be able to log dispute notes if the customer contests the charge.

---

## 11. Reporting & Operational Visibility

### 11.1 Daily Operational Reports

The Car Management Team must have access to the following daily reports:

| Report | Description |
|---|---|
| Vehicles Due for Return Today | All bookings with a scheduled return date of today |
| Vehicles Due for Service | Vehicles approaching or past their maintenance threshold |
| Current Fleet Availability | Count and list of available vehicles by category and location |
| Vehicles Under Maintenance | All vehicles currently blocked for maintenance |
| Pending Deliveries | Delivery tasks scheduled for today |
| Failed Pre-Rental Inspections | Vehicles pulled from the rental pool due to failed inspection |
| Overdue Returns | Vehicles not returned by their scheduled return time |

### 11.2 Real-Time Fleet Dashboard

- The system must provide a **real-time operational dashboard** displaying the current status of every vehicle in the fleet.
- Dashboard views must be filterable by location, category, and vehicle status.
- Dashboard data must reflect the live booking and maintenance system without requiring manual refresh.

### 11.3 Alerts & Notifications

The following automated alerts must be supported:

| Alert | Trigger |
|---|---|
| Overdue Return | Vehicle not returned within grace period after scheduled return time |
| Service Due | Vehicle approaching configured mileage or time maintenance threshold |
| Failed Pre-Rental Inspection | Vehicle fails pre-rental inspection and is pulled from the pool |
| Maintenance Conflict | A maintenance window overlaps with an existing booking |
| Delivery Failure | Delivery driver marks a delivery task as failed |
| Late Pickup Approaching Auto-Cancel | Booking approaches the auto-cancel threshold |

- Alerts must be delivered via in-system notifications and optionally via email or SMS.

### 11.4 Fleet Utilisation Metrics

The following utilisation metrics must be tracked and reportable:

| Metric | Description |
|---|---|
| Utilisation Rate per Vehicle | Percentage of time each vehicle is on active rental |
| Fleet Utilisation Rate | Overall percentage of fleet on active rental at any given time |
| Average Rental Duration | Mean number of days per rental |
| Idle Time Between Rentals | Time between vehicle return and next rental pickup |
| Revenue per Vehicle | Total rental revenue attributed to each vehicle |
| Maintenance Downtime | Time lost per vehicle due to maintenance |

---

## 12. Constraints & Priorities

### 12.1 Regulatory Requirements

- The system must support tracking **vehicle safety inspection records** and **roadworthiness certifications** to meet applicable regulatory requirements.
- Expiry dates for safety inspections and certifications must be stored per vehicle, with automated alerts triggered in advance of expiry.
- Inspection and certification records must be auditable and exportable for regulatory review.

### 12.2 Day 1 Must-Have Features

The following features are considered **mandatory for Day 1** of operation:

| Feature | Reason |
|---|---|
| Fleet inventory management (vehicle setup and attributes) | Core operational capability |
| Real-time vehicle availability and booking engine integration | Prevents double booking |
| Pre-rental and post-rental inspection forms (digital) | Protects against untracked damage liability |
| Vehicle assignment (manual and automatic) | Required for booking fulfillment |
| Maintenance scheduling and booking blocks | Prevents renting unroadworthy vehicles |
| Daily operational reports (returns, service due, availability) | Staff cannot operate without basic visibility |
| Damage recording and customer linkage | Legal and financial requirement |
| Fuel level recording and surcharge calculation | Revenue protection |
| Late return detection and charge calculation | Revenue protection |
| Identity and documentation checks at pickup | Legal and insurance requirement |

### 12.3 Operational Risks

The key operational risks if the system fails to correctly track fleet availability or maintenance status include:

| Risk | Impact |
|---|---|
| Double booking | Customer service failure; potential legal dispute |
| Renting an unroadworthy vehicle | Safety incident; regulatory penalty; liability |
| Untracked damage | Financial loss; inability to pursue damage claims |
| Missing maintenance schedule | Fleet degradation; insurance invalidation |
| Inaccurate fuel tracking | Revenue leakage |
| Overdue returns not detected | Revenue loss; fleet unavailability for subsequent bookings |

---

## 13. Glossary

| Term | Definition |
|---|---|
| VIN | Vehicle Identification Number — a unique 17-character identifier for each vehicle |
| Pre-Rental Inspection | Structured condition check performed before a vehicle is handed to a customer |
| Post-Rental Inspection | Structured condition check performed when a vehicle is returned by a customer |
| Booking Block | A system restriction preventing a vehicle from being assigned to a booking |
| One-Way Rental | A rental where the vehicle is returned to a different location from the pickup location |
| Inter-Location Transfer | The movement of a vehicle from one rental branch to another |
| Fuel Surcharge | An additional charge applied when a vehicle is returned with less fuel than at pickup |
| Utilisation Rate | The percentage of time a vehicle (or the total fleet) is on active rental |
| Grace Period | A defined time buffer before a late pickup or return triggers a penalty or cancellation |
| EV | Electric Vehicle — a vehicle powered entirely by battery-electric propulsion |
| Hold | A temporary reservation of a specific vehicle for a named customer or account |
| Damage Code | A standardised code used to categorise and record vehicle damage types |
| Roadworthiness Certificate | A regulatory document confirming a vehicle meets the legal standards for road use |
