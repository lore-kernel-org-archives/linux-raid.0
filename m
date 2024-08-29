Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BF01AD9DB
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724939329; cv=none; b=HDEJ502wK2DWmXPhhi0A77SoHi2CAvJ0QEO7DitSoH8RcbtGYM8ucVW8hmwQWVe8BZPgLmkHUrVIUHw4+U2UPsa2eWFHzS6WFe2++lqoeneWg6KgUlsY/J3MXnFAZQtptMhEbGDOHzSVp5+p2EZwsqSh1TvyU2spqtF7MftfK2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724939329; c=relaxed/simple;
	bh=jIWiPoEx31Wszaocrhv8aoVVajB1RxFRpBwWP5nyX4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MbTtY7JsOz80VZFVz8y/E/4hO0RWoix5r2l85bqkzYCu0qKcnla2YR8qloBiqtA28HoY5jLdQt7qxfILUcJc6Apb8MRHC8CqEIydiLv7b55uo8KG48AUCoTvFd1dkf+EgVHLzWkUN35hZwcYvRa5Ibg/w28ZgqE090D9t8G2ls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJ2e3MdF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJ2e3MdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724939325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8XWWjsVlleJ58964dilRxOqis54DavM4CkzmQuLYUoQ=;
	b=AJ2e3MdF05c/nfOUR8ClSK/4W5Bax5Z1rdYamig5y03Qogq5v1ms0b1mhn3JqxnuOxNEom
	nuo7eTyyYJ11Fd54HFy9zICCLvjTVVWSBS83Xbf4902JK/mhRHct5V6bMM+Oy7yuz1Wqyz
	AOTAiLaSGuPVytpeRhkaDKb5KXWSKag=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-srur406FMMyq-aWMlEmOLg-1; Thu, 29 Aug 2024 09:48:44 -0400
X-MC-Unique: srur406FMMyq-aWMlEmOLg-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5dc96240f1dso698612eaf.0
        for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 06:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724939323; x=1725544123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XWWjsVlleJ58964dilRxOqis54DavM4CkzmQuLYUoQ=;
        b=Mst0ssXfLRvta4UF4LaXhDScgPG2kPXUSCyOtRA3sjSkbpQue68de7lJ8Iai7Bn92o
         ly7unxUPvx8ELkQbcXVr9XNJStqQO8cAmoWWMpd2yb7xFWdlZ24aZskI5uG4MPzVQW0f
         QWwYETok+zd7pP1k8/9mQuWOzVgZ+glEasdxi5mHy3lQovZsmrjegcBaJwt9+CDUcL76
         M21P9ut4bT9aOMDrNCYHoYakCPnzazpkZtt+kFvyywjIVUOCbxWyNV9YNzmnPytUZ2hF
         veIiKKPkJc9sE9DeEL6aaeJtlaEp/b3cbzmqIaEpcdkBNbf+mT8r4eWgb6giEQejHbAK
         1RxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkobLIp6+BOMNMpD7nY4yjW7nhmaPEogjFaQn4fi8H8dY/7Lfy2n1TCvrcccRd+UQJXUY/AsxdNvo6@vger.kernel.org
X-Gm-Message-State: AOJu0Yynw9iS2Ymq8c4VgKLnE+EyN7NvEBOB06Qq0i0sbJtjz4GwGPk8
	mzA75svfXMqzibmCRTg5RFYFgaS/KfA0qOn/0LQ7GhcXo7jow7myAPw7uW5rIECYvKJ/17FU/hJ
	u6ggfUHy5HJCCq902eDNACjCKBCp3SiajMyH56okPiinq+Ranyy5FTbzZ5zhDPrt3K+IwuAZwEc
	DgfPtIrXqIOFYfgvq+6ZTi+N5S7IZ88YjDrw==
X-Received: by 2002:a05:6358:b00f:b0:1aa:c49e:587d with SMTP id e5c5f4694b2df-1b603c48be2mr345530555d.18.1724939323393;
        Thu, 29 Aug 2024 06:48:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl6/NCCL/GODkxPjj03+OV4B5+cjyQI7Q9rdrXaPfHz2cT5943qOy6tcerDTJKwSEFAS87P0v+Fk7GsrgmJlo=
X-Received: by 2002:a05:6358:b00f:b0:1aa:c49e:587d with SMTP id
 e5c5f4694b2df-1b603c48be2mr345520455d.18.1724939322737; Thu, 29 Aug 2024
 06:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829100133.74242-1-xni@redhat.com> <cafa231e-8ad8-05d2-80c0-f90c1b509bd1@huaweicloud.com>
 <CALTww2-dV0WTHfZANoXJro-Vx19WeA2m-NLFm1F0bCzd=jC3oQ@mail.gmail.com> <193d4bb3-3738-710e-7763-7bdc812a910f@huaweicloud.com>
In-Reply-To: <193d4bb3-3738-710e-7763-7bdc812a910f@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 29 Aug 2024 21:48:27 +0800
Message-ID: <CALTww2_D3A9r0ZRXfMYBQnHMyuYua_ynaHg=CTyVbEtRCZ84Ow@mail.gmail.com>
Subject: Re: [PATCH 1/1] [PATCH V2 md-6.12 1/1] md: add new_level sysfs interface
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 9:34=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/08/29 21:13, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Aug 29, 2024 at 8:24=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/08/29 18:01, Xiao Ni =E5=86=99=E9=81=93:
> >>> This interface is used to update new level during reshape progress.
> >>> Now it doesn't update new level during reshape. So it can't know the
> >>> new level when systemd service mdadm-grow-continue runs. And it can't
> >>> finally change to new level.
> >>
> > Hi Kuai
> >
> >> I'm not sure why updaing new level during reshape. Will this corrupt
> >> data in the array completely?
> >
> > There is no data corruption.
> >
> >
> >>>
> >>> mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> >>> mdadm --wait /dev/md0
> >>> mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> >>> cat /proc/mdstat
> >>> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> >>> md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
> >>
> >> The problem is that level is still 6 after mddev --grow -l5? I don't
> >> understand yet why this is related to update new level during reshape.
> >> :)
> >
> > mdadm --grow command returns once reshape starts when specifying
> > backup file. And it needs mdadm-grow-continue service to monitor the
> > reshape progress. It doesn't record the new level when running `mdadm
> > --grow`. So mdadm-grow-continue doesn't know the new level and it
> > can't change to new level after reshape finishes. This needs userspace
> > patch to work together.
> > https://www.spinics.net/lists/raid/msg78081.html
>
> Hi,
>
> Got it. Then I just wonder, what kind of content are stored in the
> backup file, why don't store the 'new level' in it as well, after
> reshape finishes, can mdadm use the level api to do this?

The backup file has a superblock too and the content is the data from
the raid. The service monitors reshape progress and controls it. It
copies the data from raid to backup file, and then it reshapes. Now we
usually don't care about it because the data offset can change and it
has free space. For situations where the data offset can't be changed,
it needs to write the data to the region where it is read from. If
there is a power down or something else, the backup file can avoid
data corruption.

It should be right to update the new level in md during reshape. If
not, the new level is wrong.

Best Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Best Regards
> >
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>
> >>>
> >>> The case 07changelevels in mdadm can trigger this problem. Now it can=
't
> >>> run successfully. This patch is used to fix this. There is also a
> >>> userspace patch set that work together with this patch to fix this pr=
oblem.
> >>>
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>> ---
> >>> V2: add detail about test information
> >>>    drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> >>>    1 file changed, 29 insertions(+)
> >>>
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index d3a837506a36..3c354e7a7825 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *b=
uf, size_t len)
> >>>    static struct md_sysfs_entry md_level =3D
> >>>    __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
> >>>
> >>> +static ssize_t
> >>> +new_level_show(struct mddev *mddev, char *page)
> >>> +{
> >>> +     return sprintf(page, "%d\n", mddev->new_level);
> >>> +}
> >>> +
> >>> +static ssize_t
> >>> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> >>> +{
> >>> +     unsigned int n;
> >>> +     int err;
> >>> +
> >>> +     err =3D kstrtouint(buf, 10, &n);
> >>> +     if (err < 0)
> >>> +             return err;
> >>> +     err =3D mddev_lock(mddev);
> >>> +     if (err)
> >>> +             return err;
> >>> +
> >>> +     mddev->new_level =3D n;
> >>> +     md_update_sb(mddev, 1);
> >>> +
> >>> +     mddev_unlock(mddev);
> >>> +     return len;
> >>> +}
> >>> +static struct md_sysfs_entry md_new_level =3D
> >>> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> >>> +
> >>>    static ssize_t
> >>>    layout_show(struct mddev *mddev, char *page)
> >>>    {
> >>> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, ser=
ialize_policy_show,
> >>>
> >>>    static struct attribute *md_default_attrs[] =3D {
> >>>        &md_level.attr,
> >>> +     &md_new_level.attr,
> >>>        &md_layout.attr,
> >>>        &md_raid_disks.attr,
> >>>        &md_uuid.attr,
> >>>
> >>
> >
> >
> >
> > .
> >
>

