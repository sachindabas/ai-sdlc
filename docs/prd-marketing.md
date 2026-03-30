# Product Requirements Document (PRD) — Marketing
## Car Rental System (New Line of Business)

**Document Version:** 1.0  
**Prepared by:** Product Owner  
**Stakeholder:** Marketing Team  
**Date:** 2026-03-29  
**Status:** Draft

---

## 1. Executive Summary

This document outlines the product requirements for the Marketing team as part of the Car Rental System — a new line of business being added alongside the existing car sales operation. It captures requirements across brand positioning, customer acquisition, pricing & promotions, customer data & personalization, analytics & reporting, and integration with the existing car sales business. These requirements have been derived from structured requirement-gathering interviews with the Marketing team.

---

## 2. Business Model & Market Positioning

### 2.1 Brand Positioning

- The car rental service will be **marketed as a complementary extension** of the existing car sales brand, leveraging established brand equity while maintaining a distinct rental identity.
- The system must support both **unified brand** (same company name) and **standalone sub-brand** configurations to accommodate future brand strategy decisions.
- Marketing materials and the digital presence must clearly differentiate rental offerings from the car sales offering while maintaining visual brand consistency.

### 2.2 Target Customer Segments

The system must support marketing workflows targeting the following customer segments:

| Segment | Description |
|---|---|
| Individual Consumers | Occasional renters for personal travel or temporary transportation |
| Corporate / B2B Clients | Business accounts requiring fleet access, invoicing, and reporting |
| Tourists | Short-stay visitors needing vehicles from airports, hotels, and city centres |
| Short-term Commuters | Customers requiring daily or weekly rentals as a car sales alternative |

### 2.3 Geographic Markets

- **Phase 1 Launch:** Defined initial markets (to be confirmed with Operations).
- **Phase 2+ Expansion:** System must support multi-region, multi-currency, and multi-language configurations to support geographic growth.
- The platform must be architected to add new rental locations without requiring system redevelopment.

### 2.4 Competitive Benchmarking

- Marketing requires the ability to update pricing and promotions rapidly in response to competitor activity.
- The system must support flexible pricing configuration to allow Marketing to respond to market benchmarking outcomes without engineering intervention.

### 2.5 Supported Rental Models

The system must support all of the following rental duration models for both marketing and booking:

- Hourly rentals
- Daily rentals
- Weekly rentals
- Monthly rentals
- Long-term lease-style arrangements

Marketing campaigns must be configurable per rental model type.

---

## 3. Customer Acquisition & Booking Channels

### 3.1 Booking Channels

The system must support the following booking channels at launch:

| Channel | Requirements |
|---|---|
| Company Website | Direct booking with full availability search and payment |
| Mobile App | Full booking capability with push notification support |
| Phone / Call Centre | Agent-assisted booking with CRM integration |
| Walk-in | In-location booking without prior reservation |
| Third-party Travel Platforms / OTAs | API-based availability and booking integration |

### 3.2 Website Integration

- The car rental booking flow must be accessible **directly on the company website** without redirecting customers to a separate portal.
- A dedicated landing page for car rentals must be supported, linked from the main company navigation.

### 3.3 Third-Party Platform Listings

- The system must provide an **availability and booking API** to enable listing on travel aggregators and Online Travel Agencies (OTAs).
- Availability sync must be **real-time or near-real-time** (maximum 5-minute lag) to prevent overbooking.
- Rate parity settings must be configurable per channel.

### 3.4 Corporate / B2B Accounts

- The system must support **dedicated corporate accounts** with:
  - Negotiated rate tiers
  - Consolidated invoicing (monthly billing cycles)
  - Reporting dashboards for corporate travel managers
  - Named driver management within corporate accounts

### 3.5 Referral & Affiliate Marketing

- The system must support **referral tracking**, enabling customers to share unique referral links.
- Affiliate marketing tracking must be supported, including unique affiliate codes and commission reporting.
- The Marketing team must be able to create and manage affiliate schemes via an admin interface.

### 3.6 Walk-in Customers

- Walk-in customers must be able to complete a booking at the rental location with the same product options as online customers.
- Staff must be able to initiate a customer profile at the point of walk-in booking.
- Walk-in bookings must be captured in the same system as online bookings for reporting purposes.

---

## 4. Pricing & Promotions

### 4.1 Pricing Strategy

The system must support the following pricing models:

| Model | Description |
|---|---|
| Flat Rate | Fixed price per rental category and duration |
| Dynamic / Demand-based Pricing | Automated rate adjustment based on fleet utilisation and demand signals |
| Seasonal Pricing | Pre-scheduled rate adjustments tied to calendar dates or periods |

- Marketing must be able to configure pricing rules and schedules via an admin interface without requiring engineering support.

### 4.2 Vehicle Category Rate Tiers

The system must support distinct pricing tiers for each vehicle category:

- Economy
- Mid-size / Compact
- SUV / Crossover
- Luxury / Premium
- Commercial / Van (if applicable)

Rate tiers must be independently configurable per category, duration model, and geography.

### 4.3 Promotions & Discount Management

The system must support the following promotion types:

- **Discount codes / coupon codes** (percentage or fixed amount)
- **Early-bird offers** (time-limited discount for advance bookings)
- **Bundle deals** (e.g., car + insurance, car + add-ons)
- **Weekend specials** (rate reductions for Fri–Sun bookings)
- **Flash sales** (short-duration, high-discount campaigns)

Marketing must be able to create, schedule, activate, and deactivate promotions via an admin panel.

### 4.4 Loyalty & Rewards Programme

- The system must support a **customer loyalty programme** with the following features:
  - Points accumulation per rental spend
  - Points redemption against future bookings
  - Tier-based membership levels (e.g., Silver, Gold, Platinum)
  - Loyalty tier benefits configurable by Marketing (e.g., free upgrades, priority booking)
- The loyalty programme must be extensible to cover both rental and car sales activity.

### 4.5 Add-on Services

Marketing must be able to promote and surface the following add-on services during the booking journey:

- GPS device rental
- Child seat rental
- Insurance upgrades (e.g., excess waiver)
- Fuel prepay option
- Additional driver
- Airport pickup/drop-off service

Add-on availability and pricing must be configurable per location and vehicle category.

### 4.6 Pricing Comparison Page

- The system must include a **pricing comparison view** where customers can compare:
  - Prices across vehicle categories
  - Prices across rental duration options
- This page must be SEO-friendly and accessible from marketing campaign landing pages.

### 4.7 Partner & Affiliate Discount Schemes

- The system must support partner integration for discount schemes including:
  - Airline loyalty miles earn & redeem (e.g., linked airline partner programmes)
  - Hotel partnership discounts
  - Credit card partner offers
- Partner discount codes must be distinguishable from standard promotional codes in reporting.

---

## 5. Customer Profiles & Personalization

### 5.1 Customer Data Capture

The system must capture the following data at registration and booking for Marketing use:

**At Registration:**
- Full name, email address, phone number
- Date of birth (for age verification and targeted offers)
- Address / location
- Marketing opt-in/opt-out preferences (email, SMS, push notifications)
- Driver's licence details

**At Booking:**
- Selected vehicle category
- Pickup and drop-off location
- Rental duration and dates
- Selected add-ons
- Booking channel / source
- Promotional/discount codes used
- Payment method type

### 5.2 Customer Segmentation

- The system must support **dynamic customer segmentation** based on:
  - Rental history (frequency, recency, value)
  - Vehicle category preferences
  - Geographic preferences
  - Demographic attributes
  - Loyalty tier
- Segments must be usable as audience targets in marketing campaigns and email/SMS workflows.

### 5.3 Personalised Recommendations

- The system must track customer preferences (preferred vehicle type, preferred pickup location, preferred add-ons) and use these to:
  - Display personalised vehicle recommendations on the booking homepage
  - Pre-fill preferred options during the booking flow
  - Power personalised email and push notification content

### 5.4 Email & SMS Marketing Consent Management

- The system must support **opt-in/opt-out consent management** compliant with applicable regulations (e.g., GDPR, CAN-SPAM, PECR).
- Customers must be able to manage their communication preferences via their profile page.
- Consent records must be timestamped and auditable.
- The system must integrate with the designated email marketing platform (e.g., Mailchimp, Salesforce Marketing Cloud, or equivalent) via API.

### 5.5 Post-Rental Feedback & Surveys

- The system must support **automated post-rental feedback collection**:
  - Triggered survey sent by email and/or SMS within 24 hours of rental return
  - Net Promoter Score (NPS) or equivalent satisfaction metric
  - Free-text feedback option
- Feedback data must be accessible to Marketing via the reporting dashboard.

### 5.6 New vs. Returning Customer Differentiation

- The system must distinguish between **new** and **returning** customers to enable:
  - Welcome campaigns for new customers
  - Win-back campaigns for lapsed customers
  - Retention and upsell campaigns for active returning customers
- Customer lifecycle stage must be a filterable attribute in the marketing segmentation engine.

---

## 6. Marketing Analytics & Reporting

### 6.1 Key Marketing KPIs

The system must track and report on the following KPIs:

| KPI | Description |
|---|---|
| Booking Conversion Rate | Percentage of sessions that result in a completed booking |
| Customer Acquisition Cost (CAC) | Cost per new customer acquired per channel |
| Repeat Booking Rate | Percentage of customers who make more than one booking |
| Channel Performance | Bookings, revenue, and conversion rate per acquisition channel |
| Average Booking Value | Average revenue per booking |
| Promotion Redemption Rate | Percentage of bookings using a promotional code |
| Loyalty Programme Engagement | Points earned vs. redeemed; tier progression |
| Post-rental NPS / CSAT Score | Aggregated customer satisfaction scores |

### 6.2 Reporting Frequency & Dashboards

- Marketing requires access to **real-time operational dashboards** for:
  - Active campaigns and promotional performance
  - Live booking volumes by channel
- Marketing also requires **periodic scheduled reports**:
  - Daily summary reports (automated delivery)
  - Weekly performance reports
  - Monthly campaign effectiveness reports

### 6.3 Marketing Attribution Tracking

- The system must implement **multi-touch attribution tracking** to record which marketing channel or campaign contributed to each booking.
- UTM parameters from digital campaigns must be captured and stored against each booking record.
- Attribution reports must show first-touch, last-touch, and assisted conversion data per channel and campaign.

### 6.4 Integration with External Analytics Tools

The system must support integration with the following external tools:

| Tool Category | Examples |
|---|---|
| Web Analytics | Google Analytics 4, Adobe Analytics |
| CRM Platform | Salesforce, HubSpot, or equivalent |
| Email Marketing | Mailchimp, Klaviyo, or equivalent |
| Advertising Platforms | Google Ads, Meta Ads (via conversion API) |
| BI / Reporting | Power BI, Tableau, or equivalent |

- Integration must support event-based data pushing (e.g., booking completed, registration, promotion redeemed) to configured platforms.

### 6.5 Month-End & Campaign-End Reporting

The system must generate the following reports for Marketing review:

- **Month-end report:** Total bookings, revenue, new vs. returning customers, channel breakdown, promotion performance, and loyalty programme summary.
- **Campaign-end report:** Campaign reach, bookings attributable to the campaign, revenue generated, cost per booking, and ROI calculation.
- Reports must be exportable in CSV and PDF formats.

---

## 7. Integration with Car Sales Business

### 7.1 Car Sales Cross-Sell

- The system must surface **cross-sell prompts** to rental customers at appropriate points in the journey:
  - During vehicle browsing: "Interested in owning this model? View purchase options."
  - Post-rental: Follow-up email/notification with a purchase offer for the rented vehicle.
- Cross-sell campaigns must be trackable separately from rental campaigns.

### 7.2 Existing Car Sales Customer Profiles

- Existing car sales customers must be automatically recognised when registering for or using the rental system.
- Car sales customers must receive **automatic loyalty programme membership** upon first rental booking.
- Purchase history from car sales must be available as a segmentation attribute for rental marketing targeting.

### 7.3 Shared Customer Data Governance

- A **unified customer identity** must be maintained across rental and sales, using a shared customer ID or master data management approach.
- Data sharing between sales and rental must comply with data protection regulations and internal data governance policies.
- A defined data ownership model must specify which system is the master of record for each data attribute.
- Any changes to customer contact or consent preferences in one system must propagate to the other within a defined SLA (recommended: same-day sync).

### 7.4 Cross-System Campaign Targeting

- Marketing must be able to create campaigns that target:
  - Car sales customers with rental promotions (e.g., "Try a rental before you buy your next car")
  - Rental customers with car purchase promotions (e.g., "Upgrade from renting to owning")
- Audience exports from either system must be available for use in campaign targeting tools.

---

## 8. Constraints & Priorities

### 8.1 Regulatory & Legal Requirements

- All marketing communications and booking interfaces must comply with applicable advertising and consumer protection regulations, including:
  - **Mandatory fee disclosure:** Total rental cost (including taxes, fees, and mandatory charges) must be displayed before payment confirmation.
  - **Age restriction advertising:** Age eligibility requirements must be clearly stated in all relevant marketing communications and on the booking interface.
  - **Consent management:** Compliance with GDPR (EU/UK), CAN-SPAM (US), CASL (Canada), and equivalent regulations in all target markets.
  - **Data retention policies:** Customer data must be retained and deleted in line with regulatory requirements per jurisdiction.

### 8.2 Launch Timeline & Marketing Deadlines

- Marketing requires the following features available for **Day 1 (Go-Live)**:

  **Must-Have (Day 1):**
  - Direct website booking with pricing display and comparison
  - Promotional/discount code support
  - Customer registration with marketing consent management
  - Basic email marketing integration (booking confirmation, post-rental survey)
  - Marketing attribution tracking (UTM capture)
  - Corporate account booking with negotiated rates
  - Walk-in booking capability

  **Should-Have (Phase 2 — within 90 days of launch):**
  - Loyalty/rewards programme
  - Advanced customer segmentation and personalisation
  - Full CRM integration
  - Real-time marketing dashboards
  - Referral and affiliate tracking

  **Nice-to-Have (Phase 3 — post 90 days):**
  - Dynamic/demand-based pricing
  - Partner discount schemes (airline miles, hotel partnerships)
  - Advanced multi-touch attribution
  - AI-powered personalised recommendations

### 8.3 Brand & Reputational Risk

- A failed launch would directly damage the existing car sales brand reputation. The following are considered non-negotiable for launch:
  - The online booking experience must be reliable, fast, and mobile-responsive.
  - Pricing displayed to customers must be accurate and consistent across all channels.
  - Promotional codes must work correctly and be clearly communicated.
  - Customer communication (booking confirmations, reminders) must be delivered reliably.

---

## 9. Assumptions

- The Marketing team will provide final answers to all interview questions, which may refine requirements documented in this PRD.
- Specific partner integrations (airlines, hotels, affiliate networks) will be scoped in detail during Phase 2 planning.
- The CRM platform and email marketing tool selection will be confirmed by Marketing before Phase 2 development begins.
- Data governance policies for shared customer data between sales and rental will be defined by the Data/Legal team in a separate workstream.

---

## 10. Open Questions

| # | Question | Owner | Status |
|---|---|---|---|
| 1 | Which geographic markets are in scope for Phase 1? | Marketing / Operations | Open |
| 2 | Which CRM and email marketing platforms are selected? | Marketing / IT | Open |
| 3 | Will we operate under a unified brand or a rental sub-brand? | Marketing / Leadership | Open |
| 4 | What are the exact regulatory requirements for each Phase 1 market? | Legal | Open |
| 5 | What is the confirmed Day 1 go-live date? | Product Owner / Leadership | Open |
| 6 | Which airline/hotel partners are in scope for Phase 2? | Marketing / Partnerships | Open |
| 7 | What is the loyalty programme tier structure and point earn/redemption rates? | Marketing | Open |
| 8 | Who is the master of record for shared customer identity (sales vs. rental)? | IT / Data Governance | Open |

---

## 11. Revision History

| Version | Date | Author | Description |
|---|---|---|---|
| 1.0 | 2026-03-29 | Product Owner | Initial draft based on Marketing team requirement-gathering interview |

---

*End of PRD — Marketing Team*
