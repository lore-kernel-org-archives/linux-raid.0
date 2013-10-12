From: Ethan Tira-Thompson <ethan@tira-thompson.com>
Subject: Removable mirror disks?
Date: Sat, 12 Oct 2013 11:15:43 -0700
Message-ID: <A9E6EB68-1FEC-4509-9357-2F62BC62AE84@tira-thompson.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I=92m setting up a raid mirror with two disks.  Ideally, I=92d like to =
do this in such a way that I could stop the array, remove a drive, moun=
t it directly on another machine as read-only (no RAID setup), and then=
 put it back in the RAID and re-assemble as if nothing happened.  (Or I=
 could put a new drive in and keep the old one as a snapshot backup.)  =
It=92s a maintenance option, not something I intend to do a lot.

Can I do this?  I=92ve tried creating a raid from the root block device=
 (e.g. sdb) and then partitioning and formatting within the RAID, as we=
ll as the opposite, partitioning the block device and making a raid of =
the partition.  Neither of these seems happy if I pull a drive and try =
to use it directly.  Is that due to the mdadm metadata overwriting/offs=
etting the filesystem?  Would something like DDF containers solve this?=
  Or if I shrink the filesystem on a partition (leaving unused space on=
 the partition) and then use metadata version 1.0? (not sure I can do t=
hat, everything I=92ve seen resizes the partition too)

An unrelated question: I=92ve heard some implementations RAID-1 mirrori=
ng will load balance reads between the disks at the process level but n=
ot striping of reads within a thread?  How does linux raid handle this?=
  Seems like the kernel could stripe the read requests regardless of be=
ing single threaded, but maybe there=92s some complication of guarantee=
ing coherency with writes to each drive?

Thanks!
 -Ethan--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
