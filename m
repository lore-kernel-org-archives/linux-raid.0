Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E79D264
	for <linux-raid@vger.kernel.org>; Sat, 23 Dec 2023 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ES440BYq"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20231223125810euoutp01516a048cbf288fa2d256fe88c926a5f3~jd1TcbDtQ2334823348euoutp01n;
	Sat, 23 Dec 2023 12:58:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20231223125810euoutp01516a048cbf288fa2d256fe88c926a5f3~jd1TcbDtQ2334823348euoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1703336290;
	bh=nNMljelH4wKtz2xGNCBMABXAJY1CPhYOjDF6j8rauDs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=ES440BYqcAmW3ptN/upFnTmaCQTv/Myy8LVgBW81tpx+WuqItYtnuK2Rn/q8JCWTO
	 SggMizbEeiu16XAEpArsreAU0ZA0BzedPSkRbAQHpm0sVJ34nz2xvQpr2PI0kvMrv4
	 ISpIRkzAecVTkJ2jJtxAlOOVHSwAs/6bJMgtNeGA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20231223125810eucas1p1974e66e4aa53b09fdc46603aba940f50~jd1TEtgZN3151231512eucas1p1_;
	Sat, 23 Dec 2023 12:58:10 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 58.CB.09814.169D6856; Sat, 23
	Dec 2023 12:58:09 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20231223125809eucas1p2d065d918e7612783a3893b2fcb45ffbe~jd1SszJGy1966619666eucas1p2g;
	Sat, 23 Dec 2023 12:58:09 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231223125809eusmtrp2e2419f18d52e5fb665d5dead37f90a01~jd1SsTz7W1352713527eusmtrp2b;
	Sat, 23 Dec 2023 12:58:09 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-7f-6586d9611c4b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 65.30.09274.169D6856; Sat, 23
	Dec 2023 12:58:09 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20231223125809eusmtip21eb42e189a9556c32f1df343be712037~jd1ShM0T_2177421774eusmtip2E;
	Sat, 23 Dec 2023 12:58:09 +0000 (GMT)
Received: from localhost (106.210.248.246) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Sat, 23 Dec 2023 12:58:08 +0000
Date: Sat, 23 Dec 2023 13:58:02 +0100
From: Joel Granados <j.granados@samsung.com>
To: Coly Li <colyli@suse.de>
CC: Luis Chamberlain <mcgrof@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
	Song Liu <song@kernel.org>, Kernel.org-Linux-RAID
	<linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] Revert
 "raid: Remove now superfluous sentinel element from ctl_table array"
Message-ID: <20231223125802.bhokls6a4ltpt4kh@localhost>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="zksrcfdhaggggcti"
Content-Disposition: inline
In-Reply-To: <28E06ABA-0861-486A-9C7F-2C3D4E7F0AED@suse.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7djP87qJN9tSDR7usrCY3nie3aJ9/i5G
	ixsTnjJaHF/+l81iXt9sRos5C9kc2Dxajrxl9fiys5/RY9OqTjaPzaerPT5vkgtgjeKySUnN
	ySxLLdK3S+DK+L79HHPBFdmKJ4/aGBsYX0l0MXJwSAiYSKz/rtjFyMUhJLCCUeLe4gZWCOcL
	o8TmH3OZIZzPjBIPJ8xn7GLkBOt4df8JE0RiOaPEjdfPEKqWL9wIldnKKLH13DewFhYBVYmP
	J3Yyg9hsAjoS59/cAbNFBGQktp+5xQ7SwCxwiFHixf8Z7CAJYYEkiQffVjKB2LwC5hKX2p4w
	Q9iCEidnPmEBsZkFKiRWvlrMBPIFs4C0xPJ/HCBhTgFria1fHrFCnKoscfPXO2YIu1bi1JZb
	YMdJCHRzAv3TDZVwkdi2bis7hC0s8er4FihbRuL/zvlQDZMZJfb/+8AO4axmlFjW+JUJospa
	ouXKE6gOR4kTFx+wQcKVT+LGW0GIQ/kkJm2bzgwR5pXoaBOCqFaTWH3vDcsERuVZSF6bheS1
	WQivQZiaEut36aOIghRrSyxb+JoZwraVWLfuPcsCRvZVjOKppcW56anFRnmp5XrFibnFpXnp
	esn5uZsYgenr9L/jX3YwLn/1Ue8QIxMH4yFGFaDmRxtWX2CUYsnLz0tVEuHN12lJFeJNSays
	Si3Kjy8qzUktPsQozcGiJM6rmiKfKiSQnliSmp2aWpBaBJNl4uCUamAyaE67rxNWXz/zqZ1I
	vEjNVseA3DSzCx/tElo5y7m2LtzCUrtWsn3ZVS3RLqZd1ZPXvXzyeqWf3CX/Nf3MspxTXct4
	BUo618x/seiayKX7S1p/BcX9+HMn7m3b/r9JTCE9t1ceC/g68b9q5c73WuzRFvafHv5QPMYl
	fYUryjB8o2Xqtu2MJ6zzjuv++LD4vNbFbTOeTyzxn/l1gb7sveJzq1h5v0VtkBN/Grjh+OtK
	Fm+FjbefhQUkHfGI+yL28FeJYaOX9WwJO57/jYcS56+uena/dVfe22WpTe9WnP1V1/jYNNem
	IuvP7hLD53G/entypHZOi3t36eLJFb7Pr/U+ykntevAhWmXqokN3kwt0lFiKMxINtZiLihMB
	9om2OdoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t/xe7qJN9tSDf4uVrSY3nie3aJ9/i5G
	ixsTnjJaHF/+l81iXt9sRos5C9kc2Dxajrxl9fiys5/RY9OqTjaPzaerPT5vkgtgjdKzKcov
	LUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DL+LnzOlPBJdmK
	5mn3mRoYX0h0MXJySAiYSLy6/4Spi5GLQ0hgKaPE3WXn2CASMhIbv1xlhbCFJf5c62KDKPrI
	KLHh7laojq2MEst/zQDrYBFQlfh4YicziM0moCNx/s0dMFsEaNL2M7fYQRqYBQ4xSrz4P4Md
	JCEskCRxpv80C4jNK2AucantCViDkMAKZokNq9gg4oISJ2c+AathFiiT2HGhFyjOAWRLSyz/
	xwES5hSwltj65RHUpcoSN3+9Y4awayU+/33GOIFReBaSSbOQTJqFMAkirC7xZ94lZgxhbYll
	C18zQ9i2EuvWvWdZwMi+ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzCKtx37uWUH48pXH/UO
	MTJxMB5iVAHqfLRh9QVGKZa8/LxUJRHefJ2WVCHelMTKqtSi/Pii0pzU4kOMpsBQnMgsJZqc
	D0wveSXxhmYGpoYmZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTO47mTUK9+/y
	MTsiqC/BNyOG78e6Qx09abNfB5qJFvmWn/9bOHvtSYW7TdqCPs4Mgs6BKifaCvYW1F866b5m
	weIUoxThKsm41iUsQqoH3s6OLfLIeZ3we87avBOVZ1dmiitvumZ3JHDhkVWyf/XW2xq13ne4
	8nJFrbXSDJfiJiWzO3r3Fj71iAgI2DTpjvBHsR1LQnjdOqNuM98/amx09ci1Wd1VS5Sv5TbO
	1JB8W3lt4bJ/x+e3x9rPf7Krmr/XVvr6Ww+5+HuJM1lvHHQ/FTCXcUbUnPt/RUpTQph4C7zf
	TXXqtOje0Pdf6GnEX9+jvXEMIX8ulbs49bJtX/1z2SIeA7V7mUwTHKfoTp9to8RSnJFoqMVc
	VJwIACxtf0h3AwAA
X-CMS-MailID: 20231223125809eucas1p2d065d918e7612783a3893b2fcb45ffbe
X-Msg-Generator: CA
X-RootMTR: 20231222173129eucas1p297a35e505eb08c27963ab4bf7ff1e9b6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20231222173129eucas1p297a35e505eb08c27963ab4bf7ff1e9b6
References: <20231221044925.10178-1-colyli@suse.de>
	<aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
	<ZYSPS+yUlzTYETgh@bombadil.infradead.org>
	<B44FA0F9-2A85-41C7-830E-C552E796222C@suse.de>
	<CGME20231222173129eucas1p297a35e505eb08c27963ab4bf7ff1e9b6@eucas1p2.samsung.com>
	<ZYXH5vtBkkHRaVJ2@bombadil.infradead.org>
	<20231223122523.auzswchtrsrlc5vp@localhost>
	<28E06ABA-0861-486A-9C7F-2C3D4E7F0AED@suse.de>

--zksrcfdhaggggcti
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 23, 2023 at 08:42:35PM +0800, Coly Li wrote:
>=20
>=20
> > 2023=E5=B9=B412=E6=9C=8823=E6=97=A5 20:25=EF=BC=8CJoel Granados <j.gran=
ados@samsung.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Fri, Dec 22, 2023 at 09:31:18AM -0800, Luis Chamberlain wrote:
> >> On Fri, Dec 22, 2023 at 06:17:47PM +0800, Coly Li wrote:
> >>>=20
> >>>=20
> >>>> 2023=E5=B9=B412=E6=9C=8822=E6=97=A5 03:17=EF=BC=8CLuis Chamberlain <=
mcgrof@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>=20
> >>>> On Thu, Dec 21, 2023 at 02:19:56PM +0800, Yu Kuai wrote:
> >>>>> I can't find this by code review, and I think
> >>>>> maybe it's better to fix this in sysctl error path.
> >>>>=20
> >>>> Indeed, we want to fix anything in the way to remove the empty senti=
nel,
> >>>> we continue to do that in queued work on sysctl-next [0]. Although I
> >>>> won't be able to diagnose this right away, could you try the out of
> >>>> bounds fix by Joel [1] instead?
> >>>>=20
> >>>> We want to identify what caused this and fix it within sysctl code.
> >>>>=20
> >>>> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git=
/log/?h=3Dsysctl-next
> >>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git=
/commit/?h=3Dsysctl-next&id=3Dfd696ee2395755a292f7d49bf4c701a5bab2f076
> >>>=20
> >>> Hi Luis,
> >>>=20
> >>> Thanks of the above information. IMHO your code is good, When I cherry
> >>> pick the upstream md code for testing, the sysctl related change
> >>> leaked from my eyes. please ignore my noise.=20
> >=20
> > So this was triggered because the tree was missing the changes that
> > actually handled the removal of the sentinel?
> >=20
>=20
> It was from a regular update of the subsystem I maintainer for our own
> product. This is quite common to happen when a tree wide changes
> happen and subsystem maintainers of downstream products were not aware
> of the changes out of the subsystem.
>=20
> Just as I said, please ignore the noise.
>=20
> How to avoid such unnecessary noise? Maybe the patches to subsystems
> should add more information about the tree wide changes, e.g. this
> patch goes with the core change of xxx, when you pick it for backport
> please also be aware of the changes in xxxx.

I'll take this into account for what is missing from the sentinel
changes. It is good to leave breadcrumbs in the commit.

Thx for the suggestion. Just have to remember to do it when I post it.

Best
>=20
> But this is suggestion and not mandatory, finally the developer who
> partially picked patches for  his backport will find out where he made
> mistake. Just like this time.
>=20
>=20
> > Get back to me if the oops persists even after you have included the
> > changes in sysctl-next
>=20
> Thanks for the help. I do appreciate :-)
>=20
> Coly Li

--=20

Joel Granados

--zksrcfdhaggggcti
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWG2VoACgkQupfNUreW
QU++sQv9HQhuc46bmRk2U2KBpfyLMh8Z4qxAe+TgYiJFz91Z84ANVwPAHuL3h5hi
JUxaAfRfcfYsEzgXi9SbgRsTYIoJieSh8GCid0cUqR9ebc3nyspiYYTIiOl8hbdM
npCkK2xNHWL7HimbA/88/f+FCeBw8rTyEUWHvQnNTAbkOJaapKv2H14+B5sjVNHX
IfWZQxZ58ODnJjeWwP441XmETUmdclJ4L4TgL/Qe7tB2qEee9/umArDsgb5624ad
3sLRIurKPsX7amX07nltiHoE/AD6SYb5hUCI6SqXQl3gSSvzDw8K91mUIIgQLJ6w
H4xWM5dVzudPlYV345Fjn/ElDs3ly97TTRVxlUc9DxK6hQ+peIWtJr4PQwy9f8Mm
QHSbEdZbz5sNZ7fiTXOIRcT30TBpcr9xKRGQrHhy9aNa+cljiPvzy+U0pVKEQxxb
Qla17lmGSHDL2k67IsvxpAXRP2591pp5mCqSrPSC/juWk3u7Al+eqvHWapYNoop5
3yMn/FLU
=WiWo
-----END PGP SIGNATURE-----

--zksrcfdhaggggcti--
