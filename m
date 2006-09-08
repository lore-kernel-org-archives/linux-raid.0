From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: RAID5 fill up?
Date: Fri, 08 Sep 2006 11:33:24 +0200
Message-ID: <450138E4.3060804@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I=B4ve got a software RAiD5 with 6 250GB HDs.
Now I changed one disk after another to a 400GB HD and resynced the
raid5 after each change.
Now the RAID5 has got 6 400GB HDs and still uses only 6*250GB space.
How can I grow the md0 device to use 6*400GB?

MfG,
Lars Schimmer
--=20
-------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
