From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Uncorrectable errors: how do I fix it?
Date: Fri, 28 Nov 2008 16:03:29 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811281600560.10901@p34.internal.lan>
References: <493036A0.10707@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493036A0.10707@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 28 Nov 2008, John Robinson wrote:

> One of the drives in my RAID-5 array is showing uncorrectable errors:
>
> I tried:
> [root@beast md]# mdadm /dev/md1 --fail /dev/sdc2
> mdadm: set /dev/sdc2 faulty in /dev/md1
> [root@beast md]# mdadm /dev/md1 --remove /dev/sdc2
> mdadm: hot removed /dev/sdc2
> [root@beast md]# mdadm /dev/md1 --add /dev/sdc2
> mdadm: re-added /dev/sdc2
>
> but that finished instantly. I guess it would since the array has a 
> write-intent bitmap and it's noticed that sdc2 is being re-added. I could 
> tell the system to do a complete resync with:
> # echo repair > /sys/block/md1/md/sync_action
>
> but really I want to tell the system to rebuild entirely from sda2 and sdb2, 
> onto sdc2. At least I think I do. I've a feeling the answer is to zero the 
> superblock, but I'm not confident about doing that because I'm not sure if 
> re-adding the thing without a superblock will either work or do the Right 
> Thing[tm].

Before you do this you should backup your data elsewhere just incase you 
cannot rebuild the array later.

You may be able to fix it using the hdparm --write-sector command if you 
know what you are doing, otherwise, the quickest way is to fail it from 
the array as you did before, remove it from the raid set.

zero the disk:
dd if=/dev/zero of=/dev/disk

run badblocks on it a few times:
run short+long test when its all done:

re-check smart statistics and they should complete successfully.

then sfdisk -d /dev/sda | sfdisk /dev/sdc
then pop it back into the array with mdadm /dev/md1 -a /dev/sdc2

Justin.
