From: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Subject: Re: Help with data recovery - RAID6 with 2 failed drives and another
  with broken sectors
Date: Tue, 01 Oct 2013 21:24:08 +0200
Message-ID: <524B2158.2020900@sawicz.net>
References: <524A07DC.1040002@sawicz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9Vl4p42jDVDE1iBpkBIp0aOrH2Lvxl0ET"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <524A07DC.1040002@sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9Vl4p42jDVDE1iBpkBIp0aOrH2Lvxl0ET
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01.10.2013 01:23, Micha=C5=82 Sawicz wrote:
> So the nightmare came for me - I've a 7x2TB setup under RAID6, and one
> of the drives started showing uncorrectable sectors a few days ago, but=

> I didn't yet have time to address that. I had two-disk redundancy, afte=
r
> all...
>=20
> Soon thereafter the cables / controller spew a slew of errors and the
> array was stopped. A --force --assemble later it was back up, rebuildin=
g
> onto 2 spares - I was left with no redundancy. If only the bad sectors
> drive was one of those two, everything would be fine. Unfortunately
> that's not the case, so I'm now left with an array with read errors. So=

> it fails during rebuild due to those.
>=20
> What I'd like to do first is to make sure the array rebuilds onto the 6=

> healthy drives, regardless of the bad blocks, I can probably recover th=
e
> data (assuming I can find out which files were affected - any
> pointers?), but if the array doesn't rebuild correctly, I'm afraid it's=

> gonna get worse, and soon.

OK, so a ddrescue and --zero-superblock later my array is rebuilding
onto one healthy spare. According to ddrescue I only lost some 8kB of
data in more or less one chunk, so after the array is rebuilt my next
task will be finding which file(s) that was.

--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>


--9Vl4p42jDVDE1iBpkBIp0aOrH2Lvxl0ET
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSSyFYAAoJEGnv7NPGHSZFPWUQANnvGIW+uap3xhZQPcS9oOhU
qeV8nu71CqE5Q2WaSk/EMDnHg5NPANGBfaCT65+XIOlUK2LWut00GOZ02n29gy93
tkaHCcUuETQB+fC4j9QCF/fe5RcET6eLoze0N+qTi2Md2lbezMY2kwAJyDKMdKrb
23UIoobIZ2ERGraAGIuVfcXKsXQxGDqt0+t44FhHHU6XB47pQzb5pJCUozf6T2NJ
/XKWRQs28PkNfHhC4fPhPgMIxHk6JM/R2YddG0P1PCTkOKZb7se26TK3v4YM9Lho
R8R8QUBfjTnyzQz7Ht9GHHVYrYdm3JNP0vNpJdwsHma7Ka0gOZk7SoSfWt7XV+fR
HfmbhKhoVbLjwwMEyRk1fEqBMhcuaWsAXczzZlY3aEGGooMt1j9cFjJANBrV55In
GF75YSxUtEUJtB7JgAY374QYKwryr41urZHSbleHMNfLtveaj54pxgBNvjTG9zgd
khv+FH6BAMSJLMu1hI5/xqsGTKoZ40/XsBPGyByKOHQpHCfS93MjcgnHAqL16lv5
QiN9QhyhVuE6lCXbbtJ1xPFAnubSOmVmA6dPdEFog9QZbEDyLeDyVVsviS0UVL4B
ZJQOkUxI8OnqxKXqapVoFseCAp5qSP4KLm2sUerL0jOlBIP4OYjuEi1HxAqXC+ko
wMdA6oyk1RBth0I0Vo81
=ySAa
-----END PGP SIGNATURE-----

--9Vl4p42jDVDE1iBpkBIp0aOrH2Lvxl0ET--
