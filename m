From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: RAID-6
Date: Tue, 12 Nov 2002 17:22:05 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021112162205.GB22407@unthought.net>
References: <aqou9k$ou5$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aqou9k$ou5$1@cesium.transmeta.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 11, 2002 at 10:52:36AM -0800, H. Peter Anvin wrote:
> Hi all,
>=20
> I'm playing around with RAID-6 algorithms lately.  With RAID-6 I mean
> a setup which needs N+2 disks for N disks worth of storage and can
> handle any two disks failing -- this seems to be the contemporary
> definition of RAID-6 (the originally proposed "two-dimensional parity=
"
> which required N+2*sqrt(N) drives never took off for obvious reasons.=
)
>=20
> Based on my current research, I think the following should be true:
>=20
> a) write performance will be worse than RAID-5, but I believe it can
>    be kept to within a factor of 1.5-2.0 on machines with suitable
>    SIMD instruction sets (e.g. MMX or SSE-2);

Please note that raw CPU power is usually *not* a limiting (or even
significantly contributing) factor, on modern systems.

Limitations are disk reads/writes/seeks, bus bandwidth, etc.

You will probably cause more bus activity with RAID-6, and that might
degrade performance. But I don't think you need to worry about
MMX/SSE/...  If you can do as well as the current RAID-5 code, then you
will be in the clear until people have 1GB/sec disk transfer-rates on
500MHz PIII systems  ;)

>=20
> b) read performance in normal and single failure degraded mode will b=
e
>    comparable to RAID-5;

Which again is like a RAID-0 with some extra seeks... Eg. not too bad
with huge chunk sizes.

You might want to consider using huge chunk-sizes when reading, but
making sure that writes can be made on "sub-chunks" - so that one could
run a RAID-6 with a 128k chunk size, yet have writes performed on 4k
chunks.  This is important for performance on both read and write, but
it is an optimization the current RAID-5 code lacks.

>=20
> c) read performance in dual failure degraded mode will be quite bad.
>=20
> I'm curious how much interest there would be in this, since I
> certainly have enough projects without it, and I'm probably going to
> need some of Neil's time to integrate it into the md driver and the
> tools.

I've seen quite some people ask for it.  You might find a friend in "Ro=
y
Sigurd Karlsbach" - he for one has been asking (loudly) for it  ;)

Go Peter!    ;)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
