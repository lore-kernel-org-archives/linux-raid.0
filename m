From: NeilBrown <neilb@suse.de>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Wed, 18 Jul 2012 09:34:58 +1000
Message-ID: <20120718093458.5e783b4a@notabene.brown>
References: <4FD7738D.3040403@shiftmail.org>
	<CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
	<20120716134138.0f1c9cfc@notabene.brown>
	<5003C5BC.3070609@shiftmail.org>
	<CAGRgLy6udWWhYn_UEwyyVrKsV5auAdfN5qkLVxbNnVqgWE=+UQ@mail.gmail.com>
	<5003D73B.3010609@shiftmail.org>
	<20120717114916.46263d92@notabene.brown>
	<50052099.4000401@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/il/9gVKtoa_tmFweKuARLb."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50052099.4000401@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/il/9gVKtoa_tmFweKuARLb.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jul 2012 10:21:45 +0200 Asdo <asdo@shiftmail.org> wrote:

> On 07/17/12 03:49, NeilBrown wrote:
> > On Mon, 16 Jul 2012 10:56:27 +0200 Asdo<asdo@shiftmail.org>  wrote:
> >
> > Yes, there is a degree to which your data is at risk. This is always=20
> > the case with new code. If you upgrade to new -stable kernels as they=20
> > become available, that should minimise your risk as any fix that could=
=20
> > risk data or stability is backported to these -stable kernels.
>=20
> I am on kernel 3.4, that's "stable", right?

3.4.5 is the latest kernel in the 3.4.y stable series.
It contains:
 - a fix for bad-block handling in RAID5
 - a fix for a ref-counting bug in RAID5 that can trigger when updating
   the bad block list

So if you are using bad-block-logs on RAID5 you should definitely upgrade
to 3.4.5.  If some other level ... then it is probably a good idea to upgra=
de
anyway.

>=20
> > I don't know of any particularly serious bugs that have been found - th=
ey
> > mostly are triggered by unusual conditions.  However unusual conditions=
 do
> > happen.
> >
> > Thank you for using and testing the code.  Has md found and recorded an=
y bad
> > blocks for you, or are your bad-block logs still empty?
>=20
> Still empty for now
> They are filled only on read error + failed block rewrite, right? That=20
> will take a long time to happen...

They can also be filled on a read-error during recovery of one device fails.
It is quite likely that none of this will happen for years.  But it might
happen tomorrow.

>=20
> Thanks for your work
:-)

NeilBrown


--Sig_/il/9gVKtoa_tmFweKuARLb.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAX2ojnsnt1WYoG5AQKd5g//SdvMHpDIwghhRUBRsAH8dGQwKWfyblgT
/0cWTM48Kkcmgnay1hVbTMV6lY/gj3gLEn1xQ+haDYwZMcd7CZTVfyVmf+nE5zf2
oOn8jj2SjNDFktUMP82rOyzfrjc/9beNBNTe2bkO+Okw214vdtw+PS9pHemc6eh9
LJ3VXHTubJmQSzVS0Bi0x6F2oqkrisWzuPHxYvK705UG9+FbDUSzZbYzkycYUKEd
/pLZtJY4Kx5omdJVMfqUS8653gfsW9Y1I8Yt2pMbs+pamSJaTYNOqdD62Q5UTEby
k08e6vSaMk+kTehsXjXo6s3t0T5CV5U5kw9g++mnl7MQmj+WDJ2BP/RI5r6BSLRI
rmTRCIkoTU/g3sGRKOxBQm91/5o1A+rGRWYhmSBcL2P5aoQifrVxGnyFiIYh/uS8
S1hzkHuXVOKiHJDXsjFVflFHiztjfAyCVaOFhP0skC2xu27b+QcOei9zO7iSQnhw
IL1+kHraau10p+mfBVj2vBFXEcZF/9a2e9T/b5I6m04GvUIRkHqNTvPg2Ag6zxrS
0TVx2zTYwru7WNMEOB8nsLr+ni7TDa2/Q+2UEEnoDQdUqRnh7dvmhsr5Iuos7XNA
Vb7CEVtyYG4nvQ80I5gz9Cx2Ch9vP3sG13/PAscNd73cRVYW2s8CVpn8uFq0quBj
r9cEsEEznjM=
=1TlZ
-----END PGP SIGNATURE-----

--Sig_/il/9gVKtoa_tmFweKuARLb.--
