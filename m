From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Fri, 25 Aug 2006 13:10:53 -0400
Message-ID: <44EF2F1D.AB138CDA@maine.edu>
References: <44EB5579.4020200@maine.edu> <17644.55759.763091.379642@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Neil Brown wrote:

> On Tuesday August 22, steve.cousins@maine.edu wrote:
> > Hi,
> >
> > I have a set of 11 500 GB drives. Currently each has two 250 GB
> > partitions (/dev/sd?1 and /dev/sd?2).  I have two RAID6 arrays set up,
> > each with 10 drives and then I wanted the 11th drive to be a hot-spare.
> >   When I originally created the array I used mdadm and only specified
> > the use of 10 drives since the 11th one wasn't even a thought at the
> > time (I didn't think I could get an 11th drive in the case).  Now I can
> > manually add in the 11th drive partitions into each of the arrays and
> > they show up as a spares but on reboot they aren't part of the set
> > anymore.  I have added them into /etc/mdadm.conf and the partition type
> > is set to be  Software RAID (fd).
>
> Can you show us exactly what /etc/mdadm.conf contains?
> And what kernel messages do you get when it assembled the array but
> leaves off the spare?
>

Here is mdadm.conf:

DEVICE /dev/sd[abcdefghijk]*
ARRAY /dev/md0 level=raid6 num-devices=10 spares=1
UUID=70c02805:0a324ae8:679fc224:3112a95f
devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdg1,/dev/sdh1,/dev/sdi1,/dev/sdj1,/dev/sdk1

ARRAY /dev/md1 level=raid6 num-devices=10 spares=1
UUID=87692745:1a99d67a:462b8426:4e181b2e
devices=/dev/sda2,/dev/sdb2,/dev/sdc2,/dev/sdd2,/dev/sde2,/dev/sdf2,/dev/sdg2,/dev/sdh2,/dev/sdi2,/dev/sdj2,/dev/sdk2

Below is the info from /var/log/messages. This is a listing of when two
partitions from each array were left off. It also is an example of when it
doesn't list the spare. If you want me a newer listing from when the array
builds correctly but doesn't have a spare let me know.

What I hadn't really looked at before is the lines that say:

        sdk1 has different UUID to sdk2

etc.  Of course it doesn't.  Maybe this isn't part of the problem

Aug 21 18:56:09 juno mdmonitor: mdadm shutdown succeeded
Aug 21 19:01:03 juno mdmonitor: mdadm startup succeeded
Aug 21 19:01:04 juno mdmonitor: mdadm succeeded
Aug 21 19:01:06 juno kernel: md: md driver 0.90.3 MAX_MD_DEVS=256,
MD_SB_DISKS=27
Aug 21 19:01:06 juno kernel: md: bitmap version 4.39
Aug 21 19:01:06 juno kernel: md: raid6 personality registered for level 6
Aug 21 19:01:06 juno kernel: md: Autodetecting RAID arrays.
Aug 21 19:01:06 juno kernel: md: autorun ...
Aug 21 19:01:06 juno kernel: md: considering sdk2 ...
Aug 21 19:01:06 juno kernel: md:  adding sdk2 ...
Aug 21 19:01:06 juno kernel: md: sdk1 has different UUID to sdk2
Aug 21 19:01:06 juno kernel: md:  adding sdj2 ...
Aug 21 19:01:06 juno kernel: md: sdj1 has different UUID to sdk2
Aug 21 19:01:06 juno kernel: md:  adding sdi2 ...
Aug 21 19:01:06 juno kernel: md: sdi1 has different UUID to sdk2
Aug 21 19:01:06 juno kernel: md:  adding sdh2 ...
Aug 21 19:01:06 juno kernel: md: sdh1 has different UUID to sdk2
Aug 21 19:01:06 juno kernel: md:  adding sdg2 ...
Aug 21 19:01:06 juno kernel: md: sdg1 has different UUID to sdk2
Aug 21 19:01:06 juno kernel: md:  adding sdf2 ...
Aug 21 19:01:06 juno kernel: md: sdf1 has different UUID to sdk2
Aug 21 19:01:06 juno kernel: md:  adding sde2 ...
Aug 21 19:01:06 juno kernel: md: sde1 has different UUID to sdk2
Aug 21 19:01:07 juno kernel: md:  adding sdd2 ...
Aug 21 19:01:07 juno kernel: md: sdd1 has different UUID to sdk2
Aug 21 19:01:07 juno kernel: md:  adding sdc2 ...
Aug 21 19:01:07 juno kernel: md: sdc1 has different UUID to sdk2
Aug 21 19:01:07 juno kernel: md:  adding sdb2 ...
Aug 21 19:01:07 juno kernel: md: sdb1 has different UUID to sdk2
Aug 21 19:01:07 juno kernel: md:  adding sda2 ...
Aug 21 19:01:07 juno kernel: md: sda1 has different UUID to sdk2
Aug 21 19:01:07 juno kernel: md: created md1
Aug 21 19:01:07 juno kernel: md: bind<sda2>
Aug 21 19:01:07 juno kernel: md: bind<sdb2>
Aug 21 19:01:07 juno kernel: md: bind<sdc2>
Aug 21 19:01:07 juno kernel: md: bind<sdd2>
Aug 21 19:01:07 juno kernel: md: bind<sde2>
Aug 21 19:01:07 juno kernel: md: bind<sdf2>
Aug 21 19:01:07 juno kernel: md: bind<sdg2>
Aug 21 19:01:07 juno kernel: md: bind<sdh2>
Aug 21 19:01:07 juno kernel: md: bind<sdi2>
Aug 21 19:01:07 juno kernel: md: bind<sdj2>
Aug 21 19:01:07 juno kernel: md: export_rdev(sdk2)
Aug 21 19:01:07 juno kernel: md: running:
<sdj2><sdi2><sdh2><sdg2><sdf2><sde2><sdd2><sdc2><sdb2><sda2>
Aug 21 19:01:07 juno kernel: md: kicking non-fresh sdi2 from array!
Aug 21 19:01:07 juno kernel: md: unbind<sdi2>
Aug 21 19:01:07 juno kernel: md: export_rdev(sdi2)
Aug 21 19:01:07 juno kernel: md: kicking non-fresh sdb2 from array!
Aug 21 19:01:07 juno kernel: md: unbind<sdb2>
Aug 21 19:01:07 juno kernel: md: export_rdev(sdb2)
Aug 21 19:01:07 juno kernel: raid6: allocated 10568kB for md1
Aug 21 19:01:07 juno kernel: raid6: raid level 6 set md1 active with 8 out of
10 devices, algorithm 2
Aug 21 19:01:07 juno kernel: md: considering sdk1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdk1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdj1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdi1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdh1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdg1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdf1 ...
Aug 21 19:01:07 juno kernel: md:  adding sde1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdd1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdc1 ...
Aug 21 19:01:07 juno kernel: md:  adding sdb1 ...
Aug 21 19:01:07 juno kernel: md:  adding sda1 ...
Aug 21 19:01:07 juno kernel: md: created md0
Aug 21 19:01:07 juno kernel: md: bind<sda1>
Aug 21 19:01:07 juno kernel: md: bind<sdb1>
Aug 21 19:01:07 juno kernel: md: bind<sdc1>
Aug 21 19:01:07 juno kernel: md: bind<sdd1>
Aug 21 19:01:07 juno kernel: md: bind<sde1>
Aug 21 19:01:07 juno kernel: md: bind<sdf1>
Aug 21 19:01:07 juno kernel: md: bind<sdg1>
Aug 21 19:01:07 juno kernel: md: bind<sdh1>
Aug 21 19:01:07 juno kernel: md: bind<sdi1>
Aug 21 19:01:07 juno kernel: md: bind<sdj1>
Aug 21 19:01:07 juno kernel: md: export_rdev(sdk1)
Aug 21 19:01:07 juno kernel: md: running:
<sdj1><sdi1><sdh1><sdg1><sdf1><sde1><sdd1><sdc1><sdb1><sda1>
Aug 21 19:01:07 juno kernel: md: kicking non-fresh sdi1 from array!
Aug 21 19:01:07 juno kernel: md: unbind<sdi1>
Aug 21 19:01:07 juno kernel: md: export_rdev(sdi1)
Aug 21 19:01:07 juno kernel: md: kicking non-fresh sdb1 from array!
Aug 21 19:01:07 juno kernel: md: unbind<sdb1>
Aug 21 19:01:07 juno kernel: md: export_rdev(sdb1)
Aug 21 19:01:08 juno kernel: raid6: allocated 10568kB for md0
Aug 21 19:01:08 juno kernel: raid6: raid level 6 set md0 active with 8 out of
10 devices, algorithm 2
Aug 21 19:01:08 juno kernel: md: ... autorun DONE.
Aug 21 19:01:08 juno kernel: md: Autodetecting RAID arrays.
Aug 21 19:01:08 juno kernel: md: autorun ...
Aug 21 19:01:08 juno kernel: md: considering sdb1 ...
Aug 21 19:01:08 juno kernel: md:  adding sdb1 ...
Aug 21 19:01:08 juno kernel: md:  adding sdi1 ...
Aug 21 19:01:08 juno kernel: md:  adding sdk1 ...
Aug 21 19:01:08 juno kernel: md: sdb2 has different UUID to sdb1
Aug 21 19:01:08 juno kernel: md: sdi2 has different UUID to sdb1
Aug 21 19:01:09 juno kernel: md: sdk2 has different UUID to sdb1
Aug 21 19:01:09 juno kernel: md: md0 already running, cannot run sdb1
Aug 21 19:01:09 juno kernel: md: export_rdev(sdk1)
Aug 21 19:01:09 juno kernel: md: export_rdev(sdi1)
Aug 21 19:01:09 juno kernel: md: export_rdev(sdb1)
Aug 21 19:01:09 juno kernel: md: considering sdb2 ...
Aug 21 19:01:09 juno kernel: md:  adding sdb2 ...
Aug 21 19:01:09 juno kernel: md:  adding sdi2 ...
Aug 21 19:01:10 juno kernel: md:  adding sdk2 ...
Aug 21 19:01:10 juno kernel: md: md1 already running, cannot run sdb2
Aug 21 19:01:10 juno kernel: md: export_rdev(sdk2)
Aug 21 19:01:10 juno kernel: md: export_rdev(sdi2)
Aug 21 19:01:10 juno kernel: md: export_rdev(sdb2)
Aug 21 19:01:10 juno kernel: md: ... autorun DONE.
Aug 21 19:01:11 juno kernel: md: Autodetecting RAID arrays.
Aug 21 19:01:11 juno kernel: md: autorun ...
Aug 21 19:01:11 juno kernel: md: considering sdb2 ...
Aug 21 19:01:11 juno kernel: md:  adding sdb2 ...
Aug 21 19:01:11 juno kernel: md:  adding sdi2 ...
Aug 21 19:01:11 juno kernel: md:  adding sdk2 ...
Aug 21 19:01:11 juno kernel: md: sdb1 has different UUID to sdb2
Aug 21 19:01:11 juno kernel: md: sdi1 has different UUID to sdb2
Aug 21 19:01:12 juno kernel: md: sdk1 has different UUID to sdb2
Aug 21 19:01:12 juno kernel: md: md1 already running, cannot run sdb2
Aug 21 19:01:12 juno kernel: md: export_rdev(sdk2)
Aug 21 19:01:12 juno kernel: md: export_rdev(sdi2)
Aug 21 19:01:12 juno kernel: md: export_rdev(sdb2)
Aug 21 19:01:12 juno kernel: md: considering sdb1 ...
Aug 21 19:01:12 juno kernel: md:  adding sdb1 ...
Aug 21 19:01:12 juno kernel: md:  adding sdi1 ...
Aug 21 19:01:12 juno kernel: md:  adding sdk1 ...
Aug 21 19:01:12 juno kernel: md: md0 already running, cannot run sdb1
Aug 21 19:01:12 juno kernel: md: export_rdev(sdk1)
Aug 21 19:01:12 juno kernel: md: export_rdev(sdi1)
Aug 21 19:01:12 juno kernel: md: export_rdev(sdb1)
Aug 21 19:01:12 juno kernel: md: ... autorun DONE.
Aug 21 19:01:13 juno kernel: XFS mounting filesystem md0
Aug 21 19:01:13 juno kernel: XFS mounting filesystem md1
Aug 21 19:03:08 juno kernel: md: bind<sdb1>
Aug 21 19:03:08 juno kernel: md: syncing RAID array md0
Aug 21 19:03:08 juno kernel: md: minimum _guaranteed_ reconstruction speed:
20000 KB/sec/disc.
Aug 21 19:03:08 juno kernel: md: using maximum available idle IO bandwidth
(but not more than 200000 KB/sec) for reconstruction.
Aug 21 19:03:08 juno kernel: md: using 128k window, over a total of 244141952
blocks.
Aug 21 19:03:15 juno kernel: md: bind<sdb2>
Aug 21 19:03:15 juno kernel: md: delaying resync of md1 until md0 has finished
resync (they share one or more physical units)
Aug 21 19:03:42 juno kernel: md: bind<sdi1>
Aug 21 19:03:51 juno kernel: md: bind<sdi2>


FWIW, I have installed FC5 and in the two or three reboots so far I haven't
seen any of this weirdness.


>
> >
> > Maybe I shouldn't be splitting the drives up into partitions.  I did
> > this due to issues with volumes greater than 2TB.  Maybe this isn't an
> > issue anymore and I should just rebuild the array from scratch with
> > single partitions.  Or should there even be partitions? Should I just
> > use /dev/sd[abcdefghijk] ?
> >
>
> I tend to just use whole drives, but your set up should work fine.
> md/raid isn't limited to 2TB, but some filesystems might have size
> issues (though i think even ext2 gots to at least 8 TB these days).

I'm using XFS.  I'll probably give this a try with a 4TB volume.


>
> > On a side note, maybe for another thread, the arrays work great until a
> > reboot (using 'shutdown' or 'reboot' and they seem to be shutting down
> > the md system correctly).  Sometimes one or even two (yikes!) partitions
> > in each array go offline and I have to mdadm /dev/md0 -a /dev/sdx1 it
> > back in.  Do others experience this regularly with RAID6?  Is RAID6 not
> > ready for prime time?
>
> This doesn't sound like a raid issues.  Do you have kernel logs of
> what happens when the array is reassembled and some drive(s) are
> missing?

See above.

If you'd rather not spend time on this that is fine.  Since the OS is changed
and I haven't seen this issue yet with the new OS it is probably moot.  Not
having the spare set up each time though is still an issue.

Thanks,

Steve






