From: Dominik Kubla <dominik.kubla@sciobyte.com>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 17:49:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306111749.53279.dominik.kubla@sciobyte.com>
References: <02d201c33023$13fd45a0$3351960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02d201c33023$13fd45a0$3351960a@EEL>
Content-Disposition: inline
To: Ionut Nistor <ionut@modulo.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mittwoch, 11. Juni 2003 16:09 schrieb Ionut Nistor:

> Is there something I am missing? Is this a lack in the kernel?

Yes. For the second I am not sure.

You need to map your drives WWN's to SCSI-ID's. And no, the stock kerne=
ls=20
apparently can not do this (at least i found not documentation and no=20
indications in the code). However all major FC-HBA vendors offer their =
own=20
drivers for Linux which allow you to do WWN mapping.

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
