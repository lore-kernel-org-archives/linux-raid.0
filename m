Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34EE13C8ED
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711468281; cv=none; b=nrEM8BrMvNukTyAxzrwV4UpwC7isaVsTLSIYNF6GXkTeEPCcXPNUh8nQI0pxFUNDKr7TCAcUzk0WCwIiVbj//8zzETCrDcw6TbjBfPZblZ9i1ERuEioFt8IW7HT83mKtaBWzNxEvIgqKA4wJuC09yPHlrHzdqTbZ70uEHKOfYuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711468281; c=relaxed/simple;
	bh=DBUuwu4S8tsCbdHQRTCucS+nn9YHkQIomXKF5xJhRO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YdooKsuG/xUNKTrjg9DOiTtQi7jmIWH4utcs5e9252zRuBQ/I5wKURAY8gWrobRpzBpvCCoMN65iDLUUwCrdvOzh5VRTreMHjML/+yry2ulwCGyecpxrqojjBybl1uFm9r0GD5fsoSoPaKkEbWL4GZycBICYKNyNkxZW1Zg/T5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=R51umts6; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="R51umts6"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d52e65d4a8so76189731fa.0
        for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1711468277; x=1712073077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBUuwu4S8tsCbdHQRTCucS+nn9YHkQIomXKF5xJhRO8=;
        b=R51umts6WCfCxthkiwVuPP/u7OlWKf9ZucwF35YhKVkiyX7MLDcfIUt3xaNQP3wRQw
         XZuGhsP0lmPFJJZVxwE0k4AG+I6PaBUG30i140pW5L3tzZKrASqnxVUbWQ1Rjc7C1d0o
         5rowFV1BkvEKIA8OvC2kUmCCHdm3cib5fYYDHkf+2/cnffZEpB1T1yjqQyWALBI+iT/9
         WEhb+f9yqdUaj7SPKOTxEcMmTpd1KmGEEjDzo8ZNEeL6PO9aJuiKWP6YPE8+VK/pDPXA
         e1tbKBsHI2EmYAxUGhPqqYb9m6RX8nnPrIudSNP67HIC6f/ckGI3qz5aL2+CBbQXcbI9
         t0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711468277; x=1712073077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBUuwu4S8tsCbdHQRTCucS+nn9YHkQIomXKF5xJhRO8=;
        b=dP2wYhtfkDpGyXEpKya8iqQKD9wV1X12LNAPIRycyrwhV9n/ZvpOivO6je/cZzN6Cc
         A5vZdkGUyMLZ1wGxd082J9izEes9rZ5R3imfwCF+Bv/Qot7cNYKAsjIKfzt7i0TsZODA
         P78zW+WxFHThKEqQadt8VpcLGRpA8DdpKfNS5mX+bhE3GyDo9+nScno+FFF4h4ZqSNkK
         yzKFyfLZDDLFC2ZiJN5G3DTtg73Qvp/i2uXoz2Yjkdt5ydZOSKVMxt+JV76Tyaec16lY
         4Guvfrs2ru5eJ81BumuiIaSmdOESezHmNU/fvcHtIUwCfgqmXYXMpaW2iehoLdAgcgqi
         x/EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc5VaCni+QLBjtoNbuknhCeJSryLn+pgKiv+pYHDMEULXnSwQEkHzdEJcjXB/djUO/+uGt9xLA5GvpJ6548HG6piSv2QsqrplGPg==
X-Gm-Message-State: AOJu0Yx2MsJ24F4jR2axt9Xmj4wGeLzqNhlU+Gkqj8xOKe83o08bN9Tc
	l066Ky+JTTGaSqr80WW3TukJKj+64nYcCsopoEqJ42VkWR7n79wiaX91xKena81p2kJjp6VLhBY
	Y5JjjxIpoUx5pB1z0bujVSSz5WsYVWxldHmKK5Q==
X-Google-Smtp-Source: AGHT+IGSSP9dc9nrI4bf7Q5qlKEPjIqhJURaKvkmM6gQHC7ViXAQS8mR7Elmuontmwf7LDAJmuj2KC1l9oys09AQ5as=
X-Received: by 2002:a2e:7805:0:b0:2d6:ab2f:7862 with SMTP id
 t5-20020a2e7805000000b002d6ab2f7862mr6282154ljc.2.1711468276473; Tue, 26 Mar
 2024 08:51:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307120835.87390-1-jinpu.wang@ionos.com> <CAMGffEm8hhg=C1BayDxRhGSTT2b0DBzopr3RWB7aM+XG3yTYNg@mail.gmail.com>
 <551949c9-c6ff-1ae6-fa05-660f1bd76249@huaweicloud.com>
In-Reply-To: <551949c9-c6ff-1ae6-fa05-660f1bd76249@huaweicloud.com>
From: =?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Date: Tue, 26 Mar 2024 16:51:05 +0100
Message-ID: <CAHJVUei1TOy07B_k-6j7ZRD1AaAS-xMGPX+GSL0ZWR4=f01FJw@mail.gmail.com>
Subject: Re: [PATCHv3] md: Replace md_thread's wait queue with the swait variant
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, song@kernel.org, linux-raid@vger.kernel.org, 
	Paul Menzel <pmenzel@molgen.mpg.de>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Kuai,

Thank you for your comments and questions.

About our tests:
- we used many (>=3D 100) logical volumes (each 100 GiB big) on top of 3
x md-raid5s (making up a raid50) on 8 SSDs each.
- further we started a fio instance doing random rd/wr (also of random
sizes) on each of those volumes,

And, yes indeed, as you suggested, we observed some performance change
already after adding (first) wq_has_sleeper().
The fio IOPS results improved by around 3-4% - but, in my experience,
every fluctuation <=3D 3% can also have other reasons (e.g. different
timings, temperature on SSDs, etc.).

Only afterwards, I've also changed the wait queue construct with the
swait variant (sufficient here), as its wake up path is simpler,
faster and with a smaller stack footprint.
Also used the (now since some years available) IDLE state for the
waiting thread to eliminate the (not anymore necessary) checking and
flushing of signals.
This second round of changes, although theoretically an improvement,
didn't bring any measurable performance increase, though.
This was more or less expected.

If you think, the simple adding of the wq_has_sleeper() is more
justifiable, please apply only this change.
Later today, I'll also send you a patch containing only this simple change.

Best regards,
Florian

On Tue, Mar 26, 2024 at 3:09=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/03/26 13:22, Jinpu Wang =E5=86=99=E9=81=93:
> > Hi Song, hi Kuai,
> >
> > ping, Any comments?
> >
> > Thx!
> >
> > On Thu, Mar 7, 2024 at 1:08=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com>=
 wrote:
> >>
> >> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> >>
> >> Replace md_thread's wait_event()/wake_up() related calls with their
> >> simple swait~ variants to improve performance as well as memory and
> >> stack footprint.
> >>
> >> Use the IDLE state for the worker thread put to sleep instead of
> >> misusing the INTERRUPTIBLE state combined with flushing signals
> >> just for not contributing to system's cpu load-average stats.
> >>
> >> Also check for sleeping thread before attempting its wake_up in
> >> md_wakeup_thread() for avoiding unnecessary spinlock contention.
>
> I think it'll be better to split this into a seperate patch.
> And can you check if we just add wq_has_sleeper(), will there be
> performance improvement?
>
> >>
> >> With this patch (backported) on a kernel 6.1, the IOPS improved
> >> by around 4% with raid1 and/or raid5, in high IO load scenarios.
>
> Can you be more specifical about your test? because from what I know,
> IO fast path doesn't involved with daemon thread, and I don't understand
> yet where the 4% improvement is from.
>
> Thanks,
> Kuai
>
