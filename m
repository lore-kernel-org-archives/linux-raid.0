From: Lars Gaarden <lar-gaar@online.no>
Subject: Re: SATA chipset recomendations
Date: Wed, 09 Jun 2004 15:51:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C715F2.1020100@online.no>
References: <200406082012.58968.linux_mail@rozpooh.com> <yw1xise1tdif.fsf@kth.se> <1086777225.40c6e789ade9f@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1086777225.40c6e789ade9f@www.tastycake.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nick Maynard wrote:
> M=E5ns Rullg=E5rd wrote:
>=20
>>I'm using a Highpoint RocketRAID 1540 without any problems.  There
>>have been reports on this list from others having strange problems
>>with Rocket 1540 (no fakeraid) cards.  <snip>
>=20
> Yup - that was me.  The basic Rocket (not RocketRAID) 1540 card gave =
me /very/
> serious problems with Linux.  Really - don't play with it.  I managed=
 to get
> mine RMA'd, but... blech.

Ditto. I didn't RMA my Rocket 1540. The only way I can make it work=20
properly
is to use a 2.4.x kernel, the hpt 'open source' driver and connect the=20
drive(s)
to the controller after the POST has finished.

--=20
LarsG
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
