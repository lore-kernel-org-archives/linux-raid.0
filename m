Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656CF388893
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 06:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283186; cv=none; b=C95xlC4WXFppvjI7AA3yaPIsu0Q7SxWUXonFduaNY8UcLLrtQdzhXmbCZ7xHM04h1ThHdXoNbQJTAvuKy9w891Ku5iQqKmp1Jnu02jR6Wf6dbOyAkVK/p4iuVhUD8zSpDTffSIXQCu2ErvfxslLFLkohOfg6nwbAyE22Z6WNvyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283186; c=relaxed/simple;
	bh=+mP5zBreyzsqpu3ao60hjePsqBg5/yjpI+4ZLMxkvYQ=;
	h=To:From:Message-Id:Content-Type:Subject:In-Reply-To:Date:
	 Mime-Version:References:Cc; b=tHlUWPfffVIk3fpd4mdv6aRN5qmvMSwU8AVDycWS77GQdXGbo6KROq34KwYCL5/ICqK1EVCvN5tVLPo4vuqZjwC3olwClrv1mO324R9FBaza2GV5p9b0t6s1xA7THrQs0WLIKhevvV/772UGZv2DT6jxWM0EQC4LwQba2LE31+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=fTC23qX/; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="fTC23qX/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782283174;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+mP5zBreyzsqpu3ao60hjePsqBg5/yjpI+4ZLMxkvYQ=;
 b=fTC23qX/DfyTfUpv1Ex8rJ8PNyVXh55R+FY9zrF5FtMtRsZFUM7DCq0yChsyMM10t9Mw+Z
 wTwi7ZSPhQTY2MNNZlA51DGOFnDx5+CCntxu9S+AfX9vC63mUbOnY/OnHZTAOML4oe6Zeb
 7Yu1QAtKpewQO9Phm3D9k8LyMdnZOhUlaFdTWRjBnEN7Yy6ovnbVD4Ngjd9Vic7hH1Ghes
 DEzSnl2puN/9zA/ES3rJyWzG7QPYMZurDIyXuOyPfHlWU8N6sH3A51jUDdsT+9gJSKWBdL
 Y0KsvwM8uLg55FFab45/Y7eIQIO+sa4Or7nXuay7fe/queXh776PiQlmsH75ZA==
X-Lms-Return-Path: <lba+26a3b7ba6+9c3bc7+vger.kernel.org+yukuai@fygo.io>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<vverma@digitalocean.com>, <axboe@kernel.dk>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <868207d0-d20f-42e8-8257-f57816987bf5@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind writes
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <m2y0g722bp.fsf@gmail.com>
Date: Wed, 24 Jun 2026 14:39:29 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260611083514.754922-1-abd.masalkhi@gmail.com> <61361f20-f81c-46c3-bdd2-3de24e90a0aa@fnnas.com> <m2y0g722bp.fsf@gmail.com>
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Wed, 24 Jun 2026 06:39:33 +0000

Hi,

=E5=9C=A8 2026/6/22 2:08, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> What if on a partial nowait failure we just end the master bio as
> success, but set NEEDED on that chunk's bitmap counter and start_sync()
> picks it up for resync? That way we don't have to decide why rdev2
> failed at all, resync just copies from rdev1 to rdev2 without nowait,
> so if it's a real bad block, end_sync_write() records it then.
>
> We kinda have the idea of ending the bio before the write lands on all
> mirrors in write-behind already, though it's not quite the same, there
> the deferred write still lands, here we ACK after it already failed and
> lean on resync to redo it.
>
> My worry is the loaded case: AGAIN under queue pressure isn't that rare,
> so we might end up triggering resync frequently. Do you think that's
> acceptable, or is dropping nowait better? Happy to prototype either way.

Yes, AGAIN under queue pressure isn't rare, and I don't think trigger resyn=
c
for a nowait IO failure is acceptable. This can cause lots of offline IO
pressure which will affect disk service life. Meanwhile, resync will cause
performance degradation for user.

I still feel dropping nowait is better.

--=20
Thanks,
Kuai
