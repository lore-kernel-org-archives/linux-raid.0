Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5C931F9B4
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 07:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776756988; cv=pass; b=CyfYlYMltiJOTz9lrSE0Lcc7g2Vx7m+PcWlNAUay/cwTSWPPsMg5TOkwOs3rFUN7ePVOi4NyQub2CDf1Sci4vcb+TnaEhDQSdLgEogbGs8Jmda/PH72fYW4NvyW8A+JIA3FU1pxUryKyF8DX8uJ2I5PyrFoetCDTj2/ZwItisTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776756988; c=relaxed/simple;
	bh=qmwXaUS1sEJ5KgFyKI/N1F63f4+LnbXV8ht1LxtNXRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PYUuoBqVebQXcO6x3mn2Dy0M+KVf1u8XoVm+Aay4XgOxvMc4gvxVEmx57eJrXCQwOrEK44FRH860U/eHyUlalwG+HzJ6B57nrh4D4reVH31UjnKYaDrjuWzfFcHrU5EgzAl+nOL6n3FEx+/za6v+Bts+2VPUpUhCalDgGY4NBsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QHH8XpG8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKiULf6h; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHH8XpG8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKiULf6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776756985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZabVpX8SEq/IfmC6Zcqb1N6XNmiyXEZi6U83HYRxtI4=;
	b=QHH8XpG888rNlOMhTTUz7jjy61VZspg47tF6EGlJv3uzbyyn4UgiKa+6gq66P00Sa6ZCnL
	LORXm0apRWPb4nZS7QpCQA0WRji9qvSE/zLxot1zi6UepFd22DTsfm1jSeyuBIlyyD5YJ6
	XeI3jpbegCeUu8LVYo6GqxjnlSFcD1A=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-VwasCPl2NciLOYHq9SzkIA-1; Tue, 21 Apr 2026 03:36:23 -0400
X-MC-Unique: VwasCPl2NciLOYHq9SzkIA-1
X-Mimecast-MFC-AGG-ID: VwasCPl2NciLOYHq9SzkIA_1776756982
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a2c8db25f3so3228506e87.1
        for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 00:36:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776756982; cv=none;
        d=google.com; s=arc-20240605;
        b=jzW2JqkhTzOrLnkRRtwDf7/ygJMsmT33ofmknL9HquDxLzZ5ZWCt1QHfVgRBwiIPMV
         +mxra+qJGQX1IOsYePmKLbi6BajVd+gmh/t/hFxOpzmduAkJ20QkC0ksFXmkY+Tqa6rC
         j/W8XldIWemXE8Z8VmdKtYm1IsBF1jx1B8aYLpZbRxiDuyKAL3mlqQDINbIu3icRTCGw
         CwqVuThfXr5PCkddRNQ/iLVM6FbbHksTfQhTkOOVTGkH8+HBCx201p9pbdCWKJUgPq6b
         VX+NCgegf9ecfarSDGAss+LDdtui6Y80XGSWTfoiPiDD29d1QV8DiopuRIKnADBeKPnU
         k4vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZabVpX8SEq/IfmC6Zcqb1N6XNmiyXEZi6U83HYRxtI4=;
        fh=UN/DoT1Vcl06JnLN824i/dRH7uWaB5HP66InL4Z5Fm8=;
        b=GIBEXq6cJaN1ZVqGjLcA97sYl2wJqDi7lyVOsSi0salsIR7Jamh2PgC+CG//cWPTys
         FJJqoOsAH6DMhwdohg59ckBCyHDejPwHHT9cycGRSfkBFzK8jNOU2q185kntIfIZmdVi
         +Jo9ja/EvQ4ZFvTeMvgJecVJm61YWq1jtwvZ8eaJfLLdElEOLcoHHSDYyteMTX6kkM/5
         4I0K7YeH5YvpG6vtFK2tGDyvpQS0C6nlUQq+yDqLFuPGsWGwy+KxB4pfhVMaOtdLf697
         7tioGUjGkO+pXuyvWh+WzzIisb0QOwuSiy9yY+1tsQnW/eWsR6GDcE+uZPnM+Tp/8u4P
         u4rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776756982; x=1777361782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZabVpX8SEq/IfmC6Zcqb1N6XNmiyXEZi6U83HYRxtI4=;
        b=MKiULf6hgFVSnnSFnMPVCHRj6nxXIiFYLcPV6TYrXCfY5f16DdhrE3dOMewYX4rrNS
         hQ0kq2OjmWxLirFRoWbYqc5Twlunu++dq0v6SdJghATLiCUgnp2qSn/1pE//3lRg8V1X
         m5itVTs9uTdIC2trDtwH49PzPJO9IgWLhL/pqbtaGZm1eDs8iF2aA5Krrk32sMT9U6Fx
         ETB6QH21qmbQz85Elj0zsc6K8h0Jh76WV5mqi93ThQCpxYlQyluElFHDetwKiI7f6+Rm
         o19vDAufkSpEOkQuoxxD9rz0y+DwyLbfAe5cTd0qCv7dtMD5CQ3HyIyk9lpcs+Lzyq9Z
         Pb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776756982; x=1777361782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZabVpX8SEq/IfmC6Zcqb1N6XNmiyXEZi6U83HYRxtI4=;
        b=QdbJnqH2LLx2XYan6zIsYF9sN2xkiPG3EsWbwJCsxROUjEQPfSS5F6jSqzC08QUx+U
         my1m3KJc8Pzfkx33Psw9dFVeiPvG3RsggyzJgmd3RRIrh1PoOjt2Y5LXS9K36bxrJVBr
         QqBFlPuoRhS1wlE8TKQXZO5XfSOzkJHwklznyqjIISKaW78QZdUL8sAKPVsypgOMJcBF
         XmZqYmdvsUyhsHIkC7gx/ZkYwOYftFSLyFWX0XJDFPa2mbDiRTaV66pFh6Sjd/Vzjujr
         3hozTnO0uBvm+LmNuETPug4DfzeTjOmuqUBCICn2n5N6ihZkS13YWLHtrO7UJmchcIMZ
         XQJg==
X-Forwarded-Encrypted: i=1; AFNElJ9H4UJfIhxjdUu1PzYneIgD8F1UHF8Tsb6bjC67ykp1N95xTkFfEK4DngkIyDCcnq3uPtwIV4TuQtlv@vger.kernel.org
X-Gm-Message-State: AOJu0YxSAaMRehElmM2KdpF/fG3+6smM5rN3SCzDENyiZ8OgftiTr1xU
	D7hIU8Mj9lejKheMuxtvegidcnmZ2mFRVpyQI8deqJzgkTSrYWeEq6mBwv/T33ByA/2I+Ou/oPJ
	O5pe6EAnSnjx9PlrazurV06X3sz3FUY9O5g6tmQ8HS3w1AB3c+CJVDDWTZMC/u4/3s4JNjEjde5
	P475/qXGhbfgFP0QFGNQFEowbp8rZAElOutvRO+A==
X-Gm-Gg: AeBDies3h6AYwixk35bWrrpknZeEZny8I5fF5CZJHjuha+tK3r/nu6PQUiUybI4HU82
	BQZQLHE2vzsdr11DcFmHibKljqDPmSMx3spTvcEy7g0GeKKUlAkkg89tiA8LSwT7vyG7RbT+tn6
	ZkW+6HtJXuraPNBFq0djRJV8B0Xb6z8Jv9qQw0Mambs7lKDjuAKISYUy2PBy0azoH9z5ocqrmOZ
	WTBH7lsTckbwwlNRXQKR38SoAquy44nGpyYwZwq0QkyuITBZ1T7FB9k8xRKpfyMUkfZVUzwiIb2
	MEZlH3jO2/Hl7Wo+
X-Received: by 2002:ac2:4c53:0:b0:5a4:7ed:3e41 with SMTP id 2adb3069b0e04-5a4172e3088mr5041666e87.32.1776756981923;
        Tue, 21 Apr 2026 00:36:21 -0700 (PDT)
X-Received: by 2002:ac2:4c53:0:b0:5a4:7ed:3e41 with SMTP id
 2adb3069b0e04-5a4172e3088mr5041649e87.32.1776756981268; Tue, 21 Apr 2026
 00:36:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407102625.5686-1-glass.su@suse.com> <20260407102625.5686-4-glass.su@suse.com>
 <CALTww28XwfDKbcnrka_YMtgTtArjAXEGhbUafVVGEWuAjV2o3w@mail.gmail.com> <1pg982rx.fsf@damenly.org>
In-Reply-To: <1pg982rx.fsf@damenly.org>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 21 Apr 2026 15:36:09 +0800
X-Gm-Features: AQROBzBFTmpjwBmvnYMa1xi3_SVANKvZIMS1Z0CE01sOugtsA7Wsfdd90NcIffk
Message-ID: <CALTww29y_EJq3Qkimn67cSTnL6_+Yi6Lf1LoT=JJM6YqmFTjaw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] md/md-bitmap: add dummy bitmap ops for none to fix
 wrong bitmap offset
To: Su Yue <l@damenly.org>
Cc: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org, song@kernel.org, 
	linan122@huawei.com, yukuai@fnnas.com, heming.zhao@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 10:29=E2=80=AFAM Su Yue <l@damenly.org> wrote:
>
> On Mon 20 Apr 2026 at 15:05, Xiao Ni <xni@redhat.com> wrote:
>
> > On Tue, Apr 7, 2026 at 6:27=E2=80=AFPM Su Yue <glass.su@suse.com> wrote=
:
> >>
> >> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration
> >> of bitmap_ops until creating bitmap")
> >> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and
> >> clustered have
> >> the sysfs file bitmap/location.
> >>
> >> After the commit, if bitmap is none, bitmap/location doesn't
> >> exist anymore.
> >> It breaks 'grow' behavior of a md array of madam with
> >> MD_FEATURE_BITMAP_OFFSET.
> >> Take level=3Dmirror and metadata=3D1.2 as an example:
> >>
> >> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone --raid-devices=3D2
> >> --level=3Dmirror \
> >>   --metadata=3D1.2 /dev/vdd /dev/vde
> >> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
> >> $ cat /sys/block/md0/md/bitmap/location
> >> Before:+8
> >> After: +2
> >>
> >> While growing bitmap from none to internal, clustered and
> >> llbitmap,
> >> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location
> >> first.
> >> 1)If bitmap/location exists, it sets bitmap/location after
> >> getinfo_super().
> >> 2)If bitmap/location doesn't exist, mdadm just calls
> >> md_set_array_info() then
> >> mddev->bitmap_info.default_offset will be used.
> >> Situation can be worse if growing none to clustered, bitmap
> >> offset of the node
> >> calling `madm --grow` will be changed but the other node are
> >> reading bitmap sb from
> >> the old location.
> >>
> >> Here introducing a dummy bitmap_operations for ID_BITMAP_NONE
> >> to restore sysfs
> >> file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
> >> location_store() now calls md_bitmap_(create|destroy) with
> >> false sysfs parameter then
> >> (add,remove)_internal_bitmap() will be called to manage sysfs
> >> entries.
> >>
> >> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of
> >> bitmap_ops until creating bitmap")
> >> Suggested-by: Yu Kuai <yukuai@fnnas.com>
> >> Signed-off-by: Su Yue <glass.su@suse.com>
> >> ---
> >>  drivers/md/md-bitmap.c   | 116
> >>  ++++++++++++++++++++++++++++++++++++---
> >>  drivers/md/md-bitmap.h   |   3 +
> >>  drivers/md/md-llbitmap.c |  12 ++++
> >>  drivers/md/md.c          |  16 +++---
> >>  4 files changed, 130 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> >> index ac06c9647bf0..a8a176428c61 100644
> >> --- a/drivers/md/md-bitmap.c
> >> +++ b/drivers/md/md-bitmap.c
> >> @@ -240,6 +240,11 @@ static bool bitmap_enabled(void *data,
> >> bool flush)
> >>                bitmap->storage.filemap !=3D NULL;
> >>  }
> >>
> >> +static bool dummy_bitmap_enabled(void *data, bool flush)
> >> +{
> >> +       return false;
> >> +}
> >> +
> >>  /*
> >>   * check a page and, if necessary, allocate it (or hijack it
> >>   if the alloc fails)
> >>   *
> >> @@ -2201,6 +2206,11 @@ static int bitmap_create(struct mddev
> >> *mddev)
> >>         return 0;
> >>  }
> >>
> >> +static int dummy_bitmap_create(struct mddev *mddev)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >>  static int bitmap_load(struct mddev *mddev)
> >>  {
> >>         int err =3D 0;
> >> @@ -2594,6 +2604,9 @@ location_show(struct mddev *mddev, char
> >> *page)
> >>         return len;
> >>  }
> >>
> >> +static int create_internal_group(struct mddev *mddev);
> >> +static void remove_internal_group(struct mddev *mddev);
> >> +
> >>  static ssize_t
> >>  location_store(struct mddev *mddev, const char *buf, size_t
> >>  len)
> >>  {
> >> @@ -2618,7 +2631,8 @@ location_store(struct mddev *mddev, const
> >> char *buf, size_t len)
> >>                         goto out;
> >>                 }
> >>
> >> -               md_bitmap_destroy(mddev, true);
> >> +               md_bitmap_destroy(mddev, false);
> >> +               remove_internal_group(mddev);
> >>                 mddev->bitmap_info.offset =3D 0;
> >>                 if (mddev->bitmap_info.file) {
> >>                         struct file *f =3D
> >>                         mddev->bitmap_info.file;
> >> @@ -2659,14 +2673,22 @@ location_store(struct mddev *mddev,
> >> const char *buf, size_t len)
> >>                          */
> >>                         mddev->bitmap_id =3D ID_BITMAP;
> >>                         mddev->bitmap_info.offset =3D offset;
> >> -                       rv =3D md_bitmap_create(mddev, true);
> >> +                       rv =3D md_bitmap_create(mddev, false);
> >>                         if (rv)
> >>                                 goto out;
> >>
> >> +                       rv =3D create_internal_group(mddev);
> >> +                       if (rv) {
> >> +                               mddev->bitmap_info.offset =3D 0;
> >> +                               bitmap_destroy(mddev);
> >> +                               goto out;
> >> +                       }
> >> +
> >>                         rv =3D bitmap_load(mddev);
> >>                         if (rv) {
> >> +                               remove_internal_group(mddev);
> >>                                 mddev->bitmap_info.offset =3D 0;
> >> -                               md_bitmap_destroy(mddev, true);
> >> +                               md_bitmap_destroy(mddev,
> >> false);
> >>                                 goto out;
> >>                         }
> >>                 }
> >> @@ -2960,8 +2982,7 @@ static struct md_sysfs_entry
> >> max_backlog_used =3D
> >>  __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
> >>         behind_writes_used_show, behind_writes_used_reset);
> >>
> >> -static struct attribute *md_bitmap_attrs[] =3D {
> >> -       &bitmap_location.attr,
> >> +static struct attribute *internal_bitmap_attrs[] =3D {
> >>         &bitmap_space.attr,
> >>         &bitmap_timeout.attr,
> >>         &bitmap_backlog.attr,
> >> @@ -2972,11 +2993,57 @@ static struct attribute
> >> *md_bitmap_attrs[] =3D {
> >>         NULL
> >>  };
> >>
> >> -static struct attribute_group md_bitmap_group =3D {
> >> +static struct attribute_group internal_bitmap_group =3D {
> >>         .name =3D "bitmap",
> >> -       .attrs =3D md_bitmap_attrs,
> >> +       .attrs =3D internal_bitmap_attrs,
> >>  };
> >>
> >> +/* Only necessary attrs for compatibility */
> >> +static struct attribute *common_bitmap_attrs[] =3D {
> >> +       &bitmap_location.attr,
> >> +       NULL
> >> +};
> >> +
> >> +static const struct attribute_group common_bitmap_group =3D {
> >> +       .name =3D "bitmap",
> >> +       .attrs =3D common_bitmap_attrs,
> >> +};
> >> +
> >> +static int create_internal_group(struct mddev *mddev)
> >> +{
> >> +       /*
> >> +        * md_bitmap_group and md_bitmap_common_group are using
> >> same name
> >> +        * 'bitmap'.
> >> +        */
> >> +       return sysfs_merge_group(&mddev->kobj,
> >> &internal_bitmap_group);
> >> +}
> >> +
> >> +static void remove_internal_group(struct mddev *mddev)
> >> +{
> >> +       sysfs_unmerge_group(&mddev->kobj,
> >> &internal_bitmap_group);
> >> +}
> >> +
> >> +static int bitmap_register_groups(struct mddev *mddev)
> >> +{
> >> +       int ret;
> >> +
> >> +       ret =3D sysfs_create_group(&mddev->kobj,
> >> &common_bitmap_group);
> >> +
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       ret =3D sysfs_merge_group(&mddev->kobj,
> >> &internal_bitmap_group);
> >> +       if (ret)
> >> +               sysfs_remove_group(&mddev->kobj,
> >> &common_bitmap_group);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static void bitmap_unregister_groups(struct mddev *mddev)
> >> +{
> >> +       sysfs_unmerge_group(&mddev->kobj,
> >> &internal_bitmap_group);
> >> +}
> >
> > Hi Su
> >
> > bitmap_unregister_groups should also remove common_bitmap_group,
> > right?
> >
>
> As you pasted before, mdadm:Grow.c:
>
> int Grow_addbitmap(char *devname, int fd, struct context *c,
> struct shape *s)
> {
> ...
>         if (array.state & (1 << MD_SB_BITMAP_PRESENT)) {
>                 if (s->btype =3D=3D BitmapNone) {
>                         array.state &=3D ~(1 << MD_SB_BITMAP_PRESENT);
>                         if (md_set_array_info(fd, &array) !=3D 0) {
>                                 if (array.state & (1 << MD_SB_CLUSTERED))
>                                         pr_err("failed to remove clustere=
d
>                                         bitmap.\n");
>                                 else
>                                         pr_err("failed to remove internal=
 bitmap.\n");
>                                 return 1;
>                         }
>                         return 0;
>                 }
>                 pr_err("bitmap already present on %s\n", devname);
>                 return 1;
>         }
> ...
> }
>
> In case of growing from internal to none,
> bitmap_unregister_groups() will
> be called, if common_bitmap_group is removed, bitmap/location
> won't exist.
> update_array_info() is a common function used by many call paths.
> Also
> llbitmap is involved here. I don't want to make situation and code
> more
> complicated like adding more codes in update_array_info().

The above mdadm codes use bitmap/location. In your patch, you already
pass false to md_bitmap_destroy in location_store. So removing
common_bitmap_group in bitmap_unregister_groups can't affect the above
case.

But after reading your below comments. It's good to me that
bitmap_unregister_groups doesn't remove common_bitmap_group.

>
>
> >> +
> >>  static struct bitmap_operations bitmap_ops =3D {
> >
> > You already changed md_bitmap_group to internal_bitmap_group.
> > It's
> > better to change bitmap_ops to internal_bitmap_ops?
> >
> >>         .head =3D {
> >>                 .type   =3D MD_BITMAP,
> >> @@ -3018,21 +3085,52 @@ static struct bitmap_operations
> >> bitmap_ops =3D {
> >>         .set_pages              =3D bitmap_set_pages,
> >>         .free                   =3D md_bitmap_free,
> >>
> >> -       .group                  =3D &md_bitmap_group,
> >> +       .register_groups        =3D bitmap_register_groups,
> >> +       .unregister_groups      =3D bitmap_unregister_groups,
> >> +};
> >> +
> >> +static int none_bitmap_register_groups(struct mddev *mddev)
> >> +{
> >> +       return sysfs_create_group(&mddev->kobj,
> >> &common_bitmap_group);
> >> +}
> >> +
> >> +static struct bitmap_operations none_bitmap_ops =3D {
> >> +       .head =3D {
> >> +               .type   =3D MD_BITMAP,
> >> +               .id     =3D ID_BITMAP_NONE,
> >> +               .name   =3D "none",
> >> +       },
> >> +
> >> +       .enabled                =3D dummy_bitmap_enabled,
> >> +       .create                 =3D dummy_bitmap_create,
> >> +       .destroy                =3D bitmap_destroy,
> >> +       .load                   =3D bitmap_load,
> >> +       .get_stats              =3D bitmap_get_stats,
> >> +       .free                   =3D md_bitmap_free,
> >> +
> >> +       .register_groups        =3D none_bitmap_register_groups,
> >> +       .unregister_groups      =3D NULL,
> >
> > How does bitmap/location can be deleted if array is created with
> > no
> > bitmap? Can the `mdadm --stop` command get stuck?
> >
> No. It wont get stuck.
>
> I guess here your concern is the timing of removing
> common_bitmap_group.
> The life cycle is same as before fb8cc3b0d9db. At the time
> llbitmap is
> not introduced, because there is no need to switch bitmap ops, so
> all
> attrs of bitmap are removed in kobject_put() in
> mddev_delayed_delete()
> queued by mddev_put(). This is now where common_bitmap_group is
> being removed.

Thanks for the explanation.

Best Regards
Xiao
>
> --
> Su
> > Best Regards
> > Xiao
> >
> >>  };
> >>
> >>  int md_bitmap_init(void)
> >>  {
> >> +       int ret;
> >> +
> >>         md_bitmap_wq =3D alloc_workqueue("md_bitmap",
> >>         WQ_MEM_RECLAIM | WQ_UNBOUND,
> >>                                        0);
> >>         if (!md_bitmap_wq)
> >>                 return -ENOMEM;
> >>
> >> -       return register_md_submodule(&bitmap_ops.head);
> >> +       ret =3D register_md_submodule(&bitmap_ops.head);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       return register_md_submodule(&none_bitmap_ops.head);
> >>  }
> >>
> >>  void md_bitmap_exit(void)
> >>  {
> >>         destroy_workqueue(md_bitmap_wq);
> >>         unregister_md_submodule(&bitmap_ops.head);
> >> +       unregister_md_submodule(&none_bitmap_ops.head);
> >>  }
> >> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> >> index b42a28fa83a0..10bc6854798c 100644
> >> --- a/drivers/md/md-bitmap.h
> >> +++ b/drivers/md/md-bitmap.h
> >> @@ -125,6 +125,9 @@ struct bitmap_operations {
> >>         void (*set_pages)(void *data, unsigned long pages);
> >>         void (*free)(void *data);
> >>
> >> +       int (*register_groups)(struct mddev *mddev);
> >> +       void (*unregister_groups)(struct mddev *mddev);
> >> +
> >>         struct attribute_group *group;
> >>  };
> >>
> >> diff --git a/drivers/md/md-llbitmap.c
> >> b/drivers/md/md-llbitmap.c
> >> index bf398d7476b3..9b3ea4f1d268 100644
> >> --- a/drivers/md/md-llbitmap.c
> >> +++ b/drivers/md/md-llbitmap.c
> >> @@ -1561,6 +1561,16 @@ static struct attribute_group
> >> md_llbitmap_group =3D {
> >>         .attrs =3D md_llbitmap_attrs,
> >>  };
> >>
> >> +static int llbitmap_register_groups(struct mddev *mddev)
> >> +{
> >> +       return sysfs_create_group(&mddev->kobj,
> >> &md_llbitmap_group);
> >> +}
> >> +
> >> +static void llbitmap_unregister_groups(struct mddev *mddev)
> >> +{
> >> +       sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
> >> +}
> >> +
> >>  static struct bitmap_operations llbitmap_ops =3D {
> >>         .head =3D {
> >>                 .type   =3D MD_BITMAP,
> >> @@ -1597,6 +1607,8 @@ static struct bitmap_operations
> >> llbitmap_ops =3D {
> >>         .dirty_bits             =3D llbitmap_dirty_bits,
> >>         .write_all              =3D llbitmap_write_all,
> >>
> >> +       .register_groups        =3D llbitmap_register_groups,
> >> +       .unregister_groups      =3D llbitmap_unregister_groups,
> >>         .group                  =3D &md_llbitmap_group,
> >>  };
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index d3c8f77b4fe3..55a95b227b83 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -683,8 +683,7 @@ static bool mddev_set_bitmap_ops(struct
> >> mddev *mddev, bool create_sysfs)
> >>         struct bitmap_operations *old =3D mddev->bitmap_ops;
> >>         struct md_submodule_head *head;
> >>
> >> -       if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE ||
> >> -           (old && old->head.id =3D=3D mddev->bitmap_id))
> >> +       if (old && old->head.id =3D=3D mddev->bitmap_id)
> >>                 return true;
> >>
> >>         xa_lock(&md_submodule);
> >> @@ -703,8 +702,8 @@ static bool mddev_set_bitmap_ops(struct
> >> mddev *mddev, bool create_sysfs)
> >>         mddev->bitmap_ops =3D (void *)head;
> >>         xa_unlock(&md_submodule);
> >>
> >> -       if (create_sysfs && !mddev_is_dm(mddev) &&
> >> mddev->bitmap_ops->group) {
> >> -               if (sysfs_create_group(&mddev->kobj,
> >> mddev->bitmap_ops->group))
> >> +       if (create_sysfs && !mddev_is_dm(mddev) &&
> >> mddev->bitmap_ops->register_groups) {
> >> +               if (mddev->bitmap_ops->register_groups(mddev))
> >>                         pr_warn("md: cannot register extra
> >>                         bitmap attributes for %s\n",
> >>                                 mdname(mddev));
> >>                 else
> >> @@ -724,8 +723,8 @@ static bool mddev_set_bitmap_ops(struct
> >> mddev *mddev, bool create_sysfs)
> >>  static void mddev_clear_bitmap_ops(struct mddev *mddev, bool
> >>  remove_sysfs)
> >>  {
> >>         if (remove_sysfs && !mddev_is_dm(mddev) &&
> >>         mddev->bitmap_ops &&
> >> -           mddev->bitmap_ops->group)
> >> -               sysfs_remove_group(&mddev->kobj,
> >> mddev->bitmap_ops->group);
> >> +           mddev->bitmap_ops->unregister_groups)
> >> +               mddev->bitmap_ops->unregister_groups(mddev);
> >>
> >>         mddev->bitmap_ops =3D NULL;
> >>  }
> >> @@ -6610,8 +6609,9 @@ int md_run(struct mddev *mddev)
> >>                         (unsigned long long)pers->size(mddev,
> >>                         0, 0) / 2);
> >>                 err =3D -EINVAL;
> >>         }
> >> -       if (err =3D=3D 0 && pers->sync_request &&
> >> -           (mddev->bitmap_info.file ||
> >> mddev->bitmap_info.offset)) {
> >> +       if (err =3D=3D 0 && pers->sync_request) {
> >> +               if (mddev->bitmap_info.offset =3D=3D 0)
> >> +                       mddev->bitmap_id =3D ID_BITMAP_NONE;
> >>                 err =3D md_bitmap_create(mddev, true);
> >>                 if (err)
> >>                         pr_warn("%s: failed to create bitmap
> >>                         (%d)\n",
> >> --
> >> 2.53.0
> >>
>

