From: Louis-David Mitterrand <vindex@apartia.org>
Subject: some IDE trays are bad (was Re: SW-RAID 1 and kernel 2.4.18)
Date: Tue, 3 Dec 2002 17:01:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021203160141.GA7990@apartia.org>
References: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
To: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 26, 2002 at 02:56:41PM +0100, SCHEP. - Schepke, Arnt wrote:
> Hi, i have a running software raid 1. This consist of two ide devices=
 hda
> and hdc. The root filesystem is running on this raid array. The hardd=
iscs
> are installed in removable frames.=20
                   ^^^^^^^^^^^^^^^^^

That is the issue.

> The system seems to work correctly. But i get some errors. In the fil=
e
> messages i found:=20
>=20
> linux kernel: hdc: dma_intr: status=3D0x51 { DriveReady SeekComplete =
Error }=20
> linux kernel: hdc: dma_intr: error=3D0x84 { DriveStatusError BadCRC }

I've just had the same problem. My setup: 4 Maxtor 160G connected to a
Promise 133TX2 card, one of them was in an Icy Dock removable rack, the
three remaining were directly connected to the IDE cable.=20

The tray-connected disk would always give us the BadCRC error upon
resynching with the raid5 array. That kind of error is typical of bad
cabling.

It seems the additionnal connectors and cable-length in these IDE trays
is too much to bear for picky/sensitive ATA133 drives. In any case the
BadCRC disappeared the moment the drive was directly connected the IDE
ribbon.

hdparm -t /dev/md1 gives me over 100MB/s on IDE raid5. Incredible! Over
twice what a top-of-the-line 15k scsi drive gives me.

--=20
    PHEDRE: Comme il ne respirait qu'une retraite prompte !
            Et combien sa rougeur a redoubl=E9 ma honte !
                                          (Ph=E8dre, J-B Racine, acte 3=
, sc=E8ne 1)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
