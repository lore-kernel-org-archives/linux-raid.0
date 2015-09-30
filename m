From: Neil Brown <neilb@suse.de>
Subject: Re: raid5-cache I/O path improvements V2
Date: Wed, 30 Sep 2015 15:39:52 +1000
Message-ID: <87vbaslb2v.fsf@notabene.neil.brown.name>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <D21C6812.74CB%shli@fb.com> <87a8so6t8f.fsf@notabene.neil.brown.name> <20150915215458.GA1943628@devbig084.prn1.facebook.com> <20150928140127.GA30927@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150928140127.GA30927@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Christoph Hellwig <hch@lst.de> writes:

> So the summary is that for now you want me to resend with a patch
> to opt into using FUA?

I'd like to avoid "opt in" if at all possible.
Shoahua measured that using "FUA" for all writes to the journal
hurt performance on at least one device.  Do you have a different device
where it demonstrably helps?
If there any chance of automatically detecting which is which?

>
> Also do you have a git tree as a baseline somewhere?  I've been collecting
> the patches you've sent, but with increasing time I fear I might have
> missed something.

(almost) all at git://neil.brown.name/md in 'devel' branch.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWC3WoAAoJEDnsnt1WYoG5JIkQAJ5+amQTLkjZf1GdLSJC5HNF
CZEJpdenojzm9OGEu4zxT0JhQ5CFJ8Uk5TNdOxEbxIzjs9+N+I2XPYGgtjos6TqE
vmLthhyNzxBDWF3ubwJoSm1BYUn7Po/YOLw8BZZXksCRoI+VCEJ6vpDSv2lykU5a
u8W9bQhWYtFTYg5pP9dEYQoL10teY2OlarfaEeKcmRw6HF3RGSSsGKvZsq0EYhnZ
em2K/iLmN1DUp1TwDqWQIHlEOu9ARrIj4lg/xut7cayNgTt1FvhYHswc02ACcz5u
mRaj9Np6CCsRbNLYQljwY/FMYpAQRHA32yrGzgJNGP15NhPmaCfU5fajftAdolb8
ihh1K8qvnmZYDWj88eA6oX7MKBLQ427WcACA1n/33Icp4buGn/OTD6rYhVMsc4+G
miV9QkP3vULMHFZtlq5SdXBH+p+DNcjpD7R/1G3o/oCnIfHH4LVXky8mOykLS4Ui
oYcX+hLhvb/T+gTUdGDtl9WdS+M6fdQKNBuBz9ehhGeqSJ6MpkFdzXA8fJ7hxknl
kDo+IV8oK7h3OGfogHsSpCInlul5sYbM0eqU0Hth92AnUM2O2PuvpzXlBXaTjrTb
eHAN/xwTcvPYeJD3pxtXK3WfxeXZrbHjTVX0VIcPBYGG0e6J3+HX8If7T73lXhxG
CyAM0YYa91wzszOEkOQ1
=Ey3n
-----END PGP SIGNATURE-----
--=-=-=--
