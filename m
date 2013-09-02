From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 5/5] raid5: only wakeup necessary threads
Date: Mon, 2 Sep 2013 10:45:21 +1000
Message-ID: <20130902104521.051c7fde@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095518.881234515@kernel.org>
	<20130828141304.5e6df26e@notabene.brown>
	<20130829074032.GA24012@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Pf4MWuCcstVRmg0DqGt3YTN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130829074032.GA24012@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/Pf4MWuCcstVRmg0DqGt3YTN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Aug 2013 15:40:32 +0800 Shaohua Li <shli@kernel.org> wrote:
	return batch_size;
> >=20
> > I think this could possibly return with ->working still 'true'.
> > I think it is safest to clear it on every exit from the function
>=20
> Ok, this one doesn't matter too, I fixed it.
> =20
> Subject:raid5: only wakeup necessary threads
>=20
> If there are no enough stripes to handle, we'd better not always queue all
> available work_structs. If one worker can only handle small or even none
> stripes, it will impact request merge and create lock contention.
>=20
> With this patch, the number of work_struct running will depend on pending
> stripes number. Note: some statistics info used in the patch are accessed=
 without
> locking protection. This should doesn't matter, we just try best to avoid=
 queue
> unnecessary work_struct.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Thanks.
I removed the 'working_cnt' field as it wasn't being used, and have applied
and push out the patch.

NeilBrown



--Sig_/Pf4MWuCcstVRmg0DqGt3YTN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiPfoTnsnt1WYoG5AQLG1w/+OBwkv1al+DcQRcTD12sll0YnMzBAKsMx
CueyFjbDqkkC4J55Uw5mCHGysNvBK95zxpGYKESwbnos4cnjFW8s6wGnvjxzWx+Q
d0l1xL23yN++quPoNzchTJzHFa64K0muTtNEZ4AuJ40T3Gg4tF4wt3mvdIFZbAmM
9DnP9sId2ld2K3JmW/ko7Gi3u/3YC2NwNvDE1EXmF4A8hhz8EzjpTFjfgMh7MqCT
DDysWbaL0CmCMMiStiYYSDG8pRZRUSCBvKjelmlBMXnKWHGPK1t/rB+KAMdS/wGU
ddk/9xVBmZqcFjBwVj3BzWsvjYZv7HtFeKO3vdmPbipsG5BAEIH3JJTjhJsDh/RO
1P19DuQTacFRhYQowR01xtsaMXQXWdxGDpkVY/eUu19HHj7jmdH8glE9066jahJT
ZH8uYnswIonMvZ3ONwSgSrw+bAela0w0jLVoZsqBPiFcZrPu6U2PEfn85xEwyEUg
oLyd18oiO9iKzo2+awntNFkxbW6mlbLBMS/7+K5g7iG665PyR+eZCqM505E/4PP3
aYXNuLupSFXfDaGLHJKa0QrqILyFbj9oGnf/DPrk8iGGxObAtTH4CvqXzI6kqRoZ
u0cT4NS1eAP8bH2mKBCie7XfstnuNzF/ja6jlDrjhWI8VHvkI+gDCRsujE96sP24
LiZBhBFkI94=
=cyt1
-----END PGP SIGNATURE-----

--Sig_/Pf4MWuCcstVRmg0DqGt3YTN--
