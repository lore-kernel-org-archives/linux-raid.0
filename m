From: Neil Brown <neilb@suse.de>
Subject: Re: Bad raid0 bio too large problem
Date: Wed, 23 Sep 2015 12:25:45 +1000
Message-ID: <87k2rhyiqe.fsf@notabene.neil.brown.name>
References: <wrfjoagucvyq.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjoagucvyq.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Hi Neil,
>
> I think we have some bad side effects with this patch:
>
> commit 199dc6ed5179251fa6158a461499c24bdd99c836
> Author: NeilBrown <neilb@suse.com>
> Date:   Mon Aug 3 13:11:47 2015 +1000
>
>     md/raid0: update queue parameter in a safer location.
>=20=20=20=20=20
>     When a (e.g.) RAID5 array is reshaped to RAID0, the updating
>     of queue parameters (e.g. max number of sectors per bio) is
>     done in the wrong place.
>     It should be part of ->run, but it is actually part of ->takeover.
>     This means it happens before level_store() calls:
>=20=20=20=20=20
>         blk_set_stacking_limits(&mddev->queue->limits);
>=20=20=20=20=20
> Running the '03r0assem' test suite fills my kernel log with output like
> below. Yi Zhang also had issues where writes failed too.
>
> robably something we need to resolve for 4.2-final or revert the
> offending patch.
>
> Cheers,
> Jes
>
> md: bind<loop0>
> md: bind<loop1>
> md: bind<loop2>
> md/raid0:md2: md_size is 116736 sectors.
> md: RAID0 configuration for md2 - 1 zone
> md: zone0=3D[loop0/loop1/loop2]
>       zone-offset=3D         0KB, device-offset=3D         0KB, size=3D  =
   58368KB
>
> md2: detected capacity change from 0 to 59768832
> bio too big device loop0 (296 > 255)
> bio too big device loop0 (272 > 255)

1/ Why do you blame that particular patch?

2/ Where is that error message coming from?  I cannot find "bio too big"
  in the kernel (except in a comment).
  Commit: 54efd50bfd87 ("block: make generic_make_request handle arbitraril=
y sized bios")
  removed the only instance of the error message that I know of.

Which kernel exactly are you testing?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAg2pAAoJEDnsnt1WYoG5e/wP/2a7FddG5T/7Qs5OqjEy4m5B
6LdvR4VAbu+5dz1TDz0nYtH0CTYAww0bifbE0TU5bfF9znu3Er3ymp5wS0dZ6oPJ
RJCHVjmotmIbXxIKTlNMXsm4ueLAHd5Y96D5qIUz+3FdJ6kk3ADtJk52Y8voPjhr
C8FNmh0+7nnrM813RDT6E1cUdC24QclJ8ppZDjtTqthOoWiuvqjcqSUiWY44kug3
z401BBBTEqWyPBfvhG9EFUhsJ4gRmwQD6x0Q+10vHy+U2SilLJh1nCnjNMcshzX4
UbjhtrkyT78Hv5uk4Q3DtnrPC9DNXDpqdz0y5lWhHVrTZNvmQsP6ivRiNfJAG4aq
bdOdzLzF09SmAXVAXs7eD1ZjSUOZRUvHDm64o4p0T+ov/RdXrGPWwKkFYsn+Y0u8
KH38BKCMw8+9ZgGrghh34htceEYO2GO0qdIYZO6zuRTuGbR/g21yNKUUUeaNsTYy
Wqwdohr/ifi84Yyx5dgFNGntMoLIL4CuS0HZOxm10ZfaF76bI8TBRS+YsCQYWs7z
e1AEW4T1X39zCh4222UDqtIOLAsAttefFyPzKo7ChPGYaTc9vopHMNvFH9Gw0CXb
GEjjna6SE48vQ6WJCZCexRdSI3cyv9vcOQK2AiYlOVf/RKv277MGoLuXva9sME1O
mgmuOQbKe7HzmeFCnNny
=jLy7
-----END PGP SIGNATURE-----
--=-=-=--
