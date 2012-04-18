From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on
 shutdown.
Date: Thu, 19 Apr 2012 08:48:33 +1000
Message-ID: <20120419084833.39379a6f@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yLBZ7szx3Uykn8uZjTJ3m5P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yLBZ7szx3Uykn8uZjTJ3m5P
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 18:37:56 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> > This could result in the shutdown happening when array is marked
> > dirty, thus forcing a resync on reboot. =A0However if you reboot
> > without performing a "sync" first, you get to keep both halves.
> Can you pls clarify the last statement?

"If you break it, you get to keep both halves" is a colloquial phrase meani=
ng
that that the person saying it takes no responsibility for any damage that
the person being spoken to causes.
When applied to software issues it is ironic (because when a thing 'breaks'=
 it
doesn't result in two pieces like, for example, when a plate breaks) and so
funny (I hope).
(when applied to a RAID mirror, it is doubly ironic :-)

If you force a fast shutdown without allowing a sync to happen=20
(e.g. reboot -f -n) there could be data on the way out to the array when the
system actually reboots, so the array will be dirty, so a resync will be
required when the system restarts.
This might be undesirable, but that isn't my problem and is not the problem
of md/raid.  Rather the cause of the problem is the "reboot -f -n".  i.e.
"your" problem.   "You" broke it, you get to keep both halves.

Does that help?

NeilBrown

--Sig_/yLBZ7szx3Uykn8uZjTJ3m5P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT49EwTnsnt1WYoG5AQI9Kw//dTfv8RzaamK3tKqwxEnffB33bviIzkqv
rCPlUsHIhdoonGQlKjVOhFnf10ZDgbwOFtWNGzg1zE0gSERmEYbF5cDWJoE3Ugij
3TPulnu8ZgzIlmo+O8o8yQwNJLAmrSo9aREvp6lWYCV2BHtCj3Hp2gBm0OuaQ2te
i7DQ6jwWR8OHPEG5Ss1wDuFln1Qd061pFqNRObYmhw5+etUEposcd9KTsDb8i3Oo
uDozaIb8UTGyILzVq8OdNq0937JuZpYUZI/gtzcKhDPjCnAKw+iayTAACagRtqFQ
rHokLSkNak5op2O87uTluLGv6sxL7sQwNjdYBJzQjqXUyegodTN58kzMTbQd8iSX
hzp3cG9jXz0CA3NcNFKi1P5FmQ8JLZ62fhobTADJB/ppvEudTUr96XXD0tSEje2e
FMeGDf9q5elDHq5hmjhG99XHYXaIj2YXCZiipiTn05Km+EmiPB2tkwiO+yLcNSYl
cmQpLQuSrlLXL83njLqjiSxEkHZl/nx09sFVxQM7YMQZULs495ztqeUBqZu4xLqA
U8jVU7tkuRnnTYBAJnISfwuY5/Ui709a58svxXA4mGrL+EqAO7EzlNOX7jdmowf3
1f39iVS5A7yO0HLFF3hQOdrJWpfKTEuS5ajXFnOmopHmAdC8XtwwL9ykMXLLHbro
ep34F9yirDo=
=YjqN
-----END PGP SIGNATURE-----

--Sig_/yLBZ7szx3Uykn8uZjTJ3m5P--
