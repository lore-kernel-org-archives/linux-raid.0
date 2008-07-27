From: Brad <brad46526@gmail.com>
Subject: System hangs on raid md recovery/resync
Date: Mon, 28 Jul 2008 08:05:31 +1000
Message-ID: <da290bd50807271505k4bf5734bp9734883a219e9d53@mail.gmail.com>
References: <da290bd50807260519v293851c9ue4bef88b1fc52013@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da290bd50807260519v293851c9ue4bef88b1fc52013@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.  I'm running Linux 2.6.26 with mdadm v2.6.1.  Over the past 24
hours I've several times set up a 400GB raid1 md array in a
recovery/resync operation which has subsequently hung the system.
In five such operations three have hung:

o  I added a third disk drive to a working raid1 md device; after
an hour or more of active synchronisation the system hung.

o  after pulling out the third (hot pluggable) disk I rebooted the
system, which started resyncing the md device upon assembly.
This operation also hung after about an hour.

o  rebooting again and this time reducing all activity on the system
to an absolute minimum the resync succeeded.

o  I tried again to mirror the md device to my third hot-pluggable
disk by inserting the drive and attaching it to the raid1 md device;
after an hour or so the recovery hung again.

o  rebooting again with the third drive unplugged it looks like
the resync is going to run to completion this time.

All three disks are Western Digital SATA 2 drives.  SMART says
there's no problems with the drives.

A resync/recover operation typically proceeds at an average
speed of about 35MB/sec, as reported by /proc/mdstat.  But
then - for the times that it hung - /proc/mdstat reports slower
and slower speeds and longer and longer finish times (30,000 minutes
plus!).  In /sys/block/md1/md the value of sync_completed
would stay static and sync_speed would drop lower and lower
(< 1000KB/sec).

I tried:

 echo 40960 > sync_speed_min

in an attempt to try and coax things to go faster but the system
remained hung.

The system was hung in that:

o  load average increased to about 13; top reported 50% spent
in 'wait time';

o  Any operation that accessed the disk/md device would 'hang'.
Other trivial operations - shell builtin commands, X11 widget
updates - still worked.  'shutdown -r now' wouldn't work; I had
to cold-boot the system each time.

o  No error messages logged to the console or syslog.

This 'hang' *seems* to be related to system activity; the system
has never been *heavily* loaded the three times a resync/recover
operation failed but I had a couple of download programs and the
like - keeping the network interface mildly busy - running in every
failed/hung case.

Ideally the resync/recover operation should proceed independent
of the system activity, I would have thought?  I'd hoped to be able to
perform daily/weekly transparent backups by plugging in the third drive,
adding it to the raid1 md device and then detaching the disk
after the recover operation had completed.

Can anyone help?  I have no idea if there are other things I can
do or tune to get around this problem, or if it's an actual bug.  I had
a look in the kernel archives but couldn't see anything that seemed
relevant to this problem with the latest stable kernel.

Thanks,


Brad
