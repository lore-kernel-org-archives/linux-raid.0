From: "John Stoffel" <john@stoffel.org>
Subject: md0: invalid bitmap page request: 249 (> 223)
Date: Thu, 12 Apr 2007 12:04:08 -0400
Message-ID: <17950.22648.37421.148022@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,

I've just installed a new SATA controller and a pair of 320Gb disks
into my system.  Went great.  I'm running 2.6.21-rc6, with the ATA
drivers for my disks.

I had a RAID1 mirror consisting of two 120gb disks.  I used mdadm and
grew the number of disks in md0 to four, then added in the two new
disks.  Let it resync overnight, and then this morning I removed the
two old disks.  Went really really really well.

But now I'm trying to grow (using mdadm v2.5.6, Debian unstable
system) the array to use the full space now available.  Then I'll grow
the PVs and LVs I have on top of these to make them bigger as well.

The re-sync is going:

    > cat /proc/mdstat
    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
    [raid4] 
    md0 : active raid1 sdd1[1] sdc1[0]
	  312568000 blocks [2/2] [UU]
	  [========>............]  resync = 42.1% (131637248/312568000)
    finish=373264.5min speed=0K/sec
	  bitmap: 1/224 pages [4KB], 256KB chunk

    unused devices: <none>


But it's going slowly and dragging down the whole system with pauses,
and I'm getting tons of the following messages in my dmesg output:

    [50683.698708] md0: invalid bitmap page request: 251 (> 223)
    [50683.763687] md0: invalid bitmap page request: 251 (> 223)
    [50683.828621] md0: invalid bitmap page request: 251 (> 223)
    [50683.893520] md0: invalid bitmap page request: 251 (> 223)
    [50683.958396] md0: invalid bitmap page request: 251 (> 223)
    [50684.023265] md0: invalid bitmap page request: 251 (> 223)
    [50684.088202] md0: invalid bitmap page request: 251 (> 223)
    [50684.153196] md0: invalid bitmap page request: 251 (> 223)
    [50684.218129] md0: invalid bitmap page request: 251 (> 223)
    [50684.283044] md0: invalid bitmap page request: 251 (> 223)


Is there anyway I can interrupt the command I used:

	mdadm --grow /dev/md0 --size=#####

which I know now I should have used the --size=max paramter instead,
but it wasn't in the man page or the online help.  Oh well...

I tried removing the bitmap with:

	mdadm --grow /dev/md0 --bitmap=none

but of course it won't let me do that.  Would I have to hot-fail one
of my disks to interrupt the re-sync, so I can remove the bitmap, so I
can then grow the RAID1 to the max volume size?

Thanks,
John
john@stoffel.org
