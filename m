From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Debugging a strange array corruption
Date: Tue, 14 Dec 2010 14:42:31 +0500
Message-ID: <20101214144231.0493d534@natsu>
References: <4D07265F.8060109@wasp.net.au>
	<20101214142246.20c927e1@natsu>
	<4D073AF1.7090709@wasp.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S4tV7k4fTWJShj0goxlNmDg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D073AF1.7090709@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/S4tV7k4fTWJShj0goxlNmDg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Dec 2010 17:37:53 +0800
Brad Campbell <brad@wasp.net.au> wrote:

> And in the prior incarnation I was only using 1 port on that controller so
> the problem would never have manifested itself. Thanks, at least I have
> something to try.

To add another idea to my previous reply, it should be pretty easy to test =
for
the presence of this particular problem by running your dd+md5sum test on j=
ust
the two physical disks which are plugged into that controller, starting the
tests simultaneously on both disks (in two terminal windows). See if you get
varying sums over several runs that way.


--=20
With respect,
Roman

--Sig_/S4tV7k4fTWJShj0goxlNmDg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0HPAcACgkQTLKSvz+PZwgw1gCbB8TG9PgTDYkcEr8sjBVNYBFH
ZIMAn3rf6PkgF/qXJgoefkhPbG5JvZRN
=t9uM
-----END PGP SIGNATURE-----

--Sig_/S4tV7k4fTWJShj0goxlNmDg--
