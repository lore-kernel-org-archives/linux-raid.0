Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1B1FDD
	for <linux-raid@vger.kernel.org>; Fri,  6 Sep 2024 02:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725588464; cv=none; b=aug67WWUF/9gjjH1BzcGoUb3Rh+6pee+BdNsSASq9Va945uFVKLLQ3N+2yoejUPpNjRMmBD8sC1AHIA1XWjDvMUV9arJ/Ku21zPsOSNjhN6M7A6jNSZtJP66UaJWGB93svsblufJh4JhvcMGOZdmKkPwHGx84/4wn+SaE4P1dKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725588464; c=relaxed/simple;
	bh=2N6wvn2WFB2PySPCEuBElKWA9iD2WOpT0VVXq6fJubs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILZjIteFfG/6hFL9OZiRXKBI0ya9O31SlB6+wZerEWB6ZMTi7inJriDwXBBNngH7UMCudcKYTRZuNcm1qj0NmYxo1JNovG0Z5kzhRzj/zigsBoGaqRPvWqos2PeZE6DSiFZOnC52zZDiY7cmUFiZI4CqOBUeVly/1u25qMkgv7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bjHL+ejE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjHL+ejE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725588461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=406yKRlpIL3No/Jx4zkJ5mQdwHqk7SYwrWstMvbmoGE=;
	b=bjHL+ejE/okekxQwgcHX0oYAWlseWAG6jLEbHuuJtnsi4P7luSvVBe8BqoV/0NIwOIRd1v
	Cvu7RwWt0dP2KMkk/xfV0ZQcALlHI5OuVtnw+jhXly2kX7NvQfs4quwgHiJBxVSv7lG4s5
	FwBc4VTFusz4xxRN1+4LA5lHdUZEju4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-pRBtGQacNKeymwj1Y2Rw_A-1; Thu, 05 Sep 2024 22:07:40 -0400
X-MC-Unique: pRBtGQacNKeymwj1Y2Rw_A-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-718b397166fso568610b3a.0
        for <linux-raid@vger.kernel.org>; Thu, 05 Sep 2024 19:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725588458; x=1726193258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=406yKRlpIL3No/Jx4zkJ5mQdwHqk7SYwrWstMvbmoGE=;
        b=xUnZ+VRgOEzwJdf56rEZyAtGNYaDknl1J6lLhlo9Eeerf/H5nrzK3cdWV6R6IzjRhv
         nRkJniVvabWItgmuAhKIEk76/2lhiltmng+skiulvVRigMIVWXZp0bCy1uVIOFHzvpFk
         3R1Rn9wEmkhRzX3vOc1pT4MYn8pGKAlnTYMCseQMg65wMyOdIVxGS0EsdEX74sC3i1Yh
         Xu8bdlpEclgZBgY9gBB7Pk7ZYI9iQoJ6/YiWIOHHIT2KnU5u+rBZqBzArv/bUNXL1WOB
         7qxhA26dQSTlDxgb42w4p+O3EFqDEiEMqVmRwjHbK7dCWr74ubZAPEDbWeXwU712meG/
         o3MA==
X-Gm-Message-State: AOJu0YzWQ9XEZ7RQSXeuLqvsvEf/5kyllnN3fhbFJFQl5kfEiMYI3Sls
	aLmWSJ0bQOKMUF6UOtdOfhqgtbgpXzZXxQj/agr3ZSZ7FyUjEoa1hMZIOCLlWyuGsTp8gHqAMxl
	9I3vS8N3V9DfPgLVxsheVsN/fEXxZklNdqV53DDJsqgAPScT21GQihpOGjovyWN2KGZ+ezTQ7bV
	8OnTUp/WG5+uUhXUImt1P2jg5DXf34tfO+RT/d2ZnUxse14/s=
X-Received: by 2002:a05:6a20:9f4a:b0:1c3:ea28:3c0e with SMTP id adf61e73a8af0-1cce1097c71mr22803440637.33.1725588458507;
        Thu, 05 Sep 2024 19:07:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJi9ij13+388537LiCuvSAQhVRwnAhx+JPj9x5SMIJwc52dVkICvWlGEu8OXhJYgHs6WTUsjzMw/8JDH4PU6Q=
X-Received: by 2002:a05:6a20:9f4a:b0:1c3:ea28:3c0e with SMTP id
 adf61e73a8af0-1cce1097c71mr22803412637.33.1725588457602; Thu, 05 Sep 2024
 19:07:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904235453.99120-1-xni@redhat.com> <CAPhsuW4xb8cuk0kKuLivHVkzzHOyNMDiD4iv7DBqghZ9DmwM6A@mail.gmail.com>
In-Reply-To: <CAPhsuW4xb8cuk0kKuLivHVkzzHOyNMDiD4iv7DBqghZ9DmwM6A@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 6 Sep 2024 10:07:26 +0800
Message-ID: <CALTww2-FnOaiP3GqF98oWRXn3UUxjyBDBYYn9qOcpomLv=-7Rw@mail.gmail.com>
Subject: Re: [PATCH V3 md-6.12 1/1] md: add new_level sysfs interface
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, yukuai1@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 1:55=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Wed, Sep 4, 2024 at 4:55=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
> >
> > Reshape needs to specify a backup file when it can't update data offset
> > of member disks. For this situation, first, it starts reshape and then
> > it kicks off mdadm-grow-continue service which does backup job and
> > monitors the reshape process. The service is a new process, so it needs
> > to read superblock from member disks to get information.
> >
> > But in the first step, it doesn't update new level in superblock. So
> > in the second step, the new level that systemd service reads from
> > superblock is wrong. It can't change to the right new level after resha=
pe
> > finishes. This interface is used to update new level during reshape
> > progress.
> >
> > Reproduce steps:
> > mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> > mdadm --wait /dev/md0
> > mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> > cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> > md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
> >
> > Test case 07changelevels from mdadm regression tests can trigger this
> > problem.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> > V3: explain more about the root cause
> > V2: add detail about test information
> >  drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d3a837506a36..3c354e7a7825 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf=
, size_t len)
> >  static struct md_sysfs_entry md_level =3D
> >  __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
> >
> > +static ssize_t
> > +new_level_show(struct mddev *mddev, char *page)
> > +{
> > +       return sprintf(page, "%d\n", mddev->new_level);
> > +}
> > +
> > +static ssize_t
> > +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> > +{
> > +       unsigned int n;
> > +       int err;
> > +
> > +       err =3D kstrtouint(buf, 10, &n);
> > +       if (err < 0)
> > +               return err;
> > +       err =3D mddev_lock(mddev);
> > +       if (err)
> > +               return err;
> > +
> > +       mddev->new_level =3D n;
> > +       md_update_sb(mddev, 1);
> > +
> > +       mddev_unlock(mddev);
> > +       return len;
> > +}
> > +static struct md_sysfs_entry md_new_level =3D
> > +__ATTR(new_level, 0664, new_level_show, new_level_store);
>
> Actually, since we can read and write "new_level", please describe how
> it will be used (read and write).
>
> Thanks,
> Song
>

Hi Song

I rewrite the comments like this:

Now reshape supports two ways: with backup file or without backup file.
For the situation without backup file, it needs to change data offset.
It doesn't need systemd service mdadm-grow-continue. So it can finish
the reshape job in one process environment. It can know the new level
from mdadm --grow command and can change to new level after reshape
finishes.

For the situation with backup file, it needs systemd service
mdadm-grow-continue to monitor reshape progress. So there are two process
environments. One is mdadm --grow command whick kicks off reshape. It
doesn't wait reshape to finish and wake up mdadm-grow-continue service.
Two is the service. But it doesn't know the new level. Because in the
first step, it doesn't sync the information to kernel space. So the new
level which reads from superblock is wrong.

In kernel space mddev->new_level is used to record the new level when
doing reshape. This patch tries to add a new interface to help mdadm
can update new level and sync it to metadata. So it can read the right
new level when mdadm-grow-continue starts. And it can change to the new
level after reshape finishes.

Reproduce steps:
mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
mdadm --wait /dev/md0
mdadm /dev/md0 --grow -l5 --backup=3Dbackup
cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]

Test case 07changelevels from mdadm regression tests can trigger this
problem.

If you want me to re-send a formal patch, I'll do it.

Best Regards
Xiao

