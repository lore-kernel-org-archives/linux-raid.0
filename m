From: Norman Schmidt <norman.schmidt@chemie.uni-erlangen.de>
Subject: Re: new raid system for home use
Date: Mon, 19 Apr 2004 18:03:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4083F865.7070803@chemie.uni-erlangen.de>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca> <Pine.LNX.4.58.0404181253470.24065@spoon.loc>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0404181253470.24065@spoon.loc>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Paul!

Paul Phillips schrieb:

> I was under the impression that I can't boot off raid-5, but if that
> information is dated then all the better.
>=20
> Thanks again.

Afaik, that=B4s still true. The reason is that the two (or more) drives=
 of=20
a raid 1 essentially hold the same data, and if you do everything right=
,=20
the complete boot mechanism is on all disks, so that you can boot with=20
any of them. On raid 5 disks, you would never have the complete data on=
=20
any of the disks.

Norman.

--=20
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
