From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RAID1 over aoe devices freezes cp-procs on failure of one aoe
	device
Date: Fri, 6 Jun 2008 09:34:16 +0200
Message-ID: <20080606073416.GC10273@boogie.lpds.sztaki.hu>
References: <20080605162502.09856f38.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080605162502.09856f38.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?iso-8859-2?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org, sah@coraid.com, ecashin@coraid.com
List-Id: linux-raid.ids

On Thu, Jun 05, 2008 at 04:25:02PM +0200, Lars T=E4uber wrote:

> The lost aoe-device is correctly marked as faulty but the the raid is
> not usable for a copying processes any more although the remaining
> device should be enough for a RAID1. There was no change after
> removing the faulty device from md9.
>=20
> Is it possible that one faulty aoe-device blocks the aoe-module anyho=
w
> so that all other aoe devices aren't accessible anymore? Or is the
> RAID subsystem responsible for this?

It should be easy to test: when the RAID hangs, try to read directly
from the remaining device ("dd if=3D/dev/etherd/e11.1 ..."). If that al=
so
hangs, then it is an AoE issue.

Gabor

--=20
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
