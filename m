Received: from sg-1-23.ptr.blmpb.com (sg-1-23.ptr.blmpb.com [118.26.132.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2554C9D
	for <linux-raid@vger.kernel.org>; Thu, 30 Oct 2025 02:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761792127; cv=none; b=kGHgBAd7DrxCf51VGtgfDOrpRX2JKsPrsDBzIQfYlX8ocH0qZLVTSX0v9HhhQDy4z93u7lFsPJqyInsN4+QhGF0E8T2tHozQLR/hXOu4MCZt1HKiIiAvwV9OJ8pSOOkVG342TnFGUcYTapZKEX9rTnPy6EdoHdo/O/lgXZb7zIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761792127; c=relaxed/simple;
	bh=TcyUSbo80Jx0DmY6uBc8ZIvIg0DwakU3w7Y1gSrDpVw=;
	h=References:From:Subject:Mime-Version:In-Reply-To:Date:Message-Id:
	 Content-Type:To:Cc; b=uAJjlfcQ64SqWJYhpG3pm7TGf488zfOrb/La5KEqH/eJj+5LyHQjBLbpztj3bp0QllVe3lpncdMiBP1xF5M//6+2dHGasyGoGLybKJprMvhXWLIRb3xPVz4xWCvSbai0LQEBD05Q6+DK0USt5RiCI9bPocRKZ0vRIdSVUc/tWlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=3eyi3/5p; arc=none smtp.client-ip=118.26.132.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="3eyi3/5p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761792117;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yh8djo7Nd21BgC+Yx2aUSeybVAkoleHM0MeaAP2URjo=;
 b=3eyi3/5pRMbR0mK6qLLwl5wwNN22NJn6h/53GYsFO3ggtlTRnxZOLi+ZrtKvyqQepMHU+v
 2AsFOu3DJVwa7qgEKMLJEbD1SLaDYVWzQTc1OUD77IcsD5uGNFu2l4z9RkNZfRJE3FkJUg
 kP2YLTpL4B7YfxCETosBD92zhSmWHYBeJfGJGf4XpO+MARVf3x9K66L6n0Sw0Mr1wuTK3D
 9jZ5Y1Z8JzGp+PeNCo3KPcfr4wDdIPnEIsRuPgca18py3WctDPy7qDwIVQQ1nqna/m9AWL
 5Umgo6LceXya2LfSRsseufRC+4qWUtmQzSmddg83gSE2BPQpgm5cHob2zX37ew==
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
References: <20251027150433.18193-1-k@mgml.me> <20251027150433.18193-10-k@mgml.me>
X-Lms-Return-Path: <lba+26902d073+40b84b+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v5 09/16] md/raid10: fix failfast read error not rescheduled
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20251027150433.18193-10-k@mgml.me>
Date: Thu, 30 Oct 2025 10:41:51 +0800
Message-Id: <daefef14-c1de-48f1-992d-f8dbe1c7504e@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 30 Oct 2025 10:41:54 +0800
To: "Kenta Akagi" <k@mgml.me>, "Song Liu" <song@kernel.org>, 
	"Shaohua Li" <shli@fb.com>, "Mariusz Tkaczyk" <mtkaczyk@kernel.org>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Li Nan" <linan122@huawei.com>, <yukuai@fnnas.com>

=E5=9C=A8 2025/10/27 23:04, Kenta Akagi =E5=86=99=E9=81=93:

> raid10_end_read_request lacks a path to retry when a FailFast IO fails.
> As a result, when Failfast Read IOs fail on all rdevs, the upper layer
> receives EIO, without read rescheduled.
>
> Looking at the two commits below, it seems only raid10_end_read_request
> lacks the failfast read retry handling, while raid1_end_read_request has
> it. In RAID1, the retry works as expected.
> * commit 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
> * commit 2e52d449bcec ("md/raid1: add failfast handling for reads.")
>
> This commit will make the failfast read bio for the last rdev in raid10
> retry if it fails.
>
> Fixes: 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
> Signed-off-by: Kenta Akagi<k@mgml.me>
> Reviewed-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid10.c | 7 +++++++
>   1 file changed, 7 insertions(+)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
