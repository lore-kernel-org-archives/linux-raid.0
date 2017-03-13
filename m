From: NeilBrown <neilb@suse.com>
Subject: Re: LSI RAID
Date: Tue, 14 Mar 2017 08:38:38 +1100
Message-ID: <87o9x4eu1t.fsf@notabene.neil.brown.name>
References: <CAJH6TXj+766Xj4w8BAOoq9wQ_Vym_JD66pbqRgpXriNguG6zTQ@mail.gmail.com> <CAJH6TXhwfoWKM2=0v0+qhUWp=WppF5qO7zm5Y1-vS4zWQHA5WA@mail.gmail.com> <73fdfb90-4bdc-a452-d785-eb270ad987e2@suse.de> <CAJH6TXhYDMP_Xm+nZyoGBfAR77_W4h18_3bdTKeymEKYpUu-bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhYDMP_Xm+nZyoGBfAR77_W4h18_3bdTKeymEKYpUu-bw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Feb 28 2017, Gandalf Corvotempesta wrote:

> 2017-02-28 10:06 GMT+01:00 Hannes Reinecke <hare@suse.de>:
>> Sure.
>> The recent mdadm should be able to create DDF metadata.
>
> This means that i'll be able to import a configuration created with a
> LSI MegaRaid controller and use them with mdadm ?
> If yes, how ?

Try it and see.
i.e. plug the devices into a Linux box with mdadm installed, and see
what happens.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljHEV4ACgkQOeye3VZi
gbmf4Q/+Mgq8bQyRi3qhH+Nj3tnnamw/Ml2Sys8Gzh+rpM+CZO/FfpUkUjzttDtV
Es26mBbus7BdE/jKtaYRsfKAYfU1mJKIszefGH2kUlJhLOPOVdeOiZNJpzuo/k2e
PknnH7UUqWxOFI+6nvv1atl4ktUHjlGuakxG3bsiflYYEpbYNZ6z+bKnqzaZSCeV
jsGMNsQnRgHQBNQS0uZQjkbQlHqd+x95yvSYJC5UbanZz89xQ79qUsi+7v2ALFTN
iMaTPpYGGPZMaLTIIuY+qByTZQ9hsWJR9S/iY5Fgj2kAbuDmKr0wPOcb80BpzvDL
e0lLrXbtzBKoGP67OkcIFJtmPuDFUTgBm0wUFMK6n/ycYvhCm/sAe2PLKurXXNWb
8y0QNdHrsZBslU8AV4DXfnwwfKXnSPysqEpU6/Y//3Um4OeU50m2vrmSo+JO52tE
yOewMZm6FjEyxPZKaH7ZOUT8/uYyYyGf6CBwI5UOQTlYORBDg2aSyZd2C0O1LAYF
JhdLqTVtH9N2Pi8EN77TY6vu8laVgtihcdXJsS2JJIwx0SODmmgX8UUIK3+bjmFu
PN2XEQot0KqdN6CuOK3XREaQ/JgPcuxyZeQXtLYZWiR5lm7H/YRjFbxYWIAx/sgF
Vl6kzY+dpkD3s/HAr5HHtz3wiR3Fotbi9IWHk9nKpgSaJFXKsuQ=
=HFL9
-----END PGP SIGNATURE-----
--=-=-=--
