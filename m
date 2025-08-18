Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E167433472F
	for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532706; cv=none; b=EayE3/f1CxqEpgfHb6jrTOMM6L2eZ112ObSW4vDxuhn6AdrQVB0tiKnZAYceR7pn/ePuIeARnsQCnDpscdGtMW90dkfkBcFiabOz6qL1pnO2qAA/KJryVaJQg3AaOgHjEa7oVDPY2kat31OTan9+RTCYmNHoxsg74fAVXpafu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532706; c=relaxed/simple;
	bh=N5t6gF7GnMpdWyLmPfqdjFsiI3qOo+eOeZTSrb4BynA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nJ13cDl7wcfHIwcZqmDJtYcM1cvSeZZODc9WBj5HunkJ7gmUnJkEHqRMb/zk/fXTkqmvTtDo0WivLixxA4GghTCabT2q9konLrOKBsdIGeHcxbGfRJtAF0kwCYMepAwNZ833ErQfb7K5c9tRtaMOva1e9x63XrmRgHsSyKu0Gms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTMFI9lM; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTMFI9lM"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e93498d41a1so1288156276.2
        for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 08:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755532704; x=1756137504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wroxQTju/JIwVItXhFFfdcs8fEJyV3fG1QbV4k2Tc4Y=;
        b=aTMFI9lMhtL7H/ETZRcDOVqOWOtlac1j1sX/PsX+cwPDTPDJ1JkNxVmjHJ4DcAaTeH
         WYQdQNAeVsO7SOmCTrXgmFpsyrjh3fBksM0s7xMd6aBxhwP/y0L0phXWE5M9k1WhlIvO
         9Ao3Dp/wVHdGcWXWQvO7hBRaSJPm5ZbOJm7Zw22itHkUAkg7fNBGyJ/U07t4XqmvBY+w
         H/+rpjgqDNegdjIrDzIe07BOmPGWdhMjhDDx5yvVg53Jri4RgTFDzs/aNEjNtJYa39A+
         NtTN2wczAX9B8BfRlpo+TN5ZmhC8+QC4vg8/K6kYJTQa0qOlZKgI8DuurTJMeVVNswXt
         xiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755532704; x=1756137504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wroxQTju/JIwVItXhFFfdcs8fEJyV3fG1QbV4k2Tc4Y=;
        b=EprOmBWVWiarn7h91YZTXHOnixRGWpWM8edrcDLhZW0/vyouFNUGFua3cMUJZ1RsJu
         Xh5sM8+9bG7krTLDlgq9B6iW9srqyhIKA9cvQK7IcIa7jE65V7/S4lL7QOn5HIqfcoFu
         gk9qbThTpV9dcwAQN5olXzyj+/3aAlB1VA0O7wwhuegZ/52WMisrJJ9329sMnsYLijr5
         GJo9oboOJSC3dKdVghdwcoHFJQqFzfsnAPJhzPSIpf0yPsw9v3VrV9XZ5a70gTVR2hXa
         J/wBqRQQtgZiRiOH+HT02ESn4l1JRg5gAgB9Yn/1NgOSdHVqoxvgrNA96Sgj9LAl/lq0
         BYyg==
X-Forwarded-Encrypted: i=1; AJvYcCUQ3h0EThdykq6R+A9XwpWtOFsQkxt+6Njsg6FZ3bE2eMiQIcmXtoqTmTbSjSFjlVVIYZfKQUfyL7YY@vger.kernel.org
X-Gm-Message-State: AOJu0YzoxOHqvb6bHQy7NEb8qvhv+MJfPvABKY5ekx/xDBiFuZvFrdJt
	Kc7IbTyvGbQ1Mqs2p75/zPrhvnv/yRZI7uv2r/ciXKklZRIqbLfIdnGJvC0zU5yVG70kfIWfPBI
	WH05kjjJcVkQFXgLKzLijN+5ZUnIwa/kxuhou
X-Gm-Gg: ASbGncvO6+xJqH1as9wxlmtLeifm+9vbeG0AehRWqD+Z0SW/d2/GDaPuaqSx0hqTzNg
	L63SLR+3PrQSwRS+rUG39XFxs0CCD6TOU+p1WtRufNf6PV/2So9ibG6MmURyCN0hMqxnkK//IHu
	AkJZlG/yMltLw8hOwAq7abRrTpLQFEYpG7ymst+v4DPJX7op9rf8MtgUcqBuf/nnrgDKgRDKYQV
	zoC7vvs8f1B5Oy6z9wSvCSKLG0Wtj5PudufjP4X
X-Google-Smtp-Source: AGHT+IE3I5jTghSCn8/cU82Nj3Qjisc2duTJndSXG2iOCYbf2so/p04mUljdVBd2v6MeTwBHX2kkcYwjnUWZf1jeR38=
X-Received: by 2002:a05:6902:841:b0:e94:e1e7:fdf with SMTP id
 3f1490d57ef6-e94e1e72716mr500074276.53.1755532703786; Mon, 18 Aug 2025
 08:58:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813032929.54978-1-xni@redhat.com> <e193fc4b-994f-8261-a7de-8fd8008a9bae@huaweicloud.com>
 <CAMw=ZnR0HyaeG279BZybnJ9zYD5LbnjKS=U4Gc0w5bBs=i38BA@mail.gmail.com> <c488819f-c8b1-42fe-8557-1336fb713db1@kernel.org>
In-Reply-To: <c488819f-c8b1-42fe-8557-1336fb713db1@kernel.org>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 18 Aug 2025 16:58:11 +0100
X-Gm-Features: Ac12FXz-9R4RwzP7ShRodRkDDgy9ffdBWfdVoqVgkv640uymYYj1aaVqyyXHDqg
Message-ID: <CAMw=ZnQmhZ6g=WOeQ0E4pfnTeLtNiJkNcTi_G+eN-PdtqV6kSQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
To: yukuai@kernel.org
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, 
	mpatocka@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Aug 2025 at 16:57, Yu Kuai <yukuai@kernel.org> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/8/18 17:33, Luca Boccassi =E5=86=99=E9=81=93:
> > On Thu, 14 Aug 2025 at 01:54, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >>
> >> =E5=9C=A8 2025/08/13 11:29, Xiao Ni =E5=86=99=E9=81=93:
> >>> commit 9e59d609763f ("md: call del_gendisk in control path") changes =
the
> >>> async way to sync way of calling del_gendisk. But it breaks mdadm
> >>> --assemble command. The assemble command runs like this:
> >>> 1. create the array
> >>> 2. stop the array
> >>> 3. access the sysfs files after stopping
> >>>
> >>> The sync way calls del_gendisk in step 2, so all sysfs files are remo=
ved.
> >>> Now to avoid breaking mdadm assemble command, this patch adds the par=
ameter
> >>> legacy_async_del_gendisk that can be used to choose which way. The de=
fault
> >>> is async way. In future, we plan to change default to sync way in ker=
nel
> >>> 7.0. Then users need to upgrade to mdadm 4.5+ which removes step 2.
> >>>
> >>> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> >>> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> >>> Closes: https://lore.kernel.org/linux-raid/CAMw=3DZnQ=3DET2St-+hnhsuq=
34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> >>> Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>> ---
> >>> v2: minor changes on format and log content
> >>> v3: changes in commit message and log content
> >>> v4: choose to change to sync way as default first in commit message
> >>>    drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++---------=
----
> >>>    1 file changed, 42 insertions(+), 14 deletions(-)
> >>>
> >> Aplied to md-6.17
> >> Thanks
> > Hi,
> >
> > I noticed this bugfix is not in 6.17~rc2 released yesterday, will it
> > be in rc3? Thanks
>
> Yes. You should see this in linux-next soon, and later in rc3.
>
> Thanks,
> Kuai

That's great, thank you
