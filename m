Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE91A481A3
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 19:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482570; cv=none; b=pyKVS3vcA05dkod+MfD8P9xjCuyvNIwEw9M+8YxiLeL/Q/wxCimnFIYcrLeqTyx+8pkiF7yZ6xtaRh52IUIZlUOUGJoyEkzzhJKuyW0xwNV7Ziu94n2NOCsr1VyTb8FyS+q7Rxk6OFtzvGfl4aJr3dNtb4xaacg9neKB9SR3lHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482570; c=relaxed/simple;
	bh=ng3AXZSK7QMyJLoxpZnpSIT3+fJH4WAPkpBDbIHNZj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mop+Q49ohqCzQqc8mIA1xm7McwHfHSIW7ha03JrG0j/sNGt1pkzrmWhnYdCpJ2x4HzwtqWeLonghU0jZqEDNNEwJUcdeUoRPFseiF+HvdaNy4zTDEJqECg81gBWJu2N9MOLtCjTQdWbBIEB4ytcClWVPmm8h5q1Wwh4Ji9dyOQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gjmK8QVD; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gjmK8QVD"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d6dda3adb9so24389831fa.1
        for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 12:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1711482566; x=1712087366; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ng3AXZSK7QMyJLoxpZnpSIT3+fJH4WAPkpBDbIHNZj8=;
        b=gjmK8QVDYP8ePx3RURTcXMTYsgMOA5hAE5ILyzpbHNKBYKefswZYkALjdg/fr8zpAr
         b3R1QFtsiUtBHKJ1hiVJtLUQ+WjUcgu43ch3eJ7CMDdCavG4WEB3u25x6AAi6Rl50928
         eXdD4L8EvsNImYD8x2aTp+eVTLp8ihgPlK5wmnOKGS3bzkvBoR2RXfkTcf9a2wjBauht
         feerGsR7PvlkjnwPsbYUhfMSL6rDBmwDIn7/W6fMGjPU8l1bqYvGirkD81BRLhZn3qac
         fIgTJt0vN9GMogpXwXPwXLJ9jYFQpb5onEVRSDKpGFYZ6R650CLIhZ8EKkxxNwbP45OI
         ilrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711482566; x=1712087366;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ng3AXZSK7QMyJLoxpZnpSIT3+fJH4WAPkpBDbIHNZj8=;
        b=LkNr0Om/WJzv+DpZhhxVCwq3FMd+S4A2bAecAKKZbBs91UDuTS214Mfz11wYV8L4kJ
         oho6g/C7D1NjLh03qAy4q3e0YoSrTgXI8q+igWFfWIH4H6N9Oq6rbkWxUF/M4mdthe9C
         tBWizo80jjyUc35sGyv4FkFYBQXuaNrpu6kLQor+wEOQGs/SoCO7LYtM8YV/+L/r4z7Y
         knEV3zTQsD7MKZuf0RgzKmtF5Tdjlb+PtoYw4wcCRW95petX+NLnXr95iaiXi5K9mFvT
         2IeGLqVvyqxTqwGr6oJDs+y5wNsqYjly1ArlZ+WQabpZieto8ownurEm/8QLR9gGxz8h
         bQ5w==
X-Forwarded-Encrypted: i=1; AJvYcCX7d6W3rTPyBKJLpy/rYVv5DHXsP/jUQEslF4PpEXtOWmSYSdQ18kpieRkr1bX0bgT9ykjvHfJGZN/J+VNSfwYNOhYy4w6uBEacIw==
X-Gm-Message-State: AOJu0Yz8VnoPM7wLPLWt+Sf2Ih8b8XcdbOpRufsPGJJwFAcf+WizbVO+
	xQm+oDzBfOTjoOS+PbsSSHMI6ivnqtosSmLKu/WYNsuF9ytH3n98vilkvOhJ/+0EhuzOzLoaXX8
	bCu/S4Z3k8Gld4Xg25LP5VIOqIi40DJGVdZWEXQ==
X-Google-Smtp-Source: AGHT+IHpunWSYULwGC0ho6odYdnBYqN1x6ANkahVtsI9hF0d5n18DXvfo7O1+15z4FI5vgwTbyadIkAmsvzK7uEtTqg=
X-Received: by 2002:a05:651c:1407:b0:2d4:3d86:54e2 with SMTP id
 u7-20020a05651c140700b002d43d8654e2mr2187475lje.27.1711482565376; Tue, 26 Mar
 2024 12:49:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307120835.87390-1-jinpu.wang@ionos.com> <CAMGffEm8hhg=C1BayDxRhGSTT2b0DBzopr3RWB7aM+XG3yTYNg@mail.gmail.com>
 <551949c9-c6ff-1ae6-fa05-660f1bd76249@huaweicloud.com> <CAHJVUei1TOy07B_k-6j7ZRD1AaAS-xMGPX+GSL0ZWR4=f01FJw@mail.gmail.com>
In-Reply-To: <CAHJVUei1TOy07B_k-6j7ZRD1AaAS-xMGPX+GSL0ZWR4=f01FJw@mail.gmail.com>
From: =?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Date: Tue, 26 Mar 2024 20:49:13 +0100
Message-ID: <CAHJVUeiaDCnCF7Z2Hvj+n4VnB7VMfkorEWqytU5cBq3o9_vayw@mail.gmail.com>
Subject: Re: [PATCHv3] md: Replace md_thread's wait queue with the swait variant
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, song@kernel.org, linux-raid@vger.kernel.org, 
	Paul Menzel <pmenzel@molgen.mpg.de>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: multipart/mixed; boundary="00000000000059bf7406149596c2"

--00000000000059bf7406149596c2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

here (attached) the promised simple patch.

Best,
Florian

On Tue, Mar 26, 2024 at 4:51=E2=80=AFPM Florian-Ewald M=C3=BCller
<florian-ewald.mueller@ionos.com> wrote:
>
> Hello Kuai,
>
> Thank you for your comments and questions.
>
> About our tests:
> - we used many (>=3D 100) logical volumes (each 100 GiB big) on top of 3
> x md-raid5s (making up a raid50) on 8 SSDs each.
> - further we started a fio instance doing random rd/wr (also of random
> sizes) on each of those volumes,
>
> And, yes indeed, as you suggested, we observed some performance change
> already after adding (first) wq_has_sleeper().
> The fio IOPS results improved by around 3-4% - but, in my experience,
> every fluctuation <=3D 3% can also have other reasons (e.g. different
> timings, temperature on SSDs, etc.).
>
> Only afterwards, I've also changed the wait queue construct with the
> swait variant (sufficient here), as its wake up path is simpler,
> faster and with a smaller stack footprint.
> Also used the (now since some years available) IDLE state for the
> waiting thread to eliminate the (not anymore necessary) checking and
> flushing of signals.
> This second round of changes, although theoretically an improvement,
> didn't bring any measurable performance increase, though.
> This was more or less expected.
>
> If you think, the simple adding of the wq_has_sleeper() is more
> justifiable, please apply only this change.
> Later today, I'll also send you a patch containing only this simple chang=
e.
>
> Best regards,
> Florian
>
> On Tue, Mar 26, 2024 at 3:09=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2024/03/26 13:22, Jinpu Wang =E5=86=99=E9=81=93:
> > > Hi Song, hi Kuai,
> > >
> > > ping, Any comments?
> > >
> > > Thx!
> > >
> > > On Thu, Mar 7, 2024 at 1:08=E2=80=AFPM Jack Wang <jinpu.wang@ionos.co=
m> wrote:
> > >>
> > >> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> > >>
> > >> Replace md_thread's wait_event()/wake_up() related calls with their
> > >> simple swait~ variants to improve performance as well as memory and
> > >> stack footprint.
> > >>
> > >> Use the IDLE state for the worker thread put to sleep instead of
> > >> misusing the INTERRUPTIBLE state combined with flushing signals
> > >> just for not contributing to system's cpu load-average stats.
> > >>
> > >> Also check for sleeping thread before attempting its wake_up in
> > >> md_wakeup_thread() for avoiding unnecessary spinlock contention.
> >
> > I think it'll be better to split this into a seperate patch.
> > And can you check if we just add wq_has_sleeper(), will there be
> > performance improvement?
> >
> > >>
> > >> With this patch (backported) on a kernel 6.1, the IOPS improved
> > >> by around 4% with raid1 and/or raid5, in high IO load scenarios.
> >
> > Can you be more specifical about your test? because from what I know,
> > IO fast path doesn't involved with daemon thread, and I don't understan=
d
> > yet where the 4% improvement is from.
> >
> > Thanks,
> > Kuai
> >

--00000000000059bf7406149596c2
Content-Type: application/octet-stream; name="md-6.9-md-thread.patch1"
Content-Disposition: attachment; filename="md-6.9-md-thread.patch1"
Content-Transfer-Encoding: base64
Content-ID: <f_lu8si60d0>
X-Attachment-Id: f_lu8si60d0

Y29tbWl0IDcwZTc2MzVkOGFkZmQ3OWE1ZTE5YmZmZjA0NzFhYjkwMGI0NTRiYzAKQXV0aG9yOiBG
bG9yaWFuLUV3YWxkIE11ZWxsZXIgPGZsb3JpYW4tZXdhbGQubXVlbGxlckBpb25vcy5jb20+CkRh
dGU6ICAgVHVlIE1hciAyNiAyMDoyNjoyMiAyMDI0ICswMTAwCgogICAgZHJpdmVycy9tZDogYWRk
IGNoZWNrIGZvciBzbGVlcGVycyBpbiBtZF93YWtldXBfdGhyZWFkKCkKICAgIAogICAgQ2hlY2sg
Zm9yIHNsZWVwaW5nIHRocmVhZCBiZWZvcmUgYXR0ZW1wdGluZyBpdHMgd2FrZV91cCBpbgogICAg
bWRfd2FrZXVwX3RocmVhZCgpIHRvIGF2b2lkIHVubmVjZXNzYXJ5IHNwaW5sb2NrIGNvbnRlbnRp
b24uCiAgICAKICAgIFdpdGggYSA2LjEga2VybmVsLCBmaW8gcmFuZG9tIHJlYWQvd3JpdGUgdGVz
dHMgb24gbWFueSAoPj0gMTAwKQogICAgdmlydHVhbCB2b2x1bWVzLCBvZiAxMDAgR2lCIGVhY2gs
IG9uIDMgbWQtcmFpZDVzIG9uIDggU1NEcyBlYWNoCiAgICAoYnVpbGRpbmcgYSByYWlkNTApLCBz
aG93IGJ5IDMgdG8gNCAlIGltcHJvdmVkIElPUFMgcGVyZm9ybWFuY2UuCiAgICAKICAgIFNpZ25l
ZC1vZmYtYnk6IEZsb3JpYW4tRXdhbGQgTXVlbGxlciA8Zmxvcmlhbi1ld2FsZC5tdWVsbGVyQGlv
bm9zLmNvbT4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMK
aW5kZXggNDhhZTJiMWNiNTdhLi5kYTU0MGI3ODk0MTEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQv
bWQuYworKysgYi9kcml2ZXJzL21kL21kLmMKQEAgLTgwMTcsNyArODAxNyw4IEBAIHZvaWQgbWRf
d2FrZXVwX3RocmVhZChzdHJ1Y3QgbWRfdGhyZWFkIF9fcmN1ICp0aHJlYWQpCiAJaWYgKHQpIHsK
IAkJcHJfZGVidWcoIm1kOiB3YWtpbmcgdXAgTUQgdGhyZWFkICVzLlxuIiwgdC0+dHNrLT5jb21t
KTsKIAkJc2V0X2JpdChUSFJFQURfV0FLRVVQLCAmdC0+ZmxhZ3MpOwotCQl3YWtlX3VwKCZ0LT53
cXVldWUpOworCQlpZiAod3FfaGFzX3NsZWVwZXIoJnQtPndxdWV1ZSkpCisJCQl3YWtlX3VwKCZ0
LT53cXVldWUpOwogCX0KIAlyY3VfcmVhZF91bmxvY2soKTsKIH0K
--00000000000059bf7406149596c2--
