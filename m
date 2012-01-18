From: NeilBrown <neilb@suse.de>
Subject: Re: Invalidating the pages read from a disk which md marks as
 faulty later
Date: Thu, 19 Jan 2012 07:19:55 +1100
Message-ID: <20120119071955.03a3fe9d@notabene.brown>
References: <CAHhTtBVqgv1Spgvkux55-K=y7CEYWs1qFQHXDSU_Kwu_NsuTaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/50VqzFG69mCKYyQlqZuJdxe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhTtBVqgv1Spgvkux55-K=y7CEYWs1qFQHXDSU_Kwu_NsuTaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krishnakumar R <krishnakumar.kernel@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/50VqzFG69mCKYyQlqZuJdxe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jan 2012 20:11:38 +0530 Krishnakumar R
<krishnakumar.kernel@gmail.com> wrote:

> Hi,
>=20
> Does md invalidate the pages in the page cache for data read (earlier) fr=
om
> the disk, which md finds faulty, lets say due to an I/O error ?
> The assumption here is that since md found a disk to be faulty, the data
> which was earlier read and cached can be considered invalid. Thoughts ?
> I would assume that the pages would be backed by md device, hence is it
> possible to figure out which pages were given out with data from an
> underlying disk inorder to invalidate them ?
>=20
>

Sorry, but this doesn't make any sense.

When you read from a disk, the disk drive itself does a CRC check to confirm
the data is valid.  It if isn't you don't get to see the data.  If it is, w=
hy
would you want to invalidate it?

If a device is "Faulty", that doesn't mean it has corrupted data.  It means
it has inaccessible on unchangeable data.

Though I might have  misunderstood you.  If you think I have, please give a
more detailed scenario of the situation that should be handled differently.

In any case, once md has returned the data to the caller there is nothing it
can do to "invalidate" it.

NeilBrown

--Sig_/50VqzFG69mCKYyQlqZuJdxe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxcpaznsnt1WYoG5AQKLBw/+I3vxWI7LMmJykQyGH5wZmJfH0feeKWbW
1yO+BgLffaQqvlP7XsCr018kn2yS8eteYRPYtyy7kPtYIZp7jdTcaAc0nfrFMJ7v
l+Yl2MyXtNzWnM503tf9fEZ9PJLPXK0Zp1n1isO77pYwgG0dviaT+OFXlG19DtFs
2tzmL+6tAObua6qBV4r1fVGuS73CFdPE47dGxyajwWQSVMJn4FPzmcBc8fbV9Fcu
TWpBdWzBDqxZQjthwuXHNXw+fXS8JPG5pA7TTrVoDtW6upwuroSRJBVDx21CJmdv
n6uWDR00zfFt8ON9/Wn2S3ojj0xCED3X4Qb9AhordkX+ef/Cfh72IO4O9hsGwXAg
dhchKvU6MZroJW9sOKyUEeLv2d++5mYMqrtIUFQ36oFbN1D3WXE/99RuISczBUSX
mm+tfJ55BO24BMnJxwX511W3QTqIIyDnls7hlh48SKKDYDHoz1wzujJHtry/ToLQ
RdrXWJIbhQBEIpOmko7KthHiWlrWqkc5fi10aW546h22TsNI+/GfInW+oAPMbjyJ
Z7TqdzOJUbhSszkSBK9TWm//C7GmUUYxn0SaTyHPKnz5vbO6/NO4UeVFS3SlEcq/
+69lSwvqS8/X0DuIEerFisNbCa2YD2IoS7/KpRJ+TdiO+WmbQ7tJiGt9UM1sEHGw
Qejn7G1GEfg=
=1YKg
-----END PGP SIGNATURE-----

--Sig_/50VqzFG69mCKYyQlqZuJdxe--
