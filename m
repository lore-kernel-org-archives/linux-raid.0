From: =?ISO-8859-15?Q?=22T=2E_Eichst=E4dt=22?= <abc@digithi.de>
Subject: raid10 or raid1+0 ?
Date: Mon, 27 Aug 2007 02:40:19 +0200
Message-ID: <46D21D73.9060100@digithi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo all,

I have 4 HDDs and I want to use mirroring and striping.
I am wondering what difference between the following two solutions is:

- raid0 on top of 2 raid1 devices (raid1+0)
- directly using the raid10 module

Perhaps someone can give me a hint what the raid10 linux module does in=
=20
difference to the combination of raid1 and raid0.

Another question:
How stable is the raid10 module in the linux kernel. I am currently=20
using the debian kernel 2.6.18 but I saw some patches from Neil and=20
others for 2.6.21, 2.6.22 regarding the raid10 module. And their=20
descriptions sound as if it could be useful to integrate them. when=20
using raid10.
Okay, backporting isn't complicated, but nevertheless the number of=20
patches makes me feel that raid10 is perhaps not that stable like raid0=
=20
and raid1 ???

Perhaps someone can blow away my fear :)

Best regards
  Thimo Eichst=E4dt

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
