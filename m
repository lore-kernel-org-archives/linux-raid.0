From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: Question on RAID-5 using ADMA
Date: Wed, 8 Jul 2009 14:37:44 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi,
  I am having issue with following sequence of steps.

1. Start raid-5  " mdadm -C /dev/md0 -f -z30000000 -c64 -l5 -n3
/dev/sd[a-c] -assume -clean"
2. mkfs.ext3 /dev/md0
3. mount /dev/md0 /mnt/tmpmnt
4. mdadm -a /dev/md0 /dev/sdd (adding a spare disk)
5. mdadm -f /dev/smd0 /dev/sda (fail disk /dev/sda)

When I do ls -l /mnt/tmpmnt I am seeing the errors end of the email.

---

EXT3-fs error (device md0): ext3_valid_block_bitmap: Invalid block
bitmap - block_group = 30, block = 983042
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983055, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983424, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983426, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983428, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983430, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983431, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983433, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983435, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983473, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983475, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983476, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983488, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983489, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983492, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983494, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983496, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983497, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983498, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983499, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983501, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983502, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system
zone - blocks from 983503, length 1


------------
Regards,
Marri
