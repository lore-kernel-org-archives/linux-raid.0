Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069651EBFE0
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 04:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791087487; cv=none; b=C+S6IKJCF2JajOJf7mOWtuMSm/D3c2LWTmvjjUYSWZdAph5PdEZW2q3/kcrq8hK77d1w6QmUxOrWg++XSVvoA2B2BytDNYZ7jz+PwCyiLuooJ//Rd50feulqG1upzZpd7KFKDSKIkE6s3WFYLd4FpyogLr5aUnzma0ornnUT0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791087487; c=relaxed/simple;
	bh=JGsejnkLW19OD1E0XPi3GdVLCAyiT88nVwMWA/X4+3M=;
	h=References:From:Date:In-Reply-To:Cc:Content-Type:To:Mime-Version:
	 Subject:Message-Id; b=kvAW7jEPdXMcvPc3uGyALjmd4E+PGUy3fhw8PWyNVNsnhxDUU8DOox5rQmmKYueXx3AlwQggMjpnTGHnfZHj7fXmk+vQ2amOdCON75Lzf9GExShBIuuVEktONXdccHCrOe2Os02Ee+n1ux6BTSTpVble+h/S5t5apcAdTiIY3o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=demYU37R; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="demYU37R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791087471;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=tRx8XQO0hbDHNQeHm4pKH3gtW6jrjGOF0CPosqMI1/s=;
 b=demYU37RHgfIVn1zyB9s2UwI2p7/hP2yE336MdfEItAu2jNJB8duYRZcTzYpPovjy3/Jfl
 FFxq+UjYkwAMlLiDSr3z6iWWptaiTXOmaQKK38MG8+S7Nu9eWYaalJFVEFaBLxNvuVhc6e
 gUHdMKm4zgAUH/LYW7gxt1lLl6sP1Chwf4SiNKQAqdJQjmNPJQ3yfNDtM1LxPufG7SNCnW
 UEQOXAd82fny2sR+ZSEm0XPUJjrWFPCoemvwQUf+X34QqSGDSWG0+QMFT837bIOvT7kJpm
 r3O0iZIGNzg2bcVnoOGaioQkvWNlu2WbB53n7819sWJWAir+AroXHEgfcCZtrA==
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260929083916.50620-1-dayou5941@163.com>
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 4 Oct 2026 12:17:47 +0800
In-Reply-To: <20260929083916.50620-1-dayou5941@163.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Sun, 04 Oct 2026 04:17:50 +0000
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Li Youhong" <liyouhong@kylinos.cn>, 
	<syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com>
X-Lms-Return-Path: <lba+26ac1d36e+10a689+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] md/raid5: drain released_stripes before destroying the cache
Message-Id: <9a9dcf9c-1daf-45ee-9c5b-6b4ea01ea359@fygo.io>

=E5=9C=A8 2026/9/29 16:39, Li Youhong =E5=86=99=E9=81=93:

> From: Li Youhong<liyouhong@kylinos.cn>
>
> grow_one_stripe() calls raid5_release_stripe() for each new stripe.
> When mddev->thread is already set, that queues the stripe on
> conf->released_stripes and wakes the thread. Only raid5d moves that
> list onto inactive_list.
>
> Takeover calls setup_conf() while mddev->thread still belongs to the
> previous personality, so those stripes stay on released_stripes. If
> setup_conf() then fails, shrink_stripes() only frees inactive_list and
> kmem_cache_destroy() warns that objects remain.
>
> Move stripes still queued on released_stripes onto inactive_list
> before shrink_stripes() frees them.
>
> Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
> Reported-by:syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com
> Closes:https://lore.kernel.org/linux-raid/6ab6b743.7eec07f4.c25c.0006.GAE=
@google.com/T/#t
> Signed-off-by: Li Youhong<liyouhong@kylinos.cn>
> ---
>   drivers/md/raid5.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
Applied to md-7.4

--=20
Thanks,
Kuai
