From: Timo.Bolse@SerNet.DE
Subject: Superblock Documentation
Date: Fri, 20 Feb 2004 14:33:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AuAm6-0004RG-00@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear List,
I was experimenting with Linux Software RAID for a while now using mdadm for
administrating the RAID. There is a quite nice mdadm --detail output to get 
some informations about the Devices/RAID. For me it was not 100% clear what
every value stands for exactly and i couldn't find any documentation on this
so i decided to write a little documentation on this...

If you have the time read this litte text an correct it please. English is
not my mother tongue so i think there are many mistakes in there. If you
have additional informations on this issue please mail me.

Thanks,
Timo Bolse

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="RAID-Superblock.txt"

Linux Software RAID Superblock - PRE ALPHA VERSION :)
by Timo Bolse <tb@sernet.de>

This small document is allotted to all administrators who are using Linux
Software RAID and who want to undestand the accurate meaning of the fields used
by mdadm to show some informations about the RAID. Most of these Values are 
stored in the RAID Superblock... So this can be used as a small overview to the
RAID Superblock. I put the Superblock structure as attachment to this Document 
so you can even look at these values.

I had to understand what mdadm is telling me :-) There was no documentation
on this. Now there is!

If you have common Linux Software RAID Questions consider reading this:
http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO.txt

Thanks to Neil Brown providing some quite important informations about this
issue.

Description on the basis of "mdadm --detail" output:
-------------------------------------------------------------------------------
1:   /dev/md0:      
2:          Version : 00.90.00
3:    Creation Time : Fri Apr  4 08:26:03 2003
4:       Raid Level : raid1         
5:       Array Size : 513984 (501.94 MiB 526.32 MB)
6:      Device Size : 513984 (501.94 MiB 526.32 MB)
7:     Raid Devices : 2                            
8:    Total Devices : 2                            
9:  Preferred Minor : 0                            
10:     Persistence : Superblock is persistent     
11:
12:     Update Time : Fri Apr  4 09:08:23 2003     
13:           State : dirty, no-errors             
14:  Active Devices : 2                            
15: Working Devices : 2                            
16:  Failed Devices : 0                            
17:   Spare Devices : 0                            
18:
19:    Number   Major   Minor   RaidDevice State
20:       0       3        1        0      active sync   /dev/hda1
21:       1      22        1        1      active sync   /dev/hdc1
22:           UUID : 357706a9:57fd2e0b:4ee1927d:5fd5b177
23:         Events : 0.5
-------------------------------------------------------------------------------

I thought the best way to describe this is field by field which means line by
line in this case. So the output above is like a table of contents.

1:
	The RAID Device. Should be the parameter to "mdadm --detail"...
	Here: "mdadm --detail /dev/md0"


2:
	This field shows the Version of the RAID Superblock.


3:
	This field shows the Creation Time of the given RAID-Device.


4:	
	The RAID Level.


5:
	The Size of the Array. Counted in MiB (Mebibites) and MB (Megabytes)
	WTF is a Mebibite? Authorized question! ;-)

	I will give you a small explanation on this by the following table:

	 Factor 	Abbreviation  		Name 
	 2^10 		kibi 	Ki 		kilobinary
	 2^20 		mebi 	Mi 		megabinary
	 2^30 		gibi 	Gi 		gigabinary
	 2^40 		tebi 	Ti 		terabinary
	 2^50 		pebi 	Pi 		petabinary
	 2^60	 	exbi 	Ei 		exabinary

	I thought ever that a KB (Kilobyte) is 1024 Bytes. So i was wrong the
	whole time?

	No. There was some confusion most people thought that a Kilo = 1000 so
	a Kilobyte must be 1000 Byte. To stop this confusion the International
	Electrotechnical Commission (IEC) defined those standard names in 1998.


6: 
	Device Size is the space used on each individual device. For raid1, this
	is the same value as array size... for raid5 this is quite different.


7:
	RAID Devices. This is only the number of devices which are needed for a
	fully functional array with no spares. So if the "Total Devices" counter
	is lesser than this value your RAID is not pretty functional.

	It might be functional, but it will be "degraded". i.e. still working
	but with reduced (or no) redundancy.


8:
	Total Devices. Number of devices actually in this RAID, including 
	spares... Removed devices are not counted.


9:
	Preffered Minor. This field is only used when using AutoDetect to 
	assemble arrays at boot time. In that case, this number indicated which
	md device to assemble the array as. This field dosn't matter when your 
	assembling arrays with 'mdadm --assemble'. You are able to assemble any
	array under any device.

	Device:		Minor:
	/dev/md0 	0
	/dev/md1	1
	/dev/md2	2
	and so on...


10: 
	All superblocks that are stored on disc are persistent. Only if you
	create an RAID0 or LINEAR array which does not have a superblock.

	"mdadm --detail" will list this as not having a persistent superblock.

12:
	Last Update of this RAID Device.


13: 
	The State of the RAID Device.

	Kernel 2.4: Whenever an array is active it will always be "dirty" for
	the "mdadm --detail output" "mdadm --examine" of a component device will
	show 'clean' if the array has been cleanly shut down.

	Kernel 2.6: An array that has not been written to for a short while will
	be marked 'clean' until the next write request/attempt.

	States are:
	clean		
	dirty		

	errors		 
	no-errors	


14:
	Active Devices.	The author of the software wrote:
	"The code doesn't always keep this number up-to-date correctly."

	So don't trust this number.


15: 
	Working Devices. i.e. devices that are present, but are not faulty.


16: 
	Failed Devices. 

	This only counts faulty devices that are actually present?


17:
	Spare Devices. Devices which are marked as spare.


19-21: 

	faulty - A fault is detected on this device.
	active - This device is an active part of the array.
	
	sync - This device is an active part of the array. It's sync.
	removed - This device (Slot) is empty. There is no device here.


22:
	This ID makes the RAID Device uniq... so if you have more than one device you
	can clearly say which is which by this number.


23:
	Events. Every event which changes the superblock is counted here.
	E.g.: start, stop, failure, hot-add, hot-remove.

	The number is internally stored in 64bits.

	Printed in this summary as 32bit.32bit this is not so nice.

	Open Question: What event changes which bits?


Superblock structure from the sourcecode:
			
/*
   md_p.h : physical layout of Linux RAID devices
          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
	  
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.
   
   You should have received a copy of the GNU General Public License
   (for example /usr/src/linux/COPYING); if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
*/

#ifndef _MD_P_H
#define _MD_P_H

/*
 * RAID superblock.
 *
 * The RAID superblock maintains some statistics on each RAID configuration.
 * Each real device in the RAID set contains it near the end of the device.
 * Some of the ideas are copied from the ext2fs implementation.
 *
 * We currently use 4096 bytes as follows:
 *
 *	word offset	function
 *
 *	   0  -    31	Constant generic RAID device information.
 *        32  -    63   Generic state information.
 *	  64  -   127	Personality specific information.
 *	 128  -   511	12 32-words descriptors of the disks in the raid set.
 *	 512  -   911	Reserved.
 *	 912  -  1023	Disk specific descriptor.
 */

/*
 * If x is the real device size in bytes, we return an apparent size of:
 *
 *	y = (x & ~(MD_RESERVED_BYTES - 1)) - MD_RESERVED_BYTES
 *
 * and place the 4kB superblock at offset y.
 */
#define MD_RESERVED_BYTES		(64 * 1024)
#define MD_RESERVED_SECTORS		(MD_RESERVED_BYTES / 512)
#define MD_RESERVED_BLOCKS		(MD_RESERVED_BYTES / BLOCK_SIZE)

#define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS - 1)) - MD_RESERVED_SECTORS)
#define MD_NEW_SIZE_BLOCKS(x)		((x & ~(MD_RESERVED_BLOCKS - 1)) - MD_RESERVED_BLOCKS)

#define MD_SB_BYTES			4096
#define MD_SB_WORDS			(MD_SB_BYTES / 4)
#define MD_SB_BLOCKS			(MD_SB_BYTES / BLOCK_SIZE)
#define MD_SB_SECTORS			(MD_SB_BYTES / 512)

/*
 * The following are counted in 32-bit words
 */
#define	MD_SB_GENERIC_OFFSET		0
#define MD_SB_PERSONALITY_OFFSET	64
#define MD_SB_DISKS_OFFSET		128
#define MD_SB_DESCRIPTOR_OFFSET		992

#define MD_SB_GENERIC_CONSTANT_WORDS	32
#define MD_SB_GENERIC_STATE_WORDS	32
#define MD_SB_GENERIC_WORDS		(MD_SB_GENERIC_CONSTANT_WORDS + MD_SB_GENERIC_STATE_WORDS)
#define MD_SB_PERSONALITY_WORDS		64
#define MD_SB_DESCRIPTOR_WORDS		32
#define MD_SB_DISKS			27
#define MD_SB_DISKS_WORDS		(MD_SB_DISKS*MD_SB_DESCRIPTOR_WORDS)
#define MD_SB_RESERVED_WORDS		(1024 - MD_SB_GENERIC_WORDS - MD_SB_PERSONALITY_WORDS - MD_SB_DISKS_WORDS - MD_SB_DESCRIPTOR_WORDS)
#define MD_SB_EQUAL_WORDS		(MD_SB_GENERIC_WORDS + MD_SB_PERSONALITY_WORDS + MD_SB_DISKS_WORDS)

/*
 * Device "operational" state bits
 */
#define MD_DISK_FAULTY		0 /* disk is faulty / operational */
#define MD_DISK_ACTIVE		1 /* disk is running or spare disk */
#define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
#define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */

typedef struct mdp_device_descriptor_s {
	__u32 number;		/* 0 Device number in the entire set	      */
	__u32 major;		/* 1 Device major number		      */
	__u32 minor;		/* 2 Device minor number		      */
	__u32 raid_disk;	/* 3 The role of the device in the raid set   */
	__u32 state;		/* 4 Operational state			      */
	__u32 reserved[MD_SB_DESCRIPTOR_WORDS - 5];
} mdp_disk_t;

#define MD_SB_MAGIC		0xa92b4efc

/*
 * Superblock state bits
 */
#define MD_SB_CLEAN		0
#define MD_SB_ERRORS		1

typedef struct mdp_superblock_s {
	/*
	 * Constant generic information
	 */
	__u32 md_magic;		/*  0 MD identifier 			      */
	__u32 major_version;	/*  1 major version to which the set conforms */
	__u32 minor_version;	/*  2 minor version ...			      */
	__u32 patch_version;	/*  3 patchlevel version ...		      */
	__u32 gvalid_words;	/*  4 Number of used words in this section    */
	__u32 set_uuid0;	/*  5 Raid set identifier		      */
	__u32 ctime;		/*  6 Creation time			      */
	__u32 level;		/*  7 Raid personality			      */
	__u32 size;		/*  8 Apparent size of each individual disk   */
	__u32 nr_disks;		/*  9 total disks in the raid set	      */
	__u32 raid_disks;	/* 10 disks in a fully functional raid set    */
	__u32 md_minor;		/* 11 preferred MD minor device number	      */
	__u32 not_persistent;	/* 12 does it have a persistent superblock    */
	__u32 set_uuid1;	/* 13 Raid set identifier #2		      */
	__u32 set_uuid2;	/* 14 Raid set identifier #3		      */
	__u32 set_uuid3;	/* 15 Raid set identifier #4		      */
	__u32 gstate_creserved[MD_SB_GENERIC_CONSTANT_WORDS - 16];

	/*
	 * Generic state information
	 */
	__u32 utime;		/*  0 Superblock update time		      */
	__u32 state;		/*  1 State bits (clean, ...)		      */
	__u32 active_disks;	/*  2 Number of currently active disks	      */
	__u32 working_disks;	/*  3 Number of working disks		      */
	__u32 failed_disks;	/*  4 Number of failed disks		      */
	__u32 spare_disks;	/*  5 Number of spare disks		      */
	__u32 sb_csum;		/*  6 checksum of the whole superblock        */
#if  __BYTE_ORDER ==  __BIG_ENDIAN
	__u32 events_hi;	/*  7 high-order of superblock update count   */
	__u32 events_lo;	/*  8 low-order of superblock update count    */
#else
	__u32 events_lo;	/*  7 low-order of superblock update count    */
	__u32 events_hi;	/*  8 high-order of superblock update count   */
#endif
	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 9];

	/*
	 * Personality information
	 */
	__u32 layout;		/*  0 the array's physical layout	      */
	__u32 chunk_size;	/*  1 chunk size in bytes		      */
	__u32 root_pv;		/*  2 LV root PV */
	__u32 root_block;	/*  3 LV root block */
	__u32 pstate_reserved[MD_SB_PERSONALITY_WORDS - 4];

	/*
	 * Disks information
	 */
	mdp_disk_t disks[MD_SB_DISKS];

	/*
	 * Reserved
	 */
	__u32 reserved[MD_SB_RESERVED_WORDS];

	/*
	 * Active descriptor
	 */
	mdp_disk_t this_disk;

} mdp_super_t;

#ifdef __TINYC__
typedef unsigned long long __u64;
#endif

static inline __u64 md_event(mdp_super_t *sb) {
	__u64 ev = sb->events_hi;
	return (ev<<32)| sb->events_lo;
}

#endif 


--0F1p//8PRICkK4MW--
