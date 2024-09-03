Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AE1A32
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 00:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725322717; cv=none; b=Iwz/Rji6bxjTsg74D2l8hvzfB+o9A4Nyyw1jgvGEkimSwbtn+GJy/rkY51Vv4jdYw+JdkBiyDtvBQdrmg6EAOF2u4rLStfOAXA85N4gnpj8Y2vUhSfIN1un6TtrVny1TNh6oegQdJrymYdQIVT4UeUw00eqOPjoL/f8ZmrUuueA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725322717; c=relaxed/simple;
	bh=+pws0ydn8oDmEf84LhldcXlNlelFmdgxYkk9xsXKRM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WMTL2guxqohU54+NYXGeUQ53mHZiYMQdRUbj2aNFO1BrGWjQ0iuEwh+OIs7nwg108WejJKbMcvWNncXa5CX+qrvfGcVdAbr0VXAVeKLoLAZDxt13PXopxY3fXUQHoCVUUmWnjf7QwfEXRVIpi5oXlZv8MtNa7RaxkpXzdHA7mME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJzZqGwu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJzZqGwu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725322714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IU2UyBsZkflFGOdlj8m6zYklgj5xuI4TTDnytUJZ6ZI=;
	b=MJzZqGwu+26iBDKvMq+uDaGZVGFsTLEEyFuMn7kqs0cWd4DIpXrcD6ztC/uJMxYZBRtCxC
	4xoz8IzNqVZkHlzzNeiSBDFZ3QNgvWyNcggPuzV9EnfQjpvJz98LkvVAoMp3h6sovF781L
	VwZK1w/i+mbJMUpaZJohubwgLM5X9mU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-8XF43fjBN7KrBIBtIJrOGw-1; Mon, 02 Sep 2024 20:18:33 -0400
X-MC-Unique: 8XF43fjBN7KrBIBtIJrOGw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2d882c11ce4so2596330a91.2
        for <linux-raid@vger.kernel.org>; Mon, 02 Sep 2024 17:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725322712; x=1725927512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IU2UyBsZkflFGOdlj8m6zYklgj5xuI4TTDnytUJZ6ZI=;
        b=RBmm0UXtBaoMuVV74WMPwFNVr81l6jGouDL7XGUFub/fmdnK37fKQnqQHO6HGFP+rl
         UVAz7TC9/EDtMb+1YkAs8zcSejba5ZXUz7BJ3YcZ+EKG3a2GJqxYx+b9Xd+sLvzLRzd/
         zD30n8eC7cjhkpl9rWk349i/k80fARbbBfTcaZH6arbZR4S3fK9GxNOpA9DxECCpF7YR
         jbUofwGJx6QsOandFfGNVkNau0Vd0TukkPK91s8cm60lI7hjXeO3UCnSDZ0hFI1c9skg
         jg/Sg7WEYXZk6NNRtC05B/qVciEQTjyVpUWEK7vfnZT/SsLepihM3XUFZUDOKI33r07s
         IZVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkVQZ/HrVjmPwdgTbcrwm+A7IlIYxqMiVyTD8bOI/x/rEOaKYo1eYOxhb/H22GcWHYZuPJrWgCjbDf@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7W9IoLQhaP6mo8nWkD10H4s/J7JtZ04K+vyNWnnI8NdOj6XwQ
	rb4mTTnt7wNm5bJzk0y19PPWKAM0MqcL/TG9lthhxm1Oaxmt0XD9oSYHpZWLBBjxnbS/uaKSD43
	yMSPxYSIKe9RcQzqnpxO+tVVPET2VHkwgUl7D/4SlGqnRBJQCheQAc1HSTi0cTUcDFMUpK3uUw9
	HtRwhPhE5Ut42rvxkdiancVQrhDtYWJZItWQ==
X-Received: by 2002:a17:90a:de93:b0:2d8:8a04:1b16 with SMTP id 98e67ed59e1d1-2d8905ed640mr7632243a91.33.1725322711753;
        Mon, 02 Sep 2024 17:18:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqAJxXqUB+ikEKIAduu9dyRTPqZsa4CMNFIjE2+Cqx2jNCYLEov8mzv1M/s20YP+rLDhMZ6MERbqzLRfNKyhc=
X-Received: by 2002:a17:90a:de93:b0:2d8:8a04:1b16 with SMTP id
 98e67ed59e1d1-2d8905ed640mr7632227a91.33.1725322711212; Mon, 02 Sep 2024
 17:18:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828021828.63447-1-xni@redhat.com> <20240902121323.0000589d@linux.intel.com>
In-Reply-To: <20240902121323.0000589d@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 3 Sep 2024 08:18:19 +0800
Message-ID: <CALTww2-G0EEaOma8z8ymoPkRWeX+m1f8RPaw3T2qbVM6XKXmUA@mail.gmail.com>
Subject: Re: [PATCH md-6.12 1/1] md: add new_level sysfs interface
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yukuai1@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 6:14=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 28 Aug 2024 10:18:28 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > This interface is used to updating new level during reshape progress.
> > Now it doesn't update new level during reshape. So it can't know the
> > new level when systemd service mdadm-grow-continue runs. And it can't
> > finally change to new level.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d3a837506a36..c639eca03df9 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf=
,
> > size_t len) static struct md_sysfs_entry md_level =3D
> >  __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
> >
> > +static ssize_t
> > +new_level_show(struct mddev *mddev, char *page)
> > +{
> > +     return sprintf(page, "%d\n", mddev->new_level);
> > +}
> > +
> > +static ssize_t
> > +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> > +{
> > +     unsigned int n;
> > +     int err;
> > +
> > +     err =3D kstrtouint(buf, 10, &n);
> > +     if (err < 0)
> > +             return err;
> > +     err =3D mddev_lock(mddev);
> > +     if (err)
> > +             return err;
> > +
> > +     mddev->new_level =3D n;
> > +     md_update_sb(mddev, 1);
>
> I don't see any code behind mddev->new_level handling so I suspect that
> md_update_sb() does nothing in this case. Is there something I'm missing?

You mean the calling path md_update_sb->sync_sbs->super_1_sync?

Best Regards
Xiao
>
> Thanks,
> Mariusz
>
> > +
> > +     mddev_unlock(mddev);
> > +     return err ?: len;
> > +}
> > +static struct md_sysfs_entry md_new_level =3D
> > +__ATTR(new_level, 0664, new_level_show, new_level_store);
> > +
> >  static ssize_t
> >  layout_show(struct mddev *mddev, char *page)
> >  {
> > @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR,
> > serialize_policy_show,
> >  static struct attribute *md_default_attrs[] =3D {
> >       &md_level.attr,
> > +     &md_new_level.attr,
> >       &md_layout.attr,
> >       &md_raid_disks.attr,
> >       &md_uuid.attr,
>
>

