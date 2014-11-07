[![Build Status](https://travis-ci.org/robin-drexler/cosch.svg?branch=master)](https://travis-ci.org/robin-drexler/rapid-schedule)
[![Code Climate](https://codeclimate.com/github/robin-drexler/cosch/badges/gpa.svg)](https://codeclimate.com/github/robin-drexler/rapid-schedule)
# Purpose?

With cosch you'll be able to get a conference schedule up on **Github Pages** and delivered to the attendees in minutes.

### Beware!
The responsive layout is currently made using flexbox, which will cause problems in older browsers.
Use at own risk.

## Features

### Schedule is easy to hack

When you're hacking the schedule, you probably are in a hurry and have a lot of other stuff to do.

The entire schedule consists of a single `.yml` file, with a flexible, yet easy structure.

#### Example multi day conference

```yml
title: My awesome conference
days:
  - name: Saturday
    slots:
      - start: '12:00'
        end: '13:00'

        talks:
          - speaker: Robin Drexler
            title: How Geloet will save us all
            location: H1

          - speaker: Katrin Werner
            title: Geloet is jsut not worth it
            location: H2

      - start: '12:00'
        end: '13:00'

        talks:
          - speaker: Peter
            title: Wurst is good
            location: H1

  - name: Sunday
    slots:
      - start: '15:00'
        end: '16:00'

        talks:
          - speaker: Robin Drexler
            title: How Geloet will save us all pt 2
            location: H1
```

### Easy to deploy

Deployment to Github pages can be done by one single command.

### Works Offline

Conference Wifi often isn't the most reliable out there.
Once an attendee opened the schedule url while online, it's going to be cached on her device.
The entire schedule will be available offline, even pages that weren't explicitly opened by the attendee.

No worries, if the attendee is online she will receive schedule updates again.


## Basic Usage
The fastest way from zero to online schedule.

* [Install the gem](https://rubygems.org/gems/cosch)
* Create your new schedule `cosch new DIR`
* Create repo on Github. (push initial content, if you like)
* Edit `schedule.yml` to fit your needs (Push your changes, if you like)
* Deploy to Github Pages: `cosch deploy`
* **Done**

## Workflow (Unconference, Barcamp)
Just an example workflow that worked pretty well at the [http://www.php-unconference.de/](2014 PHP Unconference).
The timeslots (talks, breaks etc.) and available rooms were known upfront. So we created the basic schedule.yml some days before the actual conference took place. This way we only had to fill in the blanks (topic, speaker) after the schedule was decided.


