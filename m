Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E0C1E231E
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 08:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745311268; cv=none; b=ZJ4QRWUADhRc6WkZZBBaaq3KF/5LHHBa35SNS28/WjC8FbRYJXl2NuRr88pRYjrLFoHiCp7O5OckNgOcnlXHyS4r6G/xMtFUFj/Xbj5Kcb5BI4AMhEK4T4Lc1gOnnBOjaLg2TCu/rTbkHxmKyM7YFwy/9UVygPz94LbqH5RV9Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745311268; c=relaxed/simple;
	bh=ATimva0p2lxdsYvqLXegqXx4xt3612FhNio4kpvYdyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XqryHjMFbq0UuGsfJGN+I64WdMRhyzrdWBKslfHqZaNwItky/JCxYCeuJ+9b9jZEQ49wC1JbnpzLZARm+27x050e4XJB8dubtfPvefxtI0Zp60e4wU1WtJgnj+OgPpCqEj3ZGleSp9AtJhyJWgM5UAbC1A5fLNN9SUBujr6AnuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Txh4oY3w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Txh4oY3w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745311264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRxnqZNawQU1P+T1gWFQnHZX8WwGHnjiWIS818As+GY=;
	b=Txh4oY3wQxfOQeq8cGhINRZzu7FVIAyNYwREqcGBdwdJpL9F2WMXhPzK/h47kYZBvDbB9k
	R+OYBY23uh/ssP/V2qieQnul4wACHkWjknDhPN5F4qrSjP+6SwEOeFvQ8RTA627QV+EhKi
	aLqVH7vJzmY1wcD7JxLT1o6izXFuItg=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-N_XjjXixPBqslUrvq59eQw-1; Tue, 22 Apr 2025 04:41:03 -0400
X-MC-Unique: N_XjjXixPBqslUrvq59eQw-1
X-Mimecast-MFC-AGG-ID: N_XjjXixPBqslUrvq59eQw_1745311262
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-54d6f933151so1401944e87.3
        for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 01:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745311262; x=1745916062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RRxnqZNawQU1P+T1gWFQnHZX8WwGHnjiWIS818As+GY=;
        b=wrHntRBUlxusvtTCv7f5VKf2QVVhUUpOFlBrYg7krxBr2i2C+3xIRDgYXAkAiTuVj/
         qyESyZS38alv1/in8RJvZyJqjfnczsiV4e05gaKd+1YuXLTWLgHoVmkpWpas1wcq+UxF
         IY1jluDFl5tDvwfEv+C8K0otTQd0BNNX6G3/gYgD9EMGc0NsfoNRRnz6mw1VR5oQib/t
         KvWwmiobyHNek21dpZgwZ9+y21tgacE14lMSTiflkLNeUVDkoZ4sMjgqinRHPd4JIWef
         NoTjw5K8ZxaBPZlA+IUA+M4c9cqBP5Cuuy5HdBaTcgCigmIfmqKlyuOPwRXQRSEOOq0+
         86bw==
X-Gm-Message-State: AOJu0YwPw/f5VMxGoVvBlq8F+H1PzdB4KS1i/dHDLaln7exx9oOXN6OY
	oytTn001S8FtljEGQ9UfyBWFucLelQoVFFib3SokfChwHk2m3XhX0mUUWaw0tuiD5PFN7pK1J6O
	DDmbWjvd0K7NKQ9mYXlKa12bEBMGvlX8DHWpp6qDkhA3gBWYS3GpkF/zD6Jql1TqWTbrr7OGWTG
	KFKcq6Ef/KhTgrm2zlvNKoZTOLnHtPdCSUxA==
X-Gm-Gg: ASbGnct2+z5SBjcPY4UiTaJXXMO3p74tLrSSXZ6IyBtXVe8X8SFt6EjNJlKrV0S6qWB
	/TtG2x9CNs0Q+lq3pm8qUKRCLxVS0Xh0FPhm87R33YUddmIAeP3TErpUHXihJ+/vEYh3+ww==
X-Received: by 2002:a05:6512:3a85:b0:549:91d3:8e66 with SMTP id 2adb3069b0e04-54d6e616de5mr3476428e87.8.1745311261593;
        Tue, 22 Apr 2025 01:41:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu8/x80qdpr3Hj82BRrhbwJ9Bktd2M77TB5AHHDP+SYk2Y2G8wGeTIEusFT9LMNbDyxTSI4M0d+6ymXomGBzU=
X-Received: by 2002:a05:6512:3a85:b0:549:91d3:8e66 with SMTP id
 2adb3069b0e04-54d6e616de5mr3476418e87.8.1745311261166; Tue, 22 Apr 2025
 01:41:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422032403.63057-1-xni@redhat.com> <20250422055108.GA29356@lst.de>
 <CALTww2-L_29Zpdf1VKQccO-O+=FSGErLakbj-dk4ZDpidr4_5A@mail.gmail.com>
In-Reply-To: <CALTww2-L_29Zpdf1VKQccO-O+=FSGErLakbj-dk4ZDpidr4_5A@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 16:40:48 +0800
X-Gm-Features: ATxdqUGYUiH5slNpi-jjRR3lgMSIapxEca2VAqmH6oyp4Ra1bLMPFaxVj-tsQ3Q
Message-ID: <CALTww28M91pMFhcZ3mY0AYirSnLL6vWSuWr1OE6ELU8oxu=Fkg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com, 
	ming.lei@redhat.com, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 4:31=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> On Tue, Apr 22, 2025 at 1:51=E2=80=AFPM Christoph Hellwig <hch@lst.de> wr=
ote:
> >
> > On Tue, Apr 22, 2025 at 11:24:03AM +0800, Xiao Ni wrote:
> > > Now del_gendisk and put_disk are called asynchronously in workqueue w=
ork.
> > > del_gendisk deletes device node by devtmpfs. devtmpfs tries to open t=
his
> > > array again and it flush the workqueue at the bigging of open process=
. So
> > > a deadlock happens.
> > >
> > > The asynchronous way also has a problem that the device node can stil=
l
> > > exist after mdadm --stop command returns in a short window. So udev r=
ule
> > > can open this device node and create the struct mddev in kernel again=
.
> > >
> > > So put del_gendisk in ioctl path and still leave put_disk in
> > > md_kobj_release to avoid uaf.
> >
> > The md lifetime rules are complicated enough as-is.  So while I won't
> > object to this change per-see I'd rather have it reviewed by the md
> > maintainers independently.
> >
> > In the meantime this should ensure devtmpfs doesn't call into
> > blkdev_get_no_open and thus put_disk:
> >
> > diff --git a/block/bdev.c b/block/bdev.c
> > index 6a34179192c9..97d4c0ab1670 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -1274,18 +1274,23 @@ void sync_bdevs(bool wait)
> >   */
> >  void bdev_statx(const struct path *path, struct kstat *stat, u32 reque=
st_mask)
> >  {
> > -       struct inode *backing_inode;
> >         struct block_device *bdev;
> >
> > -       backing_inode =3D d_backing_inode(path->dentry);
> > -
> >         /*
> > -        * Note that backing_inode is the inode of a block device node =
file,
> > -        * not the block device's internal inode.  Therefore it is *not=
* valid
> > -        * to use I_BDEV() here; the block device has to be looked up b=
y i_rdev
> > -        * instead.
> > +        * Note that d_backing_inode() returnsthe inode of a block devi=
ce node
> > +        * file, not the block device's internal inode.
> > +        *
> > +        * Therefore it is *not* valid to use I_BDEV() here; the block =
device
> > +        * has to be looked up by i_rdev instead.
> > +        *
> > +        * Only do this lookup if actually needed to avoid the performa=
nce
> > +        * overhead of the lookup, and to avoid injecting bdev lifetime=
 issues
> > +        * into devtmpfs.
> >          */
> > -       bdev =3D blkdev_get_no_open(backing_inode->i_rdev);
> > +       if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
> > +               return;
> > +
> > +       bdev =3D blkdev_get_no_open(d_backing_inode(path->dentry)->i_rd=
ev);
> >         if (!bdev)
> >                 return;
> >
> >
>
> Hi Christoph
>
> Thanks for the point. I tried this patch and it's stuck on the device
> mapper device during shutdown.

Sorry, please ignore the following error. I made a mistake when
building the kernel.

Regards
Xiao
>
> [  848.520483] systemd-shutdow[-- MARK -- Tue Apr 22 08:20:00 2025]
> [  989.175210] INFO: task systemd-shutdow:1 blocked for more than 122 sec=
onds.
> [  989.175667]       Not tainted 6.15.0-rc3+ #3
> [  989.176327] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  989.176728] task:systemd-shutdow state:D stack:0     pid:1
> tgid:1     ppid:0      task_flags:0x480100 flags:0x00004002
> [  989.177287] Call Trace:
> [  989.177429]  <TASK>
> [  989.177910]  __schedule+0x2c7/0x690
> [  989.178501]  schedule+0x23/0x80
> [  989.179265]  schedule_timeout+0xe8/0x100
> [  989.179488]  ? sched_clock_cpu+0xb/0x190
> [  989.179703]  ? __smp_call_single_queue+0xac/0x120
> [  989.180436]  ? ttwu_queue_wakelist+0xd0/0xf0
> [  989.181065]  __wait_for_common+0x99/0x1c0
> [  989.181287]  ? __pfx_schedule_timeout+0x10/0x10
> [  989.181935]  devtmpfs_submit_req+0x6e/0x90
> [  989.182154]  devtmpfs_delete_node+0x60/0x90
> [  989.182374]  ? kernfs_remove+0x5e/0x70
> [  989.182579]  ? sysfs_remove_group+0x46/0x90
> [  989.182787]  device_del+0x315/0x3d0
> [  989.183389]  ? mutex_lock+0xe/0x30
> [  989.183963]  del_gendisk+0x216/0x320
> [  989.184180]  cleanup_mapped_device+0x13f/0x150 [dm_mod]
> [  989.184502]  __dm_destroy+0x12e/0x1f0 [dm_mod]
> [  989.185162]  dev_remove+0x119/0x1a0 [dm_mod]
> [  989.185830]  ctl_ioctl+0x21c/0x370 [dm_mod]
> [  989.186090]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
> [  989.186325]  __x64_sys_ioctl+0x92/0xc0
> [  989.186533]  do_syscall_64+0x79/0x160
> [  989.186738]  ? blkg_alloc+0x10f/0x1c0
> [  989.186976]  ? __memcg_slab_free_hook+0xf2/0x140
> [  989.187616]  ? __x64_sys_close+0x39/0x80
> [  989.187836]  ? kmem_cache_free+0x33c/0x450
> [  989.188057]  ? syscall_exit_to_user_mode+0xc/0x1d0
> [  989.188696]  ? do_syscall_64+0x85/0x160
> [  989.188904]  ? __pfx_submit_bio_wait_endio+0x10/0x10
> [  989.189222]  ? blkdev_fsync+0x41/0x60
> [  989.189468]  ? syscall_exit_to_user_mode+0xc/0x1d0
> [  989.190096]  ? do_syscall_64+0x85/0x160
> [  989.190316]  ? do_sys_openat2+0x8c/0xd0
> [  989.190524]  ? syscall_exit_to_user_mode+0xc/0x1d0
> [  989.191160]  ? do_syscall_64+0x85/0x160
> [  989.191374]  ? syscall_exit_to_user_mode+0xc/0x1d0
> [  989.192001]  ? do_syscall_64+0x85/0x160
> [  989.192226]  ? do_syscall_64+0x85/0x160
> [  989.192434]  ? do_syscall_64+0x85/0x160
> [  989.192641]  ? syscall_exit_to_user_mode+0xc/0x1d0
> [  989.193287]  ? do_syscall_64+0x85/0x160
> [  989.193509]  ? do_syscall_64+0x85/0x160
> [  989.193719]  ? exc_page_fault+0x64/0x140
> [  989.2: 00000246 ORIG_RAX: 0000000000000010
> [  989.294592] RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007fef1=
3903b0b
> [  989.295388] RDX: 00007ffef60fbe50 RSI: 00000000c138fd04 RDI: 000000000=
0000005
> [  989.296153] RBP: 00007ffef60fbfc0 R08: 0000000000000000 R09: 00007ffef=
60fb190
> [  989.296936] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000=
0000005
> [  989.297708] R13: 0000000000000000 R14: 00007ffef60fbe10 R15: 000000000=
0000000
> [  989.298512]  </TASK>
> [  989.298700] INFO: task kdevtmpfs:506 blocked for more than 123 seconds=
.
> [  989.299139]       Not tainted 6.15.0-rc3+ #3
> [  989.299795] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  989.300279] task:kdevtmpfs       state:D stack:0     pid:506
> tgid:506   ppid:2      task_flags:0x208140 flags:0x00004000
> [  989.300837] Call Trace:
> [  989.300994]  <TASK>
> [  68/0x290
> [  989.701395]  ? __update_idle_core+0x23/0xb0
> [  989.701611]  devtmpfs_work_loop+0x10d/0x2a0
> [  989.701979]  ? __pfx_devtmpfsd+0x10/0x10
> [  989.700x10/0x10
> [  989.802290]  ret_from_fork+0x30/0x50
> [  989.802498]  ? __pfx_kthread+0x10/0x10
> [  989.802694]  ret_from_fork_asm+0x1a/0x30
> [  989.802926]  </TASK>
> [  989.803103] INFO: task kworker/38:1:586 blocked for more than 123 seco=
nds.
> [  989.803453]       Not tainted 6.15.0-rc3+ #3
>
>
> There is another reason that I want to put del_gendisk in the ioctl
> path. Because sometimes device node can still exist after command
> mdadm --stop. del_gendisk removes inode first and then removes device
> node (e.g. /dev/md0). So there is a small window that device node can
> be open again. Then some strange things happen. Sometimes the array is
> created but device node can't be created (I guess it's removed by
> devtempfs?). Sometimes the kernel message prints "block device
> autoloading is deprecated and will be removed".
>
> If your patch can work well, md array can call
> flush_workqueue(md_misc_wq) in do_md_stop to avoid the deadlock that
> del_gendisk needs to wait all sysfs calls to return.
>
>
> Regards
> Xiao
>
> Xiao

