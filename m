From: David Nedved <dnedved@nuvox.net>
Subject: RAID-1 md comes up degraded every time
Date: Sat, 8 Jun 2002 11:06:45 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020608110645.A16350@nuvox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I created a RAID-1 volume on Linux 2.4.18 by creating the volume in degraded
mode, then hot-adding the second disk.  It syncs up fine, but every time I
reboot, it comes back in degraded mode.  Can someone help me figure out what
I'm doing wrong?

(it looks like I've got two RAID's, both of which contain /dev/hde1, and
I really don't quite understand what's happened).

Here is the /etc/raidtab:

raiddev	/dev/md1
	raid-level		1
	nr-raid-disks		2
	nr-spare-disks		0
	persistent-superblock	1
	chunk-size		4
	device			/dev/hde1
	raid-disk		0
	device			/dev/hdg1
	raid-disk		1

(device /dev/hdg1 was set as failed disk during build, and then switched to
raid-disk before raidhotadd)

Here is the section of /var/log/messages from when it boots:

Jun  5 00:00:58 celeri kernel: md: raid1 personality registered as nr 3
Jun  5 00:00:58 celeri kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Jun  5 00:00:58 celeri kernel: md: Autodetecting RAID arrays.
Jun  5 00:00:58 celeri kernel:  [events: 00000014]
Jun  5 00:00:58 celeri kernel: md: autorun ...
Jun  5 00:00:58 celeri kernel: md: considering hde1 ...
Jun  5 00:00:58 celeri kernel: md:  adding hde1 ...
Jun  5 00:00:58 celeri kernel: md: created md1
Jun  5 00:00:58 celeri kernel: md: bind<hde1,1>
Jun  5 00:00:58 celeri kernel: md: running: <hde1>
Jun  5 00:00:58 celeri kernel: md: hde1's event counter: 00000014
Jun  5 00:00:58 celeri kernel: md: RAID level 1 does not need chunksize! Continuing anyway.
Jun  5 00:00:58 celeri kernel: md1: max total readahead window set to 124k
Jun  5 00:00:58 celeri kernel: md1: 1 data-disks, max readahead per data-disk: 124k
Jun  5 00:00:59 celeri kernel: raid1: device hde1 operational as mirror 0
Jun  5 00:00:59 celeri kernel: raid1: md1, not all disks are operational -- trying to recover array
Jun  5 00:00:59 celeri kernel: raid1: raid set md1 active with 1 out of 2 mirrors
Jun  5 00:00:59 celeri kernel: md: recovery thread got woken up ...
Jun  5 00:00:59 celeri kernel: md1: no spare disk to reconstruct array! -- continuing in degraded mode
Jun  5 00:00:59 celeri kernel: md: recovery thread finished ...
Jun  5 00:00:59 celeri kernel: md: updating md1 RAID superblock on device
Jun  5 00:00:59 celeri kernel: md: hde1 [events: 00000015]<6>(write) hde1's sb offset: 40202560
Jun  5 00:00:59 celeri kernel: md: ... autorun DONE.

Here is the section during a raidhotadd /dev/md1 /dev/hdg1:

Jun  5 22:37:08 celeri kernel: md: trying to hot-add hdg1 to md1 ...
Jun  5 22:37:08 celeri kernel: md: bind<hdg1,2>
Jun  5 22:37:08 celeri kernel: RAID1 conf printout:
Jun  5 22:37:08 celeri kernel:  --- wd:1 rd:2 nd:2
Jun  5 22:37:08 celeri kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
Jun  5 22:37:08 celeri kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
Jun  5 22:37:08 celeri kernel:  disk 2, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
Jun  5 22:37:08 celeri kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
<SNIP UP TO DISK 26>
Jun  5 22:37:08 celeri kernel: RAID1 conf printout:
Jun  5 22:37:08 celeri kernel:  --- wd:1 rd:2 nd:3
Jun  5 22:37:08 celeri kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
Jun  5 22:37:08 celeri kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
Jun  5 22:37:08 celeri kernel:  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:hdg1
Jun  5 22:37:08 celeri kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
<SNIP>
Jun  5 22:37:08 celeri kernel: md: updating md1 RAID superblock on device
Jun  5 22:37:08 celeri kernel: md: hdg1 [events: 00000016]<6>(write) hdg1's sb offset: 40202560
Jun  5 22:37:08 celeri kernel: md: hde1 [events: 00000016]<6>(write) hde1's sb offset: 40202560
Jun  5 22:37:08 celeri kernel: md: recovery thread got woken up ...
Jun  5 22:37:08 celeri kernel: md1: resyncing spare disk hdg1 to replace failed disk
Jun  5 22:37:08 celeri kernel: RAID1 conf printout:
Jun  5 22:37:08 celeri kernel:  --- wd:1 rd:2 nd:3
Jun  5 22:37:08 celeri kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
Jun  5 22:37:08 celeri kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
Jun  5 22:37:08 celeri kernel:  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:hdg1
Jun  5 22:37:08 celeri kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
<SNIP>
Jun  5 22:37:08 celeri kernel: RAID1 conf printout:
Jun  5 22:37:08 celeri kernel:  --- wd:1 rd:2 nd:3
Jun  5 22:37:08 celeri kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
Jun  5 22:37:08 celeri kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
Jun  5 22:37:08 celeri kernel:  disk 2, s:1, o:1, n:2 rd:2 us:1 dev:hdg1
Jun  5 22:37:08 celeri kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
<SNIP>
Jun  5 22:37:08 celeri kernel: md: syncing RAID array md1
Jun  5 22:37:08 celeri kernel: md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
Jun  5 22:37:08 celeri kernel: md: using maximum available idle IO bandwith (but not more than 100000 KB/sec) for reconstruction.
Jun  5 22:37:08 celeri kernel: md: using 124k window, over a total of 40202560 blocks.
Jun  5 22:39:31 celeri kernel: APIC error on CPU0: 04(04)
Jun  5 22:47:56 celeri kernel: APIC error on CPU1: 08(08)
Jun  5 22:47:56 celeri kernel: APIC error on CPU0: 04(04)
Jun  5 22:50:56 celeri kernel: APIC error on CPU1: 08(08)
Jun  5 22:50:56 celeri kernel: APIC error on CPU0: 04(04)
Jun  5 22:57:58 celeri kernel: APIC error on CPU1: 08(08)
Jun  5 22:57:58 celeri kernel: APIC error on CPU0: 04(04)
Jun  5 23:04:00 celeri kernel: APIC error on CPU1: 08(08)
Jun  5 23:04:00 celeri kernel: APIC error on CPU0: 04(04)
Jun  5 23:04:33 celeri kernel: md: md1: sync done.
Jun  5 23:04:33 celeri kernel: RAID1 conf printout:
Jun  5 23:04:33 celeri kernel:  --- wd:1 rd:2 nd:3
Jun  5 23:04:33 celeri kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
Jun  5 23:04:33 celeri kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
Jun  5 23:04:33 celeri kernel:  disk 2, s:1, o:1, n:2 rd:2 us:1 dev:hdg1
Jun  5 23:04:33 celeri kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
<SNIP>
Jun  5 23:04:33 celeri kernel: RAID1 conf printout:
Jun  5 23:04:33 celeri kernel:  --- wd:2 rd:2 nd:3
Jun  5 23:04:33 celeri kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
Jun  5 23:04:34 celeri kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdg1
Jun  5 23:04:34 celeri kernel:  disk 2, s:0, o:0, n:2 rd:2 us:0 dev:[dev 00:00]
Jun  5 23:04:34 celeri kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
Jun  5 23:04:34 celeri kernel: md: updating md1 RAID superblock on device
Jun  5 23:04:34 celeri kernel: md: hdg1 [events: 00000017]<6>(write) hdg1's sb offset: 40202560
Jun  5 23:04:34 celeri kernel: md: hde1 [events: 00000017]<6>(write) hde1's sb offset: 40202560
Jun  5 23:04:34 celeri kernel: md: recovery thread finished ...

And that's that.  If anyone read down to here, THANK YOU, and I really hope
there's something simple I did wrong (like somehow creating two RAID's with
some of the same disks?)

David
