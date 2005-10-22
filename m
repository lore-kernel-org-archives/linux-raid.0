From: Chase Venters <chase.venters@clientec.com>
Subject: Re: how to add third drive to RAID1 made of two drives without destroying data
Date: Sat, 22 Oct 2005 13:18:59 -0500
Message-ID: <200510221319.22002.chase.venters@clientec.com>
References: <1129999982.11518.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1129999982.11518.18.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Juraj Holtak <juraj@proaut.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 22 October 2005 11:52 am, Juraj Holtak wrote:
> I know I can use the "new" drive I bought today as spare, but I really
> miss the point of a spare for raid1. I think, it makes much more sense,
> to build in the drive as a live one, so instead of RAID1 made of 2
> drives, I`ll get RAID1 made of 3 drives.
>
> I use mdadm to manage the drives. If I use --manage --add and add the
> drive(partition) to the array, it becomes a spare disk and this is not
> what I want it to do.
>
> Is there a way to upgrade my raid, without destroying data?

Indeed. Check mdadm --grow:

Usage: mdadm --grow device options

This usage causes mdadm to attempt to reconfigure a running array.
This is only possibly if the kernel being used supports a particular
reconfiguration.  This version only supports changing the number of
devices in a RAID1, and changing the active size of all devices in
a RAID1/4/5/6.

Options that are valid with the grow (-G --grow) mode are:
  --size=        -z   : Change the active size of devices in an array.
                      : This is useful if all devices have been replaced
                      : with larger devices.
  --raid-disks=  -n   : Change the number of active devices in a RAID1
                      : array.

I haven't done it before personally, but I'd imagine:

mdadm --grow /dev/md0 --raid-disks=3 

would be a good start (if not the total solution).

Cheers,
Chase
