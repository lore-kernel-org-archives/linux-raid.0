From: Doug Ledford <dledford@redhat.com>
Subject: Re: stride / stripe alignment on LVM ?
Date: Sat, 03 Nov 2007 14:40:48 -0400
Message-ID: <1194115248.25553.59.camel@firewall.xsintricity.com>
References: <20071101101037.63b523f8@absurd>
	 <18218.24819.569744.141171@notabene.brown> <472B1F91.8000208@tmr.com>
	 <20071102231605.7add5154@absurd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nTqetfk9rTje4xbtUr45"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071102231605.7add5154@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-nTqetfk9rTje4xbtUr45
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-11-02 at 23:16 +0100, Janek Kozicki wrote:
> Bill Davidsen said:     (by the date of Fri, 02 Nov 2007 09:01:05 -0400)
>=20
> > So I would expect this to make a very large performance difference, so=20
> > even if it work it would do so slowly.
>=20
> I was trying to find out the stripe layout for few hours, using
> hexedit and dd. And I'm baffled:
>=20
> md1 : active raid5 hda3[0] sda3[1]
>       969907968 blocks super 1.1 level 5, 128k chunk, algorithm 2 [3/2] [=
UU_]
                               ^^^

You have the raid superblock in the front of hda3 and sda3, as well as a
bitmap I assume, which means that any data you write to md0 will
actually be written to sda3/hda3 *after* the superblock and bitmap.  If
you run mdadm -D /dev/md1 it will tell you the data offset (in sectors
IIRC).  When you hexedit hda3, you need to jump forward the same number
of sectors to get at the beginning of the actual md1 data.

Of course, being raid5 with one disk missing, the data may or may not be
present in its non-parity format depending on exactly which block you
are looking at.

However, you don't really need to do anything to figure out the stripe
size on your array, you have it already.  All the talk about figuring
out stripe layouts is for external raid devices that hide the raid
layout from you.  When you are talking about your own raid device that
you created with mdadm, you specified the stripe layout when you created
the array.  In your case, the chunk size is 128K, and since you have a 3
disk raid5 array and one chunk in each stripe of a raid5 array is
parity, the amount of data stored per stripe is chunk size * (number of
disks - 1), so 256K in your case.  But you don't even have to align the
lvm to the stripe, just to a chunk, so you really only need to align the
lvm superblock so that data starts at 128K offset into the raid array.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-nTqetfk9rTje4xbtUr45
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHLMCvTzP9PM7pjw8RAjsPAJ9CqiHVOJenhUNvimRY9n04rdQ9RgCfeokr
VbykU0eb5in9UercPO8SQL8=
=FFmd
-----END PGP SIGNATURE-----

--=-nTqetfk9rTje4xbtUr45--

