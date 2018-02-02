From: NeilBrown <neilb@suse.com>
Subject: Re: Multi-layer raid status
Date: Fri, 02 Feb 2018 17:03:34 +1100
Message-ID: <87372k2aix.fsf@notabene.neil.brown.name>
References: <5A708F8E.2040604@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A708F8E.2040604@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Jan 30 2018, David Brown wrote:

> Does anyone know the current state of multi-layer raid (in the Linux md
> layer) for recovery?
>
> I am thinking of a setup like this (hypothetical example - it is not a
> real setup):
>
> md0 = sda + sdb, raid1
> md1 = sdc + sdd, raid1
> md2 = sde + sdf, raid1
> md3 = sdg + sdh, raid1
>
> md4 = md0 + md1 + md2 + md3, raid5
>
>
> If you have an error reading a sector in sda, the raid1 pair finds the
> mirror copy on sdb, re-writes the data to sda (which re-locates the bad
> sector) and passes the good data on to the raid5 layer.  Everyone is
> happy, and the error is corrected quickly.
>
> Rebuilds are fast as single disk copies.
>
>
> However, if you have an error reading a sector in sda /and/ when reading
> the mirror copy in sdb, then the raid1 pair has no data to give to the
> raid5 layer.  The raid5 layer will then read the rest of the stripe and
> calculate the missing data.  I presume it will then re-write the
> calculated data to md0, which will in turn write it to sda and sdb, and
> all will be well again.

If sda and sdb have bad-block-logs configured, this should work.  Not
everyone trusts them though.

>
>
> But what about rebuilds?  A rebuild or recovery of the raid1 layer is
> not triggered by a read from the raid5 level - it will be handled at the
> raid1 level.  If sda is replaced, then the raid1 level will build it by
> copying from sdb.  If a read error is encountered while copying, is
> there any way for the recovery code to know that it can get the missing
> data by asking the raid5 level?  Is it possible to mark the matching sda
> sector as bad, so that a future raid5 read (such as from a scrub) will
> see that md0 stripe as bad, and re-write it?
>

"Is it possible to mark the matching sda sector as bad"

This is exactly what the bad-block-list functionality is meant to do.

NeilBrown


>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpz/zYACgkQOeye3VZi
gblFnw/9GED7170mCOVUDZSKzLK7hsV0dgf/ac/wKO3/kCDt/MMQ3vVvYThxvnXK
slisNWJkgaBRawFJrsP5fLGmZGt9z0NsFA/JhxaCAseX2khRd2vh1cw/IThJtSV+
uAEjjSRWYh/zt2vbKBOhveHAtlsr99ENcVlibufaYPeTuSEhh2I0zytsqvu2Frt7
pbePz1HF3TPqDkb7zZFG1vzp4t80GwlbYv7dlNWQTPYtTfEBUcvROxKWQ5NFP5dH
zom3UYGjPsdHVF9gLhFOLvK/omMHL3fLlld7lEG/dn+c833dUm3Sbf6hk6UQ550k
AGHDS2oo/NTQtjM+rfGvsP0kQUnlWLLpnt+pSG24ug3y4bz4dAF3WZaIR6/oETJq
/8NZBFJWl0Q//TJI7783+eORHLIV5Q5MbCY9/7Givq0ySrIAN02/W9BnGhecHUL1
TDXK/znpCEB6SPrcSooFMc/+GfzaeZX1XYMYdbzVKTevWGa8AMzdKJ4PqeC2nPaS
nOfgeCil2YywsFCc1bllT/zsYgX4gXaOLBvXfugcvc/4TM4aOxJEM2GxrRc5WUjH
AnVtKFKsxTO+07E37Ow8rAZhh7CR9wISVWP0k8bi8YJWi9I1Py/QWg3gY9XPICk7
0onVQMnMV/GFxZzOu/rbF9Zqc0fMgt5tr+xZIvp1hx7bGx3PN9Q=
=78LP
-----END PGP SIGNATURE-----
--=-=-=--
