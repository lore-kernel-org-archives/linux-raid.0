From: Thomas =?iso-8859-1?q?Carri=E9?= <thocar@thocar.org>
Subject: MD without LVM : should I reinstall ?
Date: Thu, 17 Mar 2011 22:36:46 +0100
Message-ID: <201103172236.46540.thocar@thocar.org>
Reply-To: thocar@thocar.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

My hosting provider has a setup for me a Debian server using md RAID1 b=
ut it=20
does not use LVM, should I consider re-install with LVM ?

# mount | grep ' / '
/dev/md0 on / type ext3 (rw,errors=3Dremount-ro)
# fdisk -l

Disk /dev/sdb: 250.1 GB, 250059350016 bytes
=2E..
   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1       30155   242220006   fd  Linux raid auto=
detect
/dev/sdb2           30156       30401     1975995    5  Extended
/dev/sdb5           30156       30401     1975963+  82  Linux swap / So=
laris

Disk /dev/sda: 250.1 GB, 250059350016 bytes
=2E..
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1       30155   242220006   fd  Linux raid auto=
detect
/dev/sda2           30156       30401     1975995    5  Extended
/dev/sda5           30156       30401     1975963+  82  Linux swap / So=
laris

Disk /dev/md0: 248.0 GB, 248033181696 bytes
=2E..
Disk /dev/md0 doesn't contain a valid partition table

Thanks for your feedback
--=20
Thomas Carri=E9
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
