From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Question on RAID-5 using ADMA
Date: Wed, 8 Jul 2009 19:11:48 -0400
Message-ID: <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tirumala Reddy Marri' <tmarri@amcc.com>, linux-raid@vger.kernel.org
Cc: 'Dan Williams' <dan.j.williams@intel.com>
List-Id: linux-raid.ids

I think you are doing --assume-clean wrong.

Anyway, if you are bypassing the parity build with --assume-clean then how
can you expect it to work with a failed disk?

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Tirumala Reddy Marri
} Sent: Wednesday, July 08, 2009 5:38 PM
} To: linux-raid@vger.kernel.org
} Cc: Dan Williams
} Subject: Question on RAID-5 using ADMA
} 
} Hi,
}   I am having issue with following sequence of steps.
} 
} 1. Start raid-5  " mdadm -C /dev/md0 -f -z30000000 -c64 -l5 -n3
} /dev/sd[a-c] -assume -clean"
} 2. mkfs.ext3 /dev/md0
} 3. mount /dev/md0 /mnt/tmpmnt
} 4. mdadm -a /dev/md0 /dev/sdd (adding a spare disk)
} 5. mdadm -f /dev/smd0 /dev/sda (fail disk /dev/sda)
} 
} When I do ls -l /mnt/tmpmnt I am seeing the errors end of the email.
} 
} ---
} 
} EXT3-fs error (device md0): ext3_valid_block_bitmap: Invalid block
} bitmap - block_group = 30, block = 983042
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983055, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983424, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983426, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983428, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983430, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983431, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983433, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983435, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983473, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983475, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983476, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983488, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983489, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983492, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983494, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983496, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983497, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983498, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983499, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983501, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983502, length 1
} EXT3-fs error (device md0): ext3_new_block: Allocating block in system
} zone - blocks from 983503, length 1
} 
} 
} ------------
} Regards,
} Marri
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

