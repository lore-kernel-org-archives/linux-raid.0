From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Thu, 25 May 2017 11:31:52 +1000
Message-ID: <874lw9iuwn.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk> <87poezhwsa.fsf@notabene.neil.brown.name> <87bmqio03i.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmqio03i.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, May 24 2017, Nix wrote:
>
> (I'm not sure what to do if it *works* -- how do I test any later
> changes? I might reshape back to RAID-5 + spare again just so I can test
> later stuff, but that would take ages: the array is over 14TiB...)
>

If it works (which it did), then we'll have enough understanding that it
should be easy to simulate the problem accurately in a VM.
I don't think there is any need for you to experiment further on your
data.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkmNAkACgkQOeye3VZi
gblCpA//ezJVgzq9VYX1ZOriZgeBs3i8NknGCjTtJejZ1N2F9TMRljzmwOjkm4Fo
mpZBWkr0Zl95maXyhaZlCMpnHT22GcuXETN5L2zCShbpHDryuDt2CI0nXdqT4rJ2
SgAaA5MwBWUwjEkaVY0WRv1AYN2l+S7G8XuMKcwRk9ecyI9DeS7EKqJhXDGRH6yZ
9jltib3GRxgR6i+ahdLZ+uberA/rRi6KyVt4NcqlkfG/9U/T9SmuCF35o3VP+zG+
kTijjxm0ObyK7rG3NXNM+MYWklPvot9O/TXCagG/VR/0whbA/5etrVEyIbuxjgoG
bfuaDMRAgl4A3ug6ZPjsIC/LsR3VbUwYaDGoucdJ/WwecGn3+4SXdJpzESjVioI7
hUxvRiBGUMLonU+NnPUXKIOsADyCrYia3X8tza4fXjf7Zt9CdS2QS59fSK6+adc1
fI7oqgWPM5a+zeEh+Xx7EqtgrlGaKLnIXIV0aMcgaBFOccGYRyrdP+HUuARLbBMD
uGh2RQEaIcPVwxC8vN2mm7JOYmHWVtdWnEFrBwU/ypuHHuyQA7Vr7xSbTcuRfeB2
HpVFR5YygS1OSSGSw4OjuR2VJ9zDZ6/JcyA+Id/uJcGBQfTHjo+0UmBueMlHeC/r
ExNFr2DC/BqEH6oJ2vLhbgvhzRljQ2WKVDnn7XgUHk0A7mvlyUE=
=B7vn
-----END PGP SIGNATURE-----
--=-=-=--
