From: Albert Pauw <albert.pauw@gmail.com>
Subject: RAID 10 on Fusion IO cards problems
Date: Thu, 29 Aug 2013 11:20:00 +0200
Message-ID: <CAGkViCEJqcGHZQgn0moxFbhHr_XJ0uswy1C4L_nrURR6VKCwSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I am trying to get a RAID 10 configuration working at work, but seem
to hit a performance wall after 20 minutes into a DB creation session.

Here's the setup:

OS: Oracle Linux 5.9 (effectively RHEL 5.9), kernel  2.6.32-400.29.2.el5uek.
All utilities updates, mdadm (2.6.9 latest through updates).

Setup:

Two Fusion IO Duo cards, each Fusion IO device 640 GB, so four in total.

Raid 10 set up as:

striped between the two IO devices on the same Fusion IO card, and
mirrored between the separate cards.

So, Fusion IO card 1, device fioa and fiob, Fusion IO card 2, device
fioc and fiod.

The two stripes are fioa/fiob and fioc/fiod, and a mirror between these devices:

mdadm --create --verbose /dev/md0 --level=10 --metadata=1.2
--chunk=512 --raid-devices=4 /dev/fioa /dev/fioc /dev/fiob /dev/fiod
--assume-clean -N md0

When the performance turned out bad, after about 20 minutes, the
process was stopped. I broke the mirror, so the md0 device is only
striped, but the performance hit after 20 minutes happened again.

The status of all cards are fine, no problems there. Then I created a
fs on only one device and have it run again. This time it worked fine.
The fs was in all cases ext3, no TRIM.

Any suggestions, experience with this kind of setup?

Thanks,

Albert
