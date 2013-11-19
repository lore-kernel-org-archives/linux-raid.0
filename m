From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] raid1: Rewrite the implementation of iobarrier.
Date: Tue, 19 Nov 2013 15:25:06 +1100
Message-ID: <20131119152506.3b60f52b@notabene.brown>
References: <201308281940511854138@gmail.com>
	<20131024125059.1a440152@notabene.brown>
	<201310290930116677124@gmail.com>
	<20131031133314.522f30ad@notabene.brown>
	<201310311114307462606@gmail.com>
	<20131114174438.7f2db666@notabene.brown>
	<201311151029513246491@gmail.com>
	<20131115144211.5ac78deb@notabene.brown>
	<201311151454593252903@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7K=0K3EXfRWxmjqQOWP3bJx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201311151454593252903@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/7K=0K3EXfRWxmjqQOWP3bJx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Nov 2013 14:55:02 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >If you can send me the updated patch in a day or 2 I should be able to g=
et it
> >into the current merge window.
> >
> >thanks,
> >NeilBrown
> >
> Thanks very much neil! Below the latest patch.
>=20
> Subject:raid1: Rewrite the implementation of iobarrier.

Thanks. I've applied that patch. I also cleaned up some of the formatting a=
nd
clarified the patch description quite a bit.

NeilBrown

--Sig_/7K=0K3EXfRWxmjqQOWP3bJx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoroIjnsnt1WYoG5AQI8XQ/+MhcPKK4Xp+ifJj5msj1baCpXZlbvLxx/
ZLD/20cSV5A4UWIJTVyrAR/G9q6ik8lfTQNa/sre1xuSufzmjY6byZFc/OV2RP66
xAoK3NOoonCIZjkcracvDTJDERHOFPvtdtRx10xZ3YuZH8IcCC4qoy7fcT6+u7Td
83RfE1c2eHSBibHxSxAL+uQNNP4dFNSW2oZ7yj1MnQ5ujAK9XIDkU03fcPLGVUrd
Ww8aORVLb7jyuDclD1JmfefiPEC9KyCff9tSe7KIUiAO3NAUjx/KTG+yONa+9h85
7RX0NeQUaIrbrkaXpoiKqiTMZcG7pDnwCWsibWxZjjs2qJKIElDdaX+XGCbuwDS0
3OaZwr6W/wO12OnZiNgWdje2qvMThIKGxc19UuIa4PRe2+GsSmN+SM7xVeKpXwVc
mz6uGY6VFHk5HFtm7WJHRRfEKbnP68wy22XmKKNF5FNkJGT105fuu7aWEDGoJsiP
5G1I4i3gAGNrULJbzYHhduCOuMxhQGxrYDMnxaA//eX86O3/flYjkX4mPdDjzzDL
ZxCyMcv3DXCQTexzi8xKtGhyNVg1334RzlMFVLsXgdjC2WgeWuKMeJ+HH6YYBkRg
4Cp6WEDyGvU43k52TWHZIvWlx35Fp/W1i/FKHKpD+ZsPeqJ6qeRt9So6t4NHoe50
Az/hY1i4TxE=
=TXBS
-----END PGP SIGNATURE-----

--Sig_/7K=0K3EXfRWxmjqQOWP3bJx--
