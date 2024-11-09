Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B2B28E8;
	Sat,  9 Nov 2024 02:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731118539; cv=none; b=bM2ppXH12IIKAi6OyrxVJQwXhEJ3OepHqG0+vIIQa5s2VGA2WjA1hgQSHgYqs88mkI9frGkMxIFfJuNh6xKR8NyPBa40hnEAxQYcB/CtN+OnCm/7YyG1iJ2HQyxpkBSu4ksrQTDxdi1pTbZopL0Ah5w7h0MI/FPnUiC3TdQungc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731118539; c=relaxed/simple;
	bh=00CYDuMEPBrkDvJsAfmZJVilvNCkDpEovUWQbrotSC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qeBxYRlGiYsXzPIcJRIH6rUXzvFhW93jwd0wZJjjBpVIhaiRCOC16gxNMWdwv6asyoZJOnlK1KS8sdFkf0JdSJf0bqqmjE4i8ccyuDoWSOr/43a6Fy5mzUF86vcm0vXOytMmyg3zMySEav3tqmsuxeLm/wiUQ5xSaDOOEO4rzMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=f+cRxlqM; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="f+cRxlqM"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2b71fd16fso16643a91.3;
        Fri, 08 Nov 2024 18:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1731118537; x=1731723337; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=00CYDuMEPBrkDvJsAfmZJVilvNCkDpEovUWQbrotSC4=;
        b=f+cRxlqM61hDejgqqKEn8D0w7cJaWvzogpL0oaxYtwrXMscxQnktJ/7siETF3NXV7X
         sRlR3CbyLW2+Y76+XV9TCrEsjptHfw0+FuUIvwjkZ1DVe+Hayk1M3Ai0Qke3T/g4cCni
         CxwfWc6yD4dKwdkQ70H9C21U47hxSUMFY9norqqvoDC4HzZqaDy/i7jRp1r+B82VKv2z
         rBYCWzL5TtXIVURpMkYD9PQyyp1qykd1YEldCb/yuRwGxrT9ek+ok+n99cs9XqdwMaSY
         Nncw1RfxC5Phlobhcj2bX4xLF7G4jeduZZf5AsVhWsBm/xxnWdGCgp5qgEiOTcdFO54B
         3KAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731118537; x=1731723337;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=00CYDuMEPBrkDvJsAfmZJVilvNCkDpEovUWQbrotSC4=;
        b=Of5NzOSTEpFAV7s9UZ4BFIsM3580C2LeEKYWdBzW/sPpvOWCfYAlhyMVfMUpPNmW09
         9u+wIC1F2ENpX7xMujtrafyOCunrx7bV92GzrdAS2O9vVa80XUaDIoBkrn1dw1LiFEGF
         kKa2xXWpYnyc1FrXV7OQgsl7li6EO8/Wza+jQxHnkbu+xzqLEpL8NppaiUeZvpphqFtf
         ar9UjRUZ6HuUawiTwM3mkGs05QGAJzU3fYEwAZIjA/sQqCnkHnfD0zndX3sKkLVz8tLg
         6A2zCbn7e0H8egigaVbJrjLNjZmSUlT44na4z1pWWmHXWA1fYXCHKdUqL4gMCxiF51dq
         thXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSMrUU/+D5H0gErr2RagoPMvEbTFgVQbvKj3KDXIo81MVwQ7TOCtnwx8mM1TghLJz33T6gqb95yWcg/w==@vger.kernel.org, AJvYcCWlu9TsIhq/ACsgmsNjJTp9ZWcbZMxbRZzeLA/ZlVGwG8bRxITHUKzLmPOk2K3BJhXe83t99m9lGO1k/4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTYV1MZyQEPJkh76WJZ4coNkQqGhbcmZfAzWuyv3KQMKkwVWB9
	Q/AyInmM+Bvla9euLduOjvEoIqC2qlG/79kAdVvQKCbUa4slXXPWNq1Jf45Q25ERlEVdIOssnEE
	+Gl1FZwbvHExbciuheLG/l5NV0Ls=
X-Google-Smtp-Source: AGHT+IFFq147j49OWTU0zJH3vIVhWHZ/sYIQCZcB+wSRE9WXQIv7Su0UU4HHR0ZSa8kJPwnwnVtmn17JXA1tgKR3XMA=
X-Received: by 2002:a17:902:dac9:b0:20b:80e6:bce6 with SMTP id
 d9443c01a7336-211834f8c81mr29274005ad.4.1731118537119; Fri, 08 Nov 2024
 18:15:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com> <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
 <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com> <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
 <36659c34-08bf-2103-a762-ce9e75e8262e@huaweicloud.com>
In-Reply-To: <36659c34-08bf-2103-a762-ce9e75e8262e@huaweicloud.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Sat, 9 Nov 2024 03:15:25 +0100
Message-ID: <CALtW_ai-xfkphuch64f2n544cfWzg__59bwX3Yxkf-N61K-SvA@mail.gmail.com>
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 9 Nov 2024 at 02:44, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>
> This is not what I expected, can you give the tests procedures in
> details? Including test machine, create the array and test scrpits.

Server is Dell PowerEdge R7525, 2x AMD EPYC 7313 the rest
is in the linked pastebin, let me know if you need more info.

BTW do you guys do performance tests? All of the raid levels are
practically broken performance wise. None of them scale. Looking forward
to seeing those patches from Shushu Yi included, anyone knows when those
will be shipped?

> Bitmap file will be removed, the way it's implemented is problematic. If
> you have plans to upgrade kernel to v6.13+, I can keep it for now,
> untill the other lockless bitmap is ready.

I usually use distro kernels so no such plan for now, just thought it would
be useful to ship both at the same time. Soften the blow for those using
external bitmaps.
