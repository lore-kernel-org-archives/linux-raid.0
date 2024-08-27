Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B318654;
	Tue, 27 Aug 2024 20:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724790742; cv=none; b=QhW9SIyz2dM6GxyD7RWExtacSciViFALucZWDqg3CGTe1T1thM4RKhW8DIBdZ+kZQtMMJcnSOy/QAcQEBpbIr7Cdki4BjwAZ5e8KVSAx0/DhrpbFF/TcD/9V2axDUlZJiVPhOL096ZZFg6sPVieA/jg8SCzLAeHoWK3EgwNLQoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724790742; c=relaxed/simple;
	bh=M4G8nsErHGmPHJUbbzhPuQWGDGeexSBZ0+4MVUSrSAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dxosxFICYR4j7jvUdG8TnTEqw3ELJA6oqVSG6gtg2/Z+0IO++/xSrwY86WPirLJm4kLeakcX1QwC5ALuc+fXu/fkRwSeTinJwiXS3CWrnfkh1nvMff4v60Fg2q/BNds+04jhuHyHNlhES3gTZR9Opn/kFWKRRf3f5NWBLSMFWKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KT1Weel4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KT1Weel4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E8BC4AF09;
	Tue, 27 Aug 2024 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724790741;
	bh=M4G8nsErHGmPHJUbbzhPuQWGDGeexSBZ0+4MVUSrSAc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KT1Weel4vdPRw3IcEl+4gclGEEItgEV8nLpgYrcDzYl2xKuM5hXmv7/SYpaQuRivL
	 aY5n4kdIK47hY3OID1ap2cmjg5kS9AUj4SGkSoyvafMeqkq3zM2Hr4lG58VUeaONzl
	 HHeCaHrUVlFUwe+NNvf/N1P3sbTb6FcBpTDXIiEZ+r2cHHLzbqdIBE8To0s/wt57f3
	 cAO69LWJjf9iWc6ljUxXZNsNgNogw5hw62iTpoN7YdUBEDMWMyF5zPg436vpZRx2Ts
	 xTENTHCuWwJfV9FRZniBK1iK1ZkcJpxu+vSZ1yDHJFujHSlJcBZJKHOcXrMJo2ex4u
	 dndULy8RpdQtA==
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-81f905eb19cso331806539f.3;
        Tue, 27 Aug 2024 13:32:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUPS23u7Q9hb0UaGP3nSJZY+des2q6+YxBPJ+jharAd0zo5lAj4UIS2GSROSTaSw8glSdgF4UcXU9L2TQ==@vger.kernel.org, AJvYcCVyDzbVQdphWVxtVF5u5NIKU7949oDq9ODsSQTNnE1EzyIs+zOZ6OE7CZVtdtzgChgr+YInksNheteToEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVBCIoCPofX6vgo9eCiKaipbe3KFbkBMDfkIwXx9sKebK6JvLk
	A3u4FbjhmFsrJ0d4xFQV12k4LzQSZxb1bJBle4q0fWAzmGow+XvJzhVd8UsoPTqf5a+2kRDdC2R
	JVglef8RPgheIZLDd0ZROwJvG2uY=
X-Google-Smtp-Source: AGHT+IFFyuIFJ6zN3EVD7P5ROgVxeSv1uWmnCdw1aoIjlvCJi6KdXmIS3bEvoFTgnqxxNExSZcndYk5+17/iOW1o6s0=
X-Received: by 2002:a05:6e02:1986:b0:39b:3a63:6dfd with SMTP id
 e9e14a558f8ab-39e3c977a03mr175619825ab.1.1724790741116; Tue, 27 Aug 2024
 13:32:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Tue, 27 Aug 2024 13:32:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6NOW9wuYD3ByJbbem79Nwq5LYcpXDj5RcpSyQ67ZHZAA@mail.gmail.com>
Message-ID: <CAPhsuW6NOW9wuYD3ByJbbem79Nwq5LYcpXDj5RcpSyQ67ZHZAA@mail.gmail.com>
Subject: Re: [PATCH md-6.12 v2 00/42] md/md-bitmap: introduce
 bitmap_operations and make structure internal
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, xni@redhat.com, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 12:50=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
[...]
>
> And with this we can build bitmap as kernel module, but that's not
> our concern for now.
>
> This version was tested with mdadm tests. There are still few failed
> tests in my VM, howerver, it's the test itself need to be fixed and
> we're working on it.

Do we have new test failures after this set? If so, which ones?

Thanks,
Song

> Yu Kuai (42):
>   md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
>   md/md-bitmap: replace md_bitmap_status() with a new helper
>     md_bitmap_get_stats()

[...]
