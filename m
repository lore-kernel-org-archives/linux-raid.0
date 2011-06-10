From: "Dragon" <Sunghost@gmx.de>
Subject: (unknown)
Date: Fri, 10 Jun 2011 15:06:52 +0200
Message-ID: <20110610130652.298530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You are right, the array starts at pos 0 and so pos 1 and 7 are the rig=
ht pos. the 2. try was perfect. fsck shows this:

fsck -n /dev/md0
fsck from util-linux-ng 2.17.2
e2fsck 1.41.12 (17-May-2010)
/dev/md0 wurde nicht ordnungsgem=C3=A4=C3=9F ausgeh=C3=A4ngt, Pr=C3=BCf=
ung erzwungen.
Durchgang 1: Pr=C3=BCfe Inodes, Blocks, und Gr=C3=B6=C3=9Fen
Durchgang 2: Pr=C3=BCfe Verzeichnis Struktur
Durchgang 3: Pr=C3=BCfe Verzeichnis Verkn=C3=BCpfungen
Durchgang 4: =C3=9Cberpr=C3=BCfe die Referenzz=C3=A4hler
Durchgang 5: =C3=9Cberpr=C3=BCfe Gruppe Zusammenfassung
dd/dev/md0: 266872/1007288320 Dateien (15.4% nicht zusammenh=C3=A4ngend=
), 3769576927/4029130864 Bl=C3=B6cke

and:
mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Jun 10 14:19:24 2011
     Raid Level : raid5
     Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
   Raid Devices : 13
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun 10 14:19:24 2011
          State : clean
 Active Devices : 13
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 8c4d8438:42aa49f9:a6d866f6:b6ea6b93 (local to host na=
ssrv01)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8      160        0      active sync   /dev/sdk
       1       8      208        1      active sync   /dev/sdn
       2       8      176        2      active sync   /dev/sdl
       3       8      192        3      active sync   /dev/sdm
       4       8        0        4      active sync   /dev/sda
       5       8       16        5      active sync   /dev/sdb
       6       8       64        6      active sync   /dev/sde
       7       8       48        7      active sync   /dev/sdd
       8       8       80        8      active sync   /dev/sdf
       9       8       96        9      active sync   /dev/sdg
      10       8      112       10      active sync   /dev/sdh
      11       8      128       11      active sync   /dev/sdi
      12       8      144       12      active sync   /dev/sdj

normaly i use fsck.ext4 e.a. fsck.ext4dev. problem? what means 15,4% no=
t related? the quote of lost data? after that i shrink like this:?

mdadm  /dev/md0 --fail /dev/sdj
mdadm /dev/md0 --remove /dev/sdj
mdadm --detail --scan >> /etc/mdadm/mdadm.conf

right way? i assume that the disk that i take off the raid is not the s=
ame like i added at last? so i have to read out the serial to find it u=
nder the harddrives?
many thx so far
--=20
NEU: FreePhone - kostenlos mobil telefonieren!		=09
Jetzt informieren: http://www.gmx.net/de/go/freephone
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
