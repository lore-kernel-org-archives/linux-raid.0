Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7701C6B8
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706183543; cv=none; b=fpzBxr1w4Wm05A+tCxEm8URuNBslHSsCDGz66bqjvZUlmXZ2BZlXK3/r2P4VUfPheHyF0FP/BnmzA2D5Xv/JS/hky93VXQtXxTIZCibq8sfZuqb5mFbyW3utaOL/I5np2rY0UGa2aMT6fW7dwLl60g4+ppyIR3Jx2DZDSaUaM2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706183543; c=relaxed/simple;
	bh=8IesGh+lx2LeP9ioxmdrGvTfTItFKf+5RiQ6HGAYuic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TSQe9ezXLjJXJqlxeqw+hoa3TafiPZh//H14coDPjFVBx/DeaB2AChnKlAzkmXTctX4wx6k2PgpHvPbYrs/Cp6cvknizxwL9kqVyxTDKMz9j0kYD6E8cq7Nt2oRORmNOiEJJ5Ala5Lm2kUrmSyy1bs0CDTneRSmKcOU3mD+L4f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M3F0jxIA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M3F0jxIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706183540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/fiwP5nCJZgkSM5yfNnrbsyzm77LZ+A2VSTp+p+hDE=;
	b=M3F0jxIAoBd/1rOc8/o9Z9sIOWZPUH5rs3w19qvuhDpZvdREVjKsBFXU1+WOa/JH6G2uoI
	AgrBjgYYHQJ7m/Ev3uTnOzA8/4fknz63nHzNnI/X6Pnj9FeTrrbDQyGeRXOQBvsnU14HmR
	+p+ijGzPth81pVWRe/se0tfMf7RQK1k=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-g-_r-QcaPT-8f6c9qkNHUQ-1; Thu, 25 Jan 2024 06:52:17 -0500
X-MC-Unique: g-_r-QcaPT-8f6c9qkNHUQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6ddd112c8baso247591b3a.2
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 03:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706183535; x=1706788335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a/fiwP5nCJZgkSM5yfNnrbsyzm77LZ+A2VSTp+p+hDE=;
        b=eS8u63GjMVJro0FxQEG5GJHiXX/Xr/TLbA78QirURJ199CIss0vhOX1wBJl5Pe6Ael
         W9ZuKU1LD5ggVunDftMFg3CV/086KsF57apaHvySrq4zmHznBzSVvbxnVz67nvCnMq6b
         AG0v6/vKOVws31fomQM8XJitkukOKfED0NYK+Tu1W4NF4u/VnLIhjbijWJ4SjGTcCkd9
         UCBgLvXcI9UBXZo+L4x9Wn3UNYxYU4usHxhTxLfub0FslGlNdB0EVHowtxZ0P9eKNlVd
         M7FdJ6/zXDTsFqWsppjFVUUTdfGMpUCANNoz7LZynDgZKc7FRbWMnT7LeEQYG93RiMjW
         cU3A==
X-Gm-Message-State: AOJu0YyfsEwZx2Q+lBSTnH0y6+l+KQ9Ls+c2ZGtWsrCYh0CEy0c1Sj9i
	Aip2Deo1622XrpkNrkxTEHLeBuBdqaJAW4PKjrw89OFEC60GgQlddJAmFTZ8cMyZuH+Sp3Es02A
	AJfmPe83D9HOSACaIAtZ4DwMZB01DfPA4HIHYeq1maOLemfRLkwisf7BzhMn3gk4Ej2xW1IfXH/
	8ptcKaVnyiKyFN0gPMpAch8BCsqe9AiedOHA==
X-Received: by 2002:aa7:9888:0:b0:6db:acb2:a95d with SMTP id r8-20020aa79888000000b006dbacb2a95dmr405921pfl.21.1706183535465;
        Thu, 25 Jan 2024 03:52:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYrXlRNOoYBrLSZC2TdQI370D1/7JhsEPYlxfVvUC8O4Maf4BOLfkBDc7QWWl2ffHVXX0VtYxkCOuCMhofu54=
X-Received: by 2002:aa7:9888:0:b0:6db:acb2:a95d with SMTP id
 r8-20020aa79888000000b006dbacb2a95dmr405910pfl.21.1706183535167; Thu, 25 Jan
 2024 03:52:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
 <CALTww2_V6Cr4j7hMPnMMt-g2w_xfCHQvwBpwbyOk=5rGcap6YA@mail.gmail.com> <d7b8043e-c921-8769-f39f-5105f2e866b6@huawei.com>
In-Reply-To: <d7b8043e-c921-8769-f39f-5105f2e866b6@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 25 Jan 2024 19:52:04 +0800
Message-ID: <CALTww2_jezrwJu0Vea+0mePBrV_9RwUMZ=J+_WV0KS-ShW1WPg@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md: export helpers to stop sync_thread
To: Yu Kuai <yukuai3@huawei.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	dm-devel@lists.linux.dev, song@kernel.org, neilb@suse.de, heinzm@redhat.com, 
	shli@fb.com, akpm@osdl.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 7:42=E2=80=AFPM Yu Kuai <yukuai3@huawei.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2024/01/25 19:35, Xiao Ni =E5=86=99=E9=81=93:
> > Hi all
> >
> > This is the result of lvm2 tests:
> > make check
> > ### 426 tests: 319 passed, 74 skipped, 0 timed out, 5 warned, 28
> > failed   in 56:04.914
>
> Are you testing with this patchset? 28 failed is much more than my
> test result in following:

Yes, 6.7.0-rc8 with this patch set.
>
> > make[1]: *** [Makefile:138: check] Error 1
> > make[1]: Leaving directory '/root/lvm2/test'
> > make: *** [Makefile:89: check] Error 2
> >
> > Do you know where to check which cases fail?
>
> I saved logs and grep keyword "failed:", and the result will look like
> this:

I'll use this way to collect the failed cases.

Regards
Xiao
>
>
> You can find each test log in the dir test/result/
> >
> > Best Regards
> > Xiao
> >
> > On Wed, Jan 24, 2024 at 5:19=E2=80=AFPM Yu Kuai <yukuai3@huawei.com> wr=
ote:
> >>
> >> The new heleprs will be used in dm-raid in later patches to fix
> >> regressions and prevent calling md_reap_sync_thread() directly.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/md.c | 41 +++++++++++++++++++++++++++++++++++++----
> >>   drivers/md/md.h |  3 +++
> >>   2 files changed, 40 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 6c5d0a372927..90cf31b53804 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -4915,30 +4915,63 @@ static void stop_sync_thread(struct mddev *mdd=
ev, bool locked, bool check_seq)
> >>                  mddev_lock_nointr(mddev);
> >>   }
> >>
> >> -static void idle_sync_thread(struct mddev *mddev)
> >> +void md_idle_sync_thread(struct mddev *mddev)
> >>   {
> >> +       lockdep_assert_held(mddev->reconfig_mutex);
> >> +
> >>          mutex_lock(&mddev->sync_mutex);
> >>          clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >> +       stop_sync_thread(mddev, true, true);
> >> +       mutex_unlock(&mddev->sync_mutex);
> >> +}
> >> +EXPORT_SYMBOL_GPL(md_idle_sync_thread);
> >> +
> >> +void md_frozen_sync_thread(struct mddev *mddev)
> >> +{
> >> +       lockdep_assert_held(mddev->reconfig_mutex);
> >> +
> >> +       mutex_lock(&mddev->sync_mutex);
> >> +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >> +       stop_sync_thread(mddev, true, false);
> >> +       mutex_unlock(&mddev->sync_mutex);
> >> +}
> >> +EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
> >>
> >> +void md_unfrozen_sync_thread(struct mddev *mddev)
> >> +{
> >> +       lockdep_assert_held(mddev->reconfig_mutex);
> >> +
> >> +       mutex_lock(&mddev->sync_mutex);
> >> +       clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >> +       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >> +       md_wakeup_thread(mddev->thread);
> >> +       sysfs_notify_dirent_safe(mddev->sysfs_action);
> >> +       mutex_unlock(&mddev->sync_mutex);
> >> +}
> >> +EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
> >> +
> >> +static void idle_sync_thread(struct mddev *mddev)
> >> +{
> >>          if (mddev_lock(mddev)) {
> >>                  mutex_unlock(&mddev->sync_mutex);
> >>                  return;
> >>          }
> >>
> >> +       mutex_lock(&mddev->sync_mutex);
> >> +       clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >>          stop_sync_thread(mddev, false, true);
> >>          mutex_unlock(&mddev->sync_mutex);
> >>   }
> >>
> >>   static void frozen_sync_thread(struct mddev *mddev)
> >>   {
> >> -       mutex_lock(&mddev->sync_mutex);
> >> -       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >> -
> >>          if (mddev_lock(mddev)) {
> >>                  mutex_unlock(&mddev->sync_mutex);
> >>                  return;
> >>          }
> >>
> >> +       mutex_lock(&mddev->sync_mutex);
> >> +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >>          stop_sync_thread(mddev, false, false);
> >>          mutex_unlock(&mddev->sync_mutex);
> >>   }
> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >> index 8d881cc59799..437ab70ce79b 100644
> >> --- a/drivers/md/md.h
> >> +++ b/drivers/md/md.h
> >> @@ -781,6 +781,9 @@ extern void md_rdev_clear(struct md_rdev *rdev);
> >>   extern void md_handle_request(struct mddev *mddev, struct bio *bio);
> >>   extern int mddev_suspend(struct mddev *mddev, bool interruptible);
> >>   extern void mddev_resume(struct mddev *mddev);
> >> +extern void md_idle_sync_thread(struct mddev *mddev);
> >> +extern void md_frozen_sync_thread(struct mddev *mddev);
> >> +extern void md_unfrozen_sync_thread(struct mddev *mddev);
> >>
> >>   extern void md_reload_sb(struct mddev *mddev, int raid_disk);
> >>   extern void md_update_sb(struct mddev *mddev, int force);
> >> --
> >> 2.39.2
> >>
> >
> > .
> >
>

