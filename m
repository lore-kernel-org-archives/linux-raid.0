From: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Subject: AW: SW-RAID 1 and kernel 2.4.18
Date: Wed, 27 Nov 2002 15:46:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <984305F1827DD5118FEA0000D1105F0A01BDC031@HW_MAIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,=20
we don't hot swap the IDE drives. The described errors appear in runtim=
e,
without touching the drives.

Besides the original configuration (Mainboard MSI MS-6309 V5.0 (694T Pr=
o)
with VIA Apollo Pro 133 Chipset), we try now an ASUS TUSL2-C (Chipset I=
ntel
815EP B0). Both with PIII/1300, 512MB RAM.=20

The result so far: the SW-RAID on ASUS Board also kicks one disk off th=
e
raid, in 3 of 4 tests the pc was hanging. The Asus-PCs don't have anyth=
ing
about the disks in /var/log/messages.

The same (hanging, disks kick out, no messages) happens by using a ide
controller on pci card (internal ide controller switched off by bios).


Other tests (all with MSI board) with errors:
 - other ide disks: we use IBM IC35L040 ADDA and AVVN 40GB originally,
tested also Maxtor (don't have the type) and Seagate Barracuda ATA IV
(ST340016A)
 - other distribution: originally we use SuSE 7.3 with Kernel 2.4.18, t=
ested
also Red Hat 8.

The only tests without errors were the ones with DMA switched off via=20
   hdparm -d 0 /dev/hdx
There we made 5 Tests (normal configuration, both disks on one ide port=
 (hda
and hdb), without removable frames) All this tests with DMA have errors=
=2E


Hope I have you now totally confused..



Regards

---
Arnt Schepke <schep>


-----Urspr=FCngliche Nachricht-----
Von: H. Peter Anvin [mailto:hpa@zytor.com]
Gesendet am: Dienstag, 26. November 2002 23:53
An: linux-raid@vger.kernel.org
Betreff: Re: SW-RAID 1 and kernel 2.4.18

=46ollowup to:  <3DE3CC8D.2080104@mvista.com>
By author:    Steven Dake <sdake@mvista.com>
In newsgroup: linux.dev.raid
>=20
> IDE was not designed to hotswap.  The trays are not "hot swappable" i=
n=20
> that they can only be swapped while the system is off.
>=20

There are IDE cards which can tristate -- effectively disconnect -- the=
ir
outputs.  Some of them can even control the power to the drive.  Such
drives are safe to hotswap, if they have been disconnected before
removing them.  This requires driver support, however, and I'm not
sure if Linux has that.

	-hpa
--=20
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
"Unix gives you enough rope to shoot yourself in the foot."
http://www.zytor.com/~hpa/puzzle.txt	<amsp@zytor.com>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
