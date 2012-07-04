From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Wed, 4 Jul 2012 11:45:20 +1000
Message-ID: <20120704114520.547d917b@notabene.brown>
References: <20120613091143.508417333@kernel.org>
	<20120628190352.4dc1dd76@notabene.brown>
	<CANejiEWfR1S+F5GT7Bxhi2ig8ef7ZziAbVebM_DT3-_3hftYUw@mail.gmail.com>
	<20120702073645.GA785@kernel.org>
	<20120703085858.GA829@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ne_gkNng9XRt2IktF9r57Mm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703085858.GA829@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/ne_gkNng9XRt2IktF9r57Mm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 16:58:58 +0800 Shaohua Li <shli@kernel.org> wrote:

> Looks you merged the patch to your tree, great! The raid1_unplug() still =
lacks
> blk_start_plug/blk_finish_plug.

Is that needed?  raid1_unplug will be called from a context where there is
still a plug active.
That is one aspect that I need to carefully review - make sure that requests
submitted from unplug also get unplugged etc.

> Will you add a similar patch for raid10?

Once I'm sure that that raid1 patch is good - which requires more study and
testing.


NeilBrown

--Sig_/ne_gkNng9XRt2IktF9r57Mm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/OgMDnsnt1WYoG5AQJSQw//ayDUL1jS65CWfHZL/75pP3cOgZDictHW
AobRTEN8BOwSkcO1cJPPpi/nuNskRGj+YAdWgtcUHInK2S0jmPF7NAbn/CoQsiUk
sLbn+VKCxnfVC8Sy0cdB/yHm9f0eVPSM3xDJyTcYRxkAVR1NlFSl0YrKN3ppGuWR
FMuVKgxDXSAqvhq0uf48TZRgpXrD14ozInl0b6TJGvuyHlxXCRbFQ89NuPjFhEIu
F8zjj4XZCOc0artyb4/73POs7rxUM4y/aSIpK/hhp8JLkXApnV1gkSwUG65ieZ1R
zkths6NEDtS509k9nHg7I3L30kFpyWVz7Kyb+/UL579vMuYWDvMO5Wk6rZwQQ6Nn
rbz6N/I/y1rdnqIVGgR667vC3dnjapIWp/O904FjKoxN3vA9vtGCBTdM4TqaX/Mf
BDTkTyuSnWJIdD8rmkaglpS8RbD5LeipIL/R9g4zgAZ16xzp0+LCvjf9h8Poix1Y
4+Rt+ypo5BaUfT5INh3Padt2jiwYqnp74VsGOle3dXGSAbamCEcRKWo5qF02u6+o
OLEeBgwRsap6UPryg+eDy1aZig4g1atYqxlQQmCA80VNaLk90Zmc2/PGsH5pqAGT
BAKJL7FIobCzauQtbBrOFO6Sn3p2D6M2QzOSZsB01t3orsyecHDVigjryzrMASqk
8hvFaC6ZbsY=
=PXZl
-----END PGP SIGNATURE-----

--Sig_/ne_gkNng9XRt2IktF9r57Mm--
