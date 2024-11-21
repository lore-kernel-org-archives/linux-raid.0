Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857E515ADB4
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 08:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732178439; cv=none; b=h0vWB6UYO+e5cfiru5rZD1zyPYs441CPxciN4xPsbWK8Ab+zgm/uTh3e1Z1tZSOb2rxQn0Ax6roNmDWeS3bgdPrboBT+Ai+mnByqoBgMwBNnJ0T3SwZLYoPme4YcNLcxI2ts322KDFtTxYM2S3vn5sSq3CmM9F+LlIegREBNu/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732178439; c=relaxed/simple;
	bh=I4eBaZaVx6nes8q0hwKUpkYL2IV6pUfZfirvBunVQdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W4csUj4aMgS3kU3Q+3V0MVWmOfM2zPo8rrfus7hrBn8yF7W9fRLXBj1Y2zr1wKQqfjwmTu42250ew0BUsYWygbHLTIPAtT6w7EcL2obBi9EMRYAAm3DeWS1ecKH77IWLGjaHOtXLkl5uisEau1KOdImcp11be7OczZx5q+JOuZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UxrFv0f0; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UxrFv0f0"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cfbe8f0cd8so103162a12.1
        for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 00:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732178435; x=1732783235; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4eBaZaVx6nes8q0hwKUpkYL2IV6pUfZfirvBunVQdc=;
        b=UxrFv0f00zYFQyAvJYufghBse4xOgeSft73FoehKDvkWFul/rlrCWb7cDjrnCGU9qq
         QWAPTqySA+fodGXeuaTeqj18a4XK1vZqKbJtLFfLpWPs6ebXvROs7bULSp/UpRi4v64X
         ETNaEdknkoufofH7/4/FqE1ifNgNK0eo0XMQOAGGKrbKccUsQ7YNk1qTk9bqDYVuqYQ5
         9xUbWBmOglQg8KxWYHYo1jkJ32Ji3fk99PzV0+5mi1yvlU7q2Esz4vIEjf+XLTtfOda6
         jAV/oXw2b7dCdg6GsV2pXUy+Bu3Zqo6ZJVYVQ/cRdCc4T1h2nl2JgmE664d7z0J7b5zM
         jJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732178435; x=1732783235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4eBaZaVx6nes8q0hwKUpkYL2IV6pUfZfirvBunVQdc=;
        b=wzjYqFNHV5H4knQMpOsfz+1kO0wts6Uw21CF1NsCuyrWfNtZ8ffc27ElWJlC+JM2Vl
         96dTypGYL+gdNYIsS7K2cOY7Jccz6U42WLdL3Dyiv1sW7U06JEpESuGdLMKinMxKoZX9
         84YRAUQde8IUgQF19kcSsZj9IXqu4Ln6/RAXJr1rX+YSPSXqxl2kzOYqthXQ+s6yHmfg
         EHgHtUxb2p13gIBOh9EzcBZMRTo1wU/QA3u6bLloBzYxnDwmCQj8avSQW0WL/QsXP3P5
         OFlh76Kr37gMHBDwwsne+2yEgvifkoKcEXNQKJvWgJ2GZ5Wkkv2qh5KE0m1s+gkT8QGS
         6k4w==
X-Forwarded-Encrypted: i=1; AJvYcCVV/OyV1heEzT5nIb9odHX/wyyEfkSbNhklFsdUL/+EoOxWLS7wl9YbKjZcW/avTWTWxr3Bma4COZYb@vger.kernel.org
X-Gm-Message-State: AOJu0YwDb2pTsFdMNSbQea/o4vDW32yHOrPMZLpQSrB+kMCKbfZb8+sz
	7l99+m/2uxg9unRlB0efbSKAUpeAYHaIO5JmnnGXWT1jbBpznKbrozjWqDPlzvjxagoLXsJ2jLt
	ycQTMj2WsRJ6TcW7qntxEJkIYrWOlc2JSmklmrw==
X-Gm-Gg: ASbGncu0rcWucg13xqgIB+1w9wIxC93ue07xJI4FlZ90WQopL3pK9Hm3zfXgz3tQ6k3
	x+7+krklrVD5Z5U6YxMwwJMAUDMfX0YM=
X-Google-Smtp-Source: AGHT+IEwNtBFHJJTYnKmgvScRjsEoF81IE7XkBqTTKtS39lBY1EKm8X0tj3K0Chi00aViPvYAvJ1SmIrbUFKUwYdQZg=
X-Received: by 2002:a05:6402:35c8:b0:5cf:4549:ade7 with SMTP id
 4fb4d7f45d1cf-5cff4b341a8mr1740156a12.4.1732178434897; Thu, 21 Nov 2024
 00:40:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com> <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
In-Reply-To: <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 21 Nov 2024 09:40:24 +0100
Message-ID: <CAMGffE=hKeWTJzna8gFi=Q9wSuY9SLFScftdGVqc5MNW_jxQ4Q@mail.gmail.com>
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, song@kernel.org, xni@redhat.com, 
	yangerkun@huawei.com, yi.zhang@huawei.com, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	Christian Theune <ct@flyingcircus.io>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi
On Thu, Nov 21, 2024 at 9:33=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/21 16:10, Jinpu Wang =E5=86=99=E9=81=93:
> > On Tue, Nov 19, 2024 at 4:29=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com=
> wrote:
> >>
> >> Hi Kuai,
> >>
> >> We will test on our side and report back.
> > Hi Kuai,
> >
> > Haris tested the new patchset, and it works fine.
> > Thanks for the work.
>
> Thanks for the test! And just to be sure, the BUG_ON() problem in the
> other thread is not triggered as well, right?
Yes, we tested the patchset on top of md/for-6.13 branch, no hang, no
BUG_ON, it was running fine
>
> +CC Christian
>
> Are you able to test this set for lastest kernel?
see above.
>
> Thanks,
> Kuai
Thx!
>
> >>
> >> Yes, I meant patch5.
> >>
> >> Regards!
> >> Jinpu Wang @ IONOS
> >>
> >
> > .
> >
>
