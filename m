From: NeilBrown <neilb@suse.de>
Subject: Re: [PANIC] : kernel BUG at drivers/md/raid5.c:2756!
Date: Tue, 1 Nov 2011 17:29:46 +1100
Message-ID: <20111101172946.1bf765f4@notabene.brown>
References: <CAE0An6cvpqD8oPiHr2CAb753hC=47BYErOwAxaXoeHOYPaVznA@mail.gmail.com>
	<20111101163931.4d85e330@notabene.brown>
	<CAE0An6em5crdkSJOLHSB85fQ95Br5HRmu3pa-E4O10X5y7vr9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o1O+VrKQIT1kZZ/JgZUV+DS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE0An6em5crdkSJOLHSB85fQ95Br5HRmu3pa-E4O10X5y7vr9g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/o1O+VrKQIT1kZZ/JgZUV+DS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 23:09:04 -0700 Manish Katiyar <mkatiyar@gmail.com> wrot=
e:

> > I think you were quite unlucky to hit this and that you will find it ha=
rd to
> > reproduce. :-(
>=20
> Well, its always reproducible on my ubuntu when I run that script.
>=20

Excellent!!   That means you can reliably see if the patch fixes it. :-)

I guess I was thinking of 'real' devices which are slower than XOR.  You we=
re
using loop back device on files in /tmp which are presumably always in memo=
ry.
I guess it would be a lot easier to hit in that case.

Thanks,
NeilBrown

--Sig_/o1O+VrKQIT1kZZ/JgZUV+DS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq+R2jnsnt1WYoG5AQI0lA/9EKt+Y/+iSq5+wNWhWxsuoK4vFiE5CvSL
mlBcUywz/3g5DvGrNW+D5SVGCvWyLv2BLL3Skd5rT1Fo8rzWzQiOUv03A+OmjA3h
RTD6HwWsblWUJ5ZvrSm5m+VRInL6/eP5XyGneacZNTa0mzEZWXdwSvLHZG3Ktsys
SXhdQ2E2mNAVvGAn8pwJG6d8c2vSaoUAt2JUXWjJKfUcu+LN2W5QvzPbxq42hitK
wD5rXOYHWyUsUcDOSAFqdfuugUGw8ha7YVCW6pVEtzJnEZpQmBkeVXn5Hfn/xQot
62pYuTmBgkePUS0Q92D34FUr0RqzS5HnsybqxDzIquAv0epuuXCTiFoSzj1T4UNa
8NNa0vTLMDLpHih8tFfCQLkxE/07mjK4C7InnYemJKSw4swEGjs7pKZGPjZDQ5Aj
7vIlB2lRN/nT/hx2dLTzYQIrqJ8IirFSKMSmhkSwICAl6lw66VQBIBAy05i+Xdqr
NiAva5PkI+Zf9Tnm2JHtMtPY1F4iPaU8zHmp5tyqQEtuCPccjCXMQrkLwHjW3HIp
Gdh0F9/UaMvSv6mpPFJiZAd38DPuRPOcUq9OmzybDFa4Q9u0tGh85hueNf5nxi3Q
yFLctf6V2FJsDBJV7yTpKy7wiOyPjtSwZiZMA1R/8Bxi9o/TlR6g8JNFrjKROKqD
MQBeC+ibaJY=
=tnEm
-----END PGP SIGNATURE-----

--Sig_/o1O+VrKQIT1kZZ/JgZUV+DS--
