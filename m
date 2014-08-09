From: NeilBrown <neilb@suse.de>
Subject: Re: Making spare device into active
Date: Sat, 9 Aug 2014 10:31:59 +1000
Message-ID: <20140809103159.338bef61@notabene.brown>
References: <CAAOsTSmkyCqLxrG-q2PQxnbXiAC1zz=qw6+ekMUmY=N+ZoHZ-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/b55AGtifXTGOdfO7fZMpRTP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmkyCqLxrG-q2PQxnbXiAC1zz=qw6+ekMUmY=N+ZoHZ-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?UTF-8?B?SG9ybsOtaw==?= <patrik@dsl.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/b55AGtifXTGOdfO7fZMpRTP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Aug 2014 19:25:24 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> Hello Neil,
>=20
> I am experiencing the problem with one RAID6 array.
>=20
> - I was running degraded array with 3 of 5 drives. When adding fourth
> HDD one of the drives reported read errors, later disconnected and
> then it was kicked out from array. (It was maybe doing of controller
> and not drive, not important.)
>=20
> - The array has internal intent bitmap. After the drive reconnected
> I've tried it to --re-add to array with 2 of 5 drives. I am not sure
> if that should work? But it did not, recovery got interrupted just
> after start and drive was marked as spare.

No, that is not expected to work.  RAID6 survives 2 device failures, not 3.
Once three have failed, the array has failed.  You have to stop it, and may=
be
put it back together.

>=20
> - Right now I want to assemble array to get data out of it. Is it
> possible to change "device role" field in device's superblock so it
> can be assembled? I I have --examine and --detail output from before
> the problem and so I know at which position the kicked drive belongs.

Best option is to assemble with --force.
If that works then you might have a bit of data corruption, but most of the
array should be fine.

If it fails, you probably need to carefully re-create the array with all the
right bits in the right places.  Maybe sure to create it degraded so that it
doesn't automatically resync, otherwise if you did something wrong you could
suddenly lose all hope.

But before you do any of that, you should make sure your drives and
controller are actually working.  Completely.
If any drive has any bad blocks, then get a replacement drive and copy
everything (maybe using ddrescue) from the failing drive to a good drive.

There is no way to just change arbitrary fields in the superblock, so you
cannot simply "set the device role".

Good luck.

NeilBrown


>=20
> - Changing device role field seems much safer way than recreating
> array with --assume-clean, because with recreating too much things can
> go wrong...
>=20
> Thanks.
>=20
> Patrik


--Sig_/b55AGtifXTGOdfO7fZMpRTP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+VsBTnsnt1WYoG5AQIR6g/8Cj+kycccE2iVSIXLuSxKclBgdrKA+e1S
HHBNoOpXLJT6rEbJMqU9wBYgQajfM8Y0twRdr9yYHTEIghfXWu47EO2zAGh+h5DR
gY+zxQvBPx7jvE9AhJTvnlqB+cMWTh6F3e8uWKNYo3YqgxQA6PIBI5yCFlHe3CbL
Bd9TQ3WEJePQ0ucvWgF0syfyW78YKUn2lpI+xUfg3ju8H/HhECF3U7eLi8VieNXL
bn5yx6+h/dp3a/xFhw+4y9fGe8HGdk1QSQobmGdIYWHWVyQDNFn3jzhJFEB04siA
2RMko0XfD+ZYc3RoXYmBiRKdO2jS4oonUHBUbefl3Q4SLRFnbO7+1tN8dClEsw7W
Yccsebk7piPM8YxYbLoONhTN6lQPPDF4HSs7bH7NuLnWR8U6pDlr1L0/SKPLn+A5
1v3fttFLrn9rKxS4d8d5XKsyGVg6W/7vyH+yDsM8ljuFZ7CcAomh+SgJf0ox0Vsh
rqUT90lrNP9ywcMCnhCe16Tv5JoSlLk93/eF8VW9a3qNyrk6f7Sj+nKJkE9w5SQx
W6yZ6wdU7v9cA0ZJRTMXJHoF4bEI6OxUQGIGtPgBnG+Ry/39HUUDBvi9Rt7003+9
fceJTwnoOgvTSHLu+5uMuK/yzKoLcOBwc7981CvbHPKoiFoUu3nhFhJxYCcj2p1Q
i2XtUiZraXs=
=V/HT
-----END PGP SIGNATURE-----

--Sig_/b55AGtifXTGOdfO7fZMpRTP--
