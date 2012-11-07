From: Geoff Attwater <geoffwater@gmail.com>
Subject: mystified by behaviour of mdadm raid5 -> raid0 conversion
Date: Wed, 7 Nov 2012 22:47:20 +1100
Message-ID: <CAH4Nvfn6Ek50DEqFr_hWrpeK9qrBqrGsfsG9ULmLTReJSpGWSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a relatively unimportant home fileserver that uses an mdadm
raid5 across three 1TB partitions (on separate disks - one is 1.5 TB
and has another 500GB partitition for other stuff). I wish to convert
it to raid10 across 4 1TB partitions by adding a fresh drive.

The mdadm man page, section *Grow Mode* states that it may

"convert between RAID1 and RAID5, between RAID5 and RAID6, between
RAID0, RAID4, and RAID5, and between RAID0 and RAID10 (in the near-2
mode)."

Conversion between RAID5 and RAID10 directly is not supported (mdadm
tells you so if you try it).
So my plan was to do a three stage conversion:

 1. back everything up
 2. convert from 3-disk raid5 -> 2-disk raid0 (now with no redundancy,
 but it's backed up, so that's ok)
 3. convert the 2-disk raid0 -> 4-disk raid10

All of these have the same logical size (2TB). This is on an Ubuntu
12.10 system.
mdadm --version reports:
mdadm - v3.2.5 - 18th May 2012
uname -a reports:
Linux penguin 3.5.0-18-generic #29-Ubuntu SMP Fri Oct 19 10:26:51 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

I searched around to see if anyone had followed this kind of procedure
before, but didn't find anything directly addressing exactly what I
was trying to do (I saw much more about raid0 -> raid5 type
conversions, while adding a device and the like and nothing much on
going the other way), so I proceeded based on what I understood from
the man page and other general stuff on mdadm raid reshaping I read.

for stage 2, I used the command

    mdadm --grow /dev/md0 --level=raid0 --raid-devices=2
--backup-file=/media/newdisk/raid_to_0_backup

where the backup-file is on another disk not in the array. I put the
--raid-devices=2 in to make it clear that what I was after was 2x1TB
disks in RAID0 and one spare (the same logical size), rather than a
larger logical size 3TB three-disk RAID0. Although based on Neil
Brown's blog post at http://neil.brown.name/blog/20090817000931 it
seems the conversion should generally operate by reshuffling things
into an equal-logical size array anyway, so that perhaps wasn't
necessary.

This began a lengthy rebuild process that has now finished. However,
at the end of the process, after no visible error messages and
obviously a lot of data movement seen via iostat, `mdadm --detail
/dev/md0` showed the array as *still raid5* with all disks used, and
the dmesg output contained these relevant lines:

    [93874.341429] md: reshape of RAID array md0
    [93874.341435] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
    [93874.341437] md: using maximum available idle IO bandwidth (but
not more than 200000 KB/sec) for reshape.
    [93874.341442] md: using 128k window, over a total of 976630272k.
    === snip misc unrelated stuff  ===
    [183629.064361] md: md0: reshape done.
    [183629.072722] RAID conf printout:
    [183629.072732]  --- level:5 rd:3 wd:3
    [183629.072738]  disk 0, o:1, dev:sda1
    [183629.072742]  disk 1, o:1, dev:sdc1
    [183629.072746]  disk 2, o:1, dev:sdb1
    [183629.088584] md/raid0:md0: raid5 must be degraded! Degraded disks: 0
    [183629.091657] md: md0: raid0 would not accept array

This, I have trouble making sense of. The filesystem on the /dev/md0
was still mounted throughout and appeared fine. Unmounting /dev/md0
and running `fsck.ext4 -n -f /dev/md0` to force checking integrity
even though it was marked clean (but avoid making any modifications)
showed no trouble with the actual data on the array despite all the
shenanigans.

I rebooted the system, thinking perhaps the kernel wouldn't pick up
the new layout and display it in /proc/mdstat and mdadm output until
then, but the same situation of the array continuing to report itself
as raid5 persisted.

I googled the "would not accept array" message and came up with this
page http://forums.gentoo.org/viewtopic-t-938092-start-0 It concerns
trouble in converting 2 disk raid0 -> 3 disk raid5, though. Right at
the bottom of the first page of posts, a GlenSom states:

> Though, I found the issue. html If a raid0 is created with more then 1
> zone - reshaping is not supported. (If one partition is slightly
> larger then the others)

I do not know if that is the correct diagnosis in the case of their problem, but
I have checked my partition tables:

       Device Boot      Start         End      Blocks   Id  System
    /dev/sda1            2048  1953525167   976761560   fd  Linux RAID
autodetect
    /dev/sda2      1953525168  2930277167   488376000   83  Linux
       Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1            2048  1953525167   976761560   fd  Linux RAID
autodetect
       Device Boot      Start         End      Blocks   Id  System
    /dev/sdc1            2048  1953525167   976761560   fd  Linux RAID
autodetect

All of the partitions in the raid are precisely the same geometry so
mismatches there should not be an issue.

Based on the paired `mdadm --detail` outputs on that forum post, I
noticed a before/after difference:
`Layout: Parity-last` appears after the reshape. I checked in my
`mdmadm --detail` output post-reshape (I'm afraid I did not save a
copy of the pre-reshape output) and it is there also.

I gather that this means that the reshape has successfully juggled the
data around, such that now it is laid out with basically a RAID4-style
layout, with one disk entirely consisting of parity, instead of
staggering the parity through the disks RAID5 style.

This means that the array should be losslessly convertible to RAID0
with no data motion simply through 'reinterpreting' the array as
consisting of just the first two disks and removing the parity disk
(one might expect to see it turn up as a spare in say a RAID6 -> RAID5
conversion, but as md RAID0 cannot have spares because your data is
destroyed at the point of a disk failure, it wouldn't here).

However, it didn't actually do that (failing instead with the dmesg
output mentioned above). I have since tried the command

    mdadm --grow /dev/md0 --level=raid0

to finish the job. This returns
`mdadm: failed to set raid disks` and adds a

    [ 4780.580972] md/raid:md0: reshape: not enough stripes.  Needed 512
    [ 4780.597961] md: couldn't update array info. -28

in the dmesg output.
further googling suggested that there was an interaction with a small
default stripe cache size causing it to fail. See post 12 on page
three of this thread

https://lkml.org/lkml/2006/7/7/325
> Yes. This is something I need to fix in the next mdadm. You need to
> tell md/raid5 to increase the size of the stripe cache before the grow
> can proceed. You can do this with
>
> echo 600 > /sys/block/md3/md/stripe_cache_size
>
> Then the --grow should work. The next mdadm will do this for you.
>
> NeilBrown

Anyway, `/sys/block/md0/md/stripe_cache_size` was 256, but the chunk
size of was 512k as reported by mdadm.

Running `echo 16384 > /sys/block/md/md/stripe_cache_size` and then
`mdadm --grow /dev/md0 --level=raid0`

once more, it was apparently happy and reported `raid_disks for
/dev/md0 set to 2` . Perhaps mdadm has not, in fact, been patched to
autoincrease the stripe_cache_size yet?

(NOTE: I believe that way back, before the initial resync, the
stripe_cache_size may already have been manually increased after
booting to a value larger than 512 so it may or may not have been an
issue then - but after reboot, reset to 256 as is not persistent).

However, `mdadm --detail` still reports the array as raid5,
parity-last and containing 3 active disks.

Running `mdadm --grow /dev/md0 --level=raid0 --raid-devices=2` in a
perhaps superstitious attempt to emphasise that only two devices are
wanted gives exactly the same message and no visible change in the
result (still raid5, three active drives albeit with `Layout :
parity-last`.

So this is where I stand, with a raid4/5 that doesn't seem to want to
turn into a raid0.

I guess at this point that perhaps something like failing the disk
that's parity-only and assembling an array with assumed geometry of
raid0 from the other two disks might be necessary: some way or other
to ensure that the md system does the final reinterpretation step
correctly. But it is unclear to me after reading the man page and
scanning through this list, and many serverfault questions tagged
mdadm how to do this correctly.

cat /proc/mdstat:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sda1[0] sdc1[1] sdb1[3]
      1953260544 blocks super 1.2 level 5, 512k chunk, algorithm 5 [3/3] [UUU]

unused devices: <none>

mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Thu Sep 20 15:27:14 2012
     Raid Level : raid5
     Array Size : 1953260544 (1862.77 GiB 2000.14 GB)
  Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Wed Nov  7 21:25:04 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : parity-last
     Chunk Size : 512K

           Name : penguin:0  (local to host penguin)
           UUID : a881a285:2e5d5ed0:cadf3ad1:ea423f6f
         Events : 650048

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       3       8       17        2      active sync   /dev/sdb1


I have backups of everything I need to keep, so I can just kill the
thing and rebuild it in a new config without doing online reshaping,
but that's not what I'm worried about at this point so much as
understanding what is going on.

In particular, it seems to me the first command was pretty clear and
should have either just worked, or said something informative about
why it couldn't do it or it didn't make sense in that form, rather
than crunching through the whole thing, then leaving me with an array
that was *not actually raid0* although I said *lo, make the raid level
turn into raid0*.

I'm stumped at this point after reading a bunch of documentation and
discussion about using mdadm online and trying to figure out what to
do next, not wanting to waste time with a question I can answer just
by researching the web. Anyway, sorry about the length - I've tried to
keep it relevant and to the point.  Oh yes, and thanks to all those
responsible for the md system: it's been working very nicely up to
this point and I do appreciate your hard work and recognise that you
aren't obliged to offer random people technical support.

- Geoff Attwater
