From: "Miguel Angel Martinez Ezquerro" <scsmaezm@sc.ehu.es>
Subject: Booting a RAID-1
Date: Tue, 15 Jul 2003 14:03:03 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c34ac9$0bd4e750$6296e39e@sc.ehu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello everybody,

I have a system RedHat 9.0 with RAID-1, two identical disks of 36 Gb
SCSI with the following partitions: =20
/ dev/md0 for / =20
/ dev/md2 for / users and =20
/ dev/md1 for / var =20
I have installed lilo2.5.6 to get that both disks are bootables to work
without problems in case of the failure of anyone of them. Starting fro=
m
that moment if one of the disks substitutes it for a virgin disk the
system it doesn't start up, sew that if it happened with the version
lilo-21.4.4.22 that comes for defect with RedHat 9.0. ( Nevertheless I
can boot the system with a single disk without problems)=20
 =20
Somebody knows what can it be happening?

Boot messages are as follow (notice that sdb is the new disk, without
partitions)

Md: considering sda2
Md: adding sda2 ...
Md: md2 already running, connot run sda2
Md: export_rdev(sda2)
Md: (sda2 was pending)
Md: considering sdb2
Md: adding sdb2 ...
Md: md2 already running, connot run sdb2
Md: export_rdev(sdb2)
Md: (sdb2 was pending)
Md: ...
=2E..
MD: ... Autorun DONE

=2E...
=2E.. Consequently=20
=2E..
VFS:Can't find ext3 filesystem on dev md(9,0)
=2E..
=2E....and finally
=2E...
Kernel panic: No init found. Try passing init=3D option to kernel


Thanks in advance.

Saludos,
                M.A.

------------------------------------------------------------------
Miguel =C1ngel Mart=EDnez Ezquerro      |   Universidad del Pa=EDs Vasc=
o
CIDIR Guip=FAzcoa (UPV/EHU)           |   E-mail: scsmaezm@sc.ehu.es
P.M Lardiz=E1bal,1 (Ed. F.Inform=E1tica)|   Tel...: +34 943 018005
20018 San Sebasti=E1n (SPAIN )        |   Fax...: +34 943 219306
------------------------------------------------------------------=20

=20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
