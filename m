From: Dominik Kubla <dominik.kubla@sciobyte.com>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 17:07:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307281707.52674.dominik.kubla@sciobyte.com>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net> <Pine.LNX.4.55.0307281006480.22915@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0307281006480.22915@datavibe.net>
Content-Disposition: inline
To: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag, 28. Juli 2003 16:11 schrieb Rev. Jeffrey Paul:

> Someone (3ware?) should make an IDE drive cage with a custom backplan=
e and
> an integrated IDE RAID card... and a VHDCI plug for an uplink to the =
host.
> That would be cool.

Those things do already exist.  Now the manufaturers seem to move on fr=
om PATA=20
to SATA. The latest info i got was about the following:

* Infortrend EonStor A16U:	16 drive Serial-ATA to 2x Ultra160-SCSI
* Infortrend EonStor A16F:	16 drive Serial-ATA to 2x 2Gbit-FibreChannel

3U size, (current) max. capacity 4TB brutto (equals 3,75 TB for one big=
=20
RAID5). Can be configured as RAID Level 0, 1, 3, 5, 0+1, 1+0, 3+0, 5+0 =
or as=20
JBOD or NRAID.

More info at: www.infortrend.com

Regards,
  Dominik Kubla
--=20
ScioByte GmbH                     | ScioByte Information Technologies A=
G
=46ritz-Erler-Strasse 6             | Innere G=FCterstrasse 4
55129 Mainz (Germany)             | 6304 Zug (Switzerland)
Phone: +49 700 724 629 83         | Phone: +41 41 710 30 18
=46ax:   +49 700 724 629 84         |

GnuPG: 1024D/717F16BB A384 F5F1 F566 5716 5485  27EF 3B00 C007 717F 16B=
B

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
