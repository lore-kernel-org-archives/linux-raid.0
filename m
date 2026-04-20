Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5813C9C4
	for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 05:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776662483; cv=pass; b=SDsJerMTHQ0zT31Amsvr3pplPR+S9mIYXEkafgW0vZaA8LgkLz6xffFMajnDnAen4j62mKRbr8/m6wq93m7DFdlhTxsv3kD/vKfGDRDdnDbfAeCVe6ghhmG1SVI6frbri+fqgYV0FZcMsVBpZuJORVOe59cj5Zy1L38N/glb6oY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776662483; c=relaxed/simple;
	bh=Akz3ucyzMyAJwDcep9KOlStCzc2irEQOHj+P6l+OOq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4NR1hKgin6OmBYGK39cPiArNjISBHt15sOh745JX7EYHKiawg2kpiS6mgU0Lc2aMr1929ZMC0lKKGaY8+fGtFtaKXgxLqvN2kZAyYf2PuCq8KXDLKH/ALBRfZXgSSpbgBUUgyTPUwBOFOEBWjzrOANDkRqSEmngx/m0wvq3VcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f4/hbV9r; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=O286guKo; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f4/hbV9r";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="O286guKo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776662480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HyCNjZAPDfYeZFyuc1bpz+SIpuuFFwwpbf5ud9WzP7s=;
	b=f4/hbV9rMyjA0gtsuHAD9gfAy8GEsm4lQHKh6BIQ1FfRJs9URdqW+XENQ6MEvn24hQBqm0
	V5jb3OSCU4ayTDiDCG0Pbn3YoGdwmlHAuu48xpgpea8W8QAOtvK0R16DpQR6zya9qcjyDb
	vTjFlZ7fPugfNLk0/lrvSXdZLWTvwZQ=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-KuUAQS9qPjCN280hzmzCXg-1; Mon, 20 Apr 2026 01:21:18 -0400
X-MC-Unique: KuUAQS9qPjCN280hzmzCXg-1
X-Mimecast-MFC-AGG-ID: KuUAQS9qPjCN280hzmzCXg_1776662477
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a2d20c8d33so1912119e87.3
        for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 22:21:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776662476; cv=none;
        d=google.com; s=arc-20240605;
        b=d66PdzQdNYJGOsHBtbCKJfvXV+2VXuWjdTC3uYP/1XxKNMnLR/VVeQUxpWxqi68wv2
         yzDsFmvY0vCLKeDbbULldZX3m853bN4KDHQ6MTNHkr0j13XP3Y8hB23HtwAxiiPZ/7yC
         eTrUdneW78lyNnnB/kbxEAy2U3xJqHgxVFx1TR9+DhClbOp7x0QVsxd1SxgyE9GZs1eX
         cpbdkEKEYRz6bLZ0plpStehZFi5jFqUHj4papCeCajl1qIb/BOHlpmJ77KwLox8xXi4C
         vmHK8y61mXM4YDBYW2R5bHZsncJMCKtWeeRS5pIB1NRl7J8r9yD4bQUYIF/9cl5Ldcj3
         YtFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HyCNjZAPDfYeZFyuc1bpz+SIpuuFFwwpbf5ud9WzP7s=;
        fh=41+KV4VRlV7hiIh5C/oOheEY0iY7lh9WOkETZvZJmIc=;
        b=QDnTX+Ywpp7B8QWk3hDmIVvUu4uOj50j4JCLA/Bv103H8Nveomfu1EdgeVJVT3bVPo
         MmFBVKiRXM9LLegxiHxvnN+b7nk2KsRxAFcnNon+HHcsiEpnYXe9ro5J9jROgUGBnX84
         VMB2/rPMNySXtf+vD4PQuSu6WL1l89rtBmoqKzBoqKyi1gdT83B+H8dU52aMo1cPrPtS
         gFPcaUY4kVCjSR+DqR/a3WIX0EEnbOW7x6I5knvZyxy07Qo/N6IiY3+BbrLiN6Li5l1O
         8QnW1eTp81hp5gEImEtAZR7n60qTQLx++r4ueuWDsUn8lX8SF1VB+Rq1+ViZHAFHn7Lq
         xUyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776662476; x=1777267276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HyCNjZAPDfYeZFyuc1bpz+SIpuuFFwwpbf5ud9WzP7s=;
        b=O286guKocwuucU810HzgSSD4if4ALkHzLglw6RpGbaR56cvf9XU7XV8XYk+yM2DcbD
         xsg9vJaq6JuizwPC1tXzalk4aaUhVW1iMfgIR2FzmOMD/cKRyXME2cDlFQ+UQZrXO9SF
         xAMcX2fI8d+UBRbQGurMsG6ViuSxTZMLdwpJysdvF5Z0GP+uM67huDNdL8SSyazTHh73
         cljcSgA5e61L5U2tvw15EiWEuGCXVrwMyylmaM8XF4hqfSSEmG+udR2D45ewaveIiNef
         ee7TNy67NJDpejNsa4BU+LWS7BqCCIoeDxggxVuKTNHbmKdCcrBArEAP5k/P3lHlaFnl
         ScTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776662476; x=1777267276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HyCNjZAPDfYeZFyuc1bpz+SIpuuFFwwpbf5ud9WzP7s=;
        b=jynFqJ4ElwAk6kph7hkrBVqpn71wI1IjSE9lV3rw/1g4xVEJT4O7xSLBV3cvATvy7W
         559fRgaiT7UaZuY7bH+BgCDpbS1+Zq7OIFdCe6TP5Zk7VTkGUTQEaiTcguPJb8jMZYkh
         jI6ZrlhHjYJ+XW++JFIDyI5Ocna/d3zpH54vFs/k1sZsDOs1siH/OBB0bxO0xt2RR42g
         R8x0Xnrclm9mExO5MxJXrUbDQ9jhmrB2IF/7kWrmbDJgOEq04eSyiUZaAlY+knSsrCEE
         wc6E2/FBQIrnxnNB/KmZig3tVdUyoPNvp4ECtvclQb/VY5IF5RqR7A5FceCiVwX3Yo1O
         q9VQ==
X-Forwarded-Encrypted: i=1; AFNElJ+HCL1I0IOqQ/SCKEXxE0n1O+4oLvXc3BfyUn9vnxSmHKhO9HuIv2KMPtlkdQ7uSPxRrt8s79eGRCWQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwsSk1C6uPZS0eBqKJnQFXU+cMXmAX9scxMFOsf+WPB83ni2nYi
	0VqgpC737oDAh/EZljQP5csz9jpNvAlldMrLPL/FTNGHch5IV43iHptkHPds441V9L3Yb4l3Jk0
	V3Ow6eAb06q9BUpsQoOkpzQ7AxGhY0NC4cmQHBbCA1hw0pcSOsJhSW2OXbmA46Xst7DzJkfq5uR
	6hbwvwBRo9DspSmCkMNOz8Kq/zhHL2VzMHgsedFbE6yYVzQw==
X-Gm-Gg: AeBDietJMYKb1IyAa9vCXYhUvxZVmcQpDsBIP7yNWru45nGPwOU/p4cjkq7GjDs25aN
	eQVIiXGlzmYgBJq1eh3uQRGW40CXm39Zm9IVrihcoPT+eMswauMLGhCFQFj+ZtIgh2pMd5C6EYA
	BQTG0GJ73pWlelVtcXOu2n511+VW7TGxoMhChwbgrF0vs9JlQdndJKna0F0M9yr64N2qtukyGVM
	wxJS04sAZ6SDsTPURQNIlfsUOO5RhaZyMUleQ6mYD6uDPVPgqqyoxUW1CWNMq/LxUSRLnrpI1nV
	XRvRtTvicfcO4f5+
X-Received: by 2002:a05:6512:24f:b0:5a4:18f7:a744 with SMTP id 2adb3069b0e04-5a418f7a764mr2259503e87.31.1776662475543;
        Sun, 19 Apr 2026 22:21:15 -0700 (PDT)
X-Received: by 2002:a05:6512:24f:b0:5a4:18f7:a744 with SMTP id
 2adb3069b0e04-5a418f7a764mr2259490e87.31.1776662474972; Sun, 19 Apr 2026
 22:21:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407102625.5686-1-glass.su@suse.com> <20260407102625.5686-2-glass.su@suse.com>
 <CALTww28wN=9R2RMApc89M=cRtHmrFYgc8qgakR6LwcyXeQNdDw@mail.gmail.com> <h5pb6lqs.fsf@damenly.org>
In-Reply-To: <h5pb6lqs.fsf@damenly.org>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 20 Apr 2026 13:21:03 +0800
X-Gm-Features: AQROBzDHzpedXO6EaCpnrgfckQSdJqWjMCc81me-YZXC-lOpDXupY_Bh69p62Oo
Message-ID: <CALTww28=dKKbx+jrED_e3dzQYRtC=Vh9qk04JPy=rjpE2OA7ww@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in location_store
To: Su Yue <l@damenly.org>
Cc: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org, song@kernel.org, 
	linan122@huawei.com, yukuai@fnnas.com, heming.zhao@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 10:09=E2=80=AFPM Su Yue <l@damenly.org> wrote:
>
> On Wed 15 Apr 2026 at 18:34, Xiao Ni <xni@redhat.com> wrote:
>
> > On Tue, Apr 7, 2026 at 6:26=E2=80=AFPM Su Yue <glass.su@suse.com> wrote=
:
> >>
> >> If bitmap/location is present, mdadm will call
> >> update_array_info()
> >> while growing bitmap from none to internal via
> >> location_store().
> >> md_bitmap_create() is needed to set mddev->bitmap_ops otherwise
> >> mddev->bitmap_ops->get_stats() in update_array_info() will
> >> trigger
> >> kernel NULL pointer dereference.
> >
> >
> > Hi Su Yue
> >
> > How can bitmap/location be present when bitmap is none? Could
> > you
> > provide the test commands that reproduce this problem?
> >
> Sorry for the misleading commit message. It can only be reproduced
> patch 3 is appiled.
> I adjusted the sequence of this patch for easy review because
> md_bitmap_create,destroy
> are touched in patch1,2 and 3. Also if put the patch after 3rd
> patch,
> it will break ability to bisect.
>
> # mdadm --create --assume-clean /dev/md0 -f --bitmap=3Dinternal
>   --raid-devices=3D2 --level=3Dmirror --metadata=3D1.2 /dev/vdc /dev/vdd
> # mdadm --grow /dev/md0 --bitmap=3Dnone
> # mdadm --grow /dev/md0 --bitmap=3Dinternal # step 3
> # mdadm --grow /dev/md0 --bitmap=3Dnone # step 4
> [1]    2325 killed     mdadm --grow /dev/md0 --bitmap=3Dnone
>
> When step 3 is called,
> md_bitmap_destroy() is called in update_array_info() to set NULL
> mddev->bitmap_ops
> then in step 4 kernel Oops is triggered.
>
>
> I am willing to amend commit message or move it after patch 3 if
> you would like.

Hi Su

Thanks for the detail explanation. After reading patch3, I totoally
understand. The sequence is good to me. And yes, it's better to
explain that this is needed after patch3.

Best Regards
Xiao
>
> --
> Su
>
> >
> > mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 --bitmap=3Dnone
> > (There
> > is not bitmap/location, because bitmap directory is not created)
> > mdadm /dev/md0 --grow --bitmap=3Dinternal
> > Grow.c md_set_array_info runs
> >  451             array.state |=3D (1 << MD_SB_BITMAP_PRESENT);
> >  452             rv =3D md_set_array_info(fd, &array);
> > In kernel space, it runs
> >  8125             rv =3D md_bitmap_create(mddev);
> >  8126             if (!rv)
> >  8127                 rv =3D mddev->bitmap_ops->load(mddev);
> >
> > Best Regards
> > Xiao
> >
> >>
> >> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of
> >> bitmap_ops until creating bitmap")
> >> Signed-off-by: Su Yue <glass.su@suse.com>
> >> ---
> >>  drivers/md/md-bitmap.c | 11 ++++++++---
> >>  drivers/md/md.c        |  4 ++--
> >>  drivers/md/md.h        |  2 ++
> >>  3 files changed, 12 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> >> index 83378c033c72..2f24aae05552 100644
> >> --- a/drivers/md/md-bitmap.c
> >> +++ b/drivers/md/md-bitmap.c
> >> @@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const
> >> char *buf, size_t len)
> >>                         goto out;
> >>                 }
> >>
> >> -               bitmap_destroy(mddev);
> >> +               md_bitmap_destroy(mddev);
> >>                 mddev->bitmap_info.offset =3D 0;
> >>                 if (mddev->bitmap_info.file) {
> >>                         struct file *f =3D
> >>                         mddev->bitmap_info.file;
> >> @@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev,
> >> const char *buf, size_t len)
> >>                                 goto out;
> >>                         }
> >>
> >> +                       /*
> >> +                        * lockless bitmap shoudle have set
> >> bitmap_id
> >> +                        * using bitmap_type, so always
> >> ID_BITMAP.
> >> +                        */
> >> +                       mddev->bitmap_id =3D ID_BITMAP;
> >>                         mddev->bitmap_info.offset =3D offset;
> >> -                       rv =3D bitmap_create(mddev);
> >> +                       rv =3D md_bitmap_create(mddev);
> >>                         if (rv)
> >>                                 goto out;
> >>
> >>                         rv =3D bitmap_load(mddev);
> >>                         if (rv) {
> >>                                 mddev->bitmap_info.offset =3D 0;
> >> -                               bitmap_destroy(mddev);
> >> +                               md_bitmap_destroy(mddev);
> >>                                 goto out;
> >>                         }
> >>                 }
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 3ce6f9e9d38e..8b1ecc370ad6 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -6447,7 +6447,7 @@ static void md_safemode_timeout(struct
> >> timer_list *t)
> >>
> >>  static int start_dirty_degraded;
> >>
> >> -static int md_bitmap_create(struct mddev *mddev)
> >> +int md_bitmap_create(struct mddev *mddev)
> >>  {
> >>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
> >>                 return -EINVAL;
> >> @@ -6458,7 +6458,7 @@ static int md_bitmap_create(struct mddev
> >> *mddev)
> >>         return mddev->bitmap_ops->create(mddev);
> >>  }
> >>
> >> -static void md_bitmap_destroy(struct mddev *mddev)
> >> +void md_bitmap_destroy(struct mddev *mddev)
> >>  {
> >>         if (!md_bitmap_registered(mddev))
> >>                 return;
> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >> index ac84289664cd..ed69244af00d 100644
> >> --- a/drivers/md/md.h
> >> +++ b/drivers/md/md.h
> >> @@ -895,6 +895,8 @@ static inline void safe_put_page(struct
> >> page *p)
> >>
> >>  int register_md_submodule(struct md_submodule_head *msh);
> >>  void unregister_md_submodule(struct md_submodule_head *msh);
> >> +int md_bitmap_create(struct mddev *mddev);
> >> +void md_bitmap_destroy(struct mddev *mddev);
> >>
> >>  extern struct md_thread *md_register_thread(
> >>         void (*run)(struct md_thread *thread),
> >> --
> >> 2.53.0
> >>
>

