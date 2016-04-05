From: Ron Leach <ronleach@tesco.net>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Tue, 05 Apr 2016 17:34:17 +0100
Message-ID: <5703E909.8090903@tesco.net>
References: <57038211.6040101@tesco.net> <57039BCC.6040103@tesco.net> <5703AE18.700@tesco.net> <5703D98F.4020503@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5703D98F.4020503@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/2016 16:28, Phil Turmel wrote:

>
> If your array has write-intent bitmaps, use --re-add instead of --add.
> It'll be quick.  Otherwise just --add and let it rebuild.
>

Phil, thanks for the advice.

I hit an unexpected problem fixing the partition table on /dev/sdb, 
the disk that dropped from the Raid1 array.  The problem is caused by 
/dev/sdb being *smaller* than /dev/sdc (the working array member) - 
despite the disks being identical products from WD.  gdisk complains 
that partition 5 (/dev/sdb5), which is to be the Raid1 partner for the 
LVM containing all our backed up files, is too big (together with the 
other partitions) for the /dev/sdb disk.

Presumably, raid1 doesn't work if an 'add'ed disk partition is smaller 
than the existing, running, degraded array?  Am I right in thinking 
that the LVM won't be able to be carried securely on the underlying md 
system?  lsdrv is reporting that /dev/md127 has 0 free, so it seems 
that the LVM is occupying the complete space of /dev/md127, and it 
must be using the complete space of the underlying /dev/sdc5 because 
only sdc is active, at the moment (the Raid1 being still degraded).

To protect the LVM, what would be a good thing to do?  Should I define 
a slightly shorter 'partner' partition on the failed disk (/dev/sdb) - 
I would think not, but I would welcome advice.

I did think about reducing the size of one of the other partitions on 
/dev/sdb - there's a swap partition of 2G which could become 1.5G, 
because there's another 2G on the working disk anyway.  Doing that, 
the partner partitions for the real data could be the same size, 
though not in exactly the same place on both disks.  I think this 
might work?

regards, Ron
