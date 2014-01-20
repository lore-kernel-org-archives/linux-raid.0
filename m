From: NeilBrown <neilb@suse.de>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Mon, 20 Jan 2014 17:16:45 +1100
Message-ID: <20140120171645.591b17fc@notabene.brown>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
	<20140106124143.287894da@notabene.brown>
	<CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
	<CANgodhC6wKST5B3zKHD-04xHV8DCUm1Rv71c44RWDMuJp6+WGg@mail.gmail.com>
	<CANgodhDZnogCmXDLz75Hidv=HcYoaoj=1thKTqt8htP8gx3CSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rb9zQ/YbgOz2hNK_7l2frU_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANgodhDZnogCmXDLz75Hidv=HcYoaoj=1thKTqt8htP8gx3CSw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: den Hoog <speedyden@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rb9zQ/YbgOz2hNK_7l2frU_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jan 2014 22:03:00 +0100 den Hoog <speedyden@gmail.com> wrote:

> Hi Neil
>=20
> can you try to make 'missing' working for imsm?
>=20
> probably not on the short list of things to do, but if you are willing
> to help me out, I'll appreciate it much!

Hi Dennis,

it seems that "missing" already works with IMSM.  I thought I remembered th=
at
it didn't, but I was wrong.

So you should be able to create the raid0 using the first parts of the
devices, then create the RAID5.
When creating the RAID5, list the devices that should  make up the RAID5 in
the correct order.
So something like:

 mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[bcde]
 mdadm -C /dev/md0 -l0 -n4 -c 128k -z 512G /dev/md/imsm
 mdadm -C /dev/md1 -l5 -n4 -c 128k missing /dev/sdc /dev/sdd /dev/sde

Then /dev/md1 should be your RAID5 array.

You should double-check the above command to make sure you agree with ever
part, and ask if there is anything that doesn't seem right.

NeilBrown


--Sig_/rb9zQ/YbgOz2hNK_7l2frU_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUty/TTnsnt1WYoG5AQI5lQ/8Dxg0Fnu3rwnRGs1x+f3C5tASKRu8ALLY
49HtXfphCJ33tG538Rowpxj/Z8mcbd4SkWkPaSYnSdRUTa1iBRq7E63Qmwy9wFAX
ZZjESZl4xy8kWL/NE9s19nBzTe23EnLzLhnzk3Hsv2IPCLvbRFVyKj9mlQa9io5t
cODriDD4M/T57GvjNpWbVSVGnXvBgsfaznmjfdqyIT8/ABiWH4M5ACTp0aD43oXv
fjFxoryKszaGmoHc5xrldIlh6FY9YUQ+ywJV12c5hXu9Bh7Pb3EuUVMUvPA3ZWdg
1h5C7g93VPK36yXhWruD8nyNdjtvbNO6VdFCJl22ijeBkF13Q0u+Z32XrADY14m5
g5qW4cXWxDrLykhP02GNx2CCXaIWx8dFcfQ5f81NO3Aa3ZV12Bnkb98zP8ZAL8SY
tCUZzWyV59fjemmDf0rw2NUvVNMZ3JRXXVpizhoD6HEseyESc7L5M0ceT4VDBknd
RKgSs+jkUsRVj03BI+ANBMS42tbp7l6MgObbAReGFyKBSqIFhe+G4oeZOkXa2oKO
tym3S5KhrxPSvunKXmIyALhXU+oPflAClAaWGHGXruUPQi/QMMh8jgAPRnhjkIle
ppXii3z5XAogX1AIlYvOSAoCPk5Xlu0NiIz9GHNKsbBxhY4h1DWElYWCBqwBG6DQ
BujzrZoJBTU=
=hBKw
-----END PGP SIGNATURE-----

--Sig_/rb9zQ/YbgOz2hNK_7l2frU_--
