From: NeilBrown <neilb@suse.de>
Subject: Re: Re-assembling faulty array
Date: Tue, 15 May 2012 10:09:31 +1000
Message-ID: <20120515100931.15d12053@notabene.brown>
References: <1336765276.10557.30.camel@foxtrot.cjac.ntr.f5net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4QJhtf6k+jGxIsrl.=gT5ny"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336765276.10557.30.camel@foxtrot.cjac.ntr.f5net.com>
Sender: linux-raid-owner@vger.kernel.org
To: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4QJhtf6k+jGxIsrl.=gT5ny
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 May 2012 12:41:16 -0700 "C.J. Adams-Collier KF7BMP"
<cjac@colliertech.org> wrote:

> Hey all,
>=20
> I've got an array that seems to have failed while I was re-synchronizing
> one of the disks.  sde fell out when I moved six disks from one chassis
> to another.  I re-added it and it was 98.8% done with 300 minutes left
> in the process when I went to sleep last night.  When I woke up, the
> array was in a FAILED state, sdg was marked failed and sde was marked
> spare.  I removed sdg from the array and re-booted and now the array
> won't start.
>=20
> Is there a way to re-add sdg back in to slot 5 rather than having it
> added as a spare?  AFAICT, no writes have been made to sdg or md0 since
> I removed it from the array, so it should be pretty close to its active
> state.  sde must be nearly ready to be added in as an active participant
> in the array, too.
>=20
> Is there anything I can do to re-build the array at this point?
>=20
>
Maybe.  However I cannot quite intuit the state of the arrays from your
description.
Could you report the output of "mdadm -E" on each member device please?

Thanks,
NeilBrown

--Sig_/4QJhtf6k+jGxIsrl.=gT5ny
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7Geuznsnt1WYoG5AQK7gA/+IQpMnyC1kFoY+pW1R1sOCu99sRekzCo0
ROfWQWV6jhl+/j+dgT5Xw5dAWye1X+KXDhMhAv56NPWcf+rWBIAv73lMvvhS7DYQ
+axNOEsSdN5L6SW5xtp389pHJGRyihybkzcDWIpBga2rKj4hcCnnB+shYon1sI1P
ujmBZdjyO3P4Xu4R4xBMROpOX+vtYg+KOE/y1lHdXuhNVRHfW0Ytaogp4FnjzPR6
2eCUjXW5gNsAtSZ633VLWCAlGSfvv66AH8fqi5nYFTikyrJtP4Kx7brqBVA9JPsf
03RzNXaOhRzipfpffyuXp0oIghAcdI0p5tAP99Ft9cMpZCr4WiCkI84gk4ihgOTJ
xaG0taO69HrU3a9hloLtxdnSr7o5oMVo8Jt+nPsHqAYVvRH8Ru9fYADx/jppxsG+
b57vQx1PM5iDxaJWFCzTAP0pFXkXm38E5qAz7AxQwYLbM4WOGOXKFJgz5PpOulX5
yB9l2AxgoBe3C46XI0bcn4sI+T/On10C6p+fOXuqp/4IIGJJd93NuS5Tq29B5L25
8BLJNzH1xkHJ8g0PwnbzCI7qW1eBg+kWYGBHqUQPgD490wwKVSn3jTboI9tfZBII
sj5feG1qFvL5bQMDkl1EdBDPqt3i+51Ar9h96k+HPPuk2aA48uGWTzrtcYvoQMuk
kvYCf21yF9w=
=0Uv3
-----END PGP SIGNATURE-----

--Sig_/4QJhtf6k+jGxIsrl.=gT5ny--
