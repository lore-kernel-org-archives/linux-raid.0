Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FDD21C160
	for <linux-raid@vger.kernel.org>; Mon, 11 Aug 2025 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754937131; cv=none; b=MtxaQEFt/pL78XihC1F6g/Ds8qaU35V29rpzH1MgEj3S/SBNvbEBjfBxQ17Zcrs+++sI1uS/i04tjltjlJ7jVrLbyNux2RxjQmSMbM4H9cup7mT1VA+oxY/EROQgE7Soiby/xoWD+xq8F9WR21Xvv2w3ANOEafLttRK/o59n9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754937131; c=relaxed/simple;
	bh=EA9bkkT0XhYYmCW0R3+2+i82EKaO5vMFwOylL86Cm/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IoRjXWtJg5qKt+yCBnOd1GnDGHj3sufZD7YMaLFpPkr3bq43EsGtAlwPrZ/p0bMtGOfLOM5cVJbAaq6QbKWvqK+6nP8y+mMjuDAOMVy8q4qhB5aLrFu6k0J/b9M7SUxs51C7FgYYYZcea1RLDrH8G6bK7ZYeGF/PQ8JpwNhY9/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OQvzSU1u; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OQvzSU1u"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-710e344bbf9so50025427b3.2
        for <linux-raid@vger.kernel.org>; Mon, 11 Aug 2025 11:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754937129; x=1755541929; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EA9bkkT0XhYYmCW0R3+2+i82EKaO5vMFwOylL86Cm/8=;
        b=OQvzSU1ufhrJQ7EFerZZG1iSy6FfkmfYiWqJSuTMWz9nFiJvBr/vDzjz+xPOdh6izs
         vXDnJJu7aDLPuXJb3Qr1gM7feNklI8jx5UWbq9f1lgnnbefuQpdysjOpQz9MRRiC+COW
         10JsOJKVKXBtIRRTo1kD4P9Xn0Lv700ii313yx+AgNITPeqJtrQvPY9Sf4gs9Rl1jlCy
         iQgGNd8Wnfn/s9qlnMk04s9vIxyP1aG/U4qUIKK4cld0mOQccwbSto6Ysp43qzjr/e6o
         tdcUYuC3Mrnd31bWKybyjTAPV99SKVfRKmWHb80fwqka9iOrDVMjRiU9GQa8b3d/gBQe
         Sdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754937129; x=1755541929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EA9bkkT0XhYYmCW0R3+2+i82EKaO5vMFwOylL86Cm/8=;
        b=Eeth1V9XFVKOI6zexuFpTqfYC6aS4+EX2F/7RqZBlvKzJlIv2vF639bVBlApR5dnLy
         /gb+ZHWd3+2QQHRvLl8FoAPjFziRith5pJysyBJsekkYgy53unFiio1LNtjetvib1e6V
         A1rElwbbR46UYytNLX75jUdw07C6EPZ0qPpMikSEodP6IbGLtqOijSn2oYCyeC+/+XSa
         SzkkUnIYJN0Z8nuWCxJtYfAJXttuLrc+7XNp2OZxEk2gQOtMWY8RNQHIdCRRnL861uhk
         rxPvRs7XV8AdeYxMKLqMPtBFhFAC1hZl8yQ6kqostG5LE0dQN72iBrCkKVkIGwuZc3+i
         Eq8g==
X-Forwarded-Encrypted: i=1; AJvYcCXhiSSuE5qtUZtUcGcQcRxg4iaVo7emxkTbH69Yl4DN9vBvwows81XGhQgzmqkyT1M06MU4KEJkSWMA@vger.kernel.org
X-Gm-Message-State: AOJu0YwMuAYP3+pN+LyJaZBa3fhXDB0TwkqMjYP84Q9BV4Gd/QOYNzEI
	ij1hZNQHE0cxx630fwTOk0QGaP0vSZtOP3ge3AY6eVu53dVquAdEmkuZNJlIxRNNKnyuY7pSvkN
	BmIsE3oNNvTBvYDPYDODqUq5TB9XMUIY=
X-Gm-Gg: ASbGncuLIClHORypxj1jOQDakj8bL8p3K5nmo8/IVLcKrmgW5VDMY41XhequyF8OeU/
	XDdvelJYafapgXFiq+IH16bowvhDjRAfA/EVnHy9WokZpGGTXV1cOXxWcIcTzNBKC7oVKph3ZN0
	oC6CsZg4m9IyFct+s+62VzbA/As2wIJMiRovSxuQi9mZwkUevW9LCcZ2T7MuyrVVFT7dz5gSp2X
	9VwRLsYjM/IvHjUT4xYfeuFQ1yMANuwNJpK26i6mA==
X-Google-Smtp-Source: AGHT+IGbTx/JZEJsGeF7z+bSysogGxz9+59JFTDNMOoHk0z/DfHjWwqnp19kn+SLtzRqTD3/34mEjI7Q6VM203uvK/E=
X-Received: by 2002:a05:690c:6904:b0:71c:149b:86a0 with SMTP id
 00721157ae682-71c149b9202mr109590217b3.6.1754937128985; Mon, 11 Aug 2025
 11:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
 <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
 <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
 <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com> <CALTww28y-cuJMAGfWjgVdjhkFB8w-z7SR48nNvdRHM01L0TGow@mail.gmail.com>
 <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com> <CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com>
In-Reply-To: <CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 11 Aug 2025 19:31:56 +0100
X-Gm-Features: Ac12FXyCdduIQXlZdVkOldkYYjA-b0tuHOYzRx_IRozEZfvISLu0zXjROXtiGxo
Message-ID: <CAMw=ZnS+2oqGZ31wkMEFheXi_8xk1hSM1tnW=wh_wc98TGDrXw@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	linux-raid@vger.kernel.org, vkuznets@redhat.com, yuwatana@redhat.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Aug 2025 at 09:07, Luca Boccassi <luca.boccassi@gmail.com> wrote:
>
> On Fri, 8 Aug 2025 at 07:40, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > =E5=9C=A8 2025/08/08 13:28, Xiao Ni =E5=86=99=E9=81=93:
> > > I know it's not good to break mdadm by a kernel change. But sometimes
> > > it needs userspace tool and kernel work together to fix a problem,
> > > right?
> > > Sorry for bringing the problem, and thanks for the suggestions. Any
> > > more good suggestions?
> > >
> >
> > Idealy, we should fix mdadm first, then after a release, fix kernel.
> > Sadly the transition stage is missing now. :(
> >
> > If we want to just avoid this problem in kernel, what I can think of is
> > adding a switch and mark it deprecated for now. And in new mdadm
> > releases enable that switch, and after sometime, remove mdadm legacy
> > code to stop array, and finally remove the deprecated switch in kernel
> > then everyone will be happy :)
>
> Hi,
>
> As long as the change makes the current default behaviour backward
> compatible, and the switch is used by mdadm to opt-in the new,
> incompatible behaviour, then yes that sounds like a good solution,
> thank you.

Hi,

Any update? RC1 was released with this regression. Any ETA on the fix?
If it won't be ready soon, would it be possible to revert the change
for now, until the fix is ready? Thanks!
