From: NeilBrown <neilb@suse.de>
Subject: Re: quick question about write-intent bitmap
Date: Thu, 1 Dec 2011 18:18:52 +1100
Message-ID: <20111201181852.5810ba4c@notabene.brown>
References: <CALFpzo6wwtmnyCGW+4OkZL=6=0OFPV3STREq56_5jJt9z_qX2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W0Dr52oqlWS/L9gmNF_qq6i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo6wwtmnyCGW+4OkZL=6=0OFPV3STREq56_5jJt9z_qX2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/W0Dr52oqlWS/L9gmNF_qq6i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Nov 2011 23:34:13 -0700 Marcus Sorensen <shadowsor@gmail.com>
wrote:

> I would appreciate being pointed to any sort of in-depth documentation
> on how the write intent bitmap works. To make my question quick, I'm
> wondering how the write-intent bitmap holds up to writeback caching.
> It seems like md would assume that the cached writes had made it to
> disk, and only rebuild writes that happened since the disk was
> removed, leaving an inconsistent array.
>

md writes bitmaps with

  REQ_WRITE | REQ_SYNC | REQ_FLUSH | REQ_FUA

If that returns before the data is truly safe, then you have a bug somewher=
e.

i.e. md tries to write-through an cache that might be in the way.

NeilBrown

--Sig_/W0Dr52oqlWS/L9gmNF_qq6i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtcqXDnsnt1WYoG5AQLZdxAAvupogKUg/VwEguUbwOSWCJ+/K7cQ3AYa
B1I3dEzQvm93D8RSjugSPVHhRZszm3uHWOZsGXFqeY79jwNY9unVH4xzFL1OWUKc
lmVJJzT4RuUhx+IeyoewIY/MO9934QGLXMQsl9Z4uyvJxxl1xPcjmPauoDhkRu9y
dSviLdYKrqDKZEyObmBBCcjwC+zuamUHzCaLt/+NqGoH76TWZPAAKuH4Ca5uGo+C
oPike9ay9YxGfRGHyO9t+1W/Ge6s8ZoYtNM9Wa2jZj9s40qbH9qRhqdzB2JsZaS7
w6oKrWM9B5uGyx/mYE+OpE9udWb22hHMLx3TDbgWC8r2tTKzVAtB60fwdwfpQGej
v9+o/wzyTC7hO1E6wLTH97SP+naVrjnoiQRKSztoXKIInHzUJS059CrF9z1wqZjj
XCUJijgv8fTqmQ8O05M8P+ijTDbL3jVYeeCEyetH2rxVfUXVQvvFsuklvE4lCkvr
SD69bE3/b/duxniCWxOYM8eITioYnODcX9ZtlGPQjVSyuIIJrLCKDCydPnl+flB3
8vf68XOFwdtzjXwLV+x3+P4y02R4TQfvJZ6dVWc3OFrH2/Bq1c4MLI+5COcNdSf3
FxzBT8T+S9EgHpX1xx/O+qsZKwbAbvyK3O/GfJSnMNVAP7ASjZMSn0/EzHRbtUeE
Wo83fcoouvg=
=3B+k
-----END PGP SIGNATURE-----

--Sig_/W0Dr52oqlWS/L9gmNF_qq6i--
