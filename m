Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40998BF3
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 02:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708656164; cv=none; b=NeAu3ENqe/MyoqoNxBqkuUd1iS5KUVeyPa78yRve7O8UimC/ul5ncGMRgwJ3bVvU9pq/XCJwGL6mxkAxtIUflegu0GOZaVvMR+m/m4nGV2ZcL5M3UKE3ajorA92ttuMm7jSddLTNpwYJ4IjPY2ZfAwuu6kvHDR7EWx22M+MraGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708656164; c=relaxed/simple;
	bh=xYOxN1Up79hg0dKaiQkBo3GKA2Z8eC/iqOx/kJqjdy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M22p+8rWrhaMOJNGoACtgqYHplhzj++7mHYITabjh0cjKzpXMETZ4qHEtVDjdN1o7infiRpu+cPa1XOixkeGSpw3rh9uJZ87QwsbPjkFGeb0bSWYg/HX/o/ioFLiHWzwa9IVtKI4rLamwjeqwwjw461ujDCHX7fxuvICyKVwbc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NGnPYzT1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGnPYzT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708656161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZ0FkD8XV6oglufBqTFirlQDGFfyT/4oJEa7wva2CXE=;
	b=NGnPYzT1pn0kD0faNkrQ5P7CebfvtAiVKC8mgvhr/64QM3j89/eZMYt4EMl7ARtd7LKra+
	ifKHJ49zdaSadGgTqtO6d0MYAWGW1jrH5XL94n5RYE/Z75Q6DTjU1vmotBl1CDl5XJBMjA
	E458JYDQ1xJp1XkiRZUhXjHu+7faZts=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-Dt8lX975MjeA97_-i6CCCQ-1; Thu, 22 Feb 2024 21:42:39 -0500
X-MC-Unique: Dt8lX975MjeA97_-i6CCCQ-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-59fdfc539aeso426280eaf.0
        for <linux-raid@vger.kernel.org>; Thu, 22 Feb 2024 18:42:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708656158; x=1709260958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NZ0FkD8XV6oglufBqTFirlQDGFfyT/4oJEa7wva2CXE=;
        b=Ldxy3Ie1iqBWc0NsKGvIk/bIAGaz9PReJxcHNfK++3/mezQ3uf2y6kgQuFa95HJn7X
         R+q7ZoTNunHjnh7Nl1ahylUEyY7iNdy/RJM0vi7JkA1zdSCDsRTZoATtC/b2Wks8t+M0
         9s0DZSOETVgav07tco8032P8Yauc/o3LWpkas/JWWVmJypRUTcYI/u+msCwQ3emqCQ2Z
         tukcPiAm1QpCAHW/zCrQWwDS0M+idv2MGjEmlSVG4pan9rOWrgCjV2bWxnVOo977KRFl
         Q+fwbDh51YaEjA8pxbBw/UgmiIQTL7qAwZLsSX9wZ1Mt9yhxiL//tChTRIncG0bkvZzw
         nYiA==
X-Forwarded-Encrypted: i=1; AJvYcCVQedCnCJDWyJmaEb9DT4dEisdH930NmpTkXIQF+qOr1Z+29x25Vq9wC7b4JV2h64cJG4mXBDYZmfNKG9UEtpK/HCgO+mK4XS4YBw==
X-Gm-Message-State: AOJu0Yx2QSkfTQq3pX+uDfX4V35c9/f+R9ykpe2Tf/IqZ/opAJpVCv+N
	jJzP/g20uDapuiKoAnuUlfRti1W0wf+gmX62JxzYNAFcu7McQ0li40MSpu8a8cxlZB0ct/f0r8f
	I2VPsDa6hIwQYqrfs3efoNRTG15GWtfUoGQZgSEuf2bgPaGwFKUNr0mU5JaQZCpTia4CGt9dlBl
	U5+tE8RH9qndrd/YXoZhIv6LTG+vUx7/JYxg==
X-Received: by 2002:a05:6358:41a5:b0:178:688e:fb21 with SMTP id w37-20020a05635841a500b00178688efb21mr687634rwc.7.1708656158440;
        Thu, 22 Feb 2024 18:42:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUAFIkpQK/weNod6ldBVJUs+nbjrvWBYV6BoO1AKz8dPC/Ua34kITSbigv1YOXQIb2Fsuzl5D8jhJd7qZ+zqo=
X-Received: by 2002:a05:6358:41a5:b0:178:688e:fb21 with SMTP id
 w37-20020a05635841a500b00178688efb21mr687611rwc.7.1708656158064; Thu, 22 Feb
 2024 18:42:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <ZdWN9qu8WUeJk13Q@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
In-Reply-To: <ZdWN9qu8WUeJk13Q@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 10:42:26 +0800
Message-ID: <CALTww2_tDUBQcwGiM_e4EpqXDz8citU4Gqx0JP_623Lvb73rRQ@mail.gmail.com>
Subject: Re: [PATCH RFC V2 0/4] Fix regression bugs
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: song@kernel.org, yukuai1@huaweicloud.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 1:45=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Tue, Feb 20, 2024 at 11:30:55PM +0800, Xiao Ni wrote:
> > Hi all
> >
> > Sorry, I know this patch set conflict with Yu Kuai's patch set. But
> > I have to send out this patch set. Now we're facing some deadlock
> > regression problems. So it's better to figure out the root cause and
> > fix them. But Kuai's patch set looks too complicate for me. And like
> > we're talking in the emails, Kuai's patch set breaks some rules. It's
> > not good to fix some problem by breaking the original logic. If we real=
ly
> > need to break some logic. It's better to use a distinct patch set to
> > describe why we need them.
> >
> > This patch is based on linus's tree. The tag is 6.8-rc5. If this patch =
set
> > can be accepted. We need to revert Kuai's patches which have been merge=
d
> > in Song's tree (md-6.8-20240216 tag). This patch set has four patches.
> > The first two resolves deadlock problems. With these two patches, it ca=
n
> > resolve most deadlock problem. The third one fixes active_io counter bu=
g.
> > The fouth one fixes the raid5 reshape deadlock problem.
>
> With this patchset on top of the v6.8-rc5 kernel I can still see a hang
> tearing down the devices at the end of lvconvert-raid-reshape.sh if I
> run it repeatedly. I haven't dug into this enough to be certain, but it
> appears that when this hangs, stripe_result make_stripe_request() is
> returning STRIPE_SCHEDULE_AND_RETRY because of
>
> ahead_of_reshape(mddev, logical_sector, conf->reshape_safe))
>
> this never runs stripe_across_reshape() from you last patch.
>
> It hangs with the following hung-task backtrace:
>
> [ 4569.331345] sysrq: Show Blocked State
> [ 4569.332640] task:mdX_resync      state:D stack:0     pid:155469 tgid:1=
55469 ppid:2      flags:0x00004000
> [ 4569.335367] Call Trace:
> [ 4569.336122]  <TASK>
> [ 4569.336758]  __schedule+0x3ec/0x15c0
> [ 4569.337789]  ? __schedule+0x3f4/0x15c0
> [ 4569.338433]  ? __wake_up_klogd.part.0+0x3c/0x60
> [ 4569.339186]  schedule+0x32/0xd0
> [ 4569.339709]  md_do_sync+0xede/0x11c0
> [ 4569.340324]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 4569.341183]  ? __pfx_md_thread+0x10/0x10
> [ 4569.341831]  md_thread+0xab/0x190
> [ 4569.342397]  kthread+0xe5/0x120
> [ 4569.342933]  ? __pfx_kthread+0x10/0x10
> [ 4569.343554]  ret_from_fork+0x31/0x50
> [ 4569.344152]  ? __pfx_kthread+0x10/0x10
> [ 4569.344761]  ret_from_fork_asm+0x1b/0x30
> [ 4569.345193]  </TASK>
> [ 4569.345403] task:dmsetup         state:D stack:0     pid:156091 tgid:1=
56091 ppid:155933 flags:0x00004002
> [ 4569.346300] Call Trace:
> [ 4569.346538]  <TASK>
> [ 4569.346746]  __schedule+0x3ec/0x15c0
> [ 4569.347097]  ? __schedule+0x3f4/0x15c0
> [ 4569.347440]  ? sysvec_call_function_single+0xe/0x90
> [ 4569.347905]  ? asm_sysvec_call_function_single+0x1a/0x20
> [ 4569.348401]  ? __pfx_dev_remove+0x10/0x10
> [ 4569.348779]  schedule+0x32/0xd0
> [ 4569.349079]  stop_sync_thread+0x136/0x1d0
> [ 4569.349465]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 4569.349965]  __md_stop_writes+0x15/0xe0
> [ 4569.350341]  md_stop_writes+0x29/0x40
> [ 4569.350698]  raid_postsuspend+0x53/0x60 [dm_raid]
> [ 4569.351159]  dm_table_postsuspend_targets+0x3d/0x60
> [ 4569.351627]  __dm_destroy+0x1c5/0x1e0
> [ 4569.351984]  dev_remove+0x11d/0x190
> [ 4569.352328]  ctl_ioctl+0x30e/0x5e0
> [ 4569.352659]  dm_ctl_ioctl+0xe/0x20
> [ 4569.352992]  __x64_sys_ioctl+0x94/0xd0
> [ 4569.353352]  do_syscall_64+0x86/0x170
> [ 4569.353703]  ? dm_ctl_ioctl+0xe/0x20
> [ 4569.354059]  ? syscall_exit_to_user_mode+0x89/0x230
> [ 4569.354517]  ? do_syscall_64+0x96/0x170
> [ 4569.354891]  ? exc_page_fault+0x7f/0x180
> [ 4569.355258]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> [ 4569.355744] RIP: 0033:0x7f49e5dbc13d
> [ 4569.356113] RSP: 002b:00007ffc365585f0 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [ 4569.356804] RAX: ffffffffffffffda RBX: 000055638c4932c0 RCX: 00007f49e=
5dbc13d
> [ 4569.357488] RDX: 000055638c493af0 RSI: 00000000c138fd04 RDI: 000000000=
0000003
> [ 4569.358140] RBP: 00007ffc36558640 R08: 00007f49e5fbc690 R09: 00007ffc3=
65584a8
> [ 4569.358783] R10: 00007f49e5fbb97d R11: 0000000000000246 R12: 00007f49e=
5fbb97d
> [ 4569.359442] R13: 000055638c493ba0 R14: 00007f49e5fbb97d R15: 00007f49e=
5fbb97d
> [ 4569.360090]  </TASK>

Hi Ben

I can reproduce this with 6.6 too. So it's not a regression by the
change (stop sync thread asynchronously). I'm trying to debug it and
find the root cause. In 6.8 with my patch set, the logs show it's
stuck at:
wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));

But raid5 conf->active_stripes is 0. So I'm still looking at why this
can happen.

Best Regards
Xiao
>
>
> >
> > I have run lvm2 regression test. There are 4 failed cases:
> > shell/dmsetup-integrity-keys.sh
> > shell/lvresize-fs-crypt.sh
> > shell/pvck-dump.sh
> > shell/select-report.sh
> >
> > Xiao Ni (4):
> >   Clear MD_RECOVERY_WAIT when stopping dmraid
> >   Set MD_RECOVERY_FROZEN before stop sync thread
> >   md: Missing decrease active_io for flush io
> >   Don't check crossing reshape when reshape hasn't started
> >
> >  drivers/md/dm-raid.c |  2 ++
> >  drivers/md/md.c      |  8 +++++++-
> >  drivers/md/raid5.c   | 22 ++++++++++------------
> >  3 files changed, 19 insertions(+), 13 deletions(-)
> >
> > --
> > 2.32.0 (Apple Git-132)
>

