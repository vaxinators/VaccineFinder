# VaccineFinder
## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
VaccineFinder is an app to help users find available appointments to get a COVID-19 vaccine near
them.

### App Evaluation
* **Category:** Health
* **Mobile:** This app could be viable both on the web and on mobile. However, a mobile experience would provide users with additional features such as being able to set notifications to remind you of your appointment, or when a location has more appointments available.
* **Story:** Allows users to conveniently find an appointment and remind them as needed. It could also remind them to check their local government website and ensure all the proper forms are filled out prior to their arrival.
* **Market:** Anybody who currently qualifies for the vaccine are potential users. The potential user base is also expanding as eligibility expands nationwide.
* **Habit:** An average user would use this app a few times until they are vaccinated.
* **Scope:** This app could start by simply presenting all available appointments through the API and evolve with more features to make more of the vaccination process managed in the app.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User can input location manually or get location automatically from IOS
* [x] User can scroll through locations with available appointments
* [ ] User can click on location and get a detail screen with appointments

**Optional Nice-to-have Stories**
* [x] An app icon
* [x] A launch screen
* [ ] A map to display the vaccination locations
* [ ] User can set up notifications to remind them of their appointment

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/70bVxpse0W.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='http://g.recordit.co/RbdvYpPMaV.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

### 2. Screen Archetypes

* Stream Screen
   * User can scroll through locations with available appointments
   * User can click a location to find more information about availability

* Settings Screen
   * User can set zipcode to search appointments by location

* Detail Screen
   * User can see avaiable appointments in a specific location

* Map View (Optional)
   * User can see locations near them in a map

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Locations Stream
* Locations Map (Optional)

**Flow Navigation** (Screen to Screen)

* Main Screen
   * Input zipcode and hit go button to go to second screen

* Second Screen
   * Scroll through a tableview of locations
   * Click on specific location which will go to third screen

 * Third Screen
   * Detailed View of Specific location

## Wireframes
<img src="http://g.recordit.co/85cciCl1O0.gif" width=600>

## Schema
### Models
#### Vaccine Info
| Property | Type | Description |
| -------- | ---- | ----------- |
| modernaFS | URL | Moderna vaccine fact sheet link |
| pfizerFS | URL | Pfizer vaccine fact sheet link |
| jnjFS | URL | Johnson & Johnson vaccine fact sheet link |

#### Local Government Website
| Property | Type | Description |
| -------- | ---- | ----------- |
| lgwAL | URL | link to Alabama state government website on vaccine |
| lgwAK | URL | link to Arkansas state government website on vaccine |
...
| lgwWY | URL | link to Wyoming state government website on vaccine |

### Networking
* list of network requests by screen
   * Stream Screen
      * (GET) Get the latest appointment availability data for each state
   * Detail Screen
      * (GET) Get the latest appointment availability data for each location
* list of endpoints
   * VaccineSpotter API
      * Base URL: https://www.vaccinespotter.org/api
      * | Request Type | Endpoint | Description |
        | ------------ | -------- | ----------- |
        | GET | /v0/states/'state'.json | Gets all available appointment information for 'state'|
