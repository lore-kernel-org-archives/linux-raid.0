From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 15:32:21 -0500
Message-ID: <4AFB1F55.60405@redhat.com>
References: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig83E9AE0AEE85C8FE7C1583E8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig83E9AE0AEE85C8FE7C1583E8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/10/2009 10:34 PM, Leslie Rhorer wrote:
>>  If the array isn't super performance critical, I would use mdadm
>> to delete the bitmap, then grow an internal bitmap with a nice high
>> chunk size and just go from there.  It can't be worse than what you've=

>> got going on now.
>=20
> 	I really dislike that option.  Doing it manually every time I boot
> would be a pain.  Writing a script to do it automatically is no more tr=
ouble
> (or really much different) than writing a script to mount the partition=

> explicitly prior to running mdadm, but it avoids any issues of which I =
am
> unaware (but can imagine) with, say, trying to grow a bitmap on an arra=
y
> that is other than clean.  I'd rather have mdadm take care of such deta=
ils.

I think you are overestimating the difficulty of this solution.  It's as
simple as:

mdadm -G /dev/md0 --bitmap=3Dnone
mdadm -G /dev/md0 --bitmap=3Dinternal --bitmap-chunk=3D32768 (or even hig=
her)

and you are done.  It won't need to resync the entire device as the
device is already clean and it won't create a bitmap that's too large
for the free space that currently exists between the superblock and the
start of your data.  You can see the free space available for a bitmap
by running mdadm -E on one of the block devices and interpreting the
data start/data offset/superblock offset fields (sorry there isn't a
simply field to look at, but the math changes depending on what
superblock version you use and I can't remember if I've ever known what
superblock you happen to have).  No need to copy stuff around, no need
to take things down, all done in place, and the issue is solved
permanently with no need to muck around in your system init scripts as
from now on when you boot up the bitmap is internal to the array and
will be used from the second the array is assembled.  The only reason I
mentioned anything about performance is because an internal bitmap does
slightly slow down random access to an array (although not so much
streaming access), but that slowdown is mitigated by using a nice high
bitmap chunk size (and for most people a big bitmap chunk is preferable
anyway).  As I recall, you are serving video files, so your access
pattern is large streaming I/O, and that means the bitmap really
shouldn't be noticeable in your performance.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig83E9AE0AEE85C8FE7C1583E8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7H1oACgkQg6WylM+/8ZSIVgCgibGJw52o74Nxhx9qFrZj015Z
UXcAoI4LDpg/dno/oS6nfeA5YoGBOT7s
=RYgd
-----END PGP SIGNATURE-----

--------------enig83E9AE0AEE85C8FE7C1583E8--
