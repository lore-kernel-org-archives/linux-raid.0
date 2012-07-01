From: NeilBrown <neilb@suse.de>
Subject: Re: Question about raid5 disk recovery logic
Date: Sun, 1 Jul 2012 18:00:53 +1000
Message-ID: <20120701180053.504ba439@notabene.brown>
References: <CAGRgLy7uJAzTwnuvgXgH=SnKdVBqgPF41eM0N-CYn8bS2BzW9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4/E.CDqzSQvPJpnQxDgy_.3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7uJAzTwnuvgXgH=SnKdVBqgPF41eM0N-CYn8bS2BzW9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/4/E.CDqzSQvPJpnQxDgy_.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Jul 2012 10:08:40 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi everybody,
> I am trying to understand what happens when raid5 is recovering a
> disk, and a write comes to a stripe that has not been recovered yet.
> Does md first reconstruct the missing chunk and then applies the
> write, or first the write is applied as if the array is still degraded
> (and not recovering), and only later the missing chunk is
> reconstructed (when the md_do_sync() loop gets to this area)?
> I am looking at the stripe handling logic (kernel 2.6.38), can anybody
> pls point me at the path that handle_stripe5() takes in that case?
>=20
>

Hi Alex,

 The stripe is still degraded, so md/raid5 treats it like a write to a
 degraded array.
 Exactly what happens depends one which block is being written.
 If the block being written would be stored on the recovering devices, then
 md will perform a reconstruct-write.  It will read the other data blocks,
 calculate the parity, and write out the parity and the changed data.
 Similarly if the parity block is on the recovering device a
 reconstruct-write will be needed.
 If some other block is being written, md will do a read-modify-write to
 calculate the new parity and then write out the parity and data.  In this
 case the block on the recovering device will not be written.

 I hope that clarifies the situation.

NeilBrown

--Sig_/4/E.CDqzSQvPJpnQxDgy_.3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/ADtTnsnt1WYoG5AQJj7Q//QS2umc878T4CP0PbtojppNaZemSsnpnz
19HrW14UORanJq/itIEkluph23VBkpVsGqx9zprZI8bpZySnsKQZAwPGBhyGxnb8
PNCH8sXz7ltrk9DTz59nfIg4luYfcubT183tOtnrbIBnC5onK+Fci0lqZo40n6X6
MxEHRAjQK23J2kA7NU2Q4dhObx24yZW/k4R2uAXffpyMQrLQ8SzsL39HN9Z2taRh
nPOjlYSAwWYfd5KBms6XY1nXCMDZxFUd0/LcqqcCPp2JNnxon14MNGNtMAEhirt6
wlF+ACjWu8CgdYgeFa9Q689MzPJ2KbP/JaYIXu4tgMqXrk0JNK0b6Mi7hkoX9Yb1
mZWnqoh5Vb2AACO3bVtKXwW9sun9rqCS18Hmw7DE6p748JC3gqqHJjiIWZ/Sbesk
xK9BbsGpuKjW7X4A1X4/9DA04ya5NJG6jjNJ9krREuzyF5CIVsrZ6SwE1sRek4z3
MXUpzqGxDXOJr2KFuEL5pygcoQjPlS4J/S+VhW2Hm1NP6jXLemY7/GxGZQfJsXbY
aFB9/KRgRpaZkkV9WApNpcsSxAt2niqBE7w0myY3hpqAyQZym1mD5X0/Fn4ioCLu
mQSsLrMBlaV2fcLG577cYqe6ilvvnqCpvjQf8oALEPxM2tV4ELGLxP0MkBVOgOB2
jsEcFg0RmsM=
=TLS3
-----END PGP SIGNATURE-----

--Sig_/4/E.CDqzSQvPJpnQxDgy_.3--
