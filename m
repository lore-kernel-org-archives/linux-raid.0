Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8066E7E788
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 13:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708694456; cv=none; b=n2QgfdnxviuAKyQt6D5w20fBI+ftyD6oL07++QKDM9bcb1xC+dvUTNRiQnnKNq4vDoUBbUIeB30EIGXhh6bUMZGBNd92PZyY+bgapSdrKV2AVcGEmIL2s5/iwgRCZKSLL8AhvyUpf4Ebbq9wwlf63mYgfQkvKTh1nLRYhlYocrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708694456; c=relaxed/simple;
	bh=gWuRgZKbISrsOUxx4DI0wL7M/qTJ8zP6W3B6ttagXW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d64dyp/xQtpU6DnjaZhGXXu62LaaOvi/xjlZJGP1SO4lpE3vNGnNMR3gmNeMRI1DVuSX9jlWBrLN7DzwtB6Xandm/M71vCW3jQzzcdIqAcaBvEDAJtPqbMAwFojyI8Bo6LvzmwjbztdEEa1xzOjgRtK/QETpzFrqQDXapC5+6fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIEOmgzr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIEOmgzr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708694453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tWiyGY1k8fErfSxXaJlrYF3F4fWiFw8cllnBWF7U1zQ=;
	b=NIEOmgzrnRsCX8O4c3aXoVRc/jfqnTJX3BOOeSLeuTBHznfDS4jZk/WqAMS8RhguTtSseA
	km74OpSASJsBSO8pWJil3DT6ghUUc7MgFnItiLWoDerRSochBfwum31rCFapooL2sS5u20
	aOwC7HfY40pEzbqGyS+/fh1nRk0gP2o=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-Mp6C00xHOqmbRxolEkgm0w-1; Fri, 23 Feb 2024 08:20:52 -0500
X-MC-Unique: Mp6C00xHOqmbRxolEkgm0w-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6e38b5bf1b1so520783b3a.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 05:20:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708694451; x=1709299251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWiyGY1k8fErfSxXaJlrYF3F4fWiFw8cllnBWF7U1zQ=;
        b=SRTbLakm/kCdH96sWPKxsd8IYiz4EpYYlZEedgpEFWbstccuEFx0w7PA2sRc4XEx+H
         hlFLMkaCNOTI9+u237bWDsC3tfJz2IMj7P3TN+aUFfvYCfuF/JFBriXvgqi8d00RqxIx
         on4DbEN36nLydz6Bpl1SZCS7KK3WkN6cTryzKTum2y7DeaXEBy0/EsZeh4Mac3CXmH/X
         k0//W30APdMMNgbzHJEoCevJg4/0tsipYFg0e5WXgtREnuDlDrOnQfBdzas2A3Un7BTm
         owYbTHYXSUak7qiR7Cw52mwqXIvih7LezIs5n2LSNeWfp8ewFAeWyPrHzhorMHi/2pFq
         DeCw==
X-Forwarded-Encrypted: i=1; AJvYcCVVzeRtvqWIj5ydqkeUMVO94//mt8EfZ5flMxc6aOMhw6pOtrfDYGHjWhWDn4ucFh+3hq6x6n9xKcvuyk+VgcPS0n47lL9hrmD0pA==
X-Gm-Message-State: AOJu0Yznx4/xw2EHohGhOLQAZFMvsN32xTgcEjIJOOyPdcZBa06YcfDq
	Sun5RYZgGy3bso0RCkFgULUcM/UUifiTFPREw0zuk0YLscUgTMOrsK4CPCFlED2cyRemPML2zM5
	YLEzU+4vyCqE54XAw+e8ePtwqZrYvOJIFonZ3Qf4OGcfwd9i5d5weY7h1Jtsv/l8XMhTSYuDZhE
	t89Od4g635GZuebixLu03vvcoud/jgfdEkEA==
X-Received: by 2002:a05:6a21:9808:b0:1a0:ddbb:76e with SMTP id ue8-20020a056a21980800b001a0ddbb076emr1349747pzb.33.1708694450924;
        Fri, 23 Feb 2024 05:20:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3u0rAdVy1do38iVNK3ps8vGftvxf5SQZOg5L4YtecFfe2FjBogYhZavwnrNzJkwAkcMA3TxixU4g7JwXZr1U=
X-Received: by 2002:a05:6a21:9808:b0:1a0:ddbb:76e with SMTP id
 ue8-20020a056a21980800b001a0ddbb076emr1349735pzb.33.1708694450643; Fri, 23
 Feb 2024 05:20:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-2-xni@redhat.com>
 <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com>
In-Reply-To: <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 21:20:39 +0800
Message-ID: <CALTww2-3WgtGMDpeDphcfkdCxORf5bTSFZATSZ=m3S4VbPv26w@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 11:32=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
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
>
> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky and
> really breaks how sync_thread is working, it should just go away soon,
> once we make sure sync_thread can't be registered before pers->start()
> is done.

Hi Kuai

I just want to get to a stable state without changing any existing
logic. After fixing these regressions, we can consider other changes.
(e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when array
is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
allow any io to happen including sync thread when array is suspended.

Regards
Xiao
>
> Thanks,
> Kuai
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
> >               /* Writes have to be stopped before suspending to avoid d=
eadlocks. */
> >               if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
> >                       md_stop_writes(&rs->md);
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 2266358d8074..54790261254d 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mddev,=
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

