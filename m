From: NeilBrown <neilb@suse.de>
Subject: Re: Bug#658701: mdadm: should send email if mismatches are reported
 by a check
Date: Mon, 28 May 2012 11:41:30 +1000
Message-ID: <20120528114130.31b6c1db@notabene.brown>
References: <20120205123450.21371.88843.reportbug@xev>
	<4F2E90AD.3020405@msgid.tls.msk.ru>
	<4F872CED.7050809@msgid.tls.msk.ru>
	<4FC0EB0C.1080800@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X8rPIF4kHihl3x8=3LHPRF7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC0EB0C.1080800@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: 658701@bugs.debian.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/X8rPIF4kHihl3x8=3LHPRF7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 26 May 2012 18:39:08 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Neil, can you comment on the change to Monitor offered
> in the mentioned bugreport please?
>=20
> On 12.04.2012 23:28, Michael Tokarev wrote:
> > Neil, re http://bugs.debian.org/658701 , how do you think,
> > is it okay if mdadm --monitor will send email in case check
> > found mismatches, the same way it sends email about other
> > more critical errors?
> >=20
> > I think Russell has a good point here, but there's one more
> > source of mismatches we have in kernel - some "sporadic"
> > mismatches in raid1 and raid10, especially when these are
> > used as swap space...
> >=20
> > In Debian we've several bugreports already requesting more
> > attention to mismatch_cnt, see:
> >=20
> >  http://bugs.debian.org/658701 (this one)
> >  http://bugs.debian.org/599821
> >  http://bugs.debian.org/588516
> >=20
> > Thank you!
> >=20
> > /mjt

Sorry for not replying the first time :-(

I do not agree with the suggested change to mdadm.
A non-zero mismatch count may not be a problem.
It could be due to swap writing to a RAID1/RAID10.
It could also be due to a RAID1/RAID10/RAID6 having been
created with --assume-clean.  This is perfectly safe thing
to do but results in a non-zero mismatch_cnt.

mdadm --monitor will run a program on every event.  If someone
wants more events reported than currently are reported, they are
free to write a script to do whatever they like.

If md finds unreadable blocks and fixes them, then that certainly
might be interesting.  However that is interesting much more broadly than
just for md, and I believe 'smart' makes that information available.  So
having it reported from SMART would be more sensible.

In brief: mismatch_cnt maybe useful to someone who understands what is means
and is investigating some issues, but it is not something that should be
automatically reported to a casual sysadmin.

NeilBrown

--Sig_/X8rPIF4kHihl3x8=3LHPRF7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8LXyjnsnt1WYoG5AQIk/g/9FudU93wRxPgam/UUg4VTSMWjttUADDXs
4eEasVmcBemsvL7UIohGcFeiWQUC2HC3i+rteP1Eh46zUP9+Fvec830gg/wxRRxR
znwpNsoO0ZqmLP4OTNLPPVEPTONQsOXCMtETfXOVz8WZIYF4Xtj5g6wHyBt4CKWl
B93Ch9WtknhvA6oyDwCxdTWzUXrkzgJnIKDv4jgQZdliQzcdRR9Fv889N7QjIzzz
MUiYQhU4qwIPlZeDuAiz+Mt06je4GSja/IHhJqD4J2mJjJsPEmqR7qsnbUM21Pum
YEznTvZaYU7WGTdmavvOj3WLvYwMTWbY8bmQecvYeSUpwPbWN/lP21oGTG7MDY+5
5AZ3p8kbtz0R/WqU5VHNKNCo1AbJUrTSqmHoACcHw/vZOzK1Xg7QJ5By3/a4AgPF
xktNSSe6vyfFxzr6I+Ey/5Hc5RGUMLlOTp6Cdf99ewDjX1sXSGFc7NNhZFXMKn3K
vIChFIS1VeomrnXLIuiLkZ2n33HS6z7UjbovHgd3NmyKQ4Zl+AIFL/GE0hpjwram
wQ1h0Cqqi5WroxHoHvoAzn74psTG9hVWPUm68wwF8JlNF8JqnVNm1qXJwtbEOBKR
cnvf+WF1+gPfKATY1f/PkonO+QMFrhjMlDxzOtyX6Yc2AVajs+uzBvZOw2uotmlu
gP9KzKHOOGA=
=noKb
-----END PGP SIGNATURE-----

--Sig_/X8rPIF4kHihl3x8=3LHPRF7--
