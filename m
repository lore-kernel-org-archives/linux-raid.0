From: Liwei <xieliwei@gmail.com>
Subject: Recovering Partial Data From Re-Added Drive
Date: Wed, 24 Jan 2018 01:16:43 +0800
Message-ID: <CAPE0SYx2Pf=hVe46NVLqTC3g9WQd1MckceS818bWzeNYdOVkNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,
    This is a very odd question and I'm just grasping at straws here...
========
TLDR version:
    1. RAID6 had 1 missing drive, running degraded
    2. 1 more drive dropped out due to glitch (drive seems fine)
    3. A few hours later, 1 more drive had headcrash, destroyed filesystem
    4. If I was lucky (i.e. no important writes occurred during those
hours in-between), it may have been possible to re-assemble raid with
glitched-drive in place of headcrash-drive
    5. However, accidentally re-added glitched-drive instead
    6. How to proceed?
========
    I have a RAID6 running degraded (12 out of 13 drives). Similar to
an email I previously sent to this list, it was in the process of
being migrated to a larger set of disks - thus I decided not to order
a replacement for the drive that died.

    This week, the most unfortunate thing happened: I woke up to find
the server in a boot loop, and upon checking, it appears that the
filesystem is no longer mountable. After a few emails with the btrfs
people, it appears that a very critical section of the FS, the root
tree, is gone, and unfortunately so are my files (and the cause of the
boot loop).

    What apparently happened was overnight, two things occurred:
    1. a drive glitch caused one drive to drop off the raid, causing
the raid to become unprotected. (based on an email from mdadm telling
me a drive has failed)
    2. a few hours later, a headcrash or something like that happened
and i suddenly had 1455 pending sectors. (based on an email from
smartmon telling me i have currentpending sectors)

    I can't speculate whether any significant write happened between
when the first and second thing occurred, but on the pretty-good
chance that there was no write (since it was night time, and only the
migration is running), the sectors in question should still be
consistent with the drive that glitched out.

    Thereafter, I imaged the drive with pending sectors, sans said
sectors, and placed it back in the array, to run the btrfs checks.
When that didn't work out, I absent-mindedly decided to re-add the
drive that glitched out and the raid started to re-sync things. Took
me a few minutes to realise that was a bad idea, so I stopped the
array and pulled all drives out. I think it only managed to sync the
initial few GBs before I stopped it.

    So the question is, how do I proceed from here? I realised what I
should have done, was to disassemble the array and reassemble them
sans the bad drive, and we might already have our data back. But now
that I have re-added the drive, can I still do something similar,
maybe manually?

Warm regards,
Liwei
