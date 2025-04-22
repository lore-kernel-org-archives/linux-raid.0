Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F281256C90
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 08:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310738; cv=none; b=DFJ5WEBQvFd9uiTil/aL+jw9ro4uYGauHvhsV5fVubIkZthv//vKZ+IVG6CRx24vhwDPN5AsomQW925faVkqAmNes6tYyarz3AhmPFRfskmNUygvlhxfusnrRLBLXWFd5YQPqlYWGo+6jz1kIxq/kYq2+MA7U2tnAXedxQRz8fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310738; c=relaxed/simple;
	bh=TxFPDJuX0XO5VWDAUf4zL8CX0rnJKowVfXGYJJx67Vg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GPrZDi0RtQ2xEEU4HvPn9nOyNenypETAPq0Up5lHi42yS5afHVmnX0+KEoPYXscaUF+Kpbh6fJ2PgZOo6AVgU887ZbFgxF1mVSMWoc/LSBkojDbxhQQgxZeC+f8P+Psg9TmRfShQ3YYSgWxWTVze2zErtwOrLC29OYGnwrEThoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MxO6T0wj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MxO6T0wj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745310734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4lQEL87i9ZMb4NmBNEQaFIRHquYcmMoJI5y0Wygtr+Q=;
	b=MxO6T0wjQyVgmLUIJP+YFmikumLa4DwyPHi8DMK/rEJeJmr5sSqzdsLe+9Msidicdfpw+g
	FzqBLPhaU0Rnz2Znohd/89xC7lod8pBoU/YlW6DOWuz6HABroOTjqe9SLihVqAm/LuBvze
	3NeL/n6+hqEuM7Suk8vxcGSuo1YDpqs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-4eslUB3zNBuuwqQGCEaVaw-1; Tue, 22 Apr 2025 04:32:13 -0400
X-MC-Unique: 4eslUB3zNBuuwqQGCEaVaw-1
X-Mimecast-MFC-AGG-ID: 4eslUB3zNBuuwqQGCEaVaw_1745310732
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-54991f28058so1780028e87.3
        for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 01:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745310731; x=1745915531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4lQEL87i9ZMb4NmBNEQaFIRHquYcmMoJI5y0Wygtr+Q=;
        b=SUvqmVj5HXupe/szAw9dR1Bh17ByUCCXxXVfOi1aGBN7DTpx5OKeJhmQwRCJi33KBo
         xmE/56Kw+8HyCV2QxpQqt9gv+VVQxiGzNJmXQM/vFMLcsxfhsqwI3JWng5m78iETZgla
         Xp+0bRD/aXPK2x4y/iPDu5FbnjeO88jvX/VvAoLgG+q65BwRgPiHOOfkeSPYnDiaseZR
         8QWQMjzNtp80fbbcDa10h5Dl61lLUZNVeqBUC/2vksXmL0yuF0DqNkVBErGfxGiW3Bzv
         wIWaO7gLv7RuLNK7FLdN6cZtu8LliV7Bo9CFAVm4mzNn5k4UF+zfOrgapXo95UunfSeK
         Yd1w==
X-Gm-Message-State: AOJu0Yy+JqDboao7CtV+Xi4LQz6HsSdTAY0N5CD6q4hNeHWNWLQmeVVG
	TII598E9QjjTRgQweuuWozvyIQnFX6v8lcemVFU7IthzN2yFsZ7+RJT9jguwCB74lK8RNeqP3Jl
	Hr1k+lYk6xz2cD2VmuFVL+YFPu8IDxgApbLFS3IBryV6zLAqkzou579XhKJU8PcwVxPL0J7Gr2d
	vpvejn5BRHmgsKtOF7ZmdnGFloAGqCvECq6D5jNHfLgss1TeY=
X-Gm-Gg: ASbGncsAfTx18PrUaE0ZjQPw2fE+daoxf5Nz+XWBlEKnPH1ap3L44urICmEHpDFkaKM
	xXESfqc2HixZIuXKZc06S5RcMUesAJFUPzp5v6oqcpuy8pDngMxXT6Ip2JJLeE6QcB8v73A==
X-Received: by 2002:a05:6512:108b:b0:549:9044:94b3 with SMTP id 2adb3069b0e04-54d6e632edcmr3219616e87.29.1745310730864;
        Tue, 22 Apr 2025 01:32:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTBJBelX3dbmGEip3HFgZqy7rMkQsjPYMYMKBz72N0/+0KcpyMWscnnP5o97g+CGoJHSujaqmgTlfYzTTZxqk=
X-Received: by 2002:a05:6512:108b:b0:549:9044:94b3 with SMTP id
 2adb3069b0e04-54d6e632edcmr3219607e87.29.1745310730420; Tue, 22 Apr 2025
 01:32:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422032403.63057-1-xni@redhat.com> <20250422055108.GA29356@lst.de>
In-Reply-To: <20250422055108.GA29356@lst.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 16:31:57 +0800
X-Gm-Features: ATxdqUHWcgJNU-f7Ano0WCiL-pCLN_C0XiwbZmNusQYWdF-N5S3IRPqW2m5Ea20
Message-ID: <CALTww2-L_29Zpdf1VKQccO-O+=FSGErLakbj-dk4ZDpidr4_5A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com, 
	ming.lei@redhat.com, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 1:51=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Tue, Apr 22, 2025 at 11:24:03AM +0800, Xiao Ni wrote:
> > Now del_gendisk and put_disk are called asynchronously in workqueue wor=
k.
> > del_gendisk deletes device node by devtmpfs. devtmpfs tries to open thi=
s
> > array again and it flush the workqueue at the bigging of open process. =
So
> > a deadlock happens.
> >
> > The asynchronous way also has a problem that the device node can still
> > exist after mdadm --stop command returns in a short window. So udev rul=
e
> > can open this device node and create the struct mddev in kernel again.
> >
> > So put del_gendisk in ioctl path and still leave put_disk in
> > md_kobj_release to avoid uaf.
>
> The md lifetime rules are complicated enough as-is.  So while I won't
> object to this change per-see I'd rather have it reviewed by the md
> maintainers independently.
>
> In the meantime this should ensure devtmpfs doesn't call into
> blkdev_get_no_open and thus put_disk:
>
> diff --git a/block/bdev.c b/block/bdev.c
> index 6a34179192c9..97d4c0ab1670 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -1274,18 +1274,23 @@ void sync_bdevs(bool wait)
>   */
>  void bdev_statx(const struct path *path, struct kstat *stat, u32 request=
_mask)
>  {
> -       struct inode *backing_inode;
>         struct block_device *bdev;
>
> -       backing_inode =3D d_backing_inode(path->dentry);
> -
>         /*
> -        * Note that backing_inode is the inode of a block device node fi=
le,
> -        * not the block device's internal inode.  Therefore it is *not* =
valid
> -        * to use I_BDEV() here; the block device has to be looked up by =
i_rdev
> -        * instead.
> +        * Note that d_backing_inode() returnsthe inode of a block device=
 node
> +        * file, not the block device's internal inode.
> +        *
> +        * Therefore it is *not* valid to use I_BDEV() here; the block de=
vice
> +        * has to be looked up by i_rdev instead.
> +        *
> +        * Only do this lookup if actually needed to avoid the performanc=
e
> +        * overhead of the lookup, and to avoid injecting bdev lifetime i=
ssues
> +        * into devtmpfs.
>          */
> -       bdev =3D blkdev_get_no_open(backing_inode->i_rdev);
> +       if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
> +               return;
> +
> +       bdev =3D blkdev_get_no_open(d_backing_inode(path->dentry)->i_rdev=
);
>         if (!bdev)
>                 return;
>
>

Hi Christoph

Thanks for the point. I tried this patch and it's stuck on the device
mapper device during shutdown.

[  848.520483] systemd-shutdow[-- MARK -- Tue Apr 22 08:20:00 2025]
[  989.175210] INFO: task systemd-shutdow:1 blocked for more than 122 secon=
ds.
[  989.175667]       Not tainted 6.15.0-rc3+ #3
[  989.176327] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  989.176728] task:systemd-shutdow state:D stack:0     pid:1
tgid:1     ppid:0      task_flags:0x480100 flags:0x00004002
[  989.177287] Call Trace:
[  989.177429]  <TASK>
[  989.177910]  __schedule+0x2c7/0x690
[  989.178501]  schedule+0x23/0x80
[  989.179265]  schedule_timeout+0xe8/0x100
[  989.179488]  ? sched_clock_cpu+0xb/0x190
[  989.179703]  ? __smp_call_single_queue+0xac/0x120
[  989.180436]  ? ttwu_queue_wakelist+0xd0/0xf0
[  989.181065]  __wait_for_common+0x99/0x1c0
[  989.181287]  ? __pfx_schedule_timeout+0x10/0x10
[  989.181935]  devtmpfs_submit_req+0x6e/0x90
[  989.182154]  devtmpfs_delete_node+0x60/0x90
[  989.182374]  ? kernfs_remove+0x5e/0x70
[  989.182579]  ? sysfs_remove_group+0x46/0x90
[  989.182787]  device_del+0x315/0x3d0
[  989.183389]  ? mutex_lock+0xe/0x30
[  989.183963]  del_gendisk+0x216/0x320
[  989.184180]  cleanup_mapped_device+0x13f/0x150 [dm_mod]
[  989.184502]  __dm_destroy+0x12e/0x1f0 [dm_mod]
[  989.185162]  dev_remove+0x119/0x1a0 [dm_mod]
[  989.185830]  ctl_ioctl+0x21c/0x370 [dm_mod]
[  989.186090]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
[  989.186325]  __x64_sys_ioctl+0x92/0xc0
[  989.186533]  do_syscall_64+0x79/0x160
[  989.186738]  ? blkg_alloc+0x10f/0x1c0
[  989.186976]  ? __memcg_slab_free_hook+0xf2/0x140
[  989.187616]  ? __x64_sys_close+0x39/0x80
[  989.187836]  ? kmem_cache_free+0x33c/0x450
[  989.188057]  ? syscall_exit_to_user_mode+0xc/0x1d0
[  989.188696]  ? do_syscall_64+0x85/0x160
[  989.188904]  ? __pfx_submit_bio_wait_endio+0x10/0x10
[  989.189222]  ? blkdev_fsync+0x41/0x60
[  989.189468]  ? syscall_exit_to_user_mode+0xc/0x1d0
[  989.190096]  ? do_syscall_64+0x85/0x160
[  989.190316]  ? do_sys_openat2+0x8c/0xd0
[  989.190524]  ? syscall_exit_to_user_mode+0xc/0x1d0
[  989.191160]  ? do_syscall_64+0x85/0x160
[  989.191374]  ? syscall_exit_to_user_mode+0xc/0x1d0
[  989.192001]  ? do_syscall_64+0x85/0x160
[  989.192226]  ? do_syscall_64+0x85/0x160
[  989.192434]  ? do_syscall_64+0x85/0x160
[  989.192641]  ? syscall_exit_to_user_mode+0xc/0x1d0
[  989.193287]  ? do_syscall_64+0x85/0x160
[  989.193509]  ? do_syscall_64+0x85/0x160
[  989.193719]  ? exc_page_fault+0x64/0x140
[  989.2: 00000246 ORIG_RAX: 0000000000000010
[  989.294592] RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007fef139=
03b0b
[  989.295388] RDX: 00007ffef60fbe50 RSI: 00000000c138fd04 RDI: 00000000000=
00005
[  989.296153] RBP: 00007ffef60fbfc0 R08: 0000000000000000 R09: 00007ffef60=
fb190
[  989.296936] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00005
[  989.297708] R13: 0000000000000000 R14: 00007ffef60fbe10 R15: 00000000000=
00000
[  989.298512]  </TASK>
[  989.298700] INFO: task kdevtmpfs:506 blocked for more than 123 seconds.
[  989.299139]       Not tainted 6.15.0-rc3+ #3
[  989.299795] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  989.300279] task:kdevtmpfs       state:D stack:0     pid:506
tgid:506   ppid:2      task_flags:0x208140 flags:0x00004000
[  989.300837] Call Trace:
[  989.300994]  <TASK>
[  68/0x290
[  989.701395]  ? __update_idle_core+0x23/0xb0
[  989.701611]  devtmpfs_work_loop+0x10d/0x2a0
[  989.701979]  ? __pfx_devtmpfsd+0x10/0x10
[  989.700x10/0x10
[  989.802290]  ret_from_fork+0x30/0x50
[  989.802498]  ? __pfx_kthread+0x10/0x10
[  989.802694]  ret_from_fork_asm+0x1a/0x30
[  989.802926]  </TASK>
[  989.803103] INFO: task kworker/38:1:586 blocked for more than 123 second=
s.
[  989.803453]       Not tainted 6.15.0-rc3+ #3


There is another reason that I want to put del_gendisk in the ioctl
path. Because sometimes device node can still exist after command
mdadm --stop. del_gendisk removes inode first and then removes device
node (e.g. /dev/md0). So there is a small window that device node can
be open again. Then some strange things happen. Sometimes the array is
created but device node can't be created (I guess it's removed by
devtempfs?). Sometimes the kernel message prints "block device
autoloading is deprecated and will be removed".

If your patch can work well, md array can call
flush_workqueue(md_misc_wq) in do_md_stop to avoid the deadlock that
del_gendisk needs to wait all sysfs calls to return.


Regards
Xiao

Xiao

