Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8B34A1A
	for <linux-raid@vger.kernel.org>; Thu, 27 Feb 2025 06:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740638915; cv=none; b=ATyUf7ZX+345bytMuA4jM/2Vx6q3tfoOJzV6BquyhPtdIBvKJ8Q8G9HgbFaLfIYeMEgLfy/m06z9MajlWSmu/F6YT4RKqoY6WDn1TlYGZvYIBDG/GnSme4QgS1K++uamCQFd9CyG8/AI+aLfDtF3Z0EsSvZnVvdqiWV4pB3b4x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740638915; c=relaxed/simple;
	bh=BgZsq/Zybuv7NntfJHx8mzDTBQ+PPyMx66YJExrcKUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qEm887b3syK9Vy6UAvANMB99NNEgH3arYag9s/pwLrr5J1sd2JcHRnP9y+JGjzhYOCQRRmbzae5JaSdgs+9smlXqHMdYk9WFJvDE9vLTsqs+r+RGhASPzHoqie+CUrGhk0Jxu8/7Ljv+Kk9jEROP3Lbib5+5KxR0VZR6xF1yvws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixd0igKR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixd0igKR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740638912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yq5Sd2tKm6tbuA5l6g1RDhlRCO5uE0wWwMthS8xR7xE=;
	b=ixd0igKRq7nsC2nwwJZ0GRi58tiuyFOH8VarNdwrPghSfyGY7itsToPlduiTIkgME2mPsh
	CPnU06yPXY3i+IfiMKKZ3/Ae0aWxd2X9jEQDyDjwmWQTQhMBgliZwqhQL31xJSB0qjwTla
	h/mg3a2Bt4XlrcBkdRUBsq0eqvPcDnE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-EjSrlUAaO3-lawQAZi91rg-1; Thu, 27 Feb 2025 01:48:30 -0500
X-MC-Unique: EjSrlUAaO3-lawQAZi91rg-1
X-Mimecast-MFC-AGG-ID: EjSrlUAaO3-lawQAZi91rg_1740638909
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5452e71d61dso929285e87.1
        for <linux-raid@vger.kernel.org>; Wed, 26 Feb 2025 22:48:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740638909; x=1741243709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yq5Sd2tKm6tbuA5l6g1RDhlRCO5uE0wWwMthS8xR7xE=;
        b=AfVw268rTNKl/L/Ie0dky0fM425AedrM9aGhdFru/IwnCul9xBa6qTY26TxgKcuuno
         Hi3JlSLPJ0AjlQQ9pJV3l6quOaGgQE8VCtFsy8TrELzjEuaT+MdmohoC4l1xRSwmcGqR
         h1LGL+6fbvK7GoipYJdeWWWEZSBMpKqdlgG9ZjqyxlUOc/IvCjf5gzHN8D5aVU15Jjon
         xx9k0EVVhICH5rgRupyHlDw+I5hAO5hduhk/zSuTMGIdgU5Ia1+DSpcy6WimdSGJH/sD
         Ho5t1pkpFYh0fIUUKJl2Hyn4NaZA/54s7kWDSSqMve/qfFwdhFz5jMRxIQ5YYHa57cCF
         ityQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcnt36j1cYN8uQdxyhKIZ9kpHKBEZORea7QyimK+UWJ/0Y+1MpSQ2XlPdIM3Dcsv3rmHCpdGe44tv1@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1OFKPB4sVTxF1aTTWOEiPuF3V62ON7p/gLDpR6ybuKY/lHTwk
	R+PSIkN8lx7va273I4PvauAxsj2wBeJu7jUwrIpH+RKSIemnHzR7fr7mKIdV2jPdr+OnQVaJ0RY
	+BhRbel4x1YPd9fM0VuH5BDh6uIC5uFH1XJlhkViePbNmFrvGTUeozl+MwC7tFtngO78B3PblTz
	ZnJrsGmXA10sRpSzRcyQfctZZoGflE/eeaLw==
X-Gm-Gg: ASbGncuVBbPVaRYefeNnsz4gHkMqf2WVyrsB7+keU2kn1slS/Mir6HpRKR6KjM3qjFE
	cblwxQCa5UJMpbUH80clAQHCL9GAjkbzJAz0YGOGHCL0b5EMEvtoMbEx/vYYB/mZvQK+ZLb1ecg
	==
X-Received: by 2002:a05:6512:b06:b0:545:25cc:23cd with SMTP id 2adb3069b0e04-549432fae36mr745147e87.16.1740638909266;
        Wed, 26 Feb 2025 22:48:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQ6GjEJJkipfYGQSp4iqJdqVI3t1atJWTShHoS8UQnabJFbVlF3LEIMGxBs0cyWstq8jCXrH0Xvh32TT5MdPA=
X-Received: by 2002:a05:6512:b06:b0:545:25cc:23cd with SMTP id
 2adb3069b0e04-549432fae36mr745137e87.16.1740638908818; Wed, 26 Feb 2025
 22:48:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218184831.19694-1-junxiao.bi@oracle.com> <20250224141541.000042f1@linux.intel.com>
In-Reply-To: <20250224141541.000042f1@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 27 Feb 2025 14:48:17 +0800
X-Gm-Features: AQ5f1JrK4lkZzmCeXSfaZ0ID57ATc6ZGTkOQM28bOY2D-yZ-gSk_a_IZxBVNP9s
Message-ID: <CALTww2-DSfGAO-f2Porbu3+vrhNGcAd=SsP7h+wciw60v12JAA@mail.gmail.com>
Subject: Re: [PATCH V2] mdmon: imsm: fix metadata corruption when managing new array
To: Blazej Kucman <blazej.kucman@linux.intel.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>, mtkaczyk@kernel.org, linux-raid@vger.kernel.org, 
	ncroxon@redhat.com, song@kernel.org, yukuai@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 9:16=E2=80=AFPM Blazej Kucman
<blazej.kucman@linux.intel.com> wrote:
>
> On Tue, 18 Feb 2025 10:48:31 -0800
> Junxiao Bi <junxiao.bi@oracle.com> wrote:
>
> > When manager thread detects new array, it will invoke manage_new().
> > For imsm array, it will further invoke imsm_open_new(). Since
> > commit bbab0940fa75("imsm: write bad block log on metadata sync"),
> > it preallocates bad block log when opening the array, that requires
> > increasing the mpb buffer size.
> > For that, imsm_open_new() invokes function
> > imsm_update_metadata_locally(), which first uses
> > imsm_prepare_update() to allocate a larger mpb buffer and store it at
> > "mpb->next_buf", and then invoke imsm_process_update() to copy the
> > content from current mpb buffer "mpb->buf" to "mpb->next_buf", and
> > then free the current mpb buffer and set the new buffer as current.
> >
> > There is a small race window, when monitor thread is syncing metadata,
> > it gets current buffer pointer in
> > imsm_sync_metadata()->write_super_imsm(), but before flushing the
> > buffer to disk, manager thread does above switching buffer which
> > frees current buffer, then monitor thread will run into
> > use-after-free issue and could cause on-disk metadata corruption. If
> > system keeps running, further metadata update could fix the
> > corruption, because after switching buffer, the new buffer will
> > contain good metadata, but if panic/power cycle happens while disk
> > metadata is corrupted, the system will run into bootup failure if
> > array is used as root, otherwise the array can not be assembled after
> > boot if not used as root.
> >
> > This issue will not happen for imsm array with only one member array,
> > because the memory array has not be opened yet, monitor thread will
> > not do any metadata updates.
> > This can happen for imsm array with at lease two member array, in the
> > following two scenarios:
> > 1. Restarting mdmon process with at least two member array
> > This will happen during system boot up or user restart mdmon after
> > mdadm upgrade
> > 2. Adding new member array to exist imsm array with at least one
> > member array.
> >
> > To fix this, delay the switching buffer operation to monitor thread.
> >
> > Fixes: bbab0940fa75("imsm: write bad block log on metadata sync")
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > ---
> > v2 <- v1:
> >  - address code style in manage_new()
> >  - make lines of git log not over 75 characters
> >
> >  managemon.c   | 10 ++++++++--
> >  super-intel.c | 14 +++++++++++---
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/managemon.c b/managemon.c
> > index d79813282457..74b64bfc9613 100644
> > --- a/managemon.c
> > +++ b/managemon.c
> > @@ -721,11 +721,12 @@ static void manage_new(struct mdstat_ent
> > *mdstat,
> >        * the monitor.
> >        */
> >
> > +     struct metadata_update *update =3D NULL;
> >       struct active_array *new =3D NULL;
> >       struct mdinfo *mdi =3D NULL, *di;
> > -     int i, inst;
> > -     int failed =3D 0;
> >       char buf[SYSFS_MAX_BUF_SIZE];
> > +     int failed =3D 0;
> > +     int i, inst;
> >
> >       /* check if array is ready to be monitored */
> >       if (!mdstat->active || !mdstat->level)
> > @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent *mdstat,
> >       /* if everything checks out tell the metadata handler we
> > want to
> >        * manage this instance
> >        */
> > +     container->update_tail =3D &update;
> >       if (!aa_ready(new) || container->ss->open_new(container,
> > new, inst) < 0) {
> > +             container->update_tail =3D NULL;
> >               goto error;
> >       } else {
> > +             if (update)
> > +                     queue_metadata_update(update);
> > +             container->update_tail =3D NULL;
> >               replace_array(container, victim, new);
> >               if (failed) {
> >                       new->check_degraded =3D 1;
> > diff --git a/super-intel.c b/super-intel.c
> > index cab841980830..4988eef191da 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
> > intel_super *super, struct imsm_dev *dev, return failed;
> >  }
> >
> > +static int imsm_prepare_update(struct supertype *st,
> > +                            struct metadata_update *update);
> >  static int imsm_open_new(struct supertype *c, struct active_array *a,
> >                        int inst)
> >  {
> >       struct intel_super *super =3D c->sb;
> >       struct imsm_super *mpb =3D super->anchor;
> > -     struct imsm_update_prealloc_bb_mem u;
> > +     struct imsm_update_prealloc_bb_mem *u;
> > +     struct metadata_update mu;
> >
> >       if (inst >=3D mpb->num_raid_devs) {
> >               pr_err("subarry index %d, out of range\n", inst);
> > @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c,
> > struct active_array *a, dprintf("imsm: open_new %d\n", inst);
> >       a->info.container_member =3D inst;
> >
> > -     u.type =3D update_prealloc_badblocks_mem;
> > -     imsm_update_metadata_locally(c, &u, sizeof(u));
> > +     u =3D xmalloc(sizeof(*u));
> > +     u->type =3D update_prealloc_badblocks_mem;
> > +     mu.len =3D sizeof(*u);
> > +     mu.buf =3D (char *)u;
> > +     imsm_prepare_update(c, &mu);
> > +     if (c->update_tail)
> > +             append_metadata_update(c, u, sizeof(*u));
> >
> >       return 0;
> >  }
>
> Hi Junxiao,
>
> LGTM, Approved
>
> Thanks,
> Blazej
>

Hi Blazej

Have you updated the PR
https://github.com/md-raid-utilities/mdadm/pull/152 with this V2
version?

Regards
Xiao

