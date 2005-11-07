From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 10:13:54 +1100
Message-ID: <17263.57266.902113.362087@cse.unsw.edu.au>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Troels Bang Jensen on Monday November 7
Sender: linux-raid-owner@vger.kernel.org
To: Troels Bang Jensen <marvin@fnuck.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 7, marvin@fnuck.dk wrote:
> I've got a simple setup with three IDE drives where two disks share a  
> 30mb RAID1 partition for /boot and all three share a 590GB RAID5  
> array for /
> 
> My mdadm.conf looks like this:
> 
> DEVICE partitions
> ARRAY /dev/md1 level=raid5 num-devices=3 UUID=4b22b17d: 
> 06048bd3:ecec156c:31fabbaf
>     devices=/dev/hda3,/dev/hdc3,/dev/hdg2
> ARRAY /dev/md0 level=raid1 num-devices=2  
> UUID=7d5c8486:35fff755:f5d34fc2:a12f1f81
>     devices=/dev/hda1,/dev/hdc1

You should remove the "devices=" sections.  They aren't causing a
problem in this case, but they could if you happened to change the
name of a device (plug it in somewhere different).

> 
> The UUIDs check out with the devices, and indeed /dev/md0 works  
> fine. /dev/md1 used to work perfectly, but read on :-p
> 
> All the raid partitions are type 0xfd RAID auto-detect.

Are you sure?  Really really sure?  Particularly hdc3.  What is it's
type.  Could you 
  fdisk -l /dev/hdc
just to convince me?  Because your problem REALLY looks like the
partition type isn't 0xfd...
You gave lots of detail, which is excellent, and from all that detail,
I cannot see any other possible explanation.

NeilBrown

