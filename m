Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E1A6127
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709650339; cv=none; b=VpGwuW8Kh39TLoZl99W1w/RvPemO/IpSNyHg0q91xZZbpx8rMMn4qJGaS8MUaBrwGG6i9LB6V97DEhZn3Z+7E2ZOvNJa2O/qI+gLOFbff4mC05v7x1jXPwfzZh6KBXc86ysOFpiJZPY5aQhWtPp8E+xTAtslcFG8IvkoiKW/AR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709650339; c=relaxed/simple;
	bh=Hu7j2wlY5xVnDA6KNfuYw4GLlkOh+ILKGopLDBAwiec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WusMp4Ff9W8kamSlTl7aYTEeUj9XlSBOgfOv/pH0prkLHgKC1UWzJxWcPlSF2jrV45SHm+sl4DFNjugShEgK4ZgQTAUosLkn3GY9ElIOeziWORFpLIXAnv8DAQmXyZvdyRNsKMFm+8zq3YjQNmtNFrJfmQDdRsfYY2JI6HTCozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=DQr2132p; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="DQr2132p"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-512ed314881so5340831e87.2
        for <linux-raid@vger.kernel.org>; Tue, 05 Mar 2024 06:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1709650335; x=1710255135; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hu7j2wlY5xVnDA6KNfuYw4GLlkOh+ILKGopLDBAwiec=;
        b=DQr2132pkGGCJmgaR8aha+hDiAjpGsvp9UQElFSQiC00R8kp3CK8JVbY1M3pjWPcvk
         OuuyCB2/iPK2IEPR9nBxnD/460+W0HF6z6bvzEhTtyAkpcGt3pfRL1cCkNlQ36e5F6QH
         ym5F5GUetatzOdAGSSxP+LWriqO0b08LWL84V+gBTjQn+QqU1nuW8eYNE91unvM9eyN3
         G5ihDjr7RqYw8EF1wsPxp9YFqWsjI1DhRDz07K+/87XCh0ZN6faRvxEOgll4/PEYNJuz
         dM/rKBLBq1tLXmKLZ74vigKJ84inX57zCL9bTSHVPrtbyylrcn+hhPX9whGGm5VdUsDK
         dZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709650335; x=1710255135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hu7j2wlY5xVnDA6KNfuYw4GLlkOh+ILKGopLDBAwiec=;
        b=ccaG+aZDCb0hxmQ27JPciAkcXaW3fWf4hlJWu1PqscLDuMWacnvHWWXqvRbVDzzN0k
         K8f9EBp5ir5LOHofFYIRoLZ8xKV5rECVjT42I29UGXwZTHx4FeyVqSBVWSe+KskrzM3g
         Gj0IwtPU3cN4/WIxZQ9p9vXwtDm47PlnpI2y4x2C9sVhyOht3hpdTSTQ3AKrsvJ7u7lK
         17qDaLi3mQt/WozZXy+C4Zd80k4CcwZWRrW2xKstJ4vM36Qll1/yAUK2QL1av66CBmmn
         3YzBvyA4X0bQ201EAB4CgBoFr5Or7ozXJiwQZYRALJ9GUx8bsHmkCeBjN6+XmhWp7hGn
         yAdw==
X-Forwarded-Encrypted: i=1; AJvYcCUyHbNh82jk3XMkOXavXLvVBcSVNVx/ZAg067Gj2Xd80d5jPeuJPvk2dnEzTImqrZT2LF5PiugBdNHoIPl2A0vqrQ0YxXVuX8IYgw==
X-Gm-Message-State: AOJu0YypKz+iopBHsrFBuBbRqfENsu+cCYcOKuH7DLD8syjHjvhQx0fs
	rO0C+GO1ke5KnbrD8d6c3NMfAOXcYGNiB0fyRsRmXfghKBt8tMoclcaIjca6RzUHfx4WE5mryRC
	VhRY8cK2SsHJCUIK9DnGhlnogsD/HN/LXMT7c9w==
X-Google-Smtp-Source: AGHT+IFqSPQm+WdhCRr42PRL/wVZqqjBgT0SKeitLcwQzAVnF1SNkkMgrzR7IaxwJwU3GkBs2TupWuNGkcFIXMgZ3Ac=
X-Received: by 2002:a05:6512:1029:b0:513:55d1:12b5 with SMTP id
 r9-20020a056512102900b0051355d112b5mr1185914lfr.25.1709650334881; Tue, 05 Mar
 2024 06:52:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305105419.21077-1-jinpu.wang@ionos.com> <9874f0e8-32d4-4c29-a332-718fb95a365a@molgen.mpg.de>
 <CAHJVUegG9cL6WnNCeokOnAAJyb4yEWnyzi=S20=K=sREJy3AOQ@mail.gmail.com> <7709385e-1770-4fc3-bc92-7a93b754375f@molgen.mpg.de>
In-Reply-To: <7709385e-1770-4fc3-bc92-7a93b754375f@molgen.mpg.de>
From: =?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Date: Tue, 5 Mar 2024 15:52:03 +0100
Message-ID: <CAHJVUehN_q8J96mtuq-DSmw2V4JVMcQ7GPROF2L-2GQTTH1RPQ@mail.gmail.com>
Subject: Re: [PATCHv2] md: Replace md_thread's wait queue with the swait variant
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jack Wang <jinpu.wang@ionos.com>, song@kernel.org, yukuai3@huawei.com, 
	linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Regarding the IDLE state waiting:
- yes, this could/should be backported to any version which already
has swait_event_idle() macro(s) - and so also TASK_IDLE - defined.

About our fio driven tests
- we used fio "ini" files similar to:

[global]
description=3DRandom Read/Write Access Pattern
bssplit=3D512/8:1k/4:2k/4:4k/30:8k/20:16k/10:32k/8:64k/12:128k/4
cpus_allowed=3D0-31
cpus_allowed_policy=3Dsplit
numa_mem_policy=3Dlocal
fadvise_hint=3D0
rw=3Drandrw
direct=3D1
size=3D100%
random_distribution=3Dzipf:1.2
percentage_random=3D80
ioengine=3Dlibaio
iodepth=3D128
numjobs=3D1
gtod_reduce=3D1
group_reporting
ramp_time=3D60
runtime=3D300
time_based

[job0]
filename=3D/dev/disk/by-name/vol0

[job1]
filename=3D/dev/disk/by-name/vol1

... and so on for >=3D 100 logical volumes.

Best regards,

On Tue, Mar 5, 2024 at 3:14=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> Dear Florian-Ewald,
>
>
> Thank you for your quick reply.
>
> Am 05.03.24 um 13:25 schrieb Florian-Ewald M=C3=BCller:
>
> > Regarding the INTERRUPTIBLE wait:
> > - it was introduced that time only for _not_ contributing to load-avera=
ge.
> > - now obsolete, see also explanation in our patch.
>
> Yes, I understood that. My question was regarding, if this should be
> backported to the stable series.
>
> > Regarding our tests:
> > - we used 100 logical volumes (and more) doing full-blown random rd/wr
> > IO (fio) to the same md-raid1/raid5 device.
>
> Do you have a script to create these volumes and running the fio test,
> so it=E2=80=99s easy to reproduce?
>
> Was it a spinning disk or SSD device?
>
>
> Kind regards,
>
> Paul
