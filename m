From: NeilBrown <neilb@suse.com>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Wed, 18 Oct 2017 08:01:59 +1100
Message-ID: <878tg9jxo8.fsf@notabene.neil.brown.name>
References: <59E4BA29.4050907@youngman.org.uk> <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net> <87y3oak3zj.fsf@notabene.neil.brown.name> <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk> <6c901544-fe5e-fd6a-b3b3-6b8e5edfa36b@turmel.org> <0c360057-f616-dcee-5f0a-59e12cb6ab43@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0c360057-f616-dcee-5f0a-59e12cb6ab43@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17 2017, Anthony Youngman wrote:

> On 17/10/17 20:04, Phil Turmel wrote:
>> No, it is*wrong*.  Writes in multiples of 4k and entirely within a
>> chunk are passes as-is to the devices.  For mirrors, all affected
>> devices get a copy of the request.  For parity raid, the 4k stripes
>> corresponding to those 4k blocks will be pulled into the stripe cache
>> for recalculation.  Not whole chunk-size stripes.  The stripe cache is
>> multiples of 4k, not multiples of the chunk size!
>>=20
>> Writes smaller than 4k, or not aligned to 4k, will generate a
>> read-modify-write cycle of the 4k block involved.  Not the whole chunk.
>>=20
>> It is more accurate to say that a chunk may be the*largest*  a request
>> can be before it is split between devices.
>
> Okay, I think I need to update my understanding on this ... :-)
>
> Let's say a chunk is 12K. That's three 4K blocks to drive 1, followed by=
=20
> three to drive 2 etc. Does that mean that each chunk is split across=20
> three stripes, or is the stripe all the 12K chunks one per drive?

RAID5 would not allow a 12K chunk size (must be power of 2) but RAID0
would.  Not sure about RAID10.

I interpret "stripe" to mean "a set of chunks, one from each device".
So if you had a RAID10 with a 12K chunk size and 3 devices, then a
stripe would be 36K of space, 12K per device.

This is primarily an address-space mapping.  Think of it as a function
from "array-address" to "device-index, device-address".

0 -> 0,0
512 -> 0,512
1024 -> 0,1024
....
3072 -> 1,0
3584 -> 1,512
....

No imagine that the application always sends 512 I/O requests.  Each I/O
request is mapped through the above function and sent to the appropriate
device with the new address.

In practice, larger requests are allowed and the a split into
sub-requests if the function isn't contiguous for the whole range of a
particular request.


>
> In other words, does a stripe consist of one block per drive, or one=20
> chunk per drive?

One chunk per drive.

Note that inside the md/raid5 code the word "stripe" usually means one
PAGE per drive.  This is an unfortunately historical accident.  I
sometimes use the word "strip" (no 'e') to mean one page (or one block)
per device.  A strip is not contiguous in the array address space.  A
stripe is.

Thanks,
NeilBrown

>
> (I'll put a "sic" on that page then, just to point out it's a=20
> misunderstanding by the original author. As I said, I'd rather not mess=20
> around with the page now.)
>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnmb8kACgkQOeye3VZi
gbnFKxAArsMC8SgLKz2LSCCM6EvuYHCBz/IPlvgIHiAT5AJ7/yZenaR5a8sqlZ+N
oumivBQx0Id3ZIdWYJ0oRnvXikNSwKyNuroppgZdHZ7XgxVn6aoTxung0R5e2lWg
jfVGpd9FvjWyYuKjS+lVhHdKGqvpMJV747UrWAOqlOijGq4Tn64SRU1vaU5pDzdO
BEJfjJSZjedpacMMWLBGjsOwJ3pg3/xU/0zmE0K33PfNgRIZT/906VPOt8QtqslU
0lM8uIarm6nXeEoBPHjAhx51SrA//Zi1tSSXcCWLE9oIGtayGM0Dzd+U9eg2s8fp
BBnN5imkZvMvwB0iCCH9Z1AMMy1KicIy0DkiHtU3VrFQuZqeF+yw8pwLrApzl1Le
N8zmvvmHrZtb5xPmDVkrhuXSSLhHFWNv2/N2KTMq4sjP3wuxef1FvTS6QXGJBgO3
x1geLo7SVECMkMhF0q04wlB4X5C9WNfS54rx/WeY8eE85cVG+L6rii3mfSnsKhMh
pW1OA1BUNuh1r9264roTRAK9HFsfiDcLB41klvmlXRbdcSiMveTHGZhR3U5tMu3d
eWXVkclvbZLfA9wb5srwqmqqE+ci5ko+zVN3lileiByS9C2+nU9WFpRy/w3KEPtz
e9ZhWGa2/qbts6ItP1XLRhqqepCGp8qG5kICVp9R+0rQbBxr0PY=
=FluD
-----END PGP SIGNATURE-----
--=-=-=--
