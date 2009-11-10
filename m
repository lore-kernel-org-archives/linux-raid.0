From: Doug Ledford <dledford@redhat.com>
Subject: Re: bitmap chunk size
Date: Tue, 10 Nov 2009 14:46:50 -0500
Message-ID: <4AF9C32A.9000300@redhat.com>
References: <alpine.DEB.1.00.0911100933160.10087@darius> <4AF9AA92.7030604@redhat.com> <alpine.DEB.1.00.0911101123480.12026@darius>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig24B926E2AC69764A1BA1AB93"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0911101123480.12026@darius>
Sender: linux-raid-owner@vger.kernel.org
To: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig24B926E2AC69764A1BA1AB93
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/10/2009 01:36 PM, Darius S. Naqvi wrote:
> On Tue, 10 Nov 2009, Doug Ledford wrote:
>=20
>> On 11/10/2009 11:39 AM, Darius S. Naqvi wrote:
>>> Is there any possibility of having a bitmap chunk size of 512 bytes?
>>> I know that mdadm rejects anything under 4k.  I fear that the
>>> assumption of the 4k minimum is embedded fairly strongly in the code.=

>>> Can my fear be alleviated?
>>>
>>
>> If you're putting any normal filesystem (with a block size of 4k) on
>> this, then it makes absolutely no sense to have a bitmap size less tha=
n
>> 4k as any given filesystem block is either dirty or clean, sub-block
>> semantics make no sense in this scenario.  That said, unless you have =
a
>=20
> Well, the mke2fs(8) man page says, "Valid block size values are 1024,
> 2048 and 4096 bytes per block.  If omitted, mke2fs block-size is
> heuristically determined by the file system size..."

Yes, but you can always supply the -b option and tell it what you want.
 I'm actually a little confused as to why you would quote this specific
part of the man page then at the end of the mail ask how you can force
block size on the filesystem...well, with this option you just quoted is
how.

> I always thought that filesystems typically used a block size of 4k,

They do, especially if you use any of the modern distributions.  I think
they all pass -b 4096 in when calling mke2fs.  But, even if they didn't,
I think you need a pretty small filesystem before mke2fs will
voluntarily grab a less than 4k block size.

> but apparently there is no guarantee that that is the case.  Also, I'm
> not sure what windows uses as a filesystem block size.  This is
> important to me, because we're trying to use md raid 1's to
> periodically synchronize blocks from a filesystem, and having
> sub-chunk writes messes things up for us.  What we want is that a
> whole chunk gets written, then we fiddle with things so that a
> bitmap-driven resync copies those whole chunks.  The chunks were not
> necessarily initialized before the write, so a sub-chunk write means
> garbage data is copied in the remainder of the chunk.

So?  If this is truly a raid1, and it wasn't initialized prior to use,
and you copy a larger than write size chunk with garbage at the end, it
doesn't matter, the other drive has garbage there too so you are just
overwriting garbage with garbage.  The only reason it would ever matter
if you copied garbage at the end is if you are trying to do a partial
raid1, where they aren't really fully raid1 mirror copies, but you are
using the bitmap to signal a sort of mask that you want copied and you
want other parts untouched.   What you would be doing something like
this for I don't know, but good luck getting it to work with the md
raid1 code.  It simply isn't intended to be used in that way, and even
if you manage to get it to work, I suspect it would be *VERY* fragile.

> We've seen this problem occur in practice, meaning either filesystems
> are not using 4k (or multiple thereof) chunks, or for some reason,
> writes are not 4k-aligned.  Does anyone with more knowledge of
> filesystems know about this?  Perhaps we can force block size and
> alignment of filesystems to make this work.
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig24B926E2AC69764A1BA1AB93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr5wyoACgkQg6WylM+/8ZRwkQCeNRznMrLPuxUzSfKjB/wer65n
GfsAn0BnX4bcknMo3dyqRfoCcVkAGk1z
=kxTq
-----END PGP SIGNATURE-----

--------------enig24B926E2AC69764A1BA1AB93--
