Received: from sg-1-36.ptr.blmpb.com (sg-1-36.ptr.blmpb.com [118.26.132.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568D3DFC8B
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731856; cv=none; b=oTUZ+Mbb2p3m73zzbrxUIACIUtw171G6K6GIBnKp8yerYRRwiK+tOSMW/C9ciukZ7oCKtIbJzf6czv6DmsunIlMJeWyoct0qQY2VC8yb9gxDJgOzIFRwsJIKhYHUgRTR91wmh6yAhd/A839J4GIW8aFas2IzFKgwN2V0bh9oIa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731856; c=relaxed/simple;
	bh=uTKmK5QikOcZGampGQoNNT0IHIBrvmK/w0jqpBNtXpw=;
	h=From:Subject:Message-Id:Content-Type:Mime-Version:To:Cc:Date:
	 References:In-Reply-To; b=u/2gjo0KB/2ERTLruWVfISpFJZ7tG6DE1ytItI3VGtJ03JqhQY4CGar/X53bTCssevJbMcNw4d7X9AH+FTldTnGr7iilm5PFsU17zlRJYWdBD9pHY4FpHciHOuqmxClWs2EwB20FoHXyatrSFkQvJ3RcfpGP8WEMiXDGoK0qsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=HGQIfHBa; arc=none smtp.client-ip=118.26.132.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="HGQIfHBa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772731848;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TBOs6yV1untzjyW3Eo40S7jCs5vTsNloEMOnmTpQqP4=;
 b=HGQIfHBagq3DUnfiTMXgxEsfLQ0nHBJkq0cQWvq0YYgQnDOY0IvDp1/rK7ipegTZEgg4J9
 1lUyOon+xkOId/R5QZ8fhJ3FNmCFlR0WgHkDsfmaeYlvHSDz22pi+CjI8OQ7jNrSX97JVX
 bL5u9Whiu+9YbGbaLDWX9KeIhaDOwSOH1dnO5uHTpZTfZc9ews03odmgJuidlxxq4iIXsX
 xWunC6WM3DrmFlRFXqGeHZhf0DwVx2eZTt3UY51z39FuAvdKxLeUG9Yiy+ypc++NwHwyFI
 Jl8S+uUNv2Fb/Oxs4FPlDXIgAGFk95M3B2FrBFC3h1qFzE6s5a8jyhAsW/AQUw==
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
Subject: Re: [PATCH 1/2] md/raid5: remove stale md_raid5_kick_device() declaration
Message-Id: <b2f35bb4-7601-4b47-a0cc-0e53a7141b76@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269a9bdc6+0ff59c+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	<yukuai@fnnas.com>
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
Date: Fri, 6 Mar 2026 01:30:45 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Fri, 06 Mar 2026 01:30:46 +0800
References: <20260304110919.15071-1-chencheng@fnnas.com>
In-Reply-To: <20260304110919.15071-1-chencheng@fnnas.com>

=E5=9C=A8 2026/3/4 19:09, Chen Cheng =E5=86=99=E9=81=93:

> Remove the unused md_raid5_kick_device() declaration from raid5.h -
> no definition exists for this function.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.h | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
