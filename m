Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [178.154.239.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467CF14C59A;
	Tue, 23 Jul 2024 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721745273; cv=none; b=YzguhVRdY5lZSnvJEBZhVb4P9f6gqIpNHTwXQ6ovcbSex/7WAr/wgjGsYlqiJKswNTjBJYJdxkzu+JH3coM7wW2QZnF1XAF2T/F7oOilrrGbYtqpTLeaRT83x/+lxS+ykaIUrxYFg/fPAtouXCalmj6DWv35rMHGLjG49m3z52U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721745273; c=relaxed/simple;
	bh=81/N/W2gmSrkiOGEsPxz7YSfijdVtBZZK+odEhvg1GI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ecLypayuVaV/ykkPQB6gIfXbiJj70e4AUefcT4nuSMzGQSd3f0G+FPt3NBK26dJilY7n0+JOpb6wxw61ylAb5T9YiAYP2RMONugUZe2SDtTUPNXhacy0376///3K/1p+apWBQULNSWH18QgFCgeJ/iqFSdS4S2fIAxcufszXFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=lobA4oBk; arc=none smtp.client-ip=178.154.239.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="lobA4oBk"
Received: from mail-nwsmtp-smtp-production-main-35.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-35.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2345:0:640:1ce6:0])
	by forward502d.mail.yandex.net (Yandex) with ESMTPS id E00516102E;
	Tue, 23 Jul 2024 17:34:25 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-35.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id OYPYjC0iw4Y0-oKTbNDYO;
	Tue, 23 Jul 2024 17:34:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1721745265; bh=81/N/W2gmSrkiOGEsPxz7YSfijdVtBZZK+odEhvg1GI=;
	h=In-Reply-To:Date:References:To:From:Subject:Message-ID;
	b=lobA4oBk4U9rt85SDGqMozOuyARY3SjW1/DfboVgttP5iruOM7+M3WKKSS3k0hFBK
	 jSMFwFRj5PkVXFOr9GBC8eTpHXJovjNZdHs0AYaNvp/V2wTv8Aln4SoBF3dCN7Kk8D
	 fkgGuWEqcMbjtMjC9+1QR6di/6F73+DJrJno88Mg=
Authentication-Results: mail-nwsmtp-smtp-production-main-35.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <c396092e5c7698254a1ca7818f81178b5c1ee70d.camel@yandex.ru>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)"
 <yukuai3@huawei.com>
Date: Tue, 23 Jul 2024 17:34:24 +0300
In-Reply-To: <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
	 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
	 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
	 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
	 <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
	 <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
	 <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-07-22 at 20:56 +0300, Konstantin Kharlamov wrote:
> On Mon, 2024-07-15 at 09:56 +0800, Yu Kuai wrote:
> > Line number will be helpful.
>=20
> So, after tinkering with building scripts I managed to build modules
> with debug symbols (not the kernel itself but should be good enough),
> but for some reason kernel doesn't show line numbers in stacktraces.
> No idea what could be causing it

FTR, getting a kernel with debug info doesn't seem to be on the
horizon. I tried researching into that and apparently kernel has
`bindeb-pkg` target that we're using to build the kernel, and it
unconditionally strips it (similarly to deb-pkg and srcdeb-pkg targets,
at scripts/Makefile.package:121). I found a few places in code where I
removed the stripping and replaced `strip` to `false` to make sure I
get an error if something else tries to do that, but at this point I'm
stuck with kernel succeeding the build, but leaving missing binaries
behind.

I might try digging into why installing `-dbg` package doesn't make
lines appear in stacktraces, but I presume it would take some time.

Meanwhile, as far as raid456 driver concerned, I can decode it manually
by feeding stacktrace offsets to gdb.
