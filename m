From: "bmoon" <bo@anthologysolutions.com>
Subject: Really need RESYNC at the time of RAID1&5 creation?
Date: Mon, 30 Jun 2003 14:34:51 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00b901c33f4f$715be540$6401a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil & Raiders,

I am not quite sure if we really need to resync the array at the time of
RAID 1 or RAID 5 array creation. I tried and tested without RESYNC by
modifying "case1" and "case2" from MDADM source below, I could not notice
any problems or issues.

At the time of RAID creation and mke2fs, there is no valid data on the
array. It must be a file system's job to know about it.

So I want to know what is the reason for these codes(, and
what you experieced from without RESYNC.

Thanks,

Bo



------------------------------------------------------------------
The following code is from Create.c in mdadm tool.

/* If this is raid5, we want to configure the last active slot
* as missing, so that a reconstruct happens (faster than re-parity)
*/

if (force == 0 && level == 5 && first_missing >= raiddisks) {
insert_point = raiddisks-1;
sparedisks++;
array.active_disks--;
missing_disks++;                                    <----------------case1
}

/* Ok, lets try some ioctls */

array.level = level;
array.size = size;
array.raid_disks = raiddisks;

/* The kernel should *know* what md_minor we are dealing
* with, but it chooses to trust me instead. Sigh
*/

array.md_minor = 0;

if (fstat(mdfd, &stb)==0)
array.md_minor = MINOR(stb.st_rdev);
array.not_persistent = 0;

if (level == 5 && (insert_point < raiddisks || first_missing < raiddisks))
array.state = 1; /* clean, but one drive will be missing */
else
array.state = 0; /* not clean, but no errors */    <------------------case2

