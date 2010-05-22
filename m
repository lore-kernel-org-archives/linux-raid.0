From: Tim Bostrom <tbostrom@gmail.com>
Subject: blkid and partition problem
Date: Fri, 21 May 2010 17:28:00 -0700
Message-ID: <AANLkTilFZtEDC9au165SQSsj7U1B2f_XOA4kY_4hbE0j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looking for some help.  I'm trying to start my array but just noticed
that somehow my the UUID got assigned to my physical drive and not the
partition.  The partition doesn't show up in /dev/.  Drive sdm has a
valid partition, but blkid is set on the physical disk.

/dev/sdm is the drive causing issue.  The partition is there (see
fdisk output below).  It contains data so I'd like to not have to
completely wipe the drive.  Is there any option to fix this?

blkid output (see /dev/sdm):
----------------------
/dev/sda1: UUID="dd8018e3-2939-4236-9a63-c36d6df9cf80" TYPE="ext3"
/dev/sda2: UUID="287f5ab6-d463-43a2-a3b2-7bf789dd8744" TYPE="ext3"
/dev/sda3: UUID="336a1681-af86-401d-946e-201ae37780fe" TYPE="swap"
/dev/sdb1: UUID="cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sdc1: UUID="cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sdd1: UUID="cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sde1: UUID="cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sdf1: UUID="649526d8-828a-57b4-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sdg1: UUID="649526d8-828a-57b4-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sdh: UUID="7ea182f5-0c31-3e24-adba-30185bcf511e" LABEL="1"
TYPE="linux_raid_member"
/dev/sdi: UUID="7ea182f5-0c31-3e24-adba-30185bcf511e" LABEL="1"
TYPE="linux_raid_member"
/dev/sdj1: UUID="f911d5fb-8cf2-0015-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/sdk1: UUID="f911d5fb-8cf2-0015-ab2f-edca3ef56cfb" TYPE="linux_raid_member"
/dev/md0: LABEL="teradata" UUID="2e7624ad-f059-4e35-a18a-eb8ffa645d54"
TYPE="ext3"
/dev/sdm: UUID="db34c204-6c5a-7156-28d0-d68913f396a5" LABEL="0"
TYPE="linux_raid_member"
/dev/md1: UUID="eea5390f-8f24-4a82-b899-7924fb126a5b" TYPE="ext3"


fdisk -l /dev/sdm output:
------------------
Disk /dev/sdm: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x000f2387

   Device Boot      Start         End      Blocks   Id  System
/dev/sdm1               1      121601   976760001   fd  Linux raid autodetect


 ls -l /dev/sd*
brw-rw---- 1 root disk 8,   0 2010-05-21 16:32 /dev/sda
brw-rw---- 1 root disk 8,   1 2010-05-21 16:32 /dev/sda1
brw-rw---- 1 root disk 8,   2 2010-05-21 16:32 /dev/sda2
brw-rw---- 1 root disk 8,   3 2010-05-21 16:32 /dev/sda3
brw-rw---- 1 root disk 8,  16 2010-05-21 16:32 /dev/sdb
brw-rw---- 1 root disk 8,  17 2010-05-21 16:32 /dev/sdb1
brw-rw---- 1 root disk 8,  32 2010-05-21 16:32 /dev/sdc
brw-rw---- 1 root disk 8,  33 2010-05-21 16:32 /dev/sdc1
brw-rw---- 1 root disk 8,  48 2010-05-21 16:32 /dev/sdd
brw-rw---- 1 root disk 8,  49 2010-05-21 16:32 /dev/sdd1
brw-rw---- 1 root disk 8,  64 2010-05-21 16:32 /dev/sde
brw-rw---- 1 root disk 8,  65 2010-05-21 16:32 /dev/sde1
brw-rw---- 1 root disk 8,  80 2010-05-21 16:32 /dev/sdf
brw-rw---- 1 root disk 8,  81 2010-05-21 16:32 /dev/sdf1
brw-rw---- 1 root disk 8,  96 2010-05-21 16:32 /dev/sdg
brw-rw---- 1 root disk 8,  97 2010-05-21 16:32 /dev/sdg1
brw-rw---- 1 root disk 8, 112 2010-05-21 16:32 /dev/sdh
brw-rw---- 1 root disk 8, 128 2010-05-21 16:32 /dev/sdi
brw-rw---- 1 root disk 8, 144 2010-05-21 16:32 /dev/sdj
brw-rw---- 1 root disk 8, 145 2010-05-21 16:32 /dev/sdj1
brw-rw---- 1 root disk 8, 160 2010-05-21 16:32 /dev/sdk
brw-rw---- 1 root disk 8, 161 2010-05-21 16:32 /dev/sdk1
brw-rw---- 1 root disk 8, 176 2010-05-21 16:32 /dev/sdl
brw-rw---- 1 root disk 8, 192 2010-05-21 16:32 /dev/sdm



Any help is greatly appreciated.

-Tim
