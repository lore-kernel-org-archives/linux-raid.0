From: Neil Brown <neilb@suse.de>
Subject: Re: New features?
Date: Tue, 31 Oct 2006 22:50:32 +1100
Message-ID: <17735.14472.835153.186432@cse.unsw.edu.au>
References: <1162293818.32109.113.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Rowe on Tuesday October 31
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 31, rowe@excc.ex.ac.uk wrote:
> All this discussion has led me to wonder if we users of linux RAID have
> a clear consensus of what our priorities are, ie what are the things we
> really want to see soon as opposed to the many things that would be nice
> but not worth delaying the important things for. FWIW, here are mine, in
> order although the first two are roughly equal priority.
> 
> 1 "Warm swap" - replacing drives without taking down the array but maybe
> having to type in a few commands. Presumably a sata or sata/raid
> interface issue. (True hot swap is nice but not worth delaying warm-
> swap.)

I believe that 2.6.18 has SATA hot-swap, so this should be available
know ... providing you can find out what commands to use.

> 
> 2 Adding new disks to arrays. Allows incremental upgrades and to take
> advantage of the hard disk equivalent of Moore's law.

Works for raid5 and linear.  Raid6 one day.

> 
> 3. RAID level conversion (1 to 5, 5 to 6, with single-disk to RAID 1 a
> lower priority).

A single disk is large than a RAID1 built from it, so this is
non-trivial.  What exactly do you want to do there.

> 
> 4. Uneven disk sizes, eg adding a 400GB disk to a 2x200GB mirror to
> create a 400GB mirror. Together with 2 and 3, allows me to continuously
> expand a disk array.

So you have a RAID1 (md) from sda and sdb, both 200GB, and you now have a
sdc which is 400GB.
So
   mdadm /dev/md0 -a /dev/sdc
   mdadm /dev/md0 -f /dev/sda
   mdadm /dev/md0 -r /dev/sda
   # wait for recovery
   mdadm /dev/md0 -f /dev/sdb
   mdadm /dev/md0 -r /dev/sdb
   mdadm -C /dev/md1 -l linear -n 2 /dev/sda /dev/sdb
   mdadm /dev/md0 -a /dev/md1
   # wait for recovery
   mdadm --grow /dev/md0 --size=max

You do run with a degraded array for a while, but you can do it
entirely online.
It might be possible to decrease the time when the array is degraded,
but it is too late at night to think about that.

NeilBrown
