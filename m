From: Doug Ledford <dledford@redhat.com>
Subject: Re: bitmap-chunk sizing on RAID-10?
Date: Wed, 11 Nov 2009 21:00:24 -0500
Message-ID: <4AFB6C38.9050903@redhat.com>
References: <babafd2f0911111532u2c8fe9efhc48648fe262ec7e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4769174DAC607ACE355EE492"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911111532u2c8fe9efhc48648fe262ec7e9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: robin@robinhill.me.uk, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4769174DAC607ACE355EE492
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/11/2009 06:32 PM, Ben DJ wrote:
> Hi,
>=20
> I didn't want to hijack the thread, so a new one here.
>=20
> On Wed, Nov 11, 2009 at 2:10 PM, Robin Hill <robin@robinhill.me.uk> wro=
te:
>> It's true for RAID-10, yes.  You can't physically grow the array, but
>> you can definitely add/remove the bitmap.
>=20
> Thanks for clearing that up.  The manpage is a bit unclear to my read.
>=20
> I've just been reading threads about proper sizing.  Large
> bitmap-chunk seems good, larger than "1 million bits" -- not, and an
> old bug (resolved?) if bitmap-chunk is smaller than raid10 chunk size.
>=20
> I've two arrays --
>=20
>    /dev/md0 (RAID-1, across 4x 160MB partitions)
>=20
>    /dev/md1 (RAID-10/f2 , across 4x ~1TB partitions, --chunk=3D256 )
>=20
> The first array is so small, that resync takes just a few seconds
> anyway.  Is there any advantage to still installing an internal
> write-intent bitmap on it?

Not in my opinion.  I skip bitmaps on boot arrays and other smallish
arrays like that.

> The second array takes a few hours to resync from scratch, and so the
> bitmap has performance value.  What's the right size for
> --bitmap-chunk for an internal bitmap?  Iiuc, the default that "is
> automatically deteremined to make best use of available space" results
> in 2x-4x (some say 10%) write-performance slowdowns.

It makes for noticeable slowdowns anyway.  How bad is dependent on your
data writing patterns.  Lots of random writes will actually show a
larger slowdown than more sequential writing.  The main thing to
understand is that a bitmap like this is useless if the raid stack
doesn't stop any write going to the disk unless the bit for that write's
sector is set to dirty.  So, when a new write is initiated on a clean
array, the write is help up until the bitmap write to dirty the proper
bits completes, and only then can the normal write proceed.  So, with
lots of random I/O, or even with sequential I/O on very small bitmap
chunk sizes, you end up spending a significant amount of time holding up
writes as you dirty the bits on disk.  Picking a larger bitmap chunk
helps to increase the likelihood that more writes will stream without
having to wait on a new bitmap dirty write.

Given that the only real benefit to the bitmap is reduced resync time in
the event something happens, and given that as you said a 160MB section
of array can resync in a relatively short time, and given that a smaller
bitmap chunk hurts performance *all* the time versus only helping in
rare circumstances, bigger is better in my opinion.

I haven't done specific testing of performance differences with
different size bitmap chunks, but my seat of the pants review puts the
32768 area as a good starting point.  Any given chunk will resync in
just a second or so, but it doesn't cause as much performance slowdown
as the default chunk size.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig4769174DAC607ACE355EE492
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7bDgACgkQg6WylM+/8ZQe5ACgltK0ZOcMyTGDqnaZYzLcE+Jm
c78AmgIV/WKKGDpHavqU1XNwJ9FbCnPk
=BUfh
-----END PGP SIGNATURE-----

--------------enig4769174DAC607ACE355EE492--
