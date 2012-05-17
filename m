From: NeilBrown <neilb@suse.de>
Subject: Re: [RAID0] Possible bug in raid0_make_request() function
Date: Thu, 17 May 2012 17:09:58 +1000
Message-ID: <20120517170958.5ea15635@notabene.brown>
References: <CANSbrrqyj6wL=VBHdgDP7mpjRc+tjZnCQ6rP3_4vHYtPQPqcEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pPGwZLvWNtm2EjsO+ZgEg1j"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSbrrqyj6wL=VBHdgDP7mpjRc+tjZnCQ6rP3_4vHYtPQPqcEA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anuj Goel <agoel@cs.stonybrook.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/pPGwZLvWNtm2EjsO+ZgEg1j
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 02:50:28 -0400 Anuj Goel <agoel@cs.stonybrook.edu> wrot=
e:

> Hi Guys,
> I was going through the RAID0 code and found that there could be a
> possible bug in the=A0raid0_make_request() function.

Thanks.  I love it when people read the md/raid code and report what they
find!!

>=20
> Consider the below snippet of this function.
>=20
> /* This is a one page bio that upper layers
> * refuse to split for us, so we need to split it.
> */
> if (likely(is_power_of_2(chunk_sects)))
> bp =3D bio_split(bio, chunk_sects - (sector &
> =A0 (chunk_sects-1)));
> else
> bp =3D bio_split(bio, chunk_sects -
> =A0 =A0 =A0 sector_div(sector, chunk_sects));
> raid0_make_request(mddev, &bp->bio1);
> raid0_make_request(mddev, &bp->bio2);
> bio_pair_release(bp);
> return;
>=20
> In function bio_split(..), if mempool_alloc() fails, we return NULL into =
bp.
> Now the call raid0_make_request(mddev, &bp->bio1) does not check for
> bp to be not NULL before de-referencing it.
>=20
> Could this be a problem ?

No.  mempool_alloc can only fail if __GFP_WAIT it not passed in,
and bio_split calls it with GFP_NOIO which contains __GFP_WAIT.

So the=20
   if (!bp)
      return bp;

at the top of bio_split is completely pointless - bp will never be NULL.

NeilBrown


>=20
> --
> Best Regards,
> Anuj Goel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/pPGwZLvWNtm2EjsO+ZgEg1j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7SkRjnsnt1WYoG5AQI+Xw/9HWnoPRDN++pftA5n5gPf0jeL4oV/vxK6
MQeglMrwt27wd6XT0ioiI7sv42j5re+EFWXr3yk0C7UgF4WImbwlmjYwskBUGHY3
3yFTdxto90nJweh+KdmELW5i5pB/V63eMPCW16sfXAGt1nocAX6aNbbq8e4RFAsR
8ZgmP6zf6Ru1s3rLcVpuxmaF3zhn5qcai6LvSl7zNXYS7jK7+5k4m1ZkgiUVoY+d
sL4IvHxd2OcQD1lYF19utST47SNkHIUACRixOrvSK6G79t/p3yov5nqDZu3HJMYH
k8SxI7jDSo99pTZTjm2f2Nk8OjQ8rKZBLaoQmab1wm/EnvT2+z/+J3B1eh2aZOv0
JAGGZTB+93r0VUJZNMfEkCyN7t/bPiVrYtXNE2vVFzaMWlpnEtlDDdql/fTJjYyT
aeW011+kShbPmtDyLS1RWDa/hvjvffFijzQFfhp0bEuVwNKuOQdN3CAt44V+7mbW
bSdzT9ipGxv8ehqgv/Qew78HClyPpbCVzl0z2VK9yxeQeonrUQg3irymjQJE+vsb
PSQMEzm4zOwlXRb9dYTbFGpzKigMuTox4AsFccS2iz4ig4TtuEkrLPXXJS6JdIme
ovn1yQs5EieNSN9dRYkQGep0yzbEU8+8+2Wybdq0SNevL2i5qR9gn3VRyAvgklnK
gQ2+kBB/jDE=
=/tmM
-----END PGP SIGNATURE-----

--Sig_/pPGwZLvWNtm2EjsO+ZgEg1j--
