From: =?iso-8859-1?Q?Alberto_Pic=F3n_Couselo?=
	<albertopicon@picon-networks.com>
Subject: Promise FastTrak TX2200 SATA RAID Controller
Date: Wed, 27 Apr 2005 15:46:40 +0200
Message-ID: <002401c54b2f$8da760b0$1a01a8c0@carpetana07>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there. I have been testing successfully an installation procedure
to use a Promise FastTrak TX2000 RAID controller on a Dell PowerEdge
1420SC server with Debian Woody 3.0rc2. This controller card is designe=
d
for IDE hard disks and I've been using it without problems through the
beta driver 0.03 of the kernel 2.4.30.=20

However, I'm trying to use the same installation procedure for a Promis=
e
=46astTrak TX2200 SATA RAID controller and it seems that the PDC20571
(TX2200) chip is not supported under kernel 2.4.30 for the moment. Can
anybody tell me if this card will be supported in the near future?

Thank you very much,
Al

--
Alberto Pic=F3n - albertopicon@picon-networks.com
Picon Networks S.L. - Improving your performance


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
