From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Cancelling not pausing array check
Date: Mon, 6 Oct 2014 14:36:42 +0100
Message-ID: <20141006133641.GA1928@cthulhu.home.robinhill.me.uk>
References: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Horn=EDk?= <patrik@dsl.sk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Oct 06, 2014 at 03:29:13PM +0200, Patrik Horn=EDk wrote:

> Hello,
>=20
> is it possible to cancel RAID 6 array check? echo check >
> /sys/block/mdX/md/sync_action apparently only pauses it and next check
> continuing from saved position. (I guess /sys/block/mdX/md/sync_min)
>=20
> I want to achieve two things:
>=20
> - Start check from the start of the array.
>=20
> - Be sure I can shutdown array without any ill effect because check
> was interrupted.
>=20
> I guess that position will be cleared when array is stopped and
> started again, but I dont want to guess and experiment... :)
>=20
> Thanks.
>=20
> Best regards,
>=20
> Patrik

You'd echo idle to the sync_action to pause/stop the check. If you want
to restart from the beginning next time, just echo 0 to sync_min
(similarly, if you just want to check/repair a specific range then set
sync_min and sync_max before the check/repair).

Cheers,
    Robin
position.

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQymukACgkQShxCyD40xBIMwACdEcljq/MJ/+GAX8PxcGJzpjRt
BiYAoKsiMvrrlSjbzLBD5AeWEZ2HYWto
=2ITn
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
