From: Roberto Spadim <roberto@spadim.com.br>
Subject: partitions
Date: Fri, 28 Jan 2011 19:24:37 -0200
Message-ID: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, could we implement raid partitions?
for example:
mdadm --create /dev/md0 --level=3D1 --devices /dev/sda /dev/sdb
fdisk /dev/md0
create pratition 1,2,3,4

mkfs.ext4 /dev/md0p1
mkfs.ext4 /dev/md0p2
mkfs.ext4 /dev/md0p3
mkfs.ext4 /dev/md0p4

?? any idea? could we implement it?
there=B4s a TODO list for linux software raid?

--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
