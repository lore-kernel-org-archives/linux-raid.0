From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: RAID10, 3 copies, 3 disks
Date: Sat, 11 Jan 2020 08:06:58 +0100
Message-ID: <CAJH6TXhWd-AGi0_KnbnepxZXsOvpMQGwkisFuuX14dMe157jWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi to all
i've read that with md is possible to create non-standard RAID layouts
like RAID10 but without being forced to use an even number of disks to
create the mirrors (like a standard RAID10)

So, would be possible to create a 4-disks RAID10, with redundancy set
to 3 (I need to survive up to to ANY 2 disks failures, like with
RAID6) ?

I think it would be something like the following?

A1 A1 A1 A2
A2 A2 A3 A3
A3 A4 A4 A4

Currently, when i need something similar, i use a 3-way RAID1 with LVM
on top of it to aggregate multiple mirrors in one bigger volume, but
this requires 3 drives for each mirror.

Other solutions ? I don't wan't to use any parity raid this time.
(wasting space with a 3way mirror and LVM on top would be ok, is
nothing better is available)

The raid *must* be scalable, i need to grow it on-the-fly by adding
one or more disks, when needed.
