Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1E3C1F2B
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 07:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784100984; cv=none; b=braX2TxfeYNZnM8y8rdpehljFIFlsoK2C7P9sd+L2YnXU1bdWoStdrmHBrYlL9i+LJ/duxpiwMx1hDnTMF+n/KKwmb5Zj8JcGg2QSqyKwZtY0xSvAZaAPEZ0eg6Rmu6g79QFBlGYcjohkeUTRCKtEmXJDDaX65+GP2xz5SGBCyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784100984; c=relaxed/simple;
	bh=x/VJJFudqsix5K+PKBoeQ/z18IJzFqRvU8cQp1Chnvk=;
	h=Mime-Version:References:In-Reply-To:Content-Type:To:From:Date:
	 Message-Id:Cc:Subject; b=GswgOkVCcFHWcnxE9Jj4cYaKlnuQV2IuwsAvmX7QukFfytXsixUfhldUvn2LReGvtmujXKYhVNcBnZCvKydINbaRu+Y/IuWFAXqnLKo7y2cVHQRzXn3twJNqaVElle+P+kfQH6MoBcdrtkhoYS6S4zxqlsKV7ejLUSwntR1Yx/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RpY7YINK; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RpY7YINK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784100964;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=x/VJJFudqsix5K+PKBoeQ/z18IJzFqRvU8cQp1Chnvk=;
 b=RpY7YINKG0R+EfKuf08pwUvpyLpd9U2AjM4Ae3nfVOSXXFO23g5uZp0ut2kg0xtW75V2bb
 Nf5jSwXs/qiBDFj8jFitBF3eZCNkUeuIjrHjcUNDC55/sKv7F0lxjqPjMpeFtcEbjYSk+X
 0g948q7JSxpLPaBYzWOxu2Yh+yJKkDH2BLJFVsxPe0jj1lVyDqJVjAyHH8QUC6CfUtgTOS
 xHSCpqFr1WZx1wSFHVmz6xqWlozuhX5zQWXJw7R2g3L1HgiBIUzX0GSp8pHddi08j+oDfM
 nFviLp03AEuH2CiJ9kQdnEN0g5LlT9TYjw28I3H4ipUpSnANmwCMKICpC4YeTg==
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260710101521.1714-1-abd.masalkhi@gmail.com> <20260710101521.1714-2-abd.masalkhi@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Wed, 15 Jul 2026 07:36:03 +0000
In-Reply-To: <20260710101521.1714-2-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Wed, 15 Jul 2026 15:35:59 +0800
Message-Id: <fe3c5fb1-b939-48b9-80ef-09203d72f62c@fygo.io>
Cc: <linux-raid@vger.kernel.org>, "sashiko-bot" <sashiko-bot@kernel.org>
Subject: Re: [PATCH v4 1/7] md/raid10: fix r10bio leak in raid10_write_request() error paths
X-Lms-Return-Path: <lba+26a573864+8f0aa8+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> When raid10_write_request() fails because REQ_NOWAIT is set, the
> allocated r10_bio is not freed before returning, resulting in a memory
> leak. Free r10_bio before returning from the REQ_NOWAIT error paths.
>
> Fixes: c9aa889b035f ("md: raid10 add nowait support")
> Reported-by: sashiko-bot<sashiko-bot@kernel.org>
> Closes:https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smt=
p.kernel.org/
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
