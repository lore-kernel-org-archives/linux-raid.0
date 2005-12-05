From: Alfons Andorfer <a_a@gmx.de>
Subject: Re: RAID5 problem
Date: Mon, 05 Dec 2005 11:59:40 +0100
Message-ID: <43941D9C.4010206@gmx.de>
References: <4392FB7C.6080600@gmx.de> <17299.25606.806494.749914@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17299.25606.806494.749914@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, n@suse.de
List-Id: linux-raid.ids

Neil Brown wrote:

> On Sunday December 4, a_a@gmx.de wrote:
> 
>>Hi,
>>
>>I have a RAID5 array consisting of 4 disks:
>>
>>/dev/hda3
>>/dev/hdc3
>>/dev/hde3
>>/dev/hdg3
>>
>>and the Linux machine that this system was running on crashed yesterday 
>>due to a faulty Kernel driver (i.e. the machine just halted).
>>So I resetted it, but it didn't come up again.
>>I started the machine with a Knoppix CD and found out that the array had 
>>been running in degraded mode for about two months (/dev/hda3 went off 
>>then).
Here is a short snipped of the syslog:
--------------------------------------
Oct 22 15:30:07 omega kernel: hda: dma_intr: status=0x51 { DriveReady 
SeekComplete Error }
Oct 22 15:30:07 omega kernel: hda: dma_intr: error=0x40 { 
UncorrectableError }, LBAsect=454088, sector=4264
Oct 22 15:30:07 omega kernel: end_request: I/O error, dev 03:03 (hda), 
sector 4264
Oct 22 15:30:07 omega kernel: raid5: Disk failure on hda3, disabling 
device. Operation continuing on 3 devices
Oct 22 15:30:07 omega kernel: md: updating md0 RAID superblock on device
Oct 22 15:30:07 omega kernel: md: hda3 (skipping faulty)
Oct 22 15:30:07 omega kernel: md: hdc3 [events: 00000137]
Oct 22 15:30:07 omega kernel: (write) hdc3's sb offset: 119834496
Oct 22 15:30:07 omega kernel: md: recovery thread got woken up ...
Oct 22 15:30:07 omega kernel: md: hde3 [events: 00000137]
Oct 22 15:30:07 omega kernel: (write) hde3's sb offset: 119834496
Oct 22 15:30:07 omega kernel: md: hdg3 [events: 00000137]
Oct 22 15:30:07 omega kernel: (write) hdg3's sb offset: 119834496
Oct 22 15:30:07 omega kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Oct 22 15:30:07 omega kernel: md: recovery thread finished ...


> You want to be running "mdadm --monitor".  You really really do!
> Anyone out there who is listening: if you have any md/raid arrays
> (other than linear/raid0) and are not running "mdadm --monitor",
> please do so.  Now.
> Also run "mdadm --monitor --oneshot --scan" (or similar) from a
> nightly cron job, so it will nag you about degraded arrays.
> Please!
Yes you are absolutely right! It was my first thought when I saw the 
broken array: "There _must_ be a program that monitors the array 
automatically for me and gives an alert if something goes wrong!
And it will be the first thing to do after the array is running again!


> But why do you think that hda3 dropped out of the array 2 months ago?
> The update time reported by mdadm --examine is
>        Update Time : Sat Dec  3 18:56:59 2005
This comes from an attemt to assemble the array from hda3, hde3 and 
hdg3. The first "mdadm --examine" printed out an update time for hda3 
something in October...


> The superblock from hda3 seems to suggest that it was hdc3 that was
> the problem.... odd.
> 
> 
> 
>>"pass 1: checking Inodes, Blocks, and sizes
>>read error - Block 131460 (Attempt to read block from filesystem 
>>resulted in short read) during Inode-Scan  Ignore error?"
> 
> 
> 
> This strongly suggests there is a problem with one of the drives - it
> is returning read errors.  Are there any informative kernel logs.
> If it is hdc that is reporting errors, try to re-assemble the array
> from hda3, hde3, hdg3.
That is what I already tried, but didn't succeed. So I tried it with 
hd[ceg]3 and could even mount the array and the data seem to be OK at 
first glance. What I could certainly do is to plug in an external USB 
hard drive and to copy as many data as possible to the USB drive, but 
the problem is that the array consists of 4x120GB resulting in about 
360GB of data. So I hope I can reconstruct it without copying...


But the real strange thing to me is that I can mount the array and the 
data seem to be OK, but the "fsck" produces so many errors....

The other question is why does /dev/hdg3 appear _two_times_ and 
/dev/hda3 _doesn't_at_all_ when I type

mdadm --create /dev/md0 -c32 -l5 -n4 missing /dev/hdc3 /dev/hde3 /dev/hdg3

mdadm: /dev/hdc3 appears to be part of a raid array:
     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
mdadm: /dev/hde3 appears to be part of a raid array:
     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
mdadm: /dev/hdg3 appears to contain an ext2fs file system
     size=493736704K  mtime=Tue Jan  3 04:48:21 2006
mdadm: /dev/hdg3 appears to be part of a raid array:
     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
Continue creating array? no
mdadm: create aborted.


Thanks in advance

Alfons

