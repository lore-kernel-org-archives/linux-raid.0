From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 crash and burn
Date: Sun, 31 Oct 2004 08:15:28 -0500
Message-ID: <200410311315.i9VDFXN27460@www.watkins-home.com>
References: <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
Sender: linux-raid-owner@vger.kernel.org
To: coreyfro@coreyfro.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How often do you swap?  Maybe never, if never, what performance problem?
Most people have more memory than needed these days, so little or no
swapping.

Performance problem....  No idea, writing may be slower, reading would be
faster, since you can read from 2 disks at once.

I don't want my system to crash, so I mirror swap.

If you are really worried, create little swap partitions on every disk, and
mirror them.  You have 6 disks (or more), you could have 3 mirrored swap
partitions.  This is what I do on large Unix systems (HP-UX).  This way if
it does swap it has 10 or more swap partitions to use, which allows it to
swap ten times faster.

With HP-UX you must have swap space.  1 reason, anytime shared memory is
allocated, the swap space is reserved, even if it is never used.  Seems
silly, I had an 8Gig system which never used even 4 gig, I needed about 2
gig of swap space that was not written to.  As far as I know, Linux does not
require swap space unless you want to exceed available memory.  But I never
risk it, I have swap.

A swap story....
I once had a system that the users said was so slow they almost could not
type.  I knew they were over reacting.  It took me about 10 minutes to
login.  It was so slow the login was timing out before it asked for my
passwd.  I saw it was using on 10-20% of the CPU.  But the boot disk was at
100% usage, swapping.  It could not use more CPU because every process was
waiting to swap in some code.  I created little 128Meg partitions on every
disk I could use.  Maybe 6 to 10 of them.  Each time I added 1 of them to
swap, the system got faster.  I gave the new swap partitions priority 0 so
the new swap partitions would be favored over the default one.  By the time
I was done the CPU load was at 90% or more, and the users were happy.  We
did add ram soon after that.  My emergency swap partitions were not
mirrored, with HP-UX you must buy the mirror software.  That sucks!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of coreyfro@coreyfro.com
Sent: Sunday, October 31, 2004 5:00 AM
To: linux-raid@vger.kernel.org
Subject: RE: RAID5 crash and burn

Ahhhhhh... doesn't use the raidtab... nothing needs raidtab anymore... i
guess its time i got with the program...

About swap failing, would there be much of a performence hit if i mirrored
swap?  I don't like running without it, and I don't want to repeat this
incident...  My system has more than enough ram for the load it has, but I
under stand the other reasons for having swap, so slow swap is better than
nothing or faulty, i spose...

Looks like fsck is working, thanks for the help...

> Normally I would refer you to the man page for mdadm.
>
> --scan requires the config file, I have read that mdadm will crash if you
> use --scan with out it.
>
> Try this:
> mdadm --assemble /dev/md2 /dev/hda3 /dev/hdc3 /dev/hde3 /dev/hdi3
> /dev/hdk3
>
> or this:
> mdadm --assemble /dev/md2 --force /dev/hda3 /dev/hdc3 /dev/hde3 /dev/hdi3
> /dev/hdk3
>
> I left out hdg3, since you indicate it is the failed disk.
>
> Guy
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of
> coreyfro@coreyfro.com
> Sent: Sunday, October 31, 2004 12:59 AM
> To: linux-raid@vger.kernel.org
> Subject: RAID5 crash and burn
>
> Its that time of the year again.  My biannual RAID5 crash.  Yippie!
>
> I had a drive die yesterday, and, while raid 5 can handle that, the kernel
> couldn't handle the swap on that drive going poof.  My system crashed, so
> I rebooted, thinking that the system would be able to figure out that the
> swap was dead and not to start it.
>
> RAID5 started rebuilding, services started loading, started loading swap,
> system crashed again.
>
> Now, my raid is down.  I have tried using mdadm, the old raidtools, and
> kicking the machine, but nothing has worked.
>
> Here is all the info I can think to muster, let me know if i need to add
> anything else.
>
> Thanks,
> Coreyfro
>
> ========================================================================
> ilneval ~ # cat /proc/version
> Linux version 2.6.7-gentoo-r12 (root@livecd) (gcc version 3.3.4 20040623
> (Gentoo Linux 3.3.4-r1, ssp-3.3.2-2, pie-8.7.6)) #1 Fri Aug 13 22:04:18
> PDT 2004
>
> ========================================================================
> ilneval ~ # cat /etc/raidtab.bak
> # autogenerated /etc/raidtab by YaST2
>
> raiddev /dev/md0
>    raid-level       1
>    nr-raid-disks    2
>    nr-spare-disks   0
>    persistent-superblock 1
>    chunk-size        4
>    device   /dev/hde1
>    raid-disk 0
>    device   /dev/hdg1
>    raid-disk 1
>
> raiddev /dev/md1
>    raid-level       1
>    nr-raid-disks    2
>    nr-spare-disks   0
>    persistent-superblock 1
>    chunk-size        4
>    device   /dev/hda1
>    raid-disk 0
>    device   /dev/hdc1
>    raid-disk 1
>
> raiddev /dev/md3
>    raid-level       1
>    nr-raid-disks    2
>    nr-spare-disks   0
>    persistent-superblock 1
>    chunk-size        4
>    device   /dev/hdi1
>    raid-disk 0
>    device   /dev/hdk1
>    raid-disk 1
>
> raiddev /dev/md2
>     raid-level                5
>     nr-raid-disks             6
>     nr-spare-disks            0
>     persistent-superblock     1
>
>    chunk-size                 64
>     device                    /dev/hda3
>     raid-disk                 0
>     device                    /dev/hdc3
>     raid-disk                 1
>     device                    /dev/hde3
>     failed-disk                 2
>     device                    /dev/hdg3
>     raid-disk                 3
>     device                    /dev/hdi3
>     raid-disk                 4
>     device                    /dev/hdk3
>     raid-disk                 5
>
> ========================================================================
> ilneval ~ # cat /proc/mdstat
> Personalities : [raid1] [raid5]
> md3 : active raid1 hdk1[1] hdi1[0]
>       2562240 blocks [2/2] [UU]
>
> md1 : active raid1 hdc1[1] hda1[0]
>       2562240 blocks [2/2] [UU]
>
> md0 : active raid1 hdg1[1]
>       2562240 blocks [2/1] [_U]
>
> unused devices: <none>
>
> (Note the lack of /DEV/MD2
>
> ========================================================================
> ilneval etc # dmesg -c
> md: raidstart(pid 1821) used deprecated START_ARRAY ioctl. This will not
> be supported beyond 2.6
> md: autorun ...
> md: considering hde3 ...
> md:  adding hde3 ...
> md:  adding hdk3 ...
> md:  adding hdi3 ...
> md:  adding hdg3 ...
> md:  adding hdc3 ...
> md:  adding hda3 ...
> md: created md2
> md: bind<hda3>
> md: bind<hdc3>
> md: bind<hdg3>
> md: bind<hdi3>
> md: bind<hdk3>
> md: bind<hde3>
> md: running: <hde3><hdk3><hdi3><hdg3><hdc3><hda3>
> md: kicking non-fresh hde3 from array!
> md: unbind<hde3>
> md: export_rdev(hde3)
> md: md2: raid array is not clean -- starting background reconstruction
> raid5: device hdk3 operational as raid disk 5
> raid5: device hdi3 operational as raid disk 4
> raid5: device hdg3 operational as raid disk 3
> raid5: device hdc3 operational as raid disk 1
> raid5: device hda3 operational as raid disk 0
> raid5: cannot start dirty degraded array for md2
> RAID5 conf printout:
>  --- rd:6 wd:5 fd:1
>  disk 0, o:1, dev:hda3
>  disk 1, o:1, dev:hdc3
>  disk 3, o:1, dev:hdg3
>  disk 4, o:1, dev:hdi3
>  disk 5, o:1, dev:hdk3
> raid5: failed to run raid set md2
> md: pers->run() failed ...
> md :do_md_run() returned -22
> md: md2 stopped.
> md: unbind<hdk3>
> md: export_rdev(hdk3)
> md: unbind<hdi3>
> md: export_rdev(hdi3)
> md: unbind<hdg3>
> md: export_rdev(hdg3)
> md: unbind<hdc3>
> md: export_rdev(hdc3)
> md: unbind<hda3>
> md: export_rdev(hda3)
> md: ... autorun DONE.
>
> ========================================================================
>
> ilneval etc # mdadm --assemble --scan /dev/md2
> Segmentation fault
>
> ========================================================================
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

