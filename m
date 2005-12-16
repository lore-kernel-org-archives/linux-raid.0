From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Re: SATA controller order
Date: Fri, 16 Dec 2005 22:15:34 +0100
Message-ID: <20051216211534.GA14533@atc5.vermine.org>
References: <20051216091439.GD24593@atc5.vermine.org> <43A28993.9020000@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43A28993.9020000@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-12-16 04:32 -0500, Jeff Garzik wrote:
> Andre Majorel wrote:
>
> >I have a motherboard with two SATA chips (Nvidia nForce 4 and
> >Silicon Image SiI 3114) running Linux 2.6.14.3. The drivers are
> >SCSI_SATA_NV and SCSI_SATA_SIL, both compiled-in.                   =
      =20
> >                                                                    =
           =20
> >Ports on the SiI 3114 controller are assigned scsi0 through
> >scsi3 and ports on the nForce4 chip are assigned scsi4 through
> >scsi7. Is there any way to control the order so that SCSI_SATA_NV
> >gets scsi0-scsi3 and SCSI_SATA_SIL gets scsi4-scsi7 instead ?
>=20
> Use modules,

But then wouldn't I have to use initrd if / is on a raid device ?

> otherwise its defined by link order...

OK. This did the trick :

diff -ur --exclude '*.o' linux-2.6.14.3/drivers/scsi/Makefile linux-2.6=
=2E14.3-nf4-first/drivers/scsi/Makefile
--- linux-2.6.14.3/drivers/scsi/Makefile	2005-11-24 23:10:21.000000000 =
+0100
+++ linux-2.6.14.3-nf4-first/drivers/scsi/Makefile	2005-12-16 20:52:14.=
000000000 +0100
@@ -124,6 +124,7 @@
 obj-$(CONFIG_SCSI_NSP32)	+=3D nsp32.o
 obj-$(CONFIG_SCSI_IPR)		+=3D ipr.o
 obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsi/
+obj-$(CONFIG_SCSI_SATA_NV)	+=3D libata.o sata_nv.o
 obj-$(CONFIG_SCSI_SATA_AHCI)	+=3D libata.o ahci.o
 obj-$(CONFIG_SCSI_SATA_SVW)	+=3D libata.o sata_svw.o
 obj-$(CONFIG_SCSI_ATA_PIIX)	+=3D libata.o ata_piix.o
@@ -134,7 +135,6 @@
 obj-$(CONFIG_SCSI_SATA_VITESSE)	+=3D libata.o sata_vsc.o
 obj-$(CONFIG_SCSI_SATA_SIS)	+=3D libata.o sata_sis.o
 obj-$(CONFIG_SCSI_SATA_SX4)	+=3D libata.o sata_sx4.o
-obj-$(CONFIG_SCSI_SATA_NV)	+=3D libata.o sata_nv.o
 obj-$(CONFIG_SCSI_SATA_ULI)	+=3D libata.o sata_uli.o
 obj-$(CONFIG_SCSI_SATA_MV)	+=3D libata.o sata_mv.o
=20
# dmesg | grep 'scsi. :'
scsi0 : sata_nv
scsi1 : sata_nv
scsi2 : sata_nv
scsi3 : sata_nv
scsi4 : sata_sil
scsi5 : sata_sil
scsi6 : sata_sil
scsi7 : sata_sil

Thanks !

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
