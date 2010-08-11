From: Tobias Gunkel <tobias.gunkel@qumido.de>
Subject: weird SparesMissing event
Date: Wed, 11 Aug 2010 09:04:32 +0200
Message-ID: <4C624B80.9030304@qumido.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

I've got a strange SparesMissing event on one of my raid1 arrays.
mdadm --detail /dev/md2 says all ok, but I get this message by mdadm
monitor every day:

A SparesMissing event had been detected on md device /dev/md2.

=46aithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid1]
md2 : active raid1 sda3[0] sdc3[2](S) sdb3[1]
      474714048 blocks [2/2] [UU]
[...]

root@MCI03:~# mdadm --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Fri May 28 14:54:26 2010
     Raid Level : raid1
     Array Size : 474714048 (452.72 GiB 486.11 GB)
  Used Dev Size : 474714048 (452.72 GiB 486.11 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Aug 11 08:52:13 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

           UUID : 7aa24776:9d6e8d24:54307b3d:1949437b (local to host MC=
I03)
         Events : 0.985979

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3

       2       8       35        -      spare   /dev/sdc3


This makes me wonder, too:

root@MCI03:~# mdadm --examine --scan
ARRAY /dev/md0 UUID=3D304f5f2a:fbc8082b:54307b3d:1949437b
   spares=3D1
ARRAY /dev/md1 UUID=3Db263f9c1:5c680152:54307b3d:1949437b
   spares=3D1
ARRAY /dev/md2 UUID=3D7aa24776:9d6e8d24:54307b3d:1949437b
   spares=3D2

Why spares=3D2 for md2? It was created during Debian system install wit=
h
spares=3D1.

root@MCI03:~# mdadm -V
mdadm - v3.0.3 - 22nd October 2009

root@MCI03:~# uname -r
2.6.32preemptive


What's wrong here?
Thanks for any comments!

Best regards, Tobi

--=20
qumido GmbH | Altplauen 19 | 01187 Dresden
Telefon: +49 1805 355 7555 | Telefax: +49 7472 2820 26
E-Mail:  it@qumido.de      | Web: http://www.qumido.de

Gesch=E4ftsf=FChrung: Lothar Hartinger, Jan Aurel Rohde
Sitz der Gesellschaft: Rottenburg am Neckar | Amtsgericht Stuttgart: HR=
B
723793


Diese E-Mail enth=E4lt vertrauliche und/oder rechtlich gesch=FCtzte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese
E-Mail irrt=FCmlich erhalten haben, informieren Sie bitte sofort den
Absender und vernichten Sie diese E-Mail. Das unerlaubte Kopieren sowie
die unbefugte Weitergabe dieser E-Mail ist nicht gestattet.
Internetkommunikationen sind nicht sicher. Daher =FCbernimmt die qumido
GmbH keinerlei Haftung f=FCr den Inhalt dieser Nachricht. Jegliche
Ansichten oder dargestellte Meinungen sind ausschlie=DFlich solche des
Autors und repr=E4sentieren nicht notwendigerweise die der qumido GmbH.

This e-mail may contain confidential and/or privileged information. If
you are not the intended recipient (or have received this e-mail in
error) please notify the sender immediately and destroy this e-mail. An=
y
unauthorized copying, disclosure or distribution of the material in thi=
s
e-mail is strictly forbidden. Internet communications are not secure an=
d
therefore qumido GmbH does not accept legal responsibility for the
contents of this message. Any views or opinions presented are solely
those of the author and do not necessarily represent those of qumido
GmbH.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
