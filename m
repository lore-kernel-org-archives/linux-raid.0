From: "David M. Strang" <dstrang@shellpower.net>
Subject: MD or MDADM bug?
Date: Thu, 1 Sep 2005 17:26:55 -0400
Message-ID: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is somewhat of a crosspost from my thread yesterday; but I think it 
deserves it's own thread atm. Some time ago, I had a device fail -- with the 
help of Neil, Tyler & others on the mailing list; a few patches to mdadm --  
I was able to recover. Using mdadm --remove & mdadm --add, I was able to 
rebuild the bad disc in my array. Everything seemed fine; however -- when I 
rebooted and re-assembled the raid; it wouldn't take the disk that was 
re-added. I had to add it again; and let it rebuild. About 3 weeks ago, I 
lost power -- the outage lasted longer than the UPS, and my system shutdown. 
Upon startup, once again -- I had to re-add 'the disk' back to the array. 
For some reason, if I remove a device and add it back -- when I stop and 
re-assemble the array - it won't 'start' that disk.

Last night, I had a drive fail. With help from Michael & Forrest; I was able 
to attempt to rebuild the array by hot replacing the failed drive without 
rebooting to re-enable disk I/O to that position -- I only had one spare 
available -- it was suspect; and it turns out it was bad. During the 
rebuild, the disk started to have errors -- and the array puked:

Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sda, disabling device. 
Operation continuing on 26 devices
Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sdb, disabling device. 
Operation continuing on 25 devices
Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sdi, disabling device. 
Operation continuing on 18 devices
Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sdj, disabling device. 
Operation continuing on 17 devices
Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sdk, disabling device. 
Operation continuing on 16 devices
Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sdl, disabling device. 
Operation continuing on 15 devices
Aug 31 21:45:40 abyss kernel: raid5: Disk failure on sdn, disabling device. 
Operation continuing on 14 devices

All of this disks tested fine; this happened once before -- simply forcing 
the raid to re-assemble fixes the issue; then replace the bad disk and 
re-sync it.

The problem is; my array is now 26 of 28 disks -- /dev/sdm *IS* bad; it was 
removed and re-added but the new drive is faulty -- however, disk /dev/sdaa 
is not bad -- but, since it was the 'original' disk that was hot removed / 
added so long ago -- it doesn't assemble into the raid. I'm really stuck, I 
can't start the array -- and obviously I can't rebuild the two 'bad'  disks. 
I asked this once before; and was told -- No, you shouldn't have to hotadd 
and resync each time, after hot-adding a "new" device and the initial 
rebuild finishes, unless there's another failure after that, or an unclean 
shutdown.

What can I do? I don't believe this is working as intended.

I'm using mdadm 2.0-devel-3 on a Linux 2.6.11.12 kernel, with version-1 
superblocks.

-- David


