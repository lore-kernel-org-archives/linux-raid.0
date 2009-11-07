From: Doug Ledford <dledford@redhat.com>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 17:58:55 -0500
Message-ID: <4AF5FBAF.3080603@redhat.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <4AF5F277.4040309@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAAAA6477303E3B66ED5F1011"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF5F277.4040309@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAAAA6477303E3B66ED5F1011
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/07/2009 05:19 PM, Eyal Lebedinsky wrote:
> Doug Ledford wrote:
> [trim]
>> And actually, with 1TB drives, your most likely culprit for this is th=
e
>> last item I just listed: reallocated drive sectors.
> [trim]
>=20
> I did say "smart shows no issues with the disks". This means, naturally=
, no
> reallocated count/events on any of the 5 drives.
>=20

Sorry, overlooked that (or thought it was just that it passed the self
test...wasn't sure that it specifically meant reallocated sector count
was 0.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigAAAA6477303E3B66ED5F1011
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr1+68ACgkQg6WylM+/8ZRVJwCfYBvU2nbtgT7ENLUGyq6uA6EV
cpAAn3l0pxipxb/3jsAKfQ71rLfRpjum
=IbjN
-----END PGP SIGNATURE-----

--------------enigAAAA6477303E3B66ED5F1011--
