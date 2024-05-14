Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8467D17BD2
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 08:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676047; cv=none; b=UQnibflbpZN2sI+UtKG1J6n4YJ48DOu3ofl5kZz0PBvNwXaGT7lnILHAyvRmGO9aaJofB8cudoMKhsA/8IM6YXfCVpB5kwaPA0doLNSma0lpriqHNtr9rY6rlik0VuXkjsy83iAPaAi8dpAeW0F3tKgdqyHwYcpGFl5bldxZeJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676047; c=relaxed/simple;
	bh=dFetEP4vkmRWLTuq1sqXsZFTQHPK5+caLDooAk7uDDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Th5DZ2pHU3dzOzh96L6SIR2ey4DS0FxrEvK/BHMIVKO1z3Sm+/jiPdt4vaMqsoVATtUdzoxKtX3P4tUuJ33VICAdxZXWgfsMQaY3itUiqzIaDoiJ/WLGbn43u/hkzKM/YDyfFq10JoyaPtdh9c5usXa7R3vrcL+MZ/BuuPq+Pvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evpJPZZd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evpJPZZd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715676044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XTDAkRQKfljadsK+bvkReAfKhEEpDm2v7Tj55z8J0R0=;
	b=evpJPZZdXiElN69/iXhM/ymXVaIfrS8fSJSyF0qkD6qbiXclI1DvgbYiLZPvQ8775EWL1o
	GI6OInsw5lfx+NSKvhrA76//Q64iUr0BUiX+ng+vZxMZs5sbHdPr6hQSkISl04l+XeeGeO
	y4fxMYRtu74qyw+wK56GFWHgp8vVcec=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-0ECUlbbcMnezNpyBIipzyA-1; Tue, 14 May 2024 04:40:43 -0400
X-MC-Unique: 0ECUlbbcMnezNpyBIipzyA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5ce12b4c1c9so3694387a12.1
        for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 01:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676042; x=1716280842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTDAkRQKfljadsK+bvkReAfKhEEpDm2v7Tj55z8J0R0=;
        b=KvtNivSBa1VyNbUqFE7Q6+z0viwLm5vY9+m8Omh6I2k30ifcvEBespuojRfXOhaBTP
         DTvy8G3eSURnsQVxmnCyJfRlwWMN6T361edUu5kXar40ItVo9PaK3whnO5O8CBuy7swc
         txEdNCXmpZ95hE8J5h/D7CZC/W985ad1KAftVKSL4o3UK1sffaZpaivUUYMhesOGD00u
         bV9XSgsPzqwIG129gxPHaOIIJFis7J/yHUHIwmeURQhqakdEu8iqEnl5rN57oTYShAww
         L/70+UXpZxQrR+sq5k6kL3SJClffAVYOa1tqGGbdGEhAyI38asaLRx8g7wSRdDWKnE67
         e2PA==
X-Forwarded-Encrypted: i=1; AJvYcCU+hslOexnhJIvwlUGwMPrqO+FfvwguLcg0eL/wRsBTYWJFf7gvS8HwBy6TXFF4BhLaD0uQ07+NqCySI05MUYlJqMgnoM0ddvsrlw==
X-Gm-Message-State: AOJu0YzjDiwzXooaT685l9KywrV6SLKDpWjk9l8fitKbF+fH3XynGsne
	dWpvqD9PZvtAIEguRpaPYoYqHBCJxSd7vM/Q5moCFhReTjhkeWi1pedB9/3lY+p4Wsb5BQR6sxf
	WmJj9tiLgS4GliX8cO5UdVo4JZO33OIGGpQXxU52FNzzMtY/a8qb+8FvTTDLjhQT8a18qQjZ0Y4
	ulgVpWKBxgLf1jf3o7cI2f3l20RUb+9lQKcg==
X-Received: by 2002:a05:6a21:9209:b0:1af:f817:7c30 with SMTP id adf61e73a8af0-1aff8177ccemr4598292637.54.1715676041667;
        Tue, 14 May 2024 01:40:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk0+nnfe4H6D5lCU6UzBHKF4/CM04JrcTMJkYrIEBuYxkc9VBbcacfdhScATnxIPp80XWNGD6qidj2o+fQvyM=
X-Received: by 2002:a05:6a21:9209:b0:1af:f817:7c30 with SMTP id
 adf61e73a8af0-1aff8177ccemr4598261637.54.1715676040436; Tue, 14 May 2024
 01:40:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-4-yukuai1@huaweicloud.com> <CALTww2-RPH_eYBumjxhHLkj7J2tfHskTYNif93Hwn5ksCN0+kA@mail.gmail.com>
 <06211ae2-9b5f-10c7-7953-9d79d2eacc67@huaweicloud.com>
In-Reply-To: <06211ae2-9b5f-10c7-7953-9d79d2eacc67@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 14 May 2024 16:40:28 +0800
Message-ID: <CALTww28LM_b6SMC-vLY3y7R3ZD9z80H+2vZCXMzmAwnoEH-eMA@mail.gmail.com>
Subject: Re: [PATCH md-6.10 3/9] md: add new helpers for sync_action
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 3:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/05/14 14:52, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, May 13, 2024 at 5:31=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> The new helpers will get current sync_action of the array, will be use=
d
> >> in later patches to make code cleaner.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/md.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++=
++
> >>   drivers/md/md.h |  3 +++
> >>   2 files changed, 67 insertions(+)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 00bbafcd27bb..48ec35342d1b 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -69,6 +69,16 @@
> >>   #include "md-bitmap.h"
> >>   #include "md-cluster.h"
> >>
> >> +static char *action_name[NR_SYNC_ACTIONS] =3D {
> >> +       [ACTION_RESYNC]         =3D "resync",
> >> +       [ACTION_RECOVER]        =3D "recover",
> >> +       [ACTION_CHECK]          =3D "check",
> >> +       [ACTION_REPAIR]         =3D "repair",
> >> +       [ACTION_RESHAPE]        =3D "reshape",
> >> +       [ACTION_FROZEN]         =3D "frozen",
> >> +       [ACTION_IDLE]           =3D "idle",
> >> +};
> >> +
> >>   /* pers_list is a list of registered personalities protected by pers=
_lock. */
> >>   static LIST_HEAD(pers_list);
> >>   static DEFINE_SPINLOCK(pers_lock);
> >> @@ -4867,6 +4877,60 @@ metadata_store(struct mddev *mddev, const char =
*buf, size_t len)
> >>   static struct md_sysfs_entry md_metadata =3D
> >>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, me=
tadata_store);
> >>
> >> +enum sync_action md_sync_action(struct mddev *mddev)
> >> +{
> >> +       unsigned long recovery =3D mddev->recovery;
> >> +
> >> +       /*
> >> +        * frozen has the highest priority, means running sync_thread =
will be
> >> +        * stopped immediately, and no new sync_thread can start.
> >> +        */
> >> +       if (test_bit(MD_RECOVERY_FROZEN, &recovery))
> >> +               return ACTION_FROZEN;
> >> +
> >> +       /*
> >> +        * idle means no sync_thread is running, and no new sync_threa=
d is
> >> +        * requested.
> >> +        */
> >> +       if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
> >> +           (!md_is_rdwr(mddev) || !test_bit(MD_RECOVERY_NEEDED, &reco=
very)))
> >> +               return ACTION_IDLE;
> >
> > Hi Kuai
> >
> > Can I think the above judgement cover these two situations:
> > 1. The array is readonly / readauto and it doesn't have
> > MD_RECOVERY_RUNNING. Now maybe it has MD_RECOVERY_NEEDED, it means one
> > array may want to do some sync action, but the array state is not
> > readwrite and it can't start.
> > 2. The array doesn't have MD_RECOVERY_RUNNING and MD_RECOVERY_NEEDED
> >
> >> +
> >> +       if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
> >> +           mddev->reshape_position !=3D MaxSector)
> >> +               return ACTION_RESHAPE;
> >> +
> >> +       if (test_bit(MD_RECOVERY_RECOVER, &recovery))
> >> +               return ACTION_RECOVER;
> >> +
> >> +       if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
> >> +               if (test_bit(MD_RECOVERY_CHECK, &recovery))
> >> +                       return ACTION_CHECK;
> >> +               if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
> >> +                       return ACTION_REPAIR;
> >> +               return ACTION_RESYNC;
> >> +       }
> >> +
> >> +       return ACTION_IDLE;
> >
> > Does it need this? I guess it's the reason in case there are other
> > situations, right?
>
> Yes, we need this, because they are many places to set
> MD_RECOVERY_NEEDED, while there are no sync action actually, this case
> is 'idle'.

To be frank, the logic in action_show is easier to understand than the
logic above. I have taken more than half an hour to think if the logic
here is right or not. In action_show, it only needs to think when it's
not idle and it's easy.

Now this patch logic needs to think in the opposite direction: when
it's idle. And it returns ACTION_IDLE at two places which means it
still needs to think about when it has sync action. So it's better to
keep the original logic in action_show now. It's just my 2 cents
point.

Best Regards
Xiao

>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >
> >> +}
> >> +
> >> +enum sync_action md_sync_action_by_name(char *page)
> >> +{
> >> +       enum sync_action action;
> >> +
> >> +       for (action =3D 0; action < NR_SYNC_ACTIONS; ++action) {
> >> +               if (cmd_match(page, action_name[action]))
> >> +                       return action;
> >> +       }
> >> +
> >> +       return NR_SYNC_ACTIONS;
> >> +}
> >> +
> >> +char *md_sync_action_name(enum sync_action action)
> >> +{
> >> +       return action_name[action];
> >> +}
> >> +
> >>   static ssize_t
> >>   action_show(struct mddev *mddev, char *page)
> >>   {
> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >> index 2edad966f90a..72ca7a796df5 100644
> >> --- a/drivers/md/md.h
> >> +++ b/drivers/md/md.h
> >> @@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev *mdd=
ev, struct md_thread __rcu **t
> >>   extern void md_wakeup_thread(struct md_thread __rcu *thread);
> >>   extern void md_check_recovery(struct mddev *mddev);
> >>   extern void md_reap_sync_thread(struct mddev *mddev);
> >> +extern enum sync_action md_sync_action(struct mddev *mddev);
> >> +extern enum sync_action md_sync_action_by_name(char *page);
> >> +extern char *md_sync_action_name(enum sync_action action);
> >>   extern bool md_write_start(struct mddev *mddev, struct bio *bi);
> >>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
> >>   extern void md_write_end(struct mddev *mddev);
> >> --
> >> 2.39.2
> >>
> >
> > .
> >
>
>

