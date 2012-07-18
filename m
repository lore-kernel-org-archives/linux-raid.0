From: NeilBrown <neilb@suse.de>
Subject: Re: Catching a RAID error in a process
Date: Thu, 19 Jul 2012 09:00:45 +1000
Message-ID: <20120719090045.361edaef@notabene.brown>
References: <50071D3B.3090309@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HoZ=JQpi=o+E9w=ym.oHX1o"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50071D3B.3090309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/HoZ=JQpi=o+E9w=ym.oHX1o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jul 2012 16:31:55 -0400 Bill Davidsen <davidsen@tmr.com> wrote:

> Can someone point me to the docs to have a process run or notified when a=
 RAID=20
> event triggers? I've been playing with some recovery ideas, but polling s=
tates=20
> and status is not the proper way to do this, and I want to test with a us=
er=20
> program before I start putting patches in the kernel.
>=20

I guess you don't mean "run mdadm --monitor --program /bin/myscript" ??

Do you want "just any event" or some specific set of events?

See mdstat_wait in mdstat.c in the mdadm sources.  It waits for any event by
using 'select' on /proc/mdstat.

void mdstat_wait(int seconds)
{
	fd_set fds;
	struct timeval tm;
	int maxfd =3D 0;
	FD_ZERO(&fds);
	if (mdstat_fd >=3D 0) {
		FD_SET(mdstat_fd, &fds);
		maxfd =3D mdstat_fd;
	}
	tm.tv_sec =3D seconds;
	tm.tv_usec =3D 0;
	select(maxfd + 1, NULL, NULL, &fds, &tm);
}


mdstat_fd is a global variable=20
    mdstat_fd =3D open("/proc/mdstat", O_RDONLY);

NeilBrown

--Sig_/HoZ=JQpi=o+E9w=ym.oHX1o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAdAHTnsnt1WYoG5AQI5Cg/+L0KxrlRrnJHUzGytDxHPNibWLQhtJF5u
J418P29+2H8CuAazRxJW9nsCBpsGqkWSfOUQ0e0hDJMw4eCrO4iHBfanpiCDa/k/
5eEzcf3lxzvA7zPyofSMKtwOm0Nm9/5ffi24LToLezSYEQ9F4cPY5wwS2PqezHPn
mTwFUh+Wppmxix+kYGtMl0yhmZfsHGFFbW9lPgsPMW0nHBntHZZ0jkjWeF/M/+6W
RswpaqDKfthh/3ITGLL4BYIDCXbOHoz544H68dcYPGlJqaIYESal/X6BbbXxbK4f
GvLl/jgtpXsFubs2TDIPk5g7h7P0FYAiiuzDdlP8959qapnp2n2GMYt3ZhNlUD6T
QcPFRe/4LMPzJqQOCzVe1USB6wVUMb4R3UedxSkCFvcyVv2qN0Hyr+LIW7fDY+7+
ppJRXWV2ux2mbIv19lu2tsPtfqSVyVFo+7Z25rffQhvFaClu1bTreTmBJtvsyfiu
hSESEqFP2NKGoZtE0o0+O26Irs3Z2h9FkAqnUPCz9lmvgxmtMMRp/BeUBjxE4wh9
OzLpsnPazVFANut0aUrkupYgNaQEl9i3deC47ubyL4kdezxaS1wIN++S0R/qFvyg
FLw0mEDrhAZQtn6SMPKsU8MzEsKh4jv0zxy18pZigBS/9RZg0naaZ4dFtcFThZDL
fZgYfLjkO44=
=vIKh
-----END PGP SIGNATURE-----

--Sig_/HoZ=JQpi=o+E9w=ym.oHX1o--
