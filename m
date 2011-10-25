From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm r/w operations without TEMP_FAILURE_RETRY()
Date: Wed, 26 Oct 2011 08:28:43 +1100
Message-ID: <20111026082843.7087a263@notabene.brown>
References: <2AC2FDB9F3686F48962B2B65E2040CCC3D155FA0@irsmsx503.ger.corp.intel.com>
	<20111018203016.4536708f@notabene.brown>
	<4EA6F210.7040701@ziu.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f_+x2Vs2Oal=mht1OpMlsDy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EA6F210.7040701@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: "Orlowski, Lukasz" <lukasz.orlowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/f_+x2Vs2Oal=mht1OpMlsDy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Oct 2011 19:29:52 +0200 Michal Soltys <soltys@ziu.info> wrote:

> On 11-10-18 11:30, NeilBrown wrote:
> > On Tue, 18 Oct 2011 10:16:41 +0100 "Orlowski, Lukasz"
> > <lukasz.orlowski@intel.com>  wrote:
> >
> >> Hi,
> >>
> >> I was going through mdadm code and got to realize that r/w
> >> operations are invoked without TEMP_FAILURE_RETRY() macro, which
> >> protects from unexpected operation termination, case SIGINT is
> >> thrown. According to my knowledge its POSIX best-practice to call
> >> the r/w operations within that macro, lest some sporadic unexpected
> >> behaviors occur.
> >>
> >> Any particular reason for not using it?
> >
> > I've never heard of TEMP_FAILURE_RETRY.
> >
> > And having looked in to it I would certainly try to avoid using it.
> >
>=20
> As this grabbed my attention ..
>=20
> that macro is just a shortcut to something along the:
>=20
> do {
> 	ret =3D read/write/etc.( ... );
> } while (ret < 0 && errno =3D=3D EINTR);
>=20
> which has always been the proper way to handle such situations=20
> (recollecting Stevens books, glibc reference manual, or any other solid=20
> source). Why avoid using it ? Costs nothing, and guarantees we won't run=
=20
> into some corner case.

It is ugly and often unnecessary.
Ugliness without virtue is a real cost.


>=20
> > If the SA_RESTART flag is set with sigaction() then it should be
> > totally unnecessary.
> >
>=20
> signals(7) has pretty large list of when it can or cannot happen, and
> when it will always happen regardless of SA_RESTART. And it would be=20
> quite different list when other unix vendors are considered (which=20
> doesn't of course apply to mdadm case, it being only linux specific).=20
> There're also not ignorable stop signals (and under some cases they will=
=20
> end with EINTR as well).
>=20
> And it's not only SIGINT (as the original mail could suggest), any not=20
> ignored signal can cause it.

Yes, SA_RESTART isn't really a panacea.  SIGSTOP cannot be ignored or block=
ed
and can have the same effect.

However this only affects system calls that can block (in an interruptible
'S' state, not a non-interruptible 'D' state), and then only if they cannot
complete without returning a valid partial result.

There are very few places where mdadm makes such a system calls.

Some of the ioctl calls on md devices technically behave like this, but are
very unlikely to block in practise and if they do then I probably want them
to fail.

The 'select' calls in msg.c probably should check for EINTR and try again,
but in that case there is already an error check and a loop and I would just
add
  if (rv < 0 && errno =3D=3D EINTR)
	continue;

rather than add the macro.

So it is certainly worth auditing the code for places where EINTR might be
returned (and being careful in the first place), but blindly applying
TEMP_FAILURE_RETRY() is (in my opinion) wrong.
In a well written program I would expect any place which might return EINTR
to be a place which could also return other errors that suggest a retry is
needed, and the EINTR checking should  just be included with the other
checking.

NeilBrown

--Sig_/f_+x2Vs2Oal=mht1OpMlsDy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqcqCznsnt1WYoG5AQKFMQ//YTsN6Zj/LtVMiOg99NI/E0Zlr4zvk4r0
b+2LBVbqy2fGu9rQC0zfB6rFJomFUKHHw4AZIBSVZr9voCunwiB2Y3DLoSLn2ZUh
5blbQwhCBHUOv1c0S0obeICUrv2YNn9tclRRNu7oRqFAoq2FPZ352Uf3ZCgjro2P
mBEwRJgLBuV3zPv2TmsgTjPqJhO3+Ww1mtoMwm5CUxfSzPgrxDvnNakNppGY4dqK
uRFWeTm8O17+iJmrsWkZvbkCJUSetlOjmSR7jNYI9F0Siu4nhvd517rT4ZkPd40Y
doR4Oz4higdEpXaGyJbFmyuWmh5R6JUbonz7SL7zZa6yZahbSc221ADA0H9gwPyx
cRVpL7SRKu0A2g1FueC6ZlfWbsCBOmSTAXGBEnemyVFjEShaHE08Q5S/riaGWitJ
fqHH25c+jbDSldN/zngYysYQxaa2pnuJAuU1AtIIO9mhY/TKmGbNs05sUydzaLD+
6fBqKEqUfBNP2on6VAT3RBLYhGpjf6ylULQvrY/ijg+Aw/YSedjk3jHfZynglct3
MyQRzgPBOiDpOUA9vzAELmpuyBY/daEyE2wV/fa1KJhz+LS7tziNsvqLY5GKmuT5
3AsO9bSrF+BXKGoyrezg1/E1Jk482hOVDefx62PqmYGeLbjdFQ64Ucopt5bg5bOF
koyZCAqo190=
=oULj
-----END PGP SIGNATURE-----

--Sig_/f_+x2Vs2Oal=mht1OpMlsDy--
