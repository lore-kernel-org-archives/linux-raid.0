Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794362440;
	b=kD/h5UXXHsOwLb6nbw6BgW3SA6AA2ly3Jm6yjPhGxT+qdzPMQprlL0kd+yc0jStaJOWW
	 E8ZJuXDqIqlEjVSfWkZo51wgOT7GIbrGTQQLa0B21yvl1AwSTyWPUZhAEturB74UyInQL
	 4akvtXWVhZb7z7qvvSsrAfB2fV6Aw0gbARfYVH4tYSaTFG0IZB0HgDz3wxRelmxWhmTG6
	 jovxevdSiueghcVxLHNDX4ve9glsTM5//xSNNpRzRPHSJDcU1JPskTH4j5PuV/N0jEk5x
	 wiqMUxklFYzIiDxPlBr8sbhXfsqrw+F31VLnnvJ+5Oayh6GrN/IU9g+W+pmh7AsDu3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794362440;
	h=DMARC-Filter:DKIM-Signature:Reply-To:Message-Id:Cc:From:Mime-Version:
	 References:In-Reply-To:Subject:Content-Transfer-Encoding:Received:
	 User-Agent:To:Date:X-Lms-Return-Path:Content-Type:X-Original-From;
	bh=0sgEp7c/MYW5vEqQu51IBaPfizbqCrE+qByQrxlHX1w=;
	b=VT3xhsCW07VbQe170tXUJm+Dj4pkUDYWmri+YyZweRcGiuo4eOgbxj2iEL0ZPdNLzAlG
	 9/c1eI3uPfDTl0D82hxddA2QSQdqfDN9/aQoiaIvs0W+pbWNKHSLhg5BcpNzh5zex8Nkw
	 XmJiHO4iQiIHIuQqp+nI7JH1wXHmMpRW5Dkb78Yo1gbdUTzAVzuBmSTiBcCOjw+EWmVkq
	 ssV2BlcS5ywCJia2toggxny7skUCtxO2Ia7DsmKohAfA+UPRKppJt7AKTUGiz7z/ei6ys
	 SmfVnmFMD+bxLmSJREA+2BafnR46Ho+/45TIHpqiO8bTf+vQuO/sMnvZmSeBXRwARpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=KxoffPGx;
	arc=none smtp.remote-ip=209.127.231.53
Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B6C606A320
	for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2026 02:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6B6C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=KxoffPGx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794362434;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0sgEp7c/MYW5vEqQu51IBaPfizbqCrE+qByQrxlHX1w=;
 b=KxoffPGxIOwSmqTEEuElk5325GHO5DJvpXSwXHzWV5aGOsURq5FM3wYjuKUMQNQxCySLFV
 nxv1d3pkE0Kz5+YyYX5ZTlr439g/KBknTS4pNIFIfmiutJv+Qh+JC7SC3erSJhS6ok2lS+
 A05CQ0Wy6TtIGh2qjI/Ok9qU6JEiOZt5uKR5QhaeCURFFKRM9ARQ22iUeUPrraXLt3KYNa
 c6DgWtUBfB3r+WJH/30pY8yNcpmuJq08qAVr7cnqaxNFzZhuTy8vuJRFChXdpdTIKHeNBD
 a83KMwJjLR3hAK4NWDddYi6Q8OcrCuLmqjy5XRC1x5YvsvM2XdbZX6qGhaqOog==
Reply-To: yukuai@fygo.io
Message-Id: <c0b959bb-7128-4cb4-92f3-5a1a075a6e9e@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<kernel-team@meta.com>
From: "yu kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <avA3JQ6lyAlMm1Q8@chrisdown.name>
In-Reply-To: <avA3JQ6lyAlMm1Q8@chrisdown.name>
Subject: Re: [PATCH] md/raid10: Prevent data corruption after a rejected backwards reshape
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Wed, 11 Nov 2026 02:00:33 +0000
User-Agent: Mozilla Thunderbird
To: "Chris Down" <chris@chrisdown.name>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Wed, 11 Nov 2026 10:00:30 +0800
X-Lms-Return-Path: <lba+26af3cc42+f0fb60+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>

=E5=9C=A8 2026/11/8 16:47, Chris Down =E5=86=99=E9=81=93:

> A rejected backwards RAID10 reshape can leave the array using the
> requested geometry because raid10_start_reshape() updates conf->geo
> before checking whether the new geometry can hold the current array
> size. If the check fails, we return -EINVAL with the new geometry still
> in place. Subsequent I/O then uses a layout the data hasn't been moved
> to, so reads can return the wrong data and writes can silently corrupt
> the array.
>
> To fix this, let's take the existing abort path to restore the old
> geometry.
>
> Fixes: 3ea7daa5d7fd ("md/raid10: add reshape support")
> Cc:<stable@vger.kernel.org>
> Signed-off-by: Chris Down<chris@chrisdown.name>
> ---
>   drivers/md/raid10.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
Applied

--=20
Thanks,
Kuai
