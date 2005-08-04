From: Gil <gil@fooplanet.com>
Subject: Re: Setup a Raid while OS is running
Date: Thu, 04 Aug 2005 09:48:16 -0700
Message-ID: <42F246D0.3050402@fooplanet.com>
References: <47670.212.34.68.2.1123168858.squirrel@extern.x-cellent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47670.212.34.68.2.1123168858.squirrel@extern.x-cellent.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Majer <stefan@x-cellent.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Don't try to mirror your existing filesystems.  Your concern about
superblocks trashing your filesystems is valid.

This is the way I would do it:

1. attach secondary drive to running system
2. create partitions similar in size to existing ones
3. create md devices on new disk with missing mirrors
4. create new filesystems on the md devices.
5. copy the contents of your filesystems over with tar or dump or
similar.
6. tell grub to install a bootloader on your new disk.
7. try booting your new copy of the OS from the new disk

Note that the new filesystems created in step 4 will be slightly
smaller than your old filesystems even if you create the same sized
partitions on the new disk with fdisk.  This difference is the
superblock you were worried about.

At this point you'll have your still functional old disk and a new
copy of the OS you can work on.

Once you're satisfied that your new copy of the OS works properly,
repartition your old disk (or change the partition types if you made
the partitions on your new disk the same size).  Use mdadm to add
these partitions to the md devices you created in 3.  md will now
resync onto your original disk.

--Gil

Stefan Majer wrote:
> Hi,
> 
> i have a server running on only one scsi disk. I got now one scsi disk
> extra and i want to transform the actual installation to use both disks in
> a raid1.
> Therefore i want to mirror each partition with md.
> The Question now is how to do that, if possible, without destroing the
> installed OS.
> 
> I thought it should be possible to do it in the following way:
> 
> 1. create the same partitions on the secondary drive
> 2. create a mirror for each partition with the actual installed partition
> marked as "missing"
> 3. attach the missing partition (not sure how the specify sync direction)
> 4. edit fstab
> 5. reboot.
> 
> As u can see im afraid douing this becaus im not sure
> a: how to specify sync direction and
> b: if the creation of the now new superblock destroy my filesystem
> 
> So if someone have ideas, please
> 
> Greetings from munich
> 
> Stefan Majer
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

