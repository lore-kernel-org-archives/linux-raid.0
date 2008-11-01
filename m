From: Bas van Schaik <bas@tuxes.nl>
Subject: Initial degraded RAID6 sync doesn't occur? Kernel reports it as RAID5?
Date: Sat, 01 Nov 2008 14:48:13 +0100
Message-ID: <490C5E1D.6050604@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

A while ago I created a RAID6 array of 5 devices of which one was
'missing'. The last disk just didn't arrive in time, so I decided to
create a degraded RAID6 array, actually being equal to a RAID5 in terms
of risks (correct me if I'm wrong).

When creating the device, md refused to start it. I'm very sorry not to
be able to provide the exact output, because it is already a few weeks
ago and I didn't pay that much attention to it by then. The command I
used to create the array was:
> mdadm --create /dev/md5 --level raid6 --raid-devices 5
> /dev/sd{a,b,c,d}5 missing

After that, I had to force assembly to be able to actually use the array:
> mdadm --assemble --force /dev/md5 /dev/sd{a,b,c,d}5

This did work, but it didn't trigger an initial sync of the RAID6 array.
Correct me if I'm wrong, but that initial sync should be performed for
the single redundancy block, shouldn't it?

We're a few weeks later now, and the missing disk has arrived. When
adding it to the array, the value in /sys/block/md5/md/mismatch_cnt
obviously explodes: the syndromes P and/or Q were never computed and
thus mismatch on a large part of the disk. After performing an repair
(echo repair > sync_action) these syndromes are back in sync and the
problem of mismatching blocks disappears. A e2fsck on the filesystem on
top of the array does not indicate any problems at all.

Summarizing the above: shouldn't mdadm perform an initial sync on a
degraded RAID6 array (missing 1 drive)?

The second observation I have made in this process: the kernel reports
my RAID6 array as being a RAID5 array on some places. For example, a
piece of `dmesg` output after adding the 5th disk and rebooting:
> [   68.526355] raid5: raid level 6 set md5 active with 4 out of 5
> devices, algorithm 2
> [   68.526404] RAID5 conf printout:
> [   68.526405]  --- rd:5 wd:4
> [   68.526406]  disk 0, o:1, dev:sdc5
> [   68.526407]  disk 1, o:1, dev:sdd5
> [   68.526409]  disk 2, o:1, dev:sde5
> [   68.526410]  disk 3, o:1, dev:sdf5
> [   68.526677] RAID5 conf printout:
> [   68.526678]  --- rd:5 wd:4
> [   68.526680]  disk 0, o:1, dev:sdc5
> [   68.526681]  disk 1, o:1, dev:sdd5
> [   68.526682]  disk 2, o:1, dev:sde5
> [   68.526683]  disk 3, o:1, dev:sdf5
> [   68.526684]  disk 4, o:1, dev:sda5

/proc/mdstat does show the correct output. From the output of `ps aux` I
can derive that RAID6 is actually managed by a kernel process named
"md5_raid5". I assume RAID6 is implemented as a special case of RAID5
(or theoretically the other way around, of course), but I think it is a
little bit confusing that md reports the array as being of type RAID5.

Regards,

  Bas
