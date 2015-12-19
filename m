From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: RAID6 - whole disk vs partitions
Date: Sun, 20 Dec 2015 09:21:33 +1100
Message-ID: <5675D86D.3000403@crc.id.au>
References: <56756AF1.7050005@crc.id.au> <5675BFBE.5060604@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pJKm6VcvRrJU2eVcO6s62Q4LkbUQEInoe"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5675BFBE.5060604@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pJKm6VcvRrJU2eVcO6s62Q4LkbUQEInoe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 20/12/15 07:36, Phil Turmel wrote:
> Hi Steven,
>=20
> On 12/19/2015 09:34 AM, Steven Haigh wrote:
>=20
>> I've always used the whole disk for the RAID6 - as from what I
>> understand, this gives the best layout for various drives - no matter =
if
>> they're 512 or 4096 byte sectors.
>>
>> Is this still the case?
>=20
> There's no real advantage other than an itty bit of space.  If my case
> was too small to have a separate mirror for my OS, I'd make three
> partitions on everything for boot, LVM root & etc (raid10), and bulk
> storage (raid6).  When I have room for the mirrored OS (boot & LVM), I
> use whole disks for the bulk storage.

Yes, I have two separate disks in RAID1 as the boot / VM guests - the
RAID6 is used for bulk storage. The chassis has a total of 10 hot swap
bays, with 5 used by the RAID6, 2 by the RAID1 and 3 spare. I get resync
speeds of around 170Mb/sec on the RAID1.

>> I've noticed that my resync speeds on this RAID6 hover around 60Mb/sec=
 -
>> which I was expecting to be a bit quicker (although I haven't tested
>> speeds on this array for years).
>=20
> Consider using small chunk sizes for parity raid if there's even the
> slightest random access usage.  See the list archives for the past
> couple weeks for a long thread on performance.  There's many
> optimization possibilities.

I have tried to keep up with those couple of threads - but I've found it
hard to follow across the length of time they've been going. A summary
of the findings in those threads with experimentation would be fantastic!=


It seems that actual data beyond "increase --setra on /dev/sd[.] and
increase the stripe_cache_size is about all I find via Google - and that
data is years old...

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--pJKm6VcvRrJU2eVcO6s62Q4LkbUQEInoe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWddhxAAoJEEGvNdV6fTHc6dAQAKD3IKKtJMr6bMb2zntjmrKp
VSjjg/6lRf3TBgyA6GQrWKTYS17vNnW23RJIlePYso489yQNcCta4Iqvgk6mSgVu
O2WPAn9+xTllaZcjIUlVnVv402URlmJorqNPUol76FHn4Njk9Kcwkwqy9fzk+r19
smNp7XSIibp9M8idsUMwQe73ylKR566JO0LfyqsTDxMEU/zW7AccUare9iFVBA0t
KSrWiUp7F1uZ4QRtqmws7DOPfQrHGEXg5bOdynt+Ms//ck+/8Mi+secSx3kfdPsW
3IzSQ5WgyVrxk23FHQ26xhv+AKrxJM+SLQfX4V+vRoCNBsmE8Xp1DO9bbDjXUG+t
7z2if0CsnBwpwVpkBuOzSxn6/eDWchCbniwNJZzh5m2D3OlT6UidkEwgQTLon0on
2cwcAgMrSL1NPo/OnCR8Na1+o5vAjt1a+gRybcXJyuf1df/004k1Ta3sG5ynkzj4
gtCO4XQQ+jOubb9VAcqYTXCfXqvt6opZzYAAbdJIa9s7UpUYEFXpP86UEZhCmuX5
ZhS+F33FbIdoJSoR74Dygm+XXoQzES7fgMTEVVFWAaPM2gCzeWyh7ujoV7kDvSXK
0abhO51/RUyIG0snYgqcwlTqBSUiesqtB51HDljkZ6YZdvzH84I+mUL96Ihgan1S
YmLOnlQfHUFbS8loB/+Q
=ilHx
-----END PGP SIGNATURE-----

--pJKm6VcvRrJU2eVcO6s62Q4LkbUQEInoe--
