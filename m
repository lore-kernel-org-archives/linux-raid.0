From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Multiple partitions on the same disk
Date: Mon, 17 Mar 2008 08:16:27 +1300
Message-ID: <47DD720B.2050109@sauce.co.nz>
References: <380-22008351422419859@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <380-22008351422419859@mochamail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cody wrote:
> Hi Everyone,
> 
> I have an 8-disk raid5 array (each is 500GB SATA).  The first disk
> sda1 shows bad sectors (from smartd).  mdadm reports that the array
> is fine, but I want to replace or re-add the drive.  Should I replace
> it?  It's the oldest drive in the array (the disk is ~3 years old).

If you have full backups of the array and can tolerate the unplanned 
complete failure of the drive, then you could leave it in service.

With an array of this size and age, you should be running:

echo repair > /sys/block/mdX/md/sync_action

on a regular basis to ensure the whole array is being written to and 
helping to minimise the chance of you hitting a bad sector on another 
drive during the resync after having replaced the faulty drive.

> Also, can I replace it with a 1TB disk and add it as two partitions
> (assuming that 2 partitions of the correct size can be created)?  I
> have read of RAID schemes that involves partitioning each disk into
> smaller increments, but this seems inherently unsafe to me unless
> mdadm understands that two partitions are on the same device and
> organizes parity accordingly.

If by this you mean that you wish to replace your faulty drive with one 
500GB partition and grow the array to be able to add the second 500GB 
partition, then no, this is a bad idea on two counts:

When this drive fails in the future, you lose two components and the 
array is unrecoverable (RAID 5 only allowing single component redundency).

Having two components on the same physical device would impact 
performance due to the head having to constantly re-seek between the two 
partitions.

Regards,

Richard
