Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6118D3E8686
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 09:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106652; cv=none; b=CGgD5FCr0V7TD4nBlrmqcyY4k5567js3JGVqdb50cm2TpNZ5m3JwpEA7pcZFe97q4oeEmiwJAsjIyK6PqwejuSBplytiOQYfcl0TFxokiFBpQIc+9i8IW0lJN4AIU72IlZKX53gZyvw3vxon6dJsT+GCU3MBIEr2aNfm3oBPSNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106652; c=relaxed/simple;
	bh=btqayxoqiXiqpQXBkVDNPPHzll/Lc3vmjofDfeui+zs=;
	h=Cc:From:References:To:Message-Id:Mime-Version:In-Reply-To:Subject:
	 Date:Content-Type; b=gZTKvEHz345HuETEtGUXXIHh1JK5Ceg6PnJ8qb7dl4/FPPtLyqMfE6PeA41FdkTlO1tjEEbc3DlpfQGlbiy1hVZ7wn0eot0pnMPyhpETsYsG2VvwaNkshnRHIfL9R+dhCKfSWUmxjK5vA8SzOjs/Bg8sA9FYmM0IYOVbE6rtro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=h6zflTCj; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="h6zflTCj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784106636;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=69sbYCT1PNe8Uf6rkuJM+T+srtrVJzzUw1N+k0bSBHE=;
 b=h6zflTCj9zFYWlcpPgjnY8nhUw14302JcvX3Zyf00FnwVYsxryCF7Fj68xPTivHPfzBM6J
 rmlHv7SYac9yAkHUWioPZpP6liPpikQysS8ZamurfODGlSwgxjOXBkNJjYXpkYRWUXWHKW
 fZ5+zFTRk0na+f1k5xEUUU8tiHvOeHNzSnSYF0HYXfRE7qLt+XhWNCQFtHYQRPV+LZvDQH
 MAVqU21bXG+RlH7pGUDNpzG/DkQ2RGt75iJtnek4Dgh3Od/OzyHY8BqYy3XEJkegmd1BsU
 5KdogMfoCLq0tYQS4B0d2py6jF9u//18WoLK4epbgslslg7PNvr0LNB8yLszpA==
Cc: <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com> <20260710101521.1714-4-abd.masalkhi@gmail.com>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Wed, 15 Jul 2026 09:10:35 +0000
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Message-Id: <9c000a0f-9c83-48a3-be78-e08aefb16db2@fygo.io>
X-Lms-Return-Path: <lba+26a574e8b+d0b42c+vger.kernel.org+yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260710101521.1714-4-abd.masalkhi@gmail.com>
Subject: Re: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that require splitting
Date: Wed, 15 Jul 2026 17:10:31 +0800
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> RAID10 currently handles one badblock path explicitly by failing atomic
> writes with EIO. However, another badblock path can also reduce the
> writable range and force the bio through bio_submit_split_bioset(),
> which implicitly completes the bio with EINVAL.
>
> Fix this by handling atomic writes in the common split check. If RAID10
> determines that an atomic write would require splitting, complete the
> bio with EIO.
>
> Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v4:
>   - No changes.
>   - Link to v3:https://lore.kernel.org/linux-raid/20260708101341.473750-4=
-abd.masalkhi@gmail.com/
>
> Changes in v3:
>   - No changes.
>   - Link to v2:https://lore.kernel.org/linux-raid/20260628142420.1051027-=
4-abd.masalkhi@gmail.com/
>
> Changes in v2:
>   - Drop the early atomic write split check from raid10_write_request()
>     and rely on queue limits instead.
>   - Link to v1:https://lore.kernel.org/linux-raid/20260623072456.333437-4=
-abd.masalkhi@gmail.com/
> ---
>   drivers/md/raid10.c | 14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
