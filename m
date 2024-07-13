Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C69D1E86E;
	Sat, 13 Jul 2024 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720878636; cv=none; b=cH8lOqHKDeSinCnhn8fHeKxULHa3VZJE7AZTL3H0Z2wjT2C4rY8qktrxTpVchCUWRTQru1q22nYoJy4YthXWMGP4O36I/sIZpF31nnKcVu175FBqU5Ljbj/x2WvvkZMDf/zBlbUoytdf00VxTwFYyEu2ilaL//meBI38g7Bh/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720878636; c=relaxed/simple;
	bh=mLcL/SY7UnS6QZM6TjgIX4eKwSIhCBU1rZA0YWc5V/I=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iTYy0VjSEQDqshX04yBfU9EzZRrzZQoOfgqivpmUefvuPNqpYUXIcUcYCGKiNjOHn8mAeDcKvi03aQw8//eYLI91CkU3pfZmQ6vNVeUDMQ94v6CWj3QSODnz53afmnu4G9Q6QTqBWqSbz23ipg5RLZJxUzHjUQRKPu8noPPzfnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=e28820dT; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="e28820dT"
Received: from mail-nwsmtp-smtp-production-main-19.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-19.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:3b2:0:640:ff71:0])
	by forward502b.mail.yandex.net (Yandex) with ESMTPS id 53CB15E590;
	Sat, 13 Jul 2024 16:50:24 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-19.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id Loh1uYPOpSw0-voiErDil;
	Sat, 13 Jul 2024 16:50:22 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1720878622; bh=uCIOdqunNQD9Vsp9oTkPbArvncSPx+aYWd1537T2OqQ=;
	h=In-Reply-To:Date:References:To:From:Subject:Message-ID;
	b=e28820dTD9NpwAcEFmmZSBOnF3Ugl7QlSHoLa1B2Y2xCFniE8J1CyFFm81LuK9NMe
	 3iMipgkBf8AuyuuGM+J7gBrwg/MKSp3Ae/QiCn+LBtsVppEXW+CVttLL4Cfg2GHETF
	 oT//EPLc1b78sIkqH3UXrEJb/yquaiEhmrQDFW0g=
Authentication-Results: mail-nwsmtp-smtp-production-main-19.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)"
 <yukuai3@huawei.com>
Date: Sat, 13 Jul 2024 16:50:21 +0300
In-Reply-To: <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
	 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
	 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
	 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2024-07-13 at 19:06 +0800, Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2024/07/12 20:11, Konstantin Kharlamov =E5=86=99=E9=81=93:
> > Good news: you diff seems to have fixed the problem! I would have
> > to
> > test more extensively in another environment to be completely sure,
> > but
> > by following the minimal steps-to-reproduce I can no longer
> > reproduce
> > the problem, so it seems to have fixed the problem.
>=20
> That's good. :)
> >=20
> > Bad news: there's a new lockup now =F0=9F=98=84 This one seems to happe=
n
> > after
> > the disk is returned back; unless the action of returning back
> > matches
> > accidentally the appearing stacktraces, which still might be
> > possible
> > even though I re-tested multiple times. It's because the traces
> > (below) seems not to always appear. However, even when traces do
> > not
> > appear, IO load on the fio that's running in the background drops
> > to
> > zero, so something seems definitely wrong.
>=20
> Ok, I need to investigate more for this. The call stack is not much
> helpful.

Is it not helpful because of missing line numbers or in general? If
it's the missing line numbers I'll try to fix that. We're using some
Debian scripts that create deb packages, and well, they don't work well
with debug information (it's being put to separate package, but even if
it's installed the kernel traces still don't have line numbers). I
didn't investigate into it, but I can if that will help.=20

> At first, can the problem reporduce with raid1/raid10? If not, this
> is
> probably a raid5 bug.

This is not reproducible with raid1 (i.e. no lockups for raid1), I
tested that. I didn't test raid10, if you want I can try (but probably
only after the weekend, because today I was asked to give the nodes
away, for the weekend at least, to someone else).

> The best will be that if I can reporduce this problem myself.
> The problem is that I don't understand the step 4: turning off jbod
> slot's power, is this only possible for a real machine, or can I do
> this in my VM?

Well, let's say that if it is possible, I don't know a way to do that.
The `sg_ses` commands that I used

	sg_ses --dev-slot-num=3D9 --set=3D3:4:1   /dev/sg26 # turning off
	sg_ses --dev-slot-num=3D9 --clear=3D3:4:1 /dev/sg26 # turning on

=E2=80=A6sets and clears the value of the 3:4:1 bit, where the bit is defin=
ed
by the JBOD's manufacturer datasheet. The 3:4:1 specifically is defined
by "AIC" manufacturer. That means the command as is unlikely to work on
a different hardware.

Well, while on it, do you have any thoughts why just using a `echo 1 >
/sys/block/sdX/device/delete` doesn't reproduce it? Does perhaps kernel
not emulate device disappearance too well?
