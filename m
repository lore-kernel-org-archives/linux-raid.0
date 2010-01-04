From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: Question about ADMA + RAID5 in the event of disk failure
Date: Mon, 4 Jan 2010 09:16:04 -0800
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C08882F60@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>, linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids


Hi Dan,
=A0 I have question about what ADMA + RAID-5 and disk failure. In the e=
vent of disk failure what would happen to the descriptors which are que=
ued up the DMA engine for XOR operation ?=20
This is what I am trying.
1. Create RAID-5 using 4 disks.
2. Install xfs file system and mount it.
3. Force the disk failure using mdadm -f /dev/md0 /dev/sdc
4. Then hot remove the drive mdadm -r /dev/md0 /dev/sdc
5. Un-mount the /dev/md0. Then run file system check using xfs_repair -=
L /dev/md0.=20


I see messages as shown below. These messages doesn't show up if I don'=
t use ADMA. But there seem to be no data loss. But still I there seem t=
o be a some kind of data inconsistency.


Regards,
Marri


----- messages ---
Phase 1 - find and verify superblock...
Phase 2 - using internal log
=A0=A0=A0=A0=A0=A0=A0 - zero log...
=A0=A0=A0=A0=A0=A0=A0 - scan filesystem freespace and inode maps...
bad magic # 0x83e1001c in inobt block 22/47
expected level 0 got 14369 in inobt block 22/47
dubious inode btree block header 22/47
badly aligned inode rec (starting inode =3D 6375867046)
bad starting inode # (6375867046 (0x16 0x7c0802a6)) in ino rec, skippin=
g rec

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
