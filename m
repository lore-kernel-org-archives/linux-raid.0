From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: RAID rebuild on Create
Date: Mon, 30 Apr 2007 20:35:13 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704302030510.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
 <e9c3a7c20704301119v1c69aaf0xb272fe85697934cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20704301119v1c69aaf0xb272fe85697934cd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Apr 30 2007 11:19, Dan Williams wrote:
>> 
>> when a user does `mdadm -C /dev/md0 -l <any> -n <whatever fits>
>> <devices>`, the array gets rebuilt for at least RAID1 and RAID5, even if
>> the disk contents are most likely not of importance (otherwise we would
>> not be creating a raid array right now). Could not this needless resync
>> be skipped - what do you think?
>
> If you want his behavior you can always create the array with a
> 'missing' device to hold off the resync process.  Otherwise, if all
> disks are available, why not let the array make forward progress to a
> protected state?

Having a device missing in the array does not create a protected state
as you call it. What I was out at - can't the array wait with syncing
blocks until I have actually written something there for the first
time? This should not impact protection.

_Especially_ if one starts out with blank disks. Then the resync
process copies zeroes to zeroes (before we even run mkfs). And it
chews a bit on PCI bandwidth.

> Also, the resync thread automatically yields to new data coming into
> the array, so you can effectively sync an array by writing to all the
> blocks.


Jan
-- 
