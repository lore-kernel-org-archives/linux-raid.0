From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 with MBR and GPT fails to auto-assemble during boot  -
 repost
Date: Fri, 23 Sep 2011 14:22:32 +1000
Message-ID: <20110923142232.0fc906c2@notabene.brown>
References: <20110922215540.C2949581F83@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VI4A/7kq6C/cN4T6qfZ8+Kc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110922215540.C2949581F83@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VI4A/7kq6C/cN4T6qfZ8+Kc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 15:55:30 -0600 Jim Schatzman
<james.schatzman@futurelabusa.com> wrote:

> Why does Linux fail to auto-assemble /dev/md1 during boot and how do I fi=
x the problem?
>=20

1/ because in-kernel autodetect only works for MBR partitions - it doesn't
   work for GPT or anything else.

2/ don't use in-kernel autodetect.  Change the partition type for the one
   partition that is on MBR to something else and let mdadm find an assemble
   the array for you.  This should "just work" in most distros.

NeilBrown

--Sig_/VI4A/7kq6C/cN4T6qfZ8+Kc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfAmIG5fc6gV+Wb0RAp2wAJ9JKwqMv3awdg8bxsbuGr8coKlimQCfUvTv
iuoVRWY5B6oxFaxZzbZiQwc=
=LA88
-----END PGP SIGNATURE-----

--Sig_/VI4A/7kq6C/cN4T6qfZ8+Kc--
