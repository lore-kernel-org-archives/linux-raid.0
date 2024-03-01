Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802712AEEE
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 04:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266798; cv=none; b=rYxGh6BKkQSPtNu2AgoOXMQP+Jwrlp/wwLiODicdDEt6zgTjuESnVpJjcNWIevWXNkSUhfLcamKpMNeg5RKckASWwRJwANLbcSng2sFz/7qbdWYDiNo8QmPmGJkZJ5xwVTGRraAQ9Wa+RbQ/r7gjKN2iyvQooCkJDunzsSrQ+ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266798; c=relaxed/simple;
	bh=Rbjpz8Pg5m0YAnqpIkKAHEJcUe5gWDmSGxvKUnvc5Qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JJ8Bho4Bi+UO61qwGyr0BKcQ9Z/bn5I2TA+zHNix2PdieZqVs1ea8zlIT86jzIFDR16pxdRno09jVUmDdmU78FYa8xRlGN0slmcGnbybY3u47P3m471XBuyHmNd9uXNs8zH5hcjZ22lLoABRUlrZz96oeieExWRIo0yQOiqLvYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WeZXAbEi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WeZXAbEi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OGb19kx0RQO+S4FO+017ZSrhMAd8HGMiAgGZ+CCpyJI=;
	b=WeZXAbEidYY46XriOBsYBt+GEdQY0a0dGMxgvGp1enOize7ujyHs+0Lhjp90mfTr15r9sQ
	SqFEHbr20HOQolIJwoECBdNlRuiCuWuKUoF0+bt/ruj+crWWwiyX03wqVw0YEkkQXHnGZE
	QsS+O3a8NQzJX0QAHqUOU6xC39OvUX4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-K1g2bshMPYy5bXt86PxOpQ-1; Thu, 29 Feb 2024 23:19:51 -0500
X-MC-Unique: K1g2bshMPYy5bXt86PxOpQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1dcdfaefe06so9765945ad.1
        for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 20:19:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709266791; x=1709871591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGb19kx0RQO+S4FO+017ZSrhMAd8HGMiAgGZ+CCpyJI=;
        b=OG4y3YfUC+Yfq5ur6E1sssgGXyA7ruOfrK4Sg9lT0xu0W2hihzRRWg6yW93hThECGJ
         LLmABVdU1HkOY3T9+rGCiUn1/A6MbXaNKN22KZ9VK+hn4PgfhHWt4TVZN+w7+Iu4UKDA
         LyOav+DXqHXXevFwBvQzkEU4VUOk8uLYMX7vdQA1O4aPEf1EoRa2n3l93QB2yXot8mOR
         b7m01rdst3wxTbiXcaAwcDJUrsGAFSb6nbQS2uLx2hCIiEarmg6nJFR0IaAe1prQ0Vnn
         F47PVEmo76NGM1T99RSESfoQ+HIiTTzZRN/jv7A1KE1maMfGYGSj3Ht7wq0VbfVDHMzp
         fNJw==
X-Forwarded-Encrypted: i=1; AJvYcCWeRcsQiZQjrRB8TK+mZNYsVOdaE/+UWTwMBv0eSXC7nJANs42ewRWFe0OjTb/+aq03flD/FrtmR9/apbnx1/W3A15/pM+8U/JFTQ==
X-Gm-Message-State: AOJu0Yzl/+7yq3vvslSiWu8yjuiztIUD1VdGp0vA6g9wJKyQM+Opvuzu
	vyAllHyGvAbLYYFTRbi4yGG0wBlJsDdbz1a/dcVq0RluWxSUn/84KBETTTTwvtDdmHpTNxGt8tn
	YtbFLAWyvhmsnoHz5J2aHemMem4xODxD9SyYpxK8jvNCC0BSoeF+bt+l4NS9IvLaCt6vOjn5ygG
	a/CHvGdP5q/9MQoXXb/GP7/JX3+geOQPfYJg==
X-Received: by 2002:a17:902:ce0e:b0:1db:930e:e755 with SMTP id k14-20020a170902ce0e00b001db930ee755mr913896plg.35.1709266790898;
        Thu, 29 Feb 2024 20:19:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcR4etlVfUnal8DGcVAJ/a62RFJWJT84yEmINT0EL3x4N6d6C3qCB622jPFbIpMX0vB8ppmJeAtJklrr7lb4k=
X-Received: by 2002:a17:902:ce0e:b0:1db:930e:e755 with SMTP id
 k14-20020a170902ce0e00b001db930ee755mr913878plg.35.1709266790587; Thu, 29 Feb
 2024 20:19:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229154941.99557-1-xni@redhat.com> <20240229154941.99557-5-xni@redhat.com>
 <6fcfeea4-69bc-d6cf-c367-0392d45c2efd@huaweicloud.com>
In-Reply-To: <6fcfeea4-69bc-d6cf-c367-0392d45c2efd@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 1 Mar 2024 12:19:39 +0800
Message-ID: <CALTww29wnHWuqhh1FN4FKXB9+=y1aAcnqE4GMULrtFPBZuXW+A@mail.gmail.com>
Subject: Re: [PATCH 4/6] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 10:45=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/29 23:49, Xiao Ni =E5=86=99=E9=81=93:
> > MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
> > commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
> > Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
> > dmraid stopped sync thread directy by calling md_reap_sync_thread.
> > After this patch dmraid stops sync thread asynchronously as md does.
> > This is right. Now the dmraid stop process is like this:
> >
> > 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread=
.
> > stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUNNI=
NG
> > is cleared
> > 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
> > root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_DO=
NE)
> > 3. md thread calls md_check_recovery (This is the place to reap sync
> > thread. Because MD_RECOVERY_DONE is not set. md thread can't reap sync
> > thread)
> > 4. raid_dtr stops/free struct mddev and release dmraid related resource=
s
> >
> > dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to cle=
ar
> > this bit when stopping the dmraid before stopping sync thread.
> >
> > But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
> > cleared before stopping sync thread. It's the reason stop_sync_thread o=
nly
> > wakes up task. If the task isn't running, it still needs to wake up syn=
c
> > thread too.
> >
> > This deadlock can be reproduced 100% by these commands:
> > modprobe brd rd_size=3D34816 rd_nr=3D5
> > while [ 1 ]; do
> > vgcreate test_vg /dev/ram*
> > lvcreate --type raid5 -L 16M -n test_lv test_vg
> > lvconvert -y --stripes 4 /dev/test_vg/test_lv
> > vgremove test_vg -ff
> > sleep 1
> > done
> >
> > Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
> > Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/dm-raid.c | 2 ++
> >   drivers/md/md.c      | 1 +
> >   2 files changed, 3 insertions(+)
> >
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index eb009d6bb03a..325767c1140f 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *ti=
)
> >       struct raid_set *rs =3D ti->private;
> >
> >       if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) =
{
> > +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
> > +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
>
> Like I mentioned in the RFC v2 patch, this really is not safe, or do you
> think am I missing something?

Hi Kuai

I replied based on RFC v2 email directly.

Regards
Xiao
>
> Of course we want lvm2 tests behave the same as v6.6, but we can't
> introduce new issue that is not covered by lvm2 tests.
>
> Thanks,
> Kuai
>
> >               /* Writes have to be stopped before suspending to avoid d=
eadlocks. */
> >               if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
> >                       md_stop_writes(&rs->md);
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 79dfc015c322..f264749be28b 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4908,6 +4908,7 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked, bool check_seq)
> >        * never happen
> >        */
> >       md_wakeup_thread_directly(mddev->sync_thread);
> > +     md_wakeup_thread(mddev->sync_thread);
> >       if (work_pending(&mddev->sync_work))
> >               flush_work(&mddev->sync_work);
> >
> >
>

