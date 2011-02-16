From: Lasse Jensen <fafler@gmail.com>
Subject: Upgrading from RAID 5 to 6 or build native level 6?
Date: Wed, 16 Feb 2011 16:40:12 +0100
Message-ID: <AANLkTik8XFxjKJ+GoPjmos6Qm_WKzFw4O29Rr2w8cnGJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is a RAID 6 array made by upgrading a RAID 5 array to RAID 6 in any
way inferior to a RAID 6 array build from scratch? I read somewhere
that the last drive would be parity only. I'm not sure what to make of
it and i cant find the link again either. Is it going to be a
bottleneck like in RAID 4?

The story is i have a degraded RAID 6 array with 3 out of 5 drives
active because of random read errors on the drives. Danm you, Western
Digital. Anyway, i can get all my data out, so no worries. I need to
ship the two drives for replacement and when i get them back, i'm
going to rearrange the array to put the encryption layer on top of the
RAID layer instead of the other way around as it drops out drives from
the array from time to time. Thats a whole different story.

Now, when i get the drives back, i could use one drive for most of my
data and put the rest on a couple of laptops and spare drives, build a
4 drive RAID 6 array and then add the last drive to the array.
Or i could put my data on two drives a make a 3 drive RAID 5 array,
copy data in to it, add the last two drives and upgrade to RAID 6.
Which is better?

Thanks in advance.

--
Lasse Jensen (fafler at gmail dot com)
