From: Neil Brown <neilb@suse.com>
Subject: Re: Problem w/ commit ac8fa4196d20 on older, slower hardware
Date: Fri, 09 Oct 2015 11:13:03 +1100
Message-ID: <87twq0527k.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Kinard <kumba@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Per commit ac8fa4196d20:
>=20
> > md: allow resync to go faster when there is competing IO.
> >=20
> > When md notices non-sync IO happening while it is trying to resync (or
> > reshape or recover) it slows down to the set minimum.
> >=20
> > The default minimum might have made sense many years ago but the drives=
 have
> > become faster. Changing the default to match the times isn't really a l=
ong
> > term solution.
>=20
> This holds true for modern hardware, but this commit is causing problems =
on
> older hardware, like SGI MIPS platforms, that use mdraid.  Namely, while =
trying
> to chase down an unrelated hardlock bug on an Onyx2, one of the arrays go=
t out
> of sync, so on the next reboot, mdraid's attempt to resync at full speed
> absolutely murdered interactivity.  It took close to 30mins for the syste=
m to
> finally reach the login prompt.
>=20
> Revert this patch was working to mitigate the problem at first, but it ap=
pears
> that in recent kernels, this is no longer the case, and reverting this co=
mmit
> has no noticeable effect anymore.  I assume I'd have to hunt down newer c=
ommits
> to revert, but it's probably saner to just highlight the problem and test=
 any
> proposed solutions.
>=20
> Is there some way to resolve this in such a way that old hardware maintai=
ns
> some level of interactivity during a resync, but that won't inconvenience=
 the
> more modern systems?
>=20
> http://git.linux-mips.org/cgit/ralf/linux.git/commit/?id=3Dac8fa4196d20
>=20
> Thanks!,
>

Hmmm... this change shouldn't have that effect.
It should allow resync to soak up a bit more of the idle time, but when
there is any other IO, resync should still back off.

I wonder if there is some other change which has confused the event
counting for the particular hardware you are using.

How did you identify this commit as a possible cause?

The fact that reverting it no longer helps strongly suggests that some
other change is implicated.  I don't think there have been other changes
in md which could affect this.

Have you tried adjusting /proc/sys/dev/raid/speed_limit_m{ax,in} ??
Did that have any noticeable effect?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFwaPAAoJEDnsnt1WYoG5g/EQAK4+0wA6D2NS+GAncTEUDaz5
ZVpR0STkK8Ap2hx1jKTeFJaV6SAIgoTfrQlQvo2eLswFedgmqT4YigZXLB+C5MWq
2KOj6OIZYsjyt89RdFiJrfSinyUFpG4PulinC1YNx5hBcd3+DXNutRx4Zo2W7FR+
tE5V/iBtcsPe10ZU+aMUDoiNbDlf6iCsJO7uJLbMKOhUFQ5aU7y0wfWJwCnmkD3m
UlEWvcvkWZnfLsjuP88/LEbZMeN/Yo3T6sfn9LBDY38NdqJBC+nYp6dVugpJ6wAj
CTTWRgL+OWYb5dv51vQUaabD7L/QOXh59VsxYn4p+alfesN9s13DXYTFdLi8n3Aq
gpmt9kwKHM8/Qm1OurU4N8hpdEbOOmRYABTxB8e/PCNMDEey2ZO0UtVBCa++y+K+
ux6gDL8sqYvNXUnPQiG1q9j3HAbMSNatHl/gzNkM45hOTunPiLQXg/+KZex1OlGu
hx9ZD6f8vR6JTAE8jkQ87hS8Z3qpKk02cq6+yk7XnjGmUuAmej10NCG9IUGkG25h
fZD0reGlAIi2UCS2XMhNh/SuxJ/H+3FLVQt+xYgqXyBMqEFIILH6TQ7orvmsIN0F
Ys09I8VSmvs+vjUSg67yb4eGR8N9aa49raGKsVUn6dKHRo6pYCJUI/R2aJF4hG0h
fRWRxEEymXsi3F5EfFMe
=vXnR
-----END PGP SIGNATURE-----
--=-=-=--
