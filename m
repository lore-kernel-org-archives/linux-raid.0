From: Andre Majorel <aym-xunil@teaser.fr>
Subject: SATA controller order
Date: Fri, 16 Dec 2005 10:14:39 +0100
Message-ID: <20051216091439.GD24593@atc5.vermine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all.

I have a motherboard with two SATA chips (Nvidia nForce 4 and
Silicon Image SiI 3114) running Linux 2.6.14.3. The drivers are
SCSI_SATA_NV and SCSI_SATA_SIL, both compiled-in.                      =
        =20
                                                                       =
        =20
Ports on the SiI 3114 controller are assigned scsi0 through
scsi3 and ports on the nForce4 chip are assigned scsi4 through
scsi7. Is there any way to control the order so that SCSI_SATA_NV
gets scsi0-scsi3 and SCSI_SATA_SIL gets scsi4-scsi7 instead ?

Thanks.

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
