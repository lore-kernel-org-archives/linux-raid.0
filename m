From: Neil Brown <neilb@suse.de>
Subject: Re: In Trouble--Please Help!  (was Re: Can't add disk to failed raid array)
Date: Sun, 23 Jul 2006 21:25:02 +1000
Message-ID: <17603.23694.20794.434276@cse.unsw.edu.au>
References: <200607152056.55090.pwaldo@waldoware.com>
	<200607160824.04175.pwaldo@waldoware.com>
	<17596.29506.188695.678634@cse.unsw.edu.au>
	<200607230704.46377.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Waldo on Sunday July 23
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 23, pwaldo@waldoware.com wrote:
> Please, please! I am dead in the water!
> 
> To recap, I have a RAID6 array on a Fedora Core 5 system, using /dev/hd[acdeg]
> 2 and /dev/sd[ab]2.  /dev/hdd went bad so I replaced the drive and tried to 
> add it back to the array.  Here is what happens:
> 
> #mdadm --assemble /dev/md1 /dev/hd[acdeg]2 /dev/sd[ab]2
> mdadm: no RAID superblock on /dev/hdd2
> mdadm: /dev/hdd2 has no superblock - assembly aborted
> 
> I also tried assembling without the new drive:
> #mdadm --assemble /dev/md1 /dev/hd[aceg]2 /dev/sd[ab]2
> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
> 
> Forgive me if the messages are not exactly correct, as I am booted into the FC 
> rescue disk and I am transcribing what I see to another computer.
> 
> How can I get mdadm to use the new drive?  Am I completely fscked?  Thanks in 
> advance for any help!!!!

Sorry for not following through on this earlier.
I think I know what the problem is.

 From the "-E" output you have me :
     Device Size : 155308288 (148.11 GiB 159.04 GB)

 From the fdisk output in the original email:

[root@paul ~]# fdisk -l /dev/hdd

Disk /dev/hdd: 160.0 GB, 160029999616 bytes
255 heads, 63 sectors/track, 19455 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdd1               1         122      979933+  fd  Linux raid autodetect
/dev/hdd2             123       19455   155292322+  fd  Linux raid autodetect


Notice that hdd2 is 155292322, but the device needs to be 
155308288.  It isn't quite big enough.
mdadm should pick this up, but obviously doesn't, and the error message
isn't at all helpful.
I will fix that in the next release.
For now, repartition your drive so that hdd2 is slightly larger.

NeilBrown
