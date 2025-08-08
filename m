Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A87125C818
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 08:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754640470; cv=none; b=YGrFOObqyRq30kH1T1dDWgC1vCmETx149xwAm0xXs0Y07T8AUAiCb+ShwZnZMqbgDWWLmviAAklLYJRZIEXKAdCgRSLNsGsShjT6aFw3lI/oQvfT+jb7knlzFQhea0a37jxoULkBvfKUqi3dGIDerC+IWluJVZUijL0NTzc8cB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754640470; c=relaxed/simple;
	bh=fDpMXCBai8L8w8RD1KIWKBH167LyEdkuXsw9RxUr4y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F/ry88pjf0CzLO0xHHGlinOTKdoKWjImaV9NRFDzLRJMm+hYj/y7UbvcakRT+jMc9EXTPpiKOvyc3ntnqg2xVN9Nbi+uum4EDwr1qEv7UYIDGJDCOjYNU9de16ZOobIYBd9IlOZgDA1kTT5wSXLbTU5s2P7/LpnuME+zZm82i08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SPBDNT1Y; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SPBDNT1Y"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-718389fb988so19631687b3.1
        for <linux-raid@vger.kernel.org>; Fri, 08 Aug 2025 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754640467; x=1755245267; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDpMXCBai8L8w8RD1KIWKBH167LyEdkuXsw9RxUr4y8=;
        b=SPBDNT1YpTQ+JBwn/1X1TPg0qJL2KDZlFqPyZH8Lj7IIH+nT94wVZnTgtqr4E8fyTF
         kGHuTJXOQ434FCEmVhCnwktkHcOygltAxILAW8hEzgE/gHa9NVKlSh3VaLP1/8wt36S7
         XhJzLLb6wUHqUe2vraKEfza+I1sDUb3bW/wQYymKwSjTChzG1lv2WkOLgYcPtAFOKqj5
         jiwIATjWksDU2SE6+BNstOSgOQHRSHw4dMNkCIvH9Po5ww1+injX4sLiR50/SzjV3BXk
         5bajoJi1Mi9lZVNMoL/ncmGqoxuMEl1gjkHpOZaqzY58jD37gmm2mjtg4YsysAWmii08
         6vFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754640467; x=1755245267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDpMXCBai8L8w8RD1KIWKBH167LyEdkuXsw9RxUr4y8=;
        b=Q/5dJfTT9f05YS7xziPemBYLC2a6KSpzhCgY9dwp0dtxoPXG1BF3n7v+ViTpZYH3VI
         ouSZc+Od5jXNH957qXbY8+47XmZu1HzVLu9COIPP4vqQ1rFoEMIXbBqiN48zFAWs9+vo
         w5m2wNmYgBXQv3KpvpnRrmuZ8Fwn15rSmIJ2Gr6LN6QdoJKCvEqXjBN+6c/TL4SpKgwd
         4hhT5dQkwKTZzknWo6TENUqemr103l6t4RGX/qPce9Xvbyk8cxjSovV1aBgTBO5WYhHh
         FUeYZVTqT7B7PrjWPE2H0DO/Y4qbW++6+7rWLRYN02MVJKPXGMMG/FZpFgODnmmUJRoN
         KzFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTyA8ZD9abRvm2dyDKQbQPFkB2xn4oZLOmnNwHJ5QN5c6dv+7BjoSb+TRnplfd4Z2hvnunSQciOB7j@vger.kernel.org
X-Gm-Message-State: AOJu0YyRqGCb1uuocpYNyuB1jx7l4M2LgUUPTfLe9mHT9bIqdMUPyTpg
	rohRxhn4kEec1dA81i4uftC6wMwpHHs1X5TtepnVFnbE6iSqnNUqlRWepucopx2+0dXgaSrENXS
	jocjfS4i83u5mDeZXV05KYHFKXoWtRaw=
X-Gm-Gg: ASbGnctEe0NUWQ0PgrJFTJ9X8axv1WBR0Haxrsw2PEkyZYX7u6HUmqypBPHgqLs599o
	uCqMOj2H7wAyWB5EnUz8Tlx9u5lDk4bj/gk6z3WNQxZNcL+ZQep1v4KUav9ZiBbPu8+6tbr/1FY
	+68x39Zmth8waL7Q/tSIg7gUe6VfNrPNimP2tZkO5B7UCUiIrNzWMS8JQSTv2JJccc8JggBJIsT
	mIEmaZqkOWL2D41jK8Dn912FBt5Lt/jgJgJTm9Xwg==
X-Google-Smtp-Source: AGHT+IEEc1v8F1LczEl418kjEXTKrLa1av47aTJLd2H4GBFv5v6cF/0hLdMvpdIVDwheKqTDaJtgVIB3KBLkOSlNWZ4=
X-Received: by 2002:a05:690c:6312:b0:71b:6ad2:d10a with SMTP id
 00721157ae682-71bf0d48bb0mr23745147b3.11.1754640467465; Fri, 08 Aug 2025
 01:07:47 -0700 (PDT)
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
 <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com>
In-Reply-To: <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Fri, 8 Aug 2025 09:07:36 +0100
X-Gm-Features: Ac12FXziJNltyoSIdHQl3HlZgwzpsLeFn1Kue3fvW3kCYAv9YDRtjR1IILgu7TE
Message-ID: <CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	linux-raid@vger.kernel.org, vkuznets@redhat.com, yuwatana@redhat.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Aug 2025 at 07:40, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> =E5=9C=A8 2025/08/08 13:28, Xiao Ni =E5=86=99=E9=81=93:
> > I know it's not good to break mdadm by a kernel change. But sometimes
> > it needs userspace tool and kernel work together to fix a problem,
> > right?
> > Sorry for bringing the problem, and thanks for the suggestions. Any
> > more good suggestions?
> >
>
> Idealy, we should fix mdadm first, then after a release, fix kernel.
> Sadly the transition stage is missing now. :(
>
> If we want to just avoid this problem in kernel, what I can think of is
> adding a switch and mark it deprecated for now. And in new mdadm
> releases enable that switch, and after sometime, remove mdadm legacy
> code to stop array, and finally remove the deprecated switch in kernel
> then everyone will be happy :)

Hi,

As long as the change makes the current default behaviour backward
compatible, and the switch is used by mdadm to opt-in the new,
incompatible behaviour, then yes that sounds like a good solution,
thank you.
