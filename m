From: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Subject: I/O is retried forever if last disk in a md device fails
Date: Wed, 4 Jul 2007 16:18:19 +0200
Message-ID: <7AAD212492598A4A92463C3F5D34C54F3DD36C@ccd3.cc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
List-Id: linux-raid.ids

Hello list,=20

we use linux software raid (md) to do host based mirroring of 2 SAN sto=
rage systems. We also use clustering for high availability. We use DMMP=
 for multipathing. This enables us to build fully redundant disaster re=
covery solutions. Our setup look like this (logical view):

-----------------------------
|        filesystem (xfs)   |
----------------------------
|         lvm lv            |
-----------------------------
|         lvm vg            |
-----------------------------
|    md device  (/dev/mdY)  |
-----------------------------
| dmmp device | dmmp device |
| (/dev/dm-X) | (/dev/dm-Y) |
-----------------------------
|  sda | sdb  |  sdc | sdd  |
-----------------------------
| Storage LUN | Storage LUN |
| (Storage 1) | (Storage 2) |
-----------------------------

However, we did some testing of our setup and one test was pulling all =
fibre channel cables from a server. During the test we used a broken Mi=
rror (only one DMMP device active in the mirror). The remaining disk wa=
s a DMMP Device: /dev/dm-X. DMMP is configured to report I/O errors up =
the stack if all path's are dead (no_path_retry=3Dfail). When we pulled=
 all the cables, DMMP detects the path failures after aprox. 60 seconds=
=2E Because all path's are dead, the DMMP device is declared dead. I/O =
to the DMMP device fails.

  mdadm -E /dev/dm-X returns "Could not read md superblock on device"

  dd if=3D/dev/dm-X of=3D/dev/null bs=3D1M count=3D1

also returns I/O errors.

The problem is that all I/O to the md device is queued and retried fore=
ver. The /var/log/messages file shows:=20

SCSI ERROR .. Return code =3D 0x10000
[... Many times ...]
SCSI ERROR .. Return code =3D 0x10000
raid1: dm-12 resheduling sector 0

This returns in an endless loop until I shut down the machine.=20

This does not allow our cluster to do a clean failover of the device, b=
ecause it can not deactivate lv logical volumes on top of the md device=
=2E The "lvchange -an" call hangs forever. I think this issue is no DMM=
P sepcific and should be the same for all devices.=20

The kernel we use is SLES9 SP3 kernel on IA64.=20

Is there a config option or a later version of the MD kernel code / too=
ls that report I/O errors up the stack if the last disk in a md device =
fails ?=20

If there is a later version, we may be able to get the patch back to th=
e SLES9 kernel by our SuSE support agreement.=20

Regards,=20
Robert=20

-----------------------------------------------------------------------=
-
COMPUTER CONCEPT=20
CC Computersysteme und Kommunikationstechnik GmbH=20
Robert Heinzmann
Wiener Str. 114 - 116		Email:	heinzmann@cc-dresden.de
01219 Dresden			Telefon:	+49 (351) 8 76 92-0
					Telefax:	+49 (351) 8 76 92-99
					Internet:	http://www.cc-dresden.de
Handelregister Dresden, HRB 214
Gesch=E4ftsf=FChrer: Gerd Jelinek
-----------------------------------------------------------------------=
-=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
