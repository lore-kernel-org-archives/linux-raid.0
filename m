From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 4] Introduction
Date: Mon, 23 Aug 2004 13:10:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040823130657.19914.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Following are 4 patches for md in 2.6.8.1-mm4

The first three are minor improvements and modifications either
required by or inspired by the fourth.

The fourth adds a new raid personality - raid10.  At 56K, I'm not 
sure it will get through the mailing list, but interested parties
can find it at:

  http://neilb.web.cse.unsw.edu.au/patches/linux-devel/2.6/2004-08-23-03

raid10 provides a combination of raid0 and raid1.
It requires mdadm 1.7.0 or later to use.  

The next release of mdadm should have better documention of raid10, but 
from the comment in the .c file:

/*
 * RAID10 provides a combination of RAID0 and RAID1 functionality.
 * The layout of data is defined by 
 *    chunk_size
 *    raid_disks
 *    near_copies (stored in low byte of layout)
 *    far_copies (stored in second byte of layout)
 *
 * The data to be stored is divided into chunks using chunksize.
 * Each device is divided into far_copies sections.
 * In each section, chunks are layed out in a style similar to raid0, but
 * near_copies copies of each chunk is stored (each on a different drive).
 * The starting device for each section is offset near_copies from the starting
 * device of the previous section.
 * Thus there are (near_copies*far_copies) of each chunk, and each is on a different
 * drive.
 * near_copies and far_copies must be at least one, and there product is at most
 * raid_disks.
 */

raid10 is currently marked EXPERIMENTAL, and this should be taken seriously.
A reasonable amount of basic testing hasn't shown any bugs, and it seems to resync
and rebuild correctly.  However wider testing would help.

NeilBrown
