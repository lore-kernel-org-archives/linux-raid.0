From: John Crisp <jcrisp@safeandsoundit.co.uk>
Subject: Re: Raid 6 recovery
Date: Fri, 3 Nov 2017 11:44:44 +0100
Message-ID: <778940c7-cd7c-bda7-4db6-1e1b605a9557@safeandsoundit.co.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
 <59F8BCE9.1070607@youngman.org.uk> <59FBAE95.6010206@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bini0GiOIOtlFBFCO1tK7VmPmglVGumOC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59FBAE95.6010206@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bini0GiOIOtlFBFCO1tK7VmPmglVGumOC
Content-Type: multipart/mixed; boundary="5aGbPBkgW6G8Gr9dABCJnQ6dlveIEiVIK";
 protected-headers="v1"
From: John Crisp <jcrisp@safeandsoundit.co.uk>
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
 Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
Message-ID: <778940c7-cd7c-bda7-4db6-1e1b605a9557@safeandsoundit.co.uk>
Subject: Re: Raid 6 recovery
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
 <59F8BCE9.1070607@youngman.org.uk> <59FBAE95.6010206@youngman.org.uk>
In-Reply-To: <59FBAE95.6010206@youngman.org.uk>

--5aGbPBkgW6G8Gr9dABCJnQ6dlveIEiVIK
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 03/11/17 00:47, Wols Lists wrote:
> On 31/10/17 18:11, Wols Lists wrote:
>> It's possible - I wouldn't know - that the existence of the MBR stops
>> mdadm looking for a superblock that applies to the whole drive, which
>> could explain why those drives have disappeared.
>=20
> Just been digging in the code - function check_raid - I think if you
> pass a drive to mdadm it checks the drive for a superblock, and doesn't=

> look for whether a partition table exists. So I think that's that
> explanation blown out the water ... :-(
>=20

:-) Thanks for looking.

As I mentioned, I think I created the array via Xubuntu.

As far as I remember I didn't partition any of the drives - just added
them to the array and I think it effectively created one partition
across the whole array (which would make sense why you can't see
partitions on individual drives)

I am pretty sure that is trashed, but I like to try and understand these
things !

B. Rgds
John


--5aGbPBkgW6G8Gr9dABCJnQ6dlveIEiVIK--

--bini0GiOIOtlFBFCO1tK7VmPmglVGumOC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJZ/EicAAoJEE8bo8Tv0FrJVGsH/3LUrLVNBgQw2tlyuogcDHjw
A5akfCbOcgBlTrgQk1CTUGhyKsYldvjDqIo6YvSF2sLdhOIZfFoO5VXlI0PqszPD
ykN9qd+AfK898y570m+VdOeClee7rA+TcAj6a8mpEzpuDcNzuNiCXjlNzVYUrtzU
rQFeEN4TKtKwq56xeymcF5dfVmIMDRh3a467W+GVoHEbVuQD51YGt/m/bEFHvaF6
oA9DvTORRBls8aN4T/gRuBC+GBW3i21YF1+8trQVRKgaZ++maMaNHpJ7keyzgwzS
BMhEAs0K1mEnsipOlthpC/AL17Mi1xZNrM9Keac+48YLqqNylj4Bkeh5iIpmhAc=
=G2WE
-----END PGP SIGNATURE-----

--bini0GiOIOtlFBFCO1tK7VmPmglVGumOC--
