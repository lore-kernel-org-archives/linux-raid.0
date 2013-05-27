From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mdadm vs zfs for home server?
Date: Tue, 28 May 2013 01:20:13 +0600
Message-ID: <20130528012013.2d428584@natsu>
References: <20130527180912.GA6068@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//1Bwot/vPJse6ySw6GnMVdr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130527180912.GA6068@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//1Bwot/vPJse6ySw6GnMVdr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 May 2013 13:09:12 -0500
Matt Garman <matthew.garman@gmail.com> wrote:

> the way to go.  I don't know how necessary it is, but I like the
> idea of having the in-filesystem checksums to prevent "silent" data
> corruption.

On some machines I run btrfs on top of MD RAID. In this configuration btrfs
can't heal checksum errors, but will still detect them if they appear.

btrfs now also has built-in RAID5 and RAID6 which *can* heal errors, but
that's still way too immature for being actually used. In fact one may
consider btrfs as a whole to be not mature enough yet, but in my experience
without using fancy cutting edge features like RAID it generally works, and=
 I
don't remember seeing mailing list reports of any data loss or corruption f=
rom
anyone in a long time.

--=20
With respect,
Roman

--Sig_//1Bwot/vPJse6ySw6GnMVdr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGjse0ACgkQTLKSvz+PZwjtpwCfcdEapcCYTpqH2mAf1l8wYdzP
TU8An0NtbKrq3XjSWzDRO5LhH3mz7EDR
=1S0u
-----END PGP SIGNATURE-----

--Sig_//1Bwot/vPJse6ySw6GnMVdr--
