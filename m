From: Jure =?ISO-8859-2?Q?Pe=5Far?= <pegasus@nerv.eu.org>
Subject: Re: Badstripe proposal (was Re: Bad blocks are killing us!)
Date: Sun, 21 Nov 2004 19:23:08 +0100
Message-ID: <20041121192308.75ecfacc.pegasus@nerv.eu.org>
References: <200411162307.iAGN7lN28260@www.watkins-home.com>
	<419B5050.1010501@dgreaves.com>
	<419C729D.3E36A473@libero.it>
	<20041119181222.6ce1f1be.pegasus@nerv.eu.org>
	<419F4372.CD77B4DD@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419F4372.CD77B4DD@libero.it>
Sender: linux-raid-owner@vger.kernel.org
To: Maurilio Longo <maurilio.longo@libero.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 20 Nov 2004 14:15:30 +0100
Maurilio Longo <maurilio.longo@libero.it> wrote:

> Jure Pe,
>=20
> can we use dm-bbr without installing evms? I'd like not to install it
> since it seems to me a cumbersome tool while my systems with raid1 an=
d
> grub are fairly easy to create and maintain.
>=20
> regards.

I think dm-bbr is just another dm target and so can be created and used=
 with
dmsetup just as other dm stuff.=20


--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
