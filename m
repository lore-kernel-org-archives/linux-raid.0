Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3BC225775
	for <linux-raid@vger.kernel.org>; Mon, 26 Jan 2026 05:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769405644; cv=none; b=uNf1RjxHWT1ZXkpRGyidkuA4AGaJxTVMhUEga02fa1Up8AKBKvKL+V8eA3MvlFLfJFfRHJsrQJzFdDLVk/XCC5QKuykcG7ryfqasRbliLcXKAbvwnU6elA0w/dGwIKAJmhg4ecuNNtbWO5lgR9U7r9+PTOxyWN6ljILD2XZ3bGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769405644; c=relaxed/simple;
	bh=/wC5XtevS36sRDXlejWt29/7Fk//4a4NBkLTQuqkk/I=;
	h=Cc:In-Reply-To:Mime-Version:References:Subject:Message-Id:From:
	 Date:To:Content-Type; b=r9olTr/s5JXxkgtUCD4drRxwDmToIcUC4Of2eVPjGI7FA87rx+c4sDYIk3g3OTmE/NE5FTrjEutu6SQUIj9BOCx0+Q3tDMz/zAqM+MRE6LeMXTNXa26Yd8B8P+P7HPNt3RlhPihn0Zz/E2g+Ac7IDu51E7WMAodoV00KVkMZ37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MpobRxaU; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MpobRxaU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769405629;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=VJ9LzF4Ct+myR84KeQEYhbJCkWiG0gF+QzYDvcErG4A=;
 b=MpobRxaUMn9W/2rZYXG9P/sfEVayXekpok0JH1yUrsACTq4FqLuO/mUNigPqNM+IFeJssI
 o77h8iOY7jl7XleRNsDDpXF9QYzHO/iV6utcjijAi/LIjrGM8B7nbSGn68GCQE/QMEqH91
 ha15kMmw+7mCpb+O0IQbx9DboWb/oaBxWi0Nt3xPGCes4azqw/87UuANJAoYpYVaPb/Zh9
 JtzjpNYx7fMdjg2l5xcJkIipq24zjbcvazRGrmrYhWVbvCrkxr/yUTpfAJV6Ut4wrSNHTe
 HVKoUBxHtsBJTxhrxZdszLawtZPv5JDmlHM0hPfiqQf5Pt7aohwH9pF4JbpEiA==
Cc: <stable@vger.kernel.org>, <yukuai@fnnas.com>
In-Reply-To: <20260120102456.25169-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26976fcbb+d7271d+vger.kernel.org+yukuai@fnnas.com>
References: <20260120102456.25169-1-jinpu.wang@ionos.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH] md/bitmap: fix GPF in write_page caused by resize race
Message-Id: <ad63a8bf-410f-4b91-aa89-3963dadf87af@fnnas.com>
Content-Language: en-US
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Mon, 26 Jan 2026 13:33:45 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Mon, 26 Jan 2026 13:33:43 +0800
To: "Jack Wang" <jinpu.wang@ionos.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/1/20 18:24, Jack Wang =E5=86=99=E9=81=93:

> A General Protection Fault occurs in write_page() during array resize:
> RIP: 0010:write_page+0x22b/0x3c0 [md_mod]
>
> This is a use-after-free race between bitmap_daemon_work() and
> __bitmap_resize(). The daemon iterates over `bitmap->storage.filemap`
> without locking, while the resize path frees that storage via
> md_bitmap_file_unmap(). `quiesce()` does not stop the md thread,
> allowing concurrent access to freed pages.
>
> Fix by holding `mddev->bitmap_info.mutex` during the bitmap update.
>
> Closes:https://lore.kernel.org/linux-raid/CAMGffE=3DMbfp=3D7xD_hYxXk1PAaC=
ZNSEAVeQGKGy7YF9f2S4=3DNEA@mail.gmail.com/T/#u
> Cc:stable@vger.kernel.org
> Signed-off-by: Jack Wang<jinpu.wang@ionos.com>
> ---
>   drivers/md/md-bitmap.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Applied with a fixtag:

Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow=20
bitmap resizing.")

--=20
Thansk,
Kuai
