From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 22:13:00 +0600
Message-ID: <20100617221300.3e30afe0@natsu>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
	<20100617100109.32a20ffa@natsu>
	<d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kcciBl00dTEOE2l.fd7xYET"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kcciBl00dTEOE2l.fd7xYET
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jun 2010 09:49:42 -0400
aragonx@dcsnow.com wrote:

> Prior to the change above, on a 2GB file, I would start off the write (to
> the server) at 70MB/sec and end at about 35MB/sec.  CPU usage was at 100%
> with the md0 using about 70% CPU and smb using 30% with flush sometimes
> jumping in at 30%.  Wait states remained below 10%.  After the change, on
> a 2GB file I would start the write at 70MB/sec and end about 55MB/sec
> (nice improvement!).

A more consistent way to test would be to cd into a directory on the array,
and repeatedly run something like:

dd if=3D/dev/zero of=3Dzerofile bs=3D1M count=3D2048 conv=3Dfdatasync,notru=
nc

...and implement various tweaks you are trying out between the runs, to see
their effect.

Also, the reason you see the write speed dropping off in the end, is because
your server first fills up its write cache almost at the maximum
attainable sender's (and network) speed, then, as the space in RAM for that
cache runs out, starts flushing it to disk, reducing the rate at which it
receives new data from the network. So you see that the 70 MB/sec figure is
totally unrelated to the RAID's performance. The dd test described above,
thanks to these "conv" flags (see the dd man page) will have much more sense
as a benchmark.

--=20
With respect,
Roman

--Sig_/kcciBl00dTEOE2l.fd7xYET
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwaSYwACgkQTLKSvz+PZwiwWQCfb1GCD8fV3SI1LVD+CP6ayV0B
yX4An061lNpWw5TgMJVMvJSCsF9/TekF
=OSe4
-----END PGP SIGNATURE-----

--Sig_/kcciBl00dTEOE2l.fd7xYET--
