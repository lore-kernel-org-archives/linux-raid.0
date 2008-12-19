From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Growing RAID1 array with bitmaps enabled
Date: Thu, 18 Dec 2008 22:07:30 -0600
Message-ID: <20081219040730.GA6402@atlantis.cc.ndsu.NoDak.edu>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good evening to all,

I'm looking at growing a RAID1 array from 40GB to 100GB.  The
array has a write-intent bitmap enabled, but an email from Neil=20
in August suggests that I should disable the bitmap when=20
growing the array. Here's a bit of the email Neil sent to the=20
list:

>We cannot currently change the size of a write-intent bitmap.
>So if we change the size of an array which has such a bitmap, it
>tries to set bits beyond the end of the bitmap.
>
>For now, simply reject any request to change the size of an array
>which has a bitmap.  mdadm can remove the bitmap and add a new
>one after the array has changed size.
>
[snip...]

A couple questions I have:

1) Does the superblock increase in size when the array is grown=20
to make room for a larger bitmap?  (This doesn't seem possible=20
to me, particularly if using a v1.1 or v1.2 superblock).

or...

2) Is the problem mentioned in Neil's email in regard to a
"restructuring" of the bitmap to accommodate a larger array (i.e.=20
We only have "x" amount of room on the superblock, so re-divide=20
the array into chucks that we can fit into the superblock)?

In my use case, the block devices that compose the RAID1 array
are fibre channel SAN volumes.  When I grow them to 100GB on the=20
FC target, the additional 60GB is appended to the end of the
exported block device.  My out-of-sync data will still be present=20
on the first 40GB.

With this in mind (and the adage that patches are welcome), has there=20
been any interest in being able to use a write-intent bitmap for this=20
kind of use case?  The benefit of this functionality would keep me=20
=66rom eating two _full_ re-syncs on the array when growing the block=20
devices.


Thanks in advance,

Bryan

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJSx4ClSl3SAlkhEcRAl9TAKCVvcLSXDpM4CDHvdcmwbNB6IrgFgCgtn7/
GwZ4ZIWFvYXQRvqkSJU8mL8=
=evP8
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
