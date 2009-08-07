From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: question about bitmaps and dirty percentile
Date: Thu, 6 Aug 2009 21:17:10 -0500
Message-ID: <cccedfc60908061917g7d8fc2fdj696ac0261241d3d2@mail.gmail.com>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
	<19066.30329.778572.603105@notabene.brown> <cccedfc60908060602i52403915oa7afcb38a9e386b0@mail.gmail.com>
	<0b3f2dc27832051e76c23cec416f1469.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0b3f2dc27832051e76c23cec416f1469.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 6, 2009 at 8:47 PM, NeilBrown<neilb@suse.de> wrote:
=2E..
> So the problem is that in resync_status, max_sectors is being set to
> mddev->size rather than mddev->size*2. =A0This is purely a cosmetic p=
roblem,
> it do not affect data safety at all.
>
> It looks like I botched a backport of
> =A0commit dd71cf6b2773310b01c6fe6c773064c80fd2476b
> into the Suse kernel. =A0I'll get that fixed for the next update.
>
> Thanks for the report, and as I said, the only thing affected here
> is the content of /proc/mdstat. =A0The recovery is doing the right
> thing.

Sweet! Open Source is AWESOME.


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
