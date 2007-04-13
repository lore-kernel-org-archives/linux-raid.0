From: "John Stoffel" <john@stoffel.org>
Subject: Re: md0: invalid bitmap page request: 249 (> 223)
Date: Fri, 13 Apr 2007 08:56:37 -0400
Message-ID: <17951.32261.681678.365931@smtp.charter.net>
References: <17950.22648.37421.148022@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17950.22648.37421.148022@smtp.charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

This is an update email, my system is now up and running properly,
though with some caveats.  

John> I've just installed a new SATA controller and a pair of 320Gb
John> disks into my system.  Went great.  I'm running 2.6.21-rc6, with
John> the ATA drivers for my disks.

John> I had a RAID1 mirror consisting of two 120gb disks.  I used
John> mdadm and grew the number of disks in md0 to four, then added in
John> the two new disks.  Let it resync overnight, and then this
John> morning I removed the two old disks.  Went really really really
John> well.

This is where I think part of the problem came in.  When you do a:

  mdadm /dev/md0 --fail /dev/sde1

The superblock on the disk isn't wiped nicely, or at least the UUID
isn't changed to be something different.  This can cause problems
later on if you have to reboot the system and it discoveres one of the
removed disks first, before the actual live disks are found.  

Not fun, and certainly close to heart attack time.  *grin*

John> But now I'm trying to grow (using mdadm v2.5.6, Debian unstable
John> system) the array to use the full space now available.  Then
John> I'll grow the PVs and LVs I have on top of these to make them
John> bigger as well.

I've also found issues with the LVM2 tools, in that you can't muck
with UUIDs or PV UUIDs easily.  

John> The re-sync is going:

>> cat /proc/mdstat
John>     Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
John>     [raid4] 
John>     md0 : active raid1 sdd1[1] sdc1[0]
John> 	  312568000 blocks [2/2] [UU]
John> 	  [========>............]  resync = 42.1% (131637248/312568000)
John>     finish=373264.5min speed=0K/sec
John> 	  bitmap: 1/224 pages [4KB], 256KB chunk

John>     unused devices: <none>


John> But it's going slowly and dragging down the whole system with
John> pauses, and I'm getting tons of the following messages in my
John> dmesg output:

John>     [50683.698708] md0: invalid bitmap page request: 251 (> 223)
John>     [50683.763687] md0: invalid bitmap page request: 251 (> 223)
John>     [50683.828621] md0: invalid bitmap page request: 251 (> 223)
John>     [50683.893520] md0: invalid bitmap page request: 251 (> 223)
John>     [50683.958396] md0: invalid bitmap page request: 251 (> 223)
John>     [50684.023265] md0: invalid bitmap page request: 251 (> 223)
John>     [50684.088202] md0: invalid bitmap page request: 251 (> 223)
John>     [50684.153196] md0: invalid bitmap page request: 251 (> 223)
John>     [50684.218129] md0: invalid bitmap page request: 251 (> 223)
John>     [50684.283044] md0: invalid bitmap page request: 251 (> 223)


John> Is there anyway I can interrupt the command I used:

John> 	mdadm --grow /dev/md0 --size=#####

John> which I know now I should have used the --size=max paramter
John> instead, but it wasn't in the man page or the online help.  Oh
John> well...

John> I tried removing the bitmap with:

John> 	mdadm --grow /dev/md0 --bitmap=none

John> but of course it won't let me do that.  Would I have to hot-fail
John> one of my disks to interrupt the re-sync, so I can remove the
John> bitmap, so I can then grow the RAID1 to the max volume size?

Well, once I had tried to remove the bitap during a sync, I couldn't
actually look at the output of /proc/mdstat anymore, it would just
hang when I did:  cat /proc/mdstat

So I ended up doing a reboot, which is where I then ran into a couple
of problems:

1. When you have a UUID listed in your /etc/mdadm/mdadm.conf, and
   you've changed the UUID on an array, you better change the conf file
   as well.  

   This sucks because I don't want to change the UUID of the live
   array, I want to change the UUIDs of the devices I failed and removed,
   so that they /WILL NOT/ be considered during the next assembly of
   an array.


2. LVM2 PV (Physical Volumes) have the same damm problem.  Grrr...


So I ended up unplugging the power to my old disks and rebooting a
couple of times and I managed to get all my data back, lvextend the
volumes and resize2fs the filesystems.  I'm happy.  Though I'm sad I
had as much downtime as I did.  

John
