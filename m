From: Mike Hardy <mhardy@h3c.com>
Subject: Re: New features?
Date: Tue, 31 Oct 2006 08:50:19 -0800
Message-ID: <45477ECB.1000801@h3c.com>
References: <1162293818.32109.113.camel@kenny> <17735.14472.835153.186432@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17735.14472.835153.186432@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown wrote:
> On Tuesday October 31, rowe@excc.ex.ac.uk wrote:

>> 1 "Warm swap" - replacing drives without taking down the array but maybe
>> having to type in a few commands. Presumably a sata or sata/raid
>> interface issue. (True hot swap is nice but not worth delaying warm-
>> swap.)
> 
> I believe that 2.6.18 has SATA hot-swap, so this should be available
> know ... providing you can find out what commands to use.

I forgot 2.6.18 has SATA hot-swap, has anyone tested that?

FWIW, SCSI (or SAS now, using SCSI or SATA drives) has full hot-swap
with completely online drive exchanges. I have done this on recent
kernels in production and it works.

> 
>> 2 Adding new disks to arrays. Allows incremental upgrades and to take
>> advantage of the hard disk equivalent of Moore's law.
> 
> Works for raid5 and linear.  Raid6 one day.

Also works for raid1!


>> 4. Uneven disk sizes, eg adding a 400GB disk to a 2x200GB mirror to
>> create a 400GB mirror. Together with 2 and 3, allows me to continuously
>> expand a disk array.
> 
> So you have a RAID1 (md) from sda and sdb, both 200GB, and you now have a
> sdc which is 400GB.
> So
>    mdadm /dev/md0 -a /dev/sdc
>    mdadm /dev/md0 -f /dev/sda
>    mdadm /dev/md0 -r /dev/sda
>    # wait for recovery

Could be:

    mdadm /dev/md0 -a /dev/sdc
    mdadm --grow /dev/md0 --raid-devices=3 # 3-disk mirror
    # wait for recovery
    # don't forget grub-install /dev/sda (or similar)!
    mdadm /dev/md0 -f /dev/sda
    mdadm /dev/md0 -r /dev/sda
    mdadm --grow /dev/md0 --raid-devices=2 # 2-disk again

    # Run a 'smartctl -d ata -t long /dev/sdb' before next line...

>    mdadm /dev/md0 -f /dev/sdb
>    mdadm /dev/md0 -r /dev/sdb
>    mdadm -C /dev/md1 -l linear -n 2 /dev/sda /dev/sdb
>    mdadm /dev/md0 -a /dev/md1
>    # wait for recovery
>    mdadm --grow /dev/md0 --size=max
> 
> You do run with a degraded array for a while, but you can do it
> entirely online.
> It might be possible to decrease the time when the array is degraded,
> but it is too late at night to think about that.

All I did was decrease the degradation time, but hey it could help. And
don't forget the long SMART test before running degraded for real. Could
save you some pain.

-Mike
