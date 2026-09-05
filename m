Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D58B265606
	for <linux-raid@vger.kernel.org>; Sat,  5 Sep 2026 01:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788571491; cv=none; b=l0xlEEj3cJokfTK0vqQ4A2OZ7SClgruJ5w/QqNypgyBFpO2xkPsoVbP271k6skj8aUUZFpJ3S0zc//YuQ351w23WYFLGXw7OOe40SF5hkMJ3pEj/9g3oOgUwof1R3J+vzM0pHTwFwU5/qrXr5fhfKDVL8JThtm9CncYcOLop2I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788571491; c=relaxed/simple;
	bh=AYvyS+nCRZ0pj1T2REtwZyD3Nx6k86PYHwQpkNGUjDo=;
	h=Cc:From:Date:Mime-Version:Subject:In-Reply-To:References:
	 Content-Type:To:Message-Id; b=nLYFhanQKREAjr/9SsF0KJOxWIaZxBhqJHeZcDA+HpuyxyhWVT6HpEq93Jahwhewqyp94tDViCNrCAsNjsxfYt1KAsGu2sy7BArCMv4sYRJYHQ+AGBZcRBcerQPYFfN7dIPemEMFphFzbPX8fSr08zyvU9wiv/0HMjdA792pCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Wg2rYG/m; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Wg2rYG/m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788571483;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=BLgEdeBOnz85dhT9MYDIRqX0CjANsPy1btOFoPLwh4w=;
 b=Wg2rYG/mNZpinXZcZ4N51ripx3IMay2wLX+H3BYcmsSZxHNoHjjIyOyO1+EPzBicA4Hqaz
 D/aMQBcmFrQZDNs3ZUmUIcJStiyqDE9JFjnNbj4iKgb+Xelan8/jPDcbrks+0eT5u7meuN
 KISEx7pTxaVIn7X4RH/Pp81ziH47dfzHdBgVwxfMilyAjICUcgwtGDnY03sOnpq39nuO9E
 r2QQhv1eNjXVYs9k740qIh4oZJSGVRML72NUJ1h5KIT3u/zhyFa46Youl9boaM2g6QXhq7
 FCX4srIJCvNYtbcw7wRUcH2TbLm++JAIIRzjyVbluVJmpnDiFqQ791oeylmDrA==
Cc: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<chengzhihao1@huawei.com>
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 5 Sep 2026 09:24:37 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a9b6f5a+85aed8+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sat, 05 Sep 2026 01:24:41 +0000
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH V2 0/2] md/raid10: annotate lockless access and fix hungtask
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260817033340.418119-1-wozizhi@huawei.com>
References: <20260817033340.418119-1-wozizhi@huawei.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "Zizhi Wo" <wozizhi@huawei.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Message-Id: <463a91ea-4448-4a0c-9fe7-c42c1c4fad38@fygo.io>

=E5=9C=A8 2026/8/17 11:33, Zizhi Wo =E5=86=99=E9=81=93:

> Patch 1 annotates the lockless access to conf->array_freeze_pending with
> READ_ONCE()/WRITE_ONCE(). No functional change.
>
> Patch 2 fixes a hungtask in raid10.
>
> Changes in v2:
> - Add patch 1 to annotate the lockless reads of conf->array_freeze_pendin=
g
>    with READ_ONCE(), paried with WRITE_ONCE() on the write side.
> - Use READ_ONCE() when reading conf->array_freeze_pending in patch 2.
>
> v1:
> https://lore.kernel.org/all/20260810135521.3470422-1-wozizhi@huaweicloud.=
com/
>
> Zizhi Wo (2):
>    md/raid10: annotate lockless access to array_freeze_pending
>    md/raid10: fix missing wakeup in wait_barrier_nolock
>
>   drivers/md/raid10.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
Applied to md-7.3
>
--=20
Thanks,
Kuai
