From: Norman Schmidt <schmidt@naa.net>
Subject: Re: Highpoint 1820A
Date: Sun, 18 Sep 2005 19:17:26 +0200
Message-ID: <432DA126.6070206@naa.net>
References: <Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se> <432D2D92.3090804@dtbb.net>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <432D2D92.3090804@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tyler schrieb:


> and doesn't require such finicky drivers and support
> from highpoint or any other company for that matter, as long as there=
=20
> are drivers to see the card, and the ports as standard sata/ata ports=
=20
> (and possibly some different settings in the cards bios).

Unfortunately, that isn=B4t the case, at least the highpoint support,
which I connected in the driver matter, says you need at least their
open source driver (which contains some pre-compiled object code,
anyway) and build a module from it, even to use just the SATA ports
without the hardware raid functionality.

So it doesn=B4t work without drivers and changing the kernel (at least
that=B4s what Highpoint thinks).

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
