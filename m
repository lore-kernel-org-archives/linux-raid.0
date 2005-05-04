From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Wed, 4 May 2005 12:17:45 +1000
Message-ID: <17016.12489.9021.728737@cse.unsw.edu.au>
References: <42775D47.4000805@dtbb.net>
	<17016.3902.917012.297224@cse.unsw.edu.au>
	<4278271B.1020408@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Tuesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 3, pml@dtbb.net wrote:
> Hi Neil,
> 
> I've gotten past the device being busy using the patch, and onto a new 
> error message and set of problems:
> 
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -C -l 5 -n 3 -e 1 
> /dev/md0 /dev/hdb /dev/hdc /dev/hdd
> VERS = 9002
> mdadm: ADD_NEW_DISK for /dev/hdb failed: Invalid argument
....
> 
> And the following in Dmesg:
> md: hdb has invalid sb, not importing!
> md: md_import_device returned -22
> 

Hey, I got that too!
You must be running an -mm kernel (I cannot remember what kernel you
said you were using).

Look in include/linux/md_p.h near line 205.
If it has
	__u32	chunksize;	/* in 512byte sectors */
	__u32	raid_disks;
	__u32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
				 * NOTE: signed, so bitmap can be before superblock
				 * only meaningful of feature_map[0] is set.
				 */
	__u8	pad1[128-96];	/* set to 0 when written */

then change the '96' to '100'.  (It should have been changed when
bitmap_offset was added).

You will then need to mdadm some more.  In super1.c near line 400,

	sb->ctime = __cpu_to_le64((unsigned long long)time(0));
	sb->level = __cpu_to_le32(info->level);
	sb->layout = __cpu_to_le32(info->level);
	sb->size = __cpu_to_le64(info->size*2ULL);

notice that 'layout' is being set to 'level'.  This is wrong.  That
line should be

	sb->layout = __cpu_to_le32(info->layout);

With these changes, I can create a 56 device raid6 array. (I only have
14 drives, but I partitioned each into 4 equal parts!).

I'll try to do another mdadm-2 release in the next week.

Thanks for testing this stuff...

NeilBrown
