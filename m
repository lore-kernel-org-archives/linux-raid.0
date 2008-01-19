From: Berny <webmaster@designoart.de>
Subject: Raid 5 Wiederherstellung
Date: Sat, 19 Jan 2008 12:23:26 +0100
Message-ID: <op.t46clcs5cejtzs@bueropc>
Reply-To: webmaster@designoart.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: pkg-mdadm-devel@lists.alioth.debian.org
List-Id: linux-raid.ids

Hallo,

wende mich mal an Euch mit meinem Problem. Komme aus der Windows Ecke u=
nd =20
bin daher nicht ganz so fit in Linux:

Habe auf meinem Thecus NAS N5200 folgendes gemacht: Zuerst =20
funktionierendes Raid 5 mit 3x300GB Disks=3D Kapazit=E4t von ca. 580GB.
Belegt ca. 450 GB. Dann vierte Platte eingebaut. Wurde automatisch als =
=20
Spare eingebunden, was mir aber zur Kapazit=E4tserweiterung nix gen=FCt=
zt hat. =20
Also im Webadministrations-Tool der Thecus Box den Men=FCpunkt "Migrate=
" =20
Raid 5 nach Raid 5 mit 4 Platten gestartet. Hat dann auch mehrere Stund=
en =20
"migriert" und ich hatte danach ein Raid 5 mit 4 Platten und ca. 880 GB=
 - =20
toll - das hatte aber leider keine Daten mehr. Im Hexeditor Winhex sehe=
 =20
ich auf den einzelnen Platten eine Menge Daten (habe jetzt - leider zu =
=20
sp=E4t - ein RAW Image aller Platten nach der Migration des jetzt leere=
n =20
Raids gemacht). Gibt es eine M=F6glichkeit die Datenstruktur des alten =
Raid =20
5 Verbundes mit den 3 Platten wiederherzustellen oder wenigstens ein =20
Linux-Tool um die Dateien - auch ohne Dateinamen- wiederherzustellen?

Auf der Thecus N5200 Box l=E4uft Linux version 2.6.13N5200 (root@WIG_de=
vel) =20
(gcc version 3.3.6) #135 Wed Dec 5 16:15:26 CST 2007

H=E4tte die M=F6glichkeit die RAW Images in VMWare einzubinden und dort=
 das =20
Raid evtl. virtuell wieder zusammenzubauen.

Habe bis jetzt vom Thecus Support folgendes erhalten:

If you want to recover it in a Linux(Kernel version 2.6.15 or later, =20
suggest Fedora core 7 or 8)  PC, you will need to assemble the Linux =20
software RAID across /dev/sda2, /dev/sdb2, /dev/sdc2, /dev/sdd2, /dev/s=
de2.
Then the LVM2 logical volume layer need to be actived on  /dev/vg0/lv0 =
by =20
using the commands "vgscan" then "lvscan" then "lvchange".
The Linux PC will be able to mount the activated logical volume =20
/dev/vg0/lv0 as EXT3 for further data recovery.


Vielen Dank

--=20
Berny Wei=DF
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
