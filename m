From: NeilBrown <neilb@suse.de>
Subject: Re: migrate to bad block list
Date: Thu, 16 Oct 2014 17:54:14 +1100
Message-ID: <20141016175414.01334582@notabene.brown>
References: <E1D69AD765F9D841B8DE87D96DD21E4505DFBADD@AEMAILMBX02.lenovo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Yr4HBRvSGz2IUn=L239sauX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1D69AD765F9D841B8DE87D96DD21E4505DFBADD@AEMAILMBX02.lenovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ryan <mryan@lenovoemc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Yr4HBRvSGz2IUn=L239sauX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Oct 2014 17:18:19 +0000 Michael Ryan <mryan@lenovoemc.com> wrote:

>=20
> Is there any way to migrate an existing array created with mdadm v3.2.5 a=
nd using 1.1 metadata to use a bad block list?=C2=A0 I'm assuming not as th=
ere wouldn't be space reserved for the list, but I need to ask.
>=20
> Thanks for your response!

mdadm tends to leave a fair bit of unused space on devices so that things
like a bad block list can easily be added.
If you can stop the array, then do that and re-assemble with
  --update=3Dbbl

and you should  get a bbl added to each device.

If you cannot stop the array, but it has a bitmap, then
you can, for each device:

  mdadm /dev/mdX --fail /dev/adevice
  mdadm /dev/mdX --remove /dev/adevice
  mdadm /dev/mdX --re-add --update=3Dbbl /dev/adevice

I think that should work.  The "bblk" is a feature of the device, not of the
whole array.  So you can add it to each device.

I haven't actually tested the above I think, so it might be safest to make =
an
array with loop-back devices and experiment.

NeilBrown

--Sig_/Yr4HBRvSGz2IUn=L239sauX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVD9rljnsnt1WYoG5AQI3IQ/+MeskICTD6UOMihoe7rX9QjTeuTpwKv7o
xsIxL3/zaj1IOu5PjoAiCV9fCV/gC8Rd589z4jAW/VLjEOmYjqw+3ayGnQ2hlHuf
mXyLz1cQ0NsVliIKMdEIuL62ka98NZUSkpzlH6cUBZ0TvElCj21lzyMTFqyGrHOh
6GsbokzIpdvXX4WUjUCwCcorqNO4K31MhnTSgb4/GofojkI9gTNJOsf8s7fK1tyA
9uEMtMxgnYq46TAVaN0iP39oTdF0+g4wgz81zc/RKI7CmEo62GJVp7c+Z0R+nTms
qtl5WEoe4w4ZP8SLsGi6q/xAclfjXfQYo+wfE763O6B3hQoBhs3MdQtlbrkVXuhc
seNDi7/8gXAZ4nlqPsnRyiu2M69SkMinafP0hgYo5vQsnBT5ugJ4JeJ41T48ueON
iyriNgY06aBNMao1wXjlLhiqwHlRC+jV2OPY3XRVp64rSJOhpVoc1FMn+Pp/px9Z
Xcq0aBpj1pQdfpqSvQ4Tyj4XjHlcFsupbm0DysUEhzRBJKF+i+HxUI7fDGIc20KF
n+TyYGH02hP8jirg2Rkci1Or8JuRKisjUjIO23x5sWDi2Og6ovF70SIk+85fD/Yj
KM8y9o/IDPIjTNU4HLKmZTyo+VKf+lQAbP1jeh2b78nKr0JFva8BpXU5RyB1y+Aa
mQVAGxn4IeU=
=yqYP
-----END PGP SIGNATURE-----

--Sig_/Yr4HBRvSGz2IUn=L239sauX--
