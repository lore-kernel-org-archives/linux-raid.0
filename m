From: Russ Price <rjp_raid@fubegra.net>
Subject: SiI 3112 vs. VIA chipsets?
Date: Sun, 25 Apr 2004 13:07:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <408BFE6A.4090902@fubegra.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After losing one channel of the HPT370 long ago on my Abit KT7-RAID 
motherboard (currently running Fedora Core 1), I decided that I wanted 
to build a four-disk SATA RAID5 array.  I picked up a quartet of Samsung 
SP1213C drives, and a pair of SiI3112-based I/O Flex controllers.

Little did I realize what I was in for. I installed the drives and 
controllers, and promptly found that what I read from the disks wasn't 
necessarily what I wrote to them.  I could run mke2fs on a solo drive or 
an array, then immediately run fsck and find errors.  Not good.  Files 
that I wrote would be corrupted with wrong bytes in random places, and 
no error messages would appear in the syslog.  Installing FC1 on them 
would result in subsystems crashing with Signal 11 during boot, due to 
the random corruption of files.

I tried switching cards around to different slots, thinking it might be 
an IRQ sharing problem, but nothing I could do made a difference.  I 
even set up a Windows 2000 installation on a spare ATA100 drive, booted 
it, installed the SATA drivers, and found it wouldn't successfully 
format the SATA drives.

I then tried one of the controllers and a drive in my Shuttle SK41G box 
(also a VIA chipset), and the FC1 installer would reliably crash when 
installing to the SATA drive, even though it worked just fine with the 
on-board ATA133.  I was starting to wonder if I had just bought four 
expensive paperweights.

In desperation, I took a controller and drives to work, and stuck them 
into an Intel 810-based Celeron box.  The FC1 install went smoothly, and 
the drives performed flawlessly.

Now I've replaced the Abit board with a Gigabyte 7N400 Pro2 (nForce2 
chipset).  The on-board SATA is, unfortunately, an SiI3512, not 
supported yet.  I put in one of the 3112 controllers and hooked up two 
drives, and they worked fine, without the data corruption I was 
experiencing on the Abit.  Now I've put the second card in and hooked up 
the other two drives, and I'm waiting for the RAID5 to sync up before 
doing some stress-testing.

Is it just a case of these specific cards not liking VIA-based boards, 
or is there something deeper that caused the trouble?  The fact that 
Win2K didn't like the Abit/3112 combo points to hardware trouble, 
though, and the Abit was always a bit wonky (lots of DMA errors using 
the VIA UDMA66 controller, for instance).  Until half of it went blooey, 
the HPT370 was the only worthwhile ATA controller on that board.  That 
still doesn't explain the problems I had with the Shuttle XPC, though.
