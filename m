From: Georgi Alexandrov <teh@amln.net>
Subject: Re: write-behind performance ... or how behind can write-behind write
Date: Mon, 16 Feb 2009 12:39:31 +0200
Message-ID: <49994263.4090204@amln.net>
References: <4995A170.4000000@amln.net> <4995BF95.1010908@steeleye.com> <4996C965.9020205@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF4940BC2D8DA54A006F943B2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4996C965.9020205@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF4940BC2D8DA54A006F943B2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Bill Davidsen wrote:
> Paul Clements wrote:
>> Georgi Alexandrov wrote:
>>
>>> Generally with the healthy array I'm getting the write performance of=

>>> the SATA disk alone (in terms of requests/sec issued to the disk and
>>> bytes/sec written). The SATA disk is obviously a bottleneck even with=

>>> the write-behind option set(2).
>>
>> write-behind can help with two things:
>>
>> 1) overcoming latency (say one disk is on the network -- it may be the=

>> same speed as the source disk, but it takes longer round-trip for each=

>> I/O to complete)
>>
>> 2) temporary slowness of a device (say at a peak in I/O) -- the queue
>> can temporarily hide the slowness of the secondary disk, but this
>> won't last very long -- if writes continue at a pace faster than the
>> disk can handle (i.e., the queue gets filled) then the array drops
>> back to non-write-behind behavior
>>
> At least with write-mostly all of the capacity is going into saving
> data, not serving data. But as you note below if the writes are
> happening at a rate faster than the device can support it will be a
> bottleneck.
<snip>

Well, at least write-mostly is suitable for reading from the SSD disk
only in a setup like mine. If writes get really problematic maybe it's
better to consider a SSD-only solution.

--=20
regards,
Georgi Alexandrov
key server - pgp.mit.edu :: key id - 0x37B4B3EE
Key fingerprint =3D E429 BF93 FA67 44E9 B7D4  F89E F990 01C1 37B4 B3EE



--------------enigF4940BC2D8DA54A006F943B2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmZQmkACgkQ+ZABwTe0s+7l4ACbBX3KubMurPz+/qEd6TVn6s6m
rBEAoKFVtVmjVBTYkiw2J/FV//BRrNfm
=rQ+H
-----END PGP SIGNATURE-----

--------------enigF4940BC2D8DA54A006F943B2--
