From: "David Lethe" <david@santools.com>
Subject: RE: Help recovering from failed disk on RAID 6
Date: Tue, 13 May 2008 11:28:32 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C61E61E@34093-C3-EVS3.exchange.rackspace.com>
References: <e59c37290804271916t13c7cf4rb45e1c70f6ca9bfd@mail.gmail.com> <02b601c8b513$e3ee7200$6fd2a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <02b601c8b513$e3ee7200$6fd2a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>, Joshua Johnson <enigma2175@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would also add to Steve's suggestion that you be prepared to
immediately disconnect the power to the dodgy disk once the rebuild
starts.  That eliminates possibility that the bad disk will lock up the
system.

David

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Steve Fairbairn
Sent: Tuesday, May 13, 2008 11:11 AM
To: 'Joshua Johnson'; linux-raid@vger.kernel.org
Subject: RE: Help recovering from failed disk on RAID 6

Hi,

It appears noone else has answered, so I'll try.  First I'd attempt to
start the array with the --force parameter, which I believe will start
the dirty array without the failed drive in it.

The other option to try depends on how long you have before the OS
freezes, but is to start the array with the dodgy drive in it, but
immediately tell mdadm to fail the dodgy disk.  This should have mdadm
start a resync with the spare drive.

Hope this helps,

Steve.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Joshua Johnson
> Sent: 28 April 2008 03:17
> To: linux-raid@vger.kernel.org
> Subject: Help recovering from failed disk on RAID 6
> 
> 
> I am running a linux server with an 8 disk IDE/SATA RAID 6 
> array.  One of the disks is having a problem which caused the 
> machine to freeze. If I boot the machine without the problem 
> disk the array fails to start.  If I boot with the problem 
> disk the array starts correctly and begins syncing, but the 
> machine will soon freeze up again when the disk drops out.  
> My number one question is how to get the array back online.  
> It has a spare disk, but since the OS is freezing rather than 
> failing the disk that is having the problem, it never 
> switched to the new disk.  When I try to start the array 
> without the problem disk, I
> get:
> 
> #mdadm --manage --run /dev/md0
> raid5: device hda2 operational as raid disk 0
> raid5: device sdb2 operational as raid disk 7
> raid5: device sda1 operational as raid disk 6
> raid5: device hdi2 operational as raid disk 5
> raid5: device hdg2 operational as raid disk 3
> raid5: device hde2 operational as raid disk 2
> raid5: device hdk2 operational as raid disk 1
> raid5: cannot start dirty degraded array for md0
> RAID5 conf printout:
>  --- rd:8 wd:7
>  disk 0, o:1, dev:hda2
>  disk 1, o:1, dev:hdk2
>  disk 2, o:1, dev:hde2
>  disk 3, o:1, dev:hdg2
>  disk 5, o:1, dev:hdi2
>  disk 6, o:1, dev:sda1
>  disk 7, o:1, dev:sdb2
> raid5: failed to run raid set md0
> md: pers->run() failed ...
> mdadm: failed to run array /dev/md0: Input/output error
> 
> /proc/mdstat contains:
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md1 : active raid1 hdg1[1] hda1[0]
>       4200896 blocks [2/2] [UU]
> 
> md0 : inactive hda2[0] sdc2[8](S) sdb2[7] sda1[6] hdi2[5] 
> hdg2[3] hde2[2] hdk2[1]
>       1529265920 blocks
> 
> 
> So how do I get this array to run?  I can't start it without 
> the problem disk and I can't sync it with the problem disk.  
> I am running RAID 6 to be able to recover from multiple disk 
> failures so it is a little vexing that a single disk going 
> offline renders my array unrunnable.  Any help with this 
> issue is greatly appreciated.
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
http://vger.kernel.org/majordomo-info.html

No virus found in this incoming message.
Checked by AVG. 
Version: 7.5.524 / Virus Database: 269.23.9/1419 - Release Date:
07/05/2008 07:46
 

No virus found in this outgoing message.
Checked by AVG. 
Version: 7.5.524 / Virus Database: 269.23.16/1429 - Release Date:
12/05/2008 18:14
 

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


