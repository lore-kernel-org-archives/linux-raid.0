Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2171802DB
	for <linux-raid@vger.kernel.org>; Wed, 26 Jun 2024 11:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719401630; cv=none; b=imi1C74RU8ZF/7cqw0wJ3cuQMSEJmvDhCZkzJ/9VE7TPfI9t0uDSxXhEk7gItUAxfFFO3RoJRN/MEqW3bW3Vy5XBGXZbM5dEDW6NqY42tbW8vaTAr2ke3Q6ybltlqgx2fftmRLlJGano+V3AUSw9FT7PvYbqLBDCE/YhOF6D3S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719401630; c=relaxed/simple;
	bh=wYm9Hs4YqSi12EH2JAqM0nnipLcFSABHWJY4860Tjxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=NYGPLJz0/jGDrx3N41DhsHFzBG4xBWfGBgR1o2mLlmiZRAq1aDbS5rm80iA8MXiPELJCZgv07QBOai+qUkZ5fEDMVrb2ONSsAam7/dFltXh0TAZiK3TR6n7HL4VJhxm1iqvyruVfYco6V3zPnAj4jqj2HbR0N/Ijj+zHXtddOT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P/PW1jSP; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/PW1jSP"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-79c06169e9cso110571085a.3
        for <linux-raid@vger.kernel.org>; Wed, 26 Jun 2024 04:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719401628; x=1720006428; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYm9Hs4YqSi12EH2JAqM0nnipLcFSABHWJY4860Tjxc=;
        b=P/PW1jSPae2oGaSQalSP2l2ttDk8qCJvH9/9Z0VpKUKZELVu5y5qoXEXY4XkY51fmA
         ubufAS9tW3gw73T7k2tiMhCB2BYsyn2azg0JICxsGkyYCSJUUizkV1MQ5MtbQumnXaI4
         0Y6n+WSzQ2EOC/Q5nejX687mCnodkSTFiXpcz1buTbZI5cuDdELzljuLA0+9PQp5AeNw
         TIVcBbNYaCzD6A7oSecbrXAEoIKvodlcssPChwlRYD/1mARXrOwA5si+ol36sh6+WSZE
         hTW2Z1xCTRA/A06ti/Wc/BuczpKUs63C3h/JlUJOkuOm5aCXcATyPojz3knZ9vGfrsgz
         bPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719401628; x=1720006428;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYm9Hs4YqSi12EH2JAqM0nnipLcFSABHWJY4860Tjxc=;
        b=UuBnYDZGwUZFrZhZa/jlbHNbI3SyGKqDcxz+RSmRLUH5dR7lSOLnccHgTd27k1LnRT
         JqLHFMbfoeYobnLYruWE+hFlsOSiJFtsKJwwaRO84KLfilJLHYYwSodRmUQHu9LjMHPL
         UPrB0IuzamBF6SfBmZGhATLZXZt8gD4TKK3VOHRotbT4bMapeLNGHN5BfkT+Jy4yvS6M
         xhibQ/uUBzn8ditGVIMJI0UOnT/mDaJO/Gb2M9WUVEtcaXnb8ndw2Bkw8JjFvgt5t+tk
         MRFwuQz/Ll8YILpBr9KU/sDejTcXwf7hRVY2aubA8XDSeuoswOiDd7Rv+jvXv5+F4NUJ
         K1Nw==
X-Gm-Message-State: AOJu0Yw/SViCKx294XugJGNsVtEMKKCev/kyIWEfOKjIAuKj41ZUm8dD
	sQcx+4gEHdTIkZVnsQwtvVhJ2Wnn3wEBpGgFyuvwkkZvq++gkVCWzYj6NcYmssdUGLaXCg7nRfc
	ecqkWkHu5vSFlkvlMWbJ5tYMDyQ1LMg==
X-Google-Smtp-Source: AGHT+IGqeNeHaz3lfs/Jt1Jw8qxM5L1u90oMIwFGPGYfjHxZnoASkU4PGorlmoySrp4T5y+9HHjn64+K+H00y8xKcro=
X-Received: by 2002:a0c:9c89:0:b0:6b5:42ef:2b39 with SMTP id
 6a1803df08f44-6b542ef2b88mr92408786d6.63.1719401627931; Wed, 26 Jun 2024
 04:33:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW4A6Q4q3tU7AMA3MArpiRwkTwXrb__2k2Xwzy3=-XE+7A@mail.gmail.com>
 <CALc6PW7eUNDDT0+iD7b=ZK5PJX0D0XoStubLYmdW3SsbGBLZdA@mail.gmail.com>
In-Reply-To: <CALc6PW7eUNDDT0+iD7b=ZK5PJX0D0XoStubLYmdW3SsbGBLZdA@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Wed, 26 Jun 2024 06:33:37 -0500
Message-ID: <CALc6PW6rntE012P-mhYFRAywXFahLnBrj3BUQkDijuvSHKTg5A@mail.gmail.com>
Subject: Re: reshape seems to have gotten stuck
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Is --freeze-reshape of any use here?

Obviously the reshape has crashed, I just want to know what is the
ideal way to resolve this. I would like to hear your opinions before
doing anything.

Bill

On Tue, Jun 25, 2024 at 5:18=E2=80=AFPM William Morgan <therealbrewer@gmail=
.com> wrote:
>
> Additional info:
>
> bill@bill-desk:~$ sudo cat /proc/242508/stack
> [<0>] wait_barrier.part.0+0x180/0x1e0 [raid10]
> [<0>] wait_barrier+0x70/0xc0 [raid10]
> [<0>] raid10_sync_request+0x177e/0x19e3 [raid10]
> [<0>] md_do_sync+0xa36/0x1390
> [<0>] md_thread+0xa5/0x1a0
> [<0>] kthread+0xe4/0x110
> [<0>] ret_from_fork+0x47/0x70
> [<0>] ret_from_fork_asm+0x1a/0x30
