From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody',
      homebrew 2.4.25 kernel
Date: Wed, 4 Aug 2004 11:00:10 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <27897.194.60.85.4.1091613610.squirrel@194.60.85.4>
References: <ceq7ij$vj7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ceq7ij$vj7$1@sea.gmane.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, August 4, 2004 9:42, Jens Benecke said:
> I'm planning to set up a new RAID mirrored system with the above specs. Both
> disks are master (hda and hdc). I'm currently trying to decide between LVM2 (is it in 2.4
> already?), MD, and a "manual" nightly rsync onto the second disk.

I use md and mdadm on Fedora Core 2. What distro are you contemplating?

> 
> How about RAIDing the root partition? If one drive fails will the other be
> able to boot via LILO? How about GRUB? Which do you prefer?

I have my root partition on a RAID1 mirror. I use grub and have "installed" grub to both mirrored drives so I can boot off either, e.g. if one fails. That reminds me, I must test this.
 
> How about (/var)/tmp? I (suppose I'll) need it on both disks, does it make
> sense to mirror it as well?

You *could* put /var/tmp or /tmp on separate partitions either mirrored or not, but if you want to keep things "stress free" I would keep /var/tmp and /tmp on the root partition.

> Can I mirror the whole disk? Or do I need to mirror each partition
> seperately?

You can do either. You mirror the disk using md and can then either create a filesystem on the whole disk, or use lvm to create logical volumes within the md device.

> Does MD or LVM2 do hot sync, i.e. if one drive fails will I be able to stick
> in a replacement, and stop worrying? Or do I need to repartition the new disk exactly as
> the old one, before being able to sync?

I'm not sure about this. My understanding is that you will need to shutdown the system to replace the bad disk and partition the new disk manually before md will resync, but this could be wrong.

I have six 250GB SATA disks, all partitioned identically with two partitions of 1.5GB and 248.5 GB. I have them configured as RAID devices using md follows:

md0   sda1 + sdd1    RAID1    1.5GB   root filesystem
md2   sdb1 + sde1    RAID1    1.5GB   swap 1
md3   sdc1 + sdf1    RAID1    1.5GB   currently not used
md5   sd[abcdef]2    RAID5    994GB   lvm2 volume group (4+1+spare)

Then within the lvm2 volume group I have the following logical volumes:

dude_usr   10GB     /usr
dude_var   5GB      /var
dude_home  979GB    /home

I did my initial install just to the mirrored root parition . Once I had done the initial install I set up the lvm2 array and volumes and migrated /usr and /var over.

It's working great so far.

> How does LVM2/MD deal with failing harddisks, which is why I do the mirror
> at all? I've heard about MD not detecting read errors because the "other" disk was
> reading fine, and crashing completely when one disk was finally replaced because the
> data on the other disk was also corrupt. Is that still the current case?

Again, I don't know about this.
 
> The goal is to have as "stress free" a system as possible - i.e. with as
> little manual configuration, and in event of emergencies, as little work to do, as
> possible.

If you want stress free, buy a Netapps storage appliance ;o)

R.
-- 
http://robinbowes.com

