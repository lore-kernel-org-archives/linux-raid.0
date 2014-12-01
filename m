From: terrygalant@mailbolt.com
Subject: upgrading a RAID array in-place with larger drives.  request for review
 of my approach?
Date: Sun, 30 Nov 2014 18:55:53 -0800
Message-ID: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a 4-drive RAID-10 array.  I've been using mdadm for awhile to manage the array, and replace drives as they die without changing anything.

Now, I want to increase its size in-place.  I'd like to ask for some help with a review of my setup and plans on how to do it right.

I'm really open to any advice that'll help me get there without blowing this all up!

My array is

	cat /proc/mdstat
		...
		md2 : active raid10 sdd1[1] sdc1[0] sde1[4] sdf1[3]
		      1953519616 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
		      bitmap: 0/466 pages [0KB], 2048KB chunk
		...

it's comprised of 4 drives; each is 1TB physical size, partitioned with a single 'max size' partition, where that partition is formatted 'Linux raid autodetect'

	fdisk -l /dev/sd[cdef]

		Disk /dev/sdc: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disklabel type: dos
		Disk identifier: 0x00000000

		Device     Boot Start        End    Sectors   Size Id Type
		/dev/sdc1          63 1953520064 1953520002 931.5G fd Linux raid autodetect

		Disk /dev/sdd: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disklabel type: dos
		Disk identifier: 0x00000000

		Device     Boot Start        End    Sectors   Size Id Type
		/dev/sdd1          63 1953520064 1953520002 931.5G fd Linux raid autodetect

		Disk /dev/sde: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disklabel type: dos
		Disk identifier: 0x00000000

		Device     Boot Start        End    Sectors   Size Id Type
		/dev/sde1          63 1953520064 1953520002 931.5G fd Linux raid autodetect

		Disk /dev/sdf: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disklabel type: dos
		Disk identifier: 0x00000000

		Device     Boot Start        End    Sectors   Size Id Type
		/dev/sdf1          63 1953520064 1953520002 931.5G fd Linux raid autodetect

the array contains only/multiple LVs, in a RAID-10 array size of 2TB,

	pvs /dev/md2
	  PV         VG     Fmt  Attr PSize PFree
	  /dev/md2   VGBKUP lvm2 a--  1.82t 45.56g
	vgs VGBKUP
	  VG     #PV #LV #SN Attr   VSize VFree
	  VGBKUP   1   8   0 wz--n- 1.82t 45.56g
	lvs VGBKUP
	  LV                VG     Attr      LSize   Pool Origin Data%  Move Log Cpy%Sync Convert
	  LV001             VGBKUP -wi-ao---   1.46t
	  LV002             VGBKUP -wi-ao--- 300.00g
	  LV003             VGBKUP -wi-ao--- 160.00m
	  LV004             VGBKUP -wi-ao---  12.00g
	  LV005             VGBKUP -wi-ao--- 512.00m
	  LV006             VGBKUP -wi-a---- 160.00m
	  LV007             VGBKUP -wi-a----   4.00g
	  LV008             VGBKUP -wi-a---- 512.00m

where, currently, ~45.56G of the phy dev is unused

I've purchased 4 new 3TB drives.

I want to upgrade the existing array of 4x1TB drives to 4x3TB drives.

I want to end up with a single partition, @ max_size == ~ 3TB.

I'd like to do this *in-place*, never bringing down the array.

Iiuc, this IS doable.

1st, I think the following procedure starts the process correctly:

	(1) format each new 3TB drive, with one 1TB partition, as 'linux raid autodetect', making sure it's IDENTICAL to the partition layout on the current array's disks

	(2) with the current array up & running, mdadm FAIL one drive

	(3) mdadm remove the FAIL'd drive from the array

	(4) physically remove the FAIL'd drive

	(5) physically insert the new, pre-formatted 3TB drive

	(6) mdadm add the newly inserted drive

	(7) allow the array to rebuild, until 'cat /proc/mdstat' says it's done

	(8) repeat steps (2) - (7) for each of the three remaining drives.

2nd, I have to correctly/safely to, in 'some' order

	extend the physical partitions on all four drives, or of the array (not sure which)
	extend the volume group on the array
	expand, or add, the existing LVMs in the volume group.

I'm really not sure about what steps, in what order to do *here*.

Can anyone verify that my first part is right, and help me out with doing the 2nd part right?

Thanks a lot!

Terry
