From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: RAID1 over aoe devices freezes cp-procs on failure of one aoe
 device
Date: Fri, 6 Jun 2008 12:03:40 +0200
Message-ID: <20080606120340.b2e7d25b.taeuber@bbaw.de>
References: <20080605162502.09856f38.taeuber@bbaw.de>
	<20080606073416.GC10273@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080606073416.GC10273@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-raid@vger.kernel.org, sah@coraid.com, ecashin@coraid.com
List-Id: linux-raid.ids

Hallo Gabor,

Gabor Gombas <gombasg@sztaki.hu> schrieb:
> On Thu, Jun 05, 2008 at 04:25:02PM +0200, Lars T=C3=A4uber wrote:
>=20
> > The lost aoe-device is correctly marked as faulty but the the raid =
is
> > not usable for a copying processes any more although the remaining
> > device should be enough for a RAID1. There was no change after
> > removing the faulty device from md9.
> >=20
> > Is it possible that one faulty aoe-device blocks the aoe-module any=
how
> > so that all other aoe devices aren't accessible anymore? Or is the
> > RAID subsystem responsible for this?
>=20
> It should be easy to test: when the RAID hangs, try to read directly
> from the remaining device ("dd if=3D/dev/etherd/e11.1 ..."). If that =
also
> hangs, then it is an AoE issue.

the easiest tests are the last that come to mind. :o)
There is another problem here:
The described problem is not reproducable. I'm not sure wether I made s=
omething wrong or the situation is not the same after the shutdown.

I'm checking this right now.

Thanks
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
