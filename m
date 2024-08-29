Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C5C1B1406
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937210; cv=none; b=Eme8VorJI4ukegB9p90S2MKKn3kQCDeKbiJxyUpHcxMw5BhsBHrpWaOgNCfEjtAE4yaD3ZIKV9t4ANoYqtdLXvUAdh9Th3yyRNT55S1gtb8yCCB1Zhz8//8m2yU8CzzfCXQGGc+RJDJAEJO2MvyURuOuXf8QwPhw3Gql4+sHw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937210; c=relaxed/simple;
	bh=qDmxMExVR5Cxiwmq2Kmt91ZS7kOHz44nHKGrbkblQ2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0omJO6pw3XhDTAjjFj3rL6UIxr2eJv4BfPISMcJf/cB4Gdp0Wjfvs5CGJWP+R0Kamlw0quU4Fo6238wxg0FfWU0bvscBQJ7jkPhD54/URwND6NugOP5tvRyvML0lENCNgs2t1oUDFlTTXF95/XTQHVweZyCb7uzu0MxBz0T5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGe2ii8x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGe2ii8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724937206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KzpFBHBvkholX+jal2C0kqPyIqyEoxFia4C9fAnH7Ng=;
	b=JGe2ii8xWU8TdoNy/obS4dqFZb8XfhGz2sJDTK/3O7YFNzaQHaP8mehKJ59pX+L7k/571K
	lWQ4pVc3PUP6Zgmivbmg/qESf7Z5nnpngiIqNxUykR+zNOXERDsEVGoZcIDJGN2q/LvhU7
	cntPXQd/gfzhBzcwpKX93eUK8W775l0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-IR8me0dfN9OB0DQhBIe5zg-1; Thu, 29 Aug 2024 09:13:24 -0400
X-MC-Unique: IR8me0dfN9OB0DQhBIe5zg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-202088f100aso6059385ad.3
        for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 06:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724937203; x=1725542003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzpFBHBvkholX+jal2C0kqPyIqyEoxFia4C9fAnH7Ng=;
        b=qBteXmTcT8NzOcz1QIcasbr6YpnNzImwW9wB5R7rjhZiRKrKoyI4Aj4K+bNcm2vItJ
         0kgOV0uv/rjxA5JTMdaJM1eu9hEeLRT2jWQ3VEHi/bENy0Dfp2BnWHUREP3Mo77hAfLp
         QTLvu1+Wct5YG0+KuSfMOavKqD8+1Rsc9HQSKVyJws33AYNwuPVA88kVFW489D/CDOuE
         iumotesONlNgPodYUnBkkUa2M3ZiCwlLE/2cszcXirxNO6do9QhisrMTzHpS+OYUoe67
         4kwzmCKavs13yyX2t0Y6vYdWGT2V839QjA+frgEVD4+kIKQ8Tt4irQuUJHtiNAm9Ao90
         WVsw==
X-Forwarded-Encrypted: i=1; AJvYcCW+p6F3e2lbqoCKqhG2O+AjcwJmrizX8jywUti7HficBJjq/8hApwQdEzsqUCCjYDBg4eHmOR89ZLIG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy075OmlivSfDlqKcLHdag8UQjyKlwqTdxw9XUYK+7zllNftvjI
	0GtgqiiFzcq8ZXxl+FvCqe/91YPeFoPXU7hFmBF6yKbL9nbHq8MZYILBYQ1XgxjraL6VpMfev4P
	wKJ491Jc/KKotw/aUIYzPVB77d4HNmcXtJPg3MPlt4hBVX0J/44fqQlOt8/k3CDcNhqUrx/uecC
	NE3JiziJ5SlLnH6PaS2r4DA/Zyu38va8c+bQ==
X-Received: by 2002:a17:902:f70c:b0:201:efe7:cb03 with SMTP id d9443c01a7336-2050c42079fmr25084665ad.48.1724937203085;
        Thu, 29 Aug 2024 06:13:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZYMf/cSW301Qz2xkrPFgmKBy+S148wbLlX7jNCQ8ARbfalCJNoWGMAXOEmYV7AWU6eWh3tSI5VAjWexs595A=
X-Received: by 2002:a17:902:f70c:b0:201:efe7:cb03 with SMTP id
 d9443c01a7336-2050c42079fmr25084005ad.48.1724937202432; Thu, 29 Aug 2024
 06:13:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829100133.74242-1-xni@redhat.com> <cafa231e-8ad8-05d2-80c0-f90c1b509bd1@huaweicloud.com>
In-Reply-To: <cafa231e-8ad8-05d2-80c0-f90c1b509bd1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 29 Aug 2024 21:13:04 +0800
Message-ID: <CALTww2-dV0WTHfZANoXJro-Vx19WeA2m-NLFm1F0bCzd=jC3oQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] [PATCH V2 md-6.12 1/1] md: add new_level sysfs interface
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 8:24=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/08/29 18:01, Xiao Ni =E5=86=99=E9=81=93:
> > This interface is used to update new level during reshape progress.
> > Now it doesn't update new level during reshape. So it can't know the
> > new level when systemd service mdadm-grow-continue runs. And it can't
> > finally change to new level.
>
Hi Kuai

> I'm not sure why updaing new level during reshape. Will this corrupt
> data in the array completely?

There is no data corruption.


> >
> > mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> > mdadm --wait /dev/md0
> > mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> > cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> > md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
>
> The problem is that level is still 6 after mddev --grow -l5? I don't
> understand yet why this is related to update new level during reshape.
> :)

mdadm --grow command returns once reshape starts when specifying
backup file. And it needs mdadm-grow-continue service to monitor the
reshape progress. It doesn't record the new level when running `mdadm
--grow`. So mdadm-grow-continue doesn't know the new level and it
can't change to new level after reshape finishes. This needs userspace
patch to work together.
https://www.spinics.net/lists/raid/msg78081.html

Best Regards

Xiao
>
> Thanks,
> Kuai
>
> >
> > The case 07changelevels in mdadm can trigger this problem. Now it can't
> > run successfully. This patch is used to fix this. There is also a
> > userspace patch set that work together with this patch to fix this prob=
lem.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> > V2: add detail about test information
> >   drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> >   1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d3a837506a36..3c354e7a7825 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf=
, size_t len)
> >   static struct md_sysfs_entry md_level =3D
> >   __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
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
> > +
> > +     mddev_unlock(mddev);
> > +     return len;
> > +}
> > +static struct md_sysfs_entry md_new_level =3D
> > +__ATTR(new_level, 0664, new_level_show, new_level_store);
> > +
> >   static ssize_t
> >   layout_show(struct mddev *mddev, char *page)
> >   {
> > @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, seria=
lize_policy_show,
> >
> >   static struct attribute *md_default_attrs[] =3D {
> >       &md_level.attr,
> > +     &md_new_level.attr,
> >       &md_layout.attr,
> >       &md_raid_disks.attr,
> >       &md_uuid.attr,
> >
>

