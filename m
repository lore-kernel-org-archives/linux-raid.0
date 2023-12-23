Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCDED264
	for <linux-raid@vger.kernel.org>; Sat, 23 Dec 2023 12:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MyUGvtoI"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20231223122529euoutp015ceff9c0edb9918bed2b0b87b3f0a5cf~jdYxQxb722736927369euoutp01R;
	Sat, 23 Dec 2023 12:25:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20231223122529euoutp015ceff9c0edb9918bed2b0b87b3f0a5cf~jdYxQxb722736927369euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1703334329;
	bh=SQY5wmi/MzCNn47FJoO8ieo1PtaOGMVq9yBRKaGBBCI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=MyUGvtoILoqiMvEdrER8M2VuC4U/7yReD21+M82BSj/Z259M5WrS5DDH4eMKwC2ZH
	 zjusp3DkN61LpKPe3zgq9oV/oytSr3IYBWykTVhyRIiAqicqmzqYYwxC7pTWyfPkK4
	 2sttCf6XGtDxZJSs4myQcIOGYVpmHgOjGlB2Dix4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231223122529eucas1p2588e4cdf813f05b4d7784d28c4120e9f~jdYw3SQjJ2663226632eucas1p2P;
	Sat, 23 Dec 2023 12:25:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 1E.E9.09814.9B1D6856; Sat, 23
	Dec 2023 12:25:29 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20231223122528eucas1p232ae9405ab2ca51440f6899f87c06fb0~jdYwlDrit2662226622eucas1p25;
	Sat, 23 Dec 2023 12:25:28 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231223122528eusmtrp138171224c5d87d1b98899049ef1c4337~jdYwklqvl0181201812eusmtrp14;
	Sat, 23 Dec 2023 12:25:28 +0000 (GMT)
X-AuditID: cbfec7f4-727ff70000002656-4b-6586d1b98853
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 98.DF.09274.8B1D6856; Sat, 23
	Dec 2023 12:25:28 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20231223122528eusmtip2544d996ba960b06d060e6b862239902d~jdYwZClSn3146931469eusmtip2A;
	Sat, 23 Dec 2023 12:25:28 +0000 (GMT)
Received: from localhost (106.210.248.246) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Sat, 23 Dec 2023 12:25:27 +0000
Date: Sat, 23 Dec 2023 13:25:23 +0100
From: Joel Granados <j.granados@samsung.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: Coly Li <colyli@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
	<song@kernel.org>, <linux-raid@vger.kernel.org>, "yukuai (C)"
	<yukuai3@huawei.com>
Subject: Re: [PATCH] Revert
 "raid: Remove now superfluous sentinel element from ctl_table array"
Message-ID: <20231223122523.auzswchtrsrlc5vp@localhost>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="sa5niknxzbwlmire"
Content-Disposition: inline
In-Reply-To: <ZYXH5vtBkkHRaVJ2@bombadil.infradead.org>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7djP87o7L7alGkxexmoxvfE8u0X7/F2M
	FjcmPGW0OL78L5vFvL7ZjBZzFrI5sHm0HHnL6vFlZz+jx6ZVnWwem09Xe3zeJBfAGsVlk5Ka
	k1mWWqRvl8CV0bxkA1vBX+GKhseFDYw/BLoYOTkkBEwkWlcfZu1i5OIQEljBKLHk0jM2kISQ
	wBdGiXuNqhCJz4wSc+dvZYfpWPGjgQ0isZxRYsHxVla4qq/P3zJCOFsZJbYf2s8K0sIioCrx
	dNojRhCbTUBH4vybO8wgtoiAhsS+Cb1MIA3MAtMZJRr3HgNLCAskSTz4thIowcHBK2Au0XdE
	AiTMKyAocXLmExYQm1mgQuLFJ5CTOIBsaYnl/zhATE4BM4nNNwMgDlWWuPnrHTOEXStxasst
	sE0SApM5JTbc2ccIkXCR2HjnMlSRsMSr41ugvpSROD25hwWqgVFi/78P7BDOakaJZY1fmSCq
	rCVarjyB6nCUOHHxARvIFRICfBI33gpC3MknMWnbdGaIMK9ER5sQRLWaxOp7b1gmMCrPQvLZ
	LCSfzUL4DMLUlFi/Sx9FFKRYW2LZwtfMELatxLp171kWMLKvYhRPLS3OTU8tNspLLdcrTswt
	Ls1L10vOz93ECExcp/8d/7KDcfmrj3qHGJk4GA8xqgA1P9qw+gKjFEtefl6qkghvvk5LqhBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXFe1RT5VCGB9MSS1OzU1ILUIpgsEwenVAOT0+4rD5YHaVuo
	Cdy8u+r6nHpgUs7NunJvQXL/pR2tVXfWZEy7+bNpf+nVurYN9TX/b3n7v533pfyj+FWxtZu7
	z9TKeFzZIzbPN2ytoQOP/4YVcnMK+fSKU81aDljwd51YZ+e39v2h2a0mjp9sso5z72Dc/v6j
	j+6NqCmih//+yGXLyNSfpnaiTvTOv3gVwy3le2Va5Tc0RfTqfzr4Oynm1XWlFXM0owTuLhPc
	dffmmtz+21JR2QsW+/+eUxB9dPlcrurL68InVNxULTQNit6S+H9+8vbwY9sK582Zz7h3o0D+
	vT3fzqu9PV84qUl+ou3aK1zrqluy9Kasen7COq/uyf0WqW3GZ1/E7GoJ5ZhTqcRSnJFoqMVc
	VJwIAFfCpjDXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t/xe7o7LralGqyapmcxvfE8u0X7/F2M
	FjcmPGW0OL78L5vFvL7ZjBZzFrI5sHm0HHnL6vFlZz+jx6ZVnWwem09Xe3zeJBfAGqVnU5Rf
	WpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CX0X3+EnvBb+GK
	14udGhi/CXQxcnJICJhIrPjRwNbFyMUhJLCUUeLA+aPMEAkZiY1frrJC2MISf651sYHYQgIf
	GSWWfHKHaNjKKLHg801GkASLgKrE02mPwGw2AR2J82/ugA0SEdCQ2DehlwmkgVlgOqNE495j
	YAlhgSSJM/2nWboYOTh4Bcwl+o5IQAw9ySSxsrebBaSGV0BQ4uTMJ2A2s0CZxOxPn5lA6pkF
	pCWW/+MAMTkFzCQ23wyAuFNZ4uavd1D310p8/vuMcQKj8Cwkg2YhGTQLYRBEWF3iz7xLzBjC
	2hLLFr5mhrBtJdate8+ygJF9FaNIamlxbnpusZFecWJucWleul5yfu4mRmD8bjv2c8sOxpWv
	PuodYmTiYDzEqALU+WjD6guMUix5+XmpSiK8+TotqUK8KYmVValF+fFFpTmpxYcYTYGBOJFZ
	SjQ5H5hY8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamDQeJlYb
	blV8kckfaBfsebwk9Q3r4csMz718mpznCslL2YSscbJM4GcsvBzvyu3v9sJT7rF+ulm+3zxb
	5n+Hb6xgUZ95aq5UotL6FtOSxX+PVrxK/9ymsDLxkPChA2/UogJWPvRZGfvDo86yeU7r94S6
	w2/Zrmv9Lglz9wpf9OT6yb9HXV1/cOosD5xwXrblwfK323yPyBYyRX5s/nHS8p6ZwRK51+xn
	ysM2vu093TWhd0byY425n2+snv31bXSNvLDDdaezn7Svp57al9IzZZKFk/uGB1d1n69jiF2a
	m/ki5qbr1LVvtu432XuAXULgJduzlRKXxK9e0JZcsSV11/UZHw0+znngeoErjvNWpIgSS3FG
	oqEWc1FxIgB6Nb6xdAMAAA==
X-CMS-MailID: 20231223122528eucas1p232ae9405ab2ca51440f6899f87c06fb0
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

--sa5niknxzbwlmire
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22, 2023 at 09:31:18AM -0800, Luis Chamberlain wrote:
> On Fri, Dec 22, 2023 at 06:17:47PM +0800, Coly Li wrote:
> >=20
> >=20
> > > 2023=E5=B9=B412=E6=9C=8822=E6=97=A5 03:17=EF=BC=8CLuis Chamberlain <m=
cgrof@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
> > >=20
> > > On Thu, Dec 21, 2023 at 02:19:56PM +0800, Yu Kuai wrote:
> > >> I can't find this by code review, and I think
> > >> maybe it's better to fix this in sysctl error path.
> > >=20
> > > Indeed, we want to fix anything in the way to remove the empty sentin=
el,
> > > we continue to do that in queued work on sysctl-next [0]. Although I
> > > won't be able to diagnose this right away, could you try the out of
> > > bounds fix by Joel [1] instead?
> > >=20
> > > We want to identify what caused this and fix it within sysctl code.
> > >=20
> > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/=
log/?h=3Dsysctl-next
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/=
commit/?h=3Dsysctl-next&id=3Dfd696ee2395755a292f7d49bf4c701a5bab2f076
> >=20
> > Hi Luis,
> >=20
> > Thanks of the above information. IMHO your code is good, When I cherry
> > pick the upstream md code for testing, the sysctl related change
> > leaked from my eyes. please ignore my noise.=20

So this was triggered because the tree was missing the changes that
actually handled the removal of the sentinel?

Get back to me if the oops persists even after you have included the
changes in sysctl-next

Best

>=20
> Great thanks for the heads up! Happy holidays.
>=20
>   Luis

--=20

Joel Granados

--sa5niknxzbwlmire
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWG0bMACgkQupfNUreW
QU8fzAv+PPEj/zr9VfHrpT3MmOqDQi1zYJ0RL0XlfIL6vWrUHxzE+c/CqKe/zJ/E
WNv1G9g+0gHmUpf1dlgvsJs115/LCs6Rru5i+sOLVKps6Lx8ULNCOHiWjsUB3NNO
4DXm9xjCb62TrNBu8+CwbexdTh1+Afj3kcHg93rf4BWMMHU4F/DgO/EhZHA5f/mR
Kt9j0CtdcbZBpfa091qK5Zi3ptdPMAvFKsetTWP788ee8JBjcHQANULntYqbFCs2
3MduIIbmPKDvsVsX/ufgSRKRGEkLcJv72xTOMwSGqXuIQRnq4qHNRvhx7w8UxiQc
D0mFePYHLy6Ned80SYX/BXAz1i/e31rENYz+JYVxrSDHhtezy1z70vCa38em7ng2
P1ylTS1qAaTKK5GQReSJkeo272FW0R5Tg7VVN92scnAkKBCvY2meupwy3LlUa6R8
smmuzzuU5DbHKRdaV3WMwvyFjM2j/Y5FBJ4UYRQgWWwJx7oQIvr6YdzpofH9eeoB
Zxx1osq/
=RnfJ
-----END PGP SIGNATURE-----

--sa5niknxzbwlmire--
