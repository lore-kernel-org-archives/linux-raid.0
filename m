From: Andy Smith <andy@strugglers.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 16:23:37 +0000
Message-ID: <20050105162337.GL99565@caffreys.strugglers.net>
References: <200501051517.j05FHv925754@www.watkins-home.com> <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aWh+LmBTmEUMKd3g"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--aWh+LmBTmEUMKd3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2005 at 07:33:55AM -0800, Alvin Oga wrote:
> On Wed, 5 Jan 2005, Guy wrote:
>=20
> > I agree, but for a different reason.  Your reason is new to me.
> ..
> > Loosing the swap disk would kill the system.
>=20
> if one is using swap space ... i'd add more memory .. before i'd use raid
> 	- swap is too slow and as you folks point out, it could die
> 	due to (unlikely) bad disk sectors in swap area

This again is besides the point.  As I said already swap is part of
your virtual memory and if you can't keep it available you should
not be using it.  It is the same as saying that your machine will
die if half its RAM suddenly ceased to exist while it was running.

Your recommendations so far have been "don't run processes which
might swap" and "don't let swap be used".  If you yourself are able
to keep to both of these 100% of the time may I ask why you yourself
have any swap at all?

ometimes) or those of us in the real world where swap is desirable
and may (sometimes) be used, a swap device failure *will* *take*
*the* *machine* *down*.

--aWh+LmBTmEUMKd3g
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB3BSJIJm2TL8VSQsRAnBLAJ4poYvjd015R/dgVmU53RMRsExoCgCg+cgD
kIn6c47kaisFd8wf5idSQw8=
=JkWA
-----END PGP SIGNATURE-----

--aWh+LmBTmEUMKd3g--
