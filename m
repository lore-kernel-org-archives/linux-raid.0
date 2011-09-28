From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Thu, 29 Sep 2011 09:49:10 +1000
Message-ID: <20110929094910.2c44ff8a@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
	<20110926193130.6377f5b9@notabene.brown>
	<4E82203A.60507@yazzy.org>
	<20110928091335.1df35f8e@notabene.brown>
	<4E828B92.40502@hardwarefreak.com>
	<4E82C862.8000705@yazzy.org>
	<4E834758.2090508@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5EjrSN9onuu6.xHPmV+/Ees"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E834758.2090508@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5EjrSN9onuu6.xHPmV+/Ees
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 11:12:08 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 9/28/2011 2:10 AM, Marcin M. Jessa wrote:
> > On 9/28/11 4:50 AM, Stan Hoeppner wrote:
> >
> >> Reading the thread, and the many like it over the past months/years, m=
ay
> >> yield a clue as to why you wish to move on to something other than Lin=
ux
> >> RAID...
> >
> > :) I will give it another chance.
> > In case of failure FreeBSD and ZFS would be another option.
>=20
> I was responding to Neil's exhaustion with mdadm.  I was speculating=20
> that help threads such as yours may be a contributing factor,=20
> requesting/requiring Neil to become Superman many times per month to try=
=20
> to save some OP's bacon.
>=20

No, I don't really think they are a factor - though thanks for thinking
about it.

Obviously not all "help threads" end with a good result but quite a few do
and one has to take the rough with the smooth.
And each help thread is a potential learning experience.  If I see patterns
of failure recurring it will guide and motivate me to improve md or mdadm to
make that failure mode less likely.

I think it is simply that it isn't new any more.  I first started
contributing to md early in 2000, and 11 years is a long time.  Not as long
as Mr Torvalds has works on Linux of course, but Linux is a lot bigger than
md so there is more room to be interested.
There have been many highlights over that time, but the ones that stick in =
my
memory is when others have contributed in significant ways.  I really value
that, whether it is code, or review or documentation, or making a wiki or
answering mailing lists questions before I do, or even putting extra time in
to reproduce a bug so we can drill down to the cause.

I figure that appearing competent capable and in control isn't going to
attract new blood - new blood wants wide open frontiers with lots of
opportunity (I started in md when it was essentially unmaintained - I know
the attraction).  So I just want to say that there is certainly room and
opportunity over here.

I'm not about to drop md, but I would love an apprentice or two (or 3 or 4)
and would aim to provide the same mix of independence and oversight as Linus
does.

NeilBrown

--Sig_/5EjrSN9onuu6.xHPmV+/Ees
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOg7J2G5fc6gV+Wb0RAl5lAJ0V9Lwo/8CG6GVrOYh35UymociHdwCfQcqY
ozyWkQDTHpq+gWn5+nUTMDI=
=BbHY
-----END PGP SIGNATURE-----

--Sig_/5EjrSN9onuu6.xHPmV+/Ees--
