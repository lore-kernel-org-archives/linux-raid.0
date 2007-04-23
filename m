From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Mon, 23 Apr 2007 15:56:27 +0100
Message-ID: <462CC91B.8030008@dgreaves.com>
References: <45709639.70104@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45709639.70104@laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

I think this is a bug.

Essentially if I create an auto=part md device then I get md_d0p? partitions.
If I stop the array and just re-assemble, I don't.

It looks like the same (?) problem as Mike (see below - Mike do you have a
patch?) but I'm on 2.6.20.7 with mdadm v2.5.6

FWIW I upgraded from 2.6.16 where it worked (but used in-kernel detection which
isn't working in 2.6.20 for some reason but I don't mind).


Here's a simple sequence of commands:

teak:~# mdadm --stop /dev/md_d0
mdadm: stopped /dev/md_d0

teak:~# mdadm --create /dev/md_d0 -l5 -n5 --bitmap=internal -e1.2 --auto=part
--name media --force /dev/sde1 /dev/sdc1 /dev/sdd1 missing /dev/sdf1
mdadm: /dev/sde1 appears to be part of a raid array:
    level=raid5 devices=5 ctime=Mon Apr 23 15:02:13 2007
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid5 devices=5 ctime=Mon Apr 23 15:02:13 2007
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid5 devices=5 ctime=Mon Apr 23 15:02:13 2007
mdadm: /dev/sdf1 appears to be part of a raid array:
    level=raid5 devices=5 ctime=Mon Apr 23 15:02:13 2007
Continue creating array? y
mdadm: array /dev/md_d0 started.

teak:~# grep md /proc/partitions
 254     0 1250241792 md_d0
 254     1 1250144138 md_d0p1
 254     2      97652 md_d0p2

teak:~# mdadm --stop /dev/md_d0
mdadm: stopped /dev/md_d0

teak:~# mdadm --assemble /dev/md_d0 --auto=part  /dev/sde1 /dev/sdc1 /dev/sdd1
/dev/sdf1
mdadm: /dev/md_d0 has been started with 4 drives (out of 5).

teak:~# grep md /proc/partitions
 254     0 1250241792 md_d0


If I then run cfdisk it finds the partition table. I write this and get:
teak:~# cfdisk /dev/md_d0

Disk has been changed.

WARNING: If you have created or modified any
DOS 6.x partitions, please see the cfdisk manual
page for additional information.
teak:~# grep md /proc/partitions
 254     0 1250241792 md_d0
 254     1 1250144138 md_d0p1
 254     2      97652 md_d0p2


and the syslog:
Apr 23 15:13:13 localhost kernel: md: md_d0 stopped.
Apr 23 15:13:13 localhost kernel: md: unbind<sde1>
Apr 23 15:13:13 localhost kernel: md: export_rdev(sde1)
Apr 23 15:13:13 localhost kernel: md: unbind<sdf1>
Apr 23 15:13:13 localhost kernel: md: export_rdev(sdf1)
Apr 23 15:13:13 localhost kernel: md: unbind<sdd1>
Apr 23 15:13:13 localhost kernel: md: export_rdev(sdd1)
Apr 23 15:13:13 localhost kernel: md: unbind<sdc1>
Apr 23 15:13:13 localhost kernel: md: export_rdev(sdc1)
Apr 23 15:13:13 localhost mdadm: DeviceDisappeared event detected on md device
/dev/md_d0
Apr 23 15:13:36 localhost kernel: md: bind<sde1>
Apr 23 15:13:36 localhost kernel: md: bind<sdc1>
Apr 23 15:13:36 localhost kernel: md: bind<sdd1>
Apr 23 15:13:36 localhost kernel: md: bind<sdf1>
Apr 23 15:13:36 localhost kernel: raid5: device sdf1 operational as raid disk 4
Apr 23 15:13:36 localhost kernel: raid5: device sdd1 operational as raid disk 2
Apr 23 15:13:36 localhost kernel: raid5: device sdc1 operational as raid disk 1
Apr 23 15:13:36 localhost kernel: raid5: device sde1 operational as raid disk 0
Apr 23 15:13:36 localhost kernel: raid5: allocated 5236kB for md_d0
Apr 23 15:13:36 localhost kernel: raid5: raid level 5 set md_d0 active with 4
out of 5 devices, algorithm 2
Apr 23 15:13:36 localhost kernel: RAID5 conf printout:
Apr 23 15:13:36 localhost kernel:  --- rd:5 wd:4
Apr 23 15:13:36 localhost kernel:  disk 0, o:1, dev:sde1
Apr 23 15:13:36 localhost kernel:  disk 1, o:1, dev:sdc1
Apr 23 15:13:36 localhost kernel:  disk 2, o:1, dev:sdd1
Apr 23 15:13:36 localhost kernel:  disk 4, o:1, dev:sdf1
Apr 23 15:13:36 localhost kernel: md_d0: bitmap initialized from disk: read 1/1
pages, set 19078 bits, status: 0
Apr 23 15:13:36 localhost kernel: created bitmap (10 pages) for device md_d0
Apr 23 15:13:36 localhost kernel:  md_d0: p1 p2
Apr 23 15:13:54 localhost kernel: md: md_d0 stopped.
Apr 23 15:13:54 localhost kernel: md: unbind<sdf1>
Apr 23 15:13:54 localhost kernel: md: export_rdev(sdf1)
Apr 23 15:13:54 localhost kernel: md: unbind<sdd1>
Apr 23 15:13:54 localhost kernel: md: export_rdev(sdd1)
Apr 23 15:13:54 localhost kernel: md: unbind<sdc1>
Apr 23 15:13:54 localhost kernel: md: export_rdev(sdc1)
Apr 23 15:13:54 localhost kernel: md: unbind<sde1>
Apr 23 15:13:54 localhost kernel: md: export_rdev(sde1)
Apr 23 15:13:54 localhost mdadm: DeviceDisappeared event detected on md device
/dev/md_d0
Apr 23 15:14:04 localhost kernel: md: md_d0 stopped.
Apr 23 15:14:04 localhost kernel: md: bind<sdc1>
Apr 23 15:14:04 localhost kernel: md: bind<sdd1>
Apr 23 15:14:04 localhost kernel: md: bind<sdf1>
Apr 23 15:14:04 localhost kernel: md: bind<sde1>
Apr 23 15:14:04 localhost kernel: raid5: device sde1 operational as raid disk 0
Apr 23 15:14:04 localhost kernel: raid5: device sdf1 operational as raid disk 4
Apr 23 15:14:04 localhost kernel: raid5: device sdd1 operational as raid disk 2
Apr 23 15:14:04 localhost kernel: raid5: device sdc1 operational as raid disk 1
Apr 23 15:14:04 localhost kernel: raid5: allocated 5236kB for md_d0
Apr 23 15:14:04 localhost kernel: raid5: raid level 5 set md_d0 active with 4
out of 5 devices, algorithm 2
Apr 23 15:14:04 localhost kernel: RAID5 conf printout:
Apr 23 15:14:04 localhost kernel:  --- rd:5 wd:4
Apr 23 15:14:04 localhost kernel:  disk 0, o:1, dev:sde1
Apr 23 15:14:04 localhost kernel:  disk 1, o:1, dev:sdc1
Apr 23 15:14:04 localhost kernel:  disk 2, o:1, dev:sdd1
Apr 23 15:14:04 localhost kernel:  disk 4, o:1, dev:sdf1
Apr 23 15:14:04 localhost kernel: md_d0: bitmap initialized from disk: read 1/1
pages, set 0 bits, status: 0
Apr 23 15:14:04 localhost kernel: created bitmap (10 pages) for device md_d0
Apr 23 15:14:04 localhost kernel:  md_d0: unknown partition table

after cfdisk write:
Apr 23 15:33:00 localhost kernel:  md_d0: p1 p2


Back in dec 2006,Mike Accetta wrote:
> In setting up a partitioned array as the boot disk and using a nash
> initrd to find the root file system by volume label, I see a delay in
> the appearance of the /dev/md_d0p partitions in /proc/partitions.  When
> the mdadm --assemble command completes, only /dev/md_d0 is visible.
> Since the raid partitions are not visible after the assemble, the volume
> label search will not consult them in looking for the root volume and
> the boot gets aborted. When I run a similar assemble command while up
> multi-user in a friendlier debug environment I see the same effect and
> observe that pretty much any access of /dev/md_d0 has the side effect of
> then making the /dev/md_d0p partitions visible in /proc/partitions.
>
> I tried a few experiments changing the --assemble code in mdadm.  If I
> open() and close() /dev/md_d0 after assembly *before* closing the file
> descriptor which the assemble step used to assemble the array, there is
> no effect.  Even doing a BLKRRPART ioctl call on the assembly fd or the
> newly opened fd have no effect.  The kernel prints "unknown partition"
> diagnostics on the console.  However, if the assembly fd is first
> close()'d, a simple open() of /dev/md_d0 and immediate close() of that
> fd has the side effect of making the /dev/md_d0p partitions visible and
> one sees the console disk partitioning confirmation from the kernel as
> well.
>
> Adding the open()/close() after assembly within mdadm solves my problem,
> but I thought I'd raise the issue on the list as it seems there is a bug
> somewhere.  I see in the kernel md driver that the RUN_ARRAY ioctl()
> calls do_md_run() which calls md_probe() which calls add_disk() and I
> gather that this would normally have the side effect of making the
> partitions visible.  However, my experiments at user level seem to imply
> that the array isn't completely usable until the assembly file
> descriptor is closed, even on return from the ioctl(), and hence the
> kernel add_disk() isn't having the desired partitioning side effect at
> the point it is being invoked.
>
> This is all with kernel 2.6.18 and mdadm 2.3.1

