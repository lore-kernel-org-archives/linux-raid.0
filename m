From: Mike Hartman <mike@hartmanipulation.com>
Subject: How to initialize "composite" RAID
Date: Fri, 10 Sep 2010 18:14:51 -0400
Message-ID: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is unrelated to my other RAID thread, but I discovered this issue
when I was forced to hard restart due to the other one.

My main raid (md0) is a RAID 5 composite that looks like this:

- partition on hard drive A (1.5TB)
- partition on hard drive B (1.5TB)
- partition on hard drive C (1.5TB)
- partition on RAID 1 (md1) (1.5TB)

md1 is a RAID 0 used to combine two 750GB drives I already had so that
they could be fit into the larger RAID 5 (since all the RAID 5
components need to be the same size).

This seems to be a fairly standard approach that is more or less
endorsed by the various RAID tutorials I've read through, and it works
fine when I start all my arrays manually, with md1 started before md0.

But when the system boots up it tries to start all my arrays
automatically and the timeline looks like:

Detecting md0. Can't start md0 because it's missing a component (md1)
and thus wouldn't be in a clean state.
Detecting md1. md1 started.
Then I use mdadm to stop md0 and restart it (mdadm --assemble md0),
which works fine at that point because md1 is up.

But aside from the fact that I don't want to do that manually every
time I reboot, since md0 was started without the md1 component and
then had it re-added it decides the array needs to go through a
resync, which takes 10 hours. And that will only get worse as I
continue to add more drives.

Is there any way to exercise more control over the array
initialization order while still having everything start automatically
at bootup? Right now I've done no setup like that at all - it all just
works. I've been keeping /etc/mdadm.conf updated, but as I understand
it that's more for my own reference than the system's.

Mike
