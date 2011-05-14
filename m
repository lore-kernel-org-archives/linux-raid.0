From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mdadm does not create partition devices whatsoever,
 "partitionable" functionality broken
Date: Sat, 14 May 2011 16:24:27 +0600
Message-ID: <20110514162427.143668d6@natsu>
References: <4DCD4A83.8060202@pulseforce.com>
	<4DCD6119.3080705@turmel.org>
	<4DCD67EF.1070602@pulseforce.com>
	<4DCD6B27.70402@pulseforce.com>
	<20110513234055.4307c536@natsu>
	<4DCD72AF.1070809@pulseforce.com>
	<4DCD75FE.8010703@turmel.org>
	<4DCD7E78.6050000@pulseforce.com>
	<4DCD84E1.3040704@turmel.org>
	<20110514013221.552dc8ef@natsu>
	<iqlkfg$1s9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VGffokO2aS/A6mEhw5mrkP6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iqlkfg$1s9$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VGffokO2aS/A6mEhw5mrkP6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 May 2011 12:10:56 +0200
David Brown <david.brown@hesbynett.no> wrote:

> What is perhaps more relevant, is can filesystems see the fragmentation=20
> of the LV's?  I don't know the answer.

No, of course they can't.

> Still, you don't usually have many segments in an LV - if you want the=20
> LV to be fast, you can request it to be contiguous when creating it.=20
> Then you only get a fragment for each time it is grown.  It's a price=20
> often worth paying for the flexibility.

=46rom what I see, the key selling point for LVM is the ability to 'easily'
add/remove/resize LVs. And then if you buy that and start to actively use
these features, you end up in a situation (badly fragmented LVs) from which
there isn't a proper way out. No - backup and restore, or 'have enough
contiguous free space to mirror your entire LV and then nuke the original' =
are
not the answer. What's sad is that there isn't any fundamental technical
reason LVs can't be defragmented. They can, just no one has bothered to wri=
te
the corresponding code yet.

--=20
With respect,
Roman

--Sig_/VGffokO2aS/A6mEhw5mrkP6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3OWFsACgkQTLKSvz+PZwj8bwCfdMlEdBrqM8uuPJCnTBQwVm41
Op8An2o2EwlxbKTRWUzJY6/cfhOKett7
=xJOL
-----END PGP SIGNATURE-----

--Sig_/VGffokO2aS/A6mEhw5mrkP6--
