From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.2.3 and adding metadata 1.0 bitmaps
Date: Wed, 11 Apr 2012 08:59:44 +1000
Message-ID: <20120411085944.0c2e4b5b@notabene.brown>
References: <loom.20120410T165425-854@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qKL=9RhlQ2UqxAsEULjhNpr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20120410T165425-854@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <jdl1291@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qKL=9RhlQ2UqxAsEULjhNpr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 15:40:59 +0000 (UTC) Joe Lawrence <jdl1291@gmail.com>
wrote:

> Hi Neil,
>=20
> I'm testing out RHEL 6.3 Alpha which is shipped with mdadm 3.2.3 and kern=
el-
> 2.6.32-257, which may not contain all the latest md bitmap fixes.  Before=
 I go=20
> diving into the upstream vs. RHEL kernel changes, I thought I would try t=
he list=20
> first.
>=20
> The problem I'm seeing is when I try to grow a RAID1 array, adding a writ=
e=20
> intent bitmap to a metadata 1.0 array:

Hi Joe,
 I haven't had a proper look yet, but does:

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3Dfbdef49811c9e2b54e2=
064d9af68cfffa77c6e77

   Bitmap_offset is a signed number

Make a difference?

Thanks,
NeilBrown

--Sig_/qKL=9RhlQ2UqxAsEULjhNpr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4S7YDnsnt1WYoG5AQJDog//YX8x+Bp2Rm2XPFbtQIdOnc057ArN3TMP
/7q2/iQSWnV8h/C9rhZZOSiAwH8eg8Yx0tn9Lutl2sNoUNSPnRFrJvxBWE+JFHhj
hNvnbVleyInh48/0saqO5x7/TOUDPE8czZV/6AxMj4U4rUfOut23cCj0sEloK3ZK
WhDXnsZMdiueJLfdCtW7R/7T9XPHMcLaLXHAlvuwQJiEInocgNzClzWqUEuxjuzL
3GEWFmUgPCFQ9glQ5g77Pd3B/C+Ij4ARWDD90pQJvsD1qRznA58BJlguDVI1JB+u
Pw6Q/wRraUTZoYgxzYWRCBSfph7nW4ex5ox/Ojc26fxiHo5XjqPypzIGLnf/6edL
vlxCafA58VmOEPdK8ro7/RAv/lLJZ3ji6X3bs1PiVpqMuqcTcSvUizaQYKkR6IdS
F7bUFIfEMTllv576PXhoh9UEJzDvSCr19bssmEjysljqmDVQqa0u0QOCVz/3xktF
R6KFYyXrpdsBV6rjm21CYPZXXw1muMg3r68QJJ28tGX2G1yF1SeDLx5NypGXMDO1
PBTkdWT+QvkCvgAONZa+CUUwTpCBdUcIqLY9Us0oQqsloSjkGC4yEmWJ1dsY4fFD
Vv1LQCpjDeJ+JzRvESSJ1amKf7nZMVTiDD0Lte/2uQM5xq7F18ZP1suh5rUz1I98
5YP50UA3QVg=
=qto4
-----END PGP SIGNATURE-----

--Sig_/qKL=9RhlQ2UqxAsEULjhNpr--
