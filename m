From: Marcus Sorensen <shadowsor@gmail.com>
Subject: sync speed strangeness and other advice
Date: Thu, 17 May 2012 09:37:50 -0600
Message-ID: <CALFpzo6EgYjNKDjq41ZFj1_NL6AYy7OLDF18Zeis5iWd21taRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First off, I'm using the stock RHEL 6.2 kernel, so obviously not the
latest, but I want to get some input on a strange issue I'm seeing.
Maybe it rings a bell and someone knows a fix or a specific kernel to
try.

I have a few RAID 1 arrays that while resyncing refuse to use the
bandwidth allowed to them. I'm using an internal bitmap. My impression
was that the various sync speed settings are supposed to use all
available bandwidth, backing off if there is other system activity.
The disks are capable of syncing at 400MB/s, and my sync_speed_min is
set to 10000, sync_speed_max is set to 500000, yet they sync at
~80MB/s and iostat shows the disks as being mostly idle.  If I
increase sync_speed_min to 200000, the array happily complies and
resyncs at 200MB/s, no problem.

Also, I seem to have run into an issue similar to the following
thread, where failing a disk, then restarting the array and re-adding
the disk results in a full resync. I'll see if I can replicate via the
included instructions.

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08745.html

Last, I've been reading bits about a bad block bitmap, and if I'm
going to a newer kernel I want to make sure I'm not using one. My
understanding was that I have to use a new version of the mdadm
userspace utility to even create an array with a bad block bitmap, and
even then it's not on by default, correct?

Thanks
