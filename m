From: "Miguel Angel Martinez Ezquerro" <scsmaezm@sc.ehu.es>
Subject: Unable to boot after upgrading a Raid1 system
Date: Thu, 26 Aug 2004 14:27:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408261227.i7QCRHug021798@lgsx14.lg.ehu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
	I have upgrade my system with 3 Raid partitions from Red Hat 9 to
Red Hat Enterprise Linux AS, and after upgrading successfully the syste=
m say


---
Md: autodetecting Raid Arrays
    autorun ...
    ... Autorun done
Md: autodetecting Raid Arrays
    autorun ...
    ... Autorun done
Md: autodetecting Raid Arrays
    autorun ...
    ... Autorun done
Reading block devices
EXT2-fs: unable to read superblock
Iofs_read_super: bread failled, dev=3D09:00, iso_blknum=3D16, block=3D3=
2
EXT3-fs: unable to read superblock
Kernel panic: VFS: Unable to mount root fs on 09:00


I have booted the system with the Install CD en linux rescue mode and I=
 see
three raid 1 well syncronized and it seems to be all ok in lilo.conf.
Somebody can appoint what can be happening and how to solve this proble=
m??

Thanks in advance.

Saludos,
                M.A.

------------------------------------------------------------------
Miguel =C1ngel Mart=EDnez Ezquerro      |   Universidad del Pa=EDs Vasc=
o
CIDIR Guip=FAzcoa (UPV/EHU)           |   E-mail: scsmaezm@sc.ehu.es
P.M Lardiz=E1bal,1 (Ed. F.Inform=E1tica)|   Tel...: +34 943 018005
20018 San Sebasti=E1n (SPAIN )        |   Fax...: +34 943 015590
------------------------------------------------------------------=20

=20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
