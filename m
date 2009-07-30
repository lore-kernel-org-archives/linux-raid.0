From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: question about bitmaps and dirty percentile
Date: Thu, 30 Jul 2009 14:16:49 -0500
Message-ID: <cccedfc60907301216h769eadd7oc575dd3ae04f64bb@mail.gmail.com>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 30, 2009 at 1:25 PM, Jon
Nelson<jnelson-linux-raid@jamponi.net> wrote:
> Then things got weird.
>
> I saw this, which just *can't* be right:
>
> md12 : active raid1 nbd0[2](W) sde[0]
> =A0 =A0 =A072612988 blocks super 1.1 [3/1] [U__]
> =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>] =A0recovery=
 =3D192.7%
> (69979200/36306494) finish=3D13228593199978.6min speed=3D11620K/sec
> =A0 =A0 =A0bitmap: 139/139 pages [556KB], 256KB chunk
>
> and of course the percentile kept growing, and the finish minutes are=
 crazy.

Weirdness: it ready 199 (or so) and then completed:

md12 : active raid1 nbd0[2](W) sde[0]
      72612988 blocks super 1.1 [3/2] [UU_]
      bitmap: 139/139 pages [556KB], 256KB chunk

I --fail, --remove the device, and then --re-add it.

The recovery *starts over*, as if nothing had happened over the last ho=
ur or so.
The event counter are very close between /dev/nbd0 (the device here)
and /dev/sde (the core device), within a dozen or so, but the "dirty
percentile" on /dev/nbd0 is big - 18.8%, and unchanging between runs.
It's like the bitmap isn't getting updated, or getting updated
incompletely, or something.

Does the bitmap only get updated when *all* devices have sync'd???
I'll let you know in about 2 hours.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
