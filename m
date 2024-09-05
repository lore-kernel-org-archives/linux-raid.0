Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C699C10940
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725547572; cv=none; b=FJGjHWc1hNu2iUaOp9i3Tl71/hVkbE0KjkUsuL3J3c6nmmpGSyyhV0J9RcDk7n7dvjmG+RW7nZQr9G+9HYIJdMEUy/CgKEc/5vQo6hdabBCsHjmhzzuWL5pXgKF5do8ypdTJdLfCFLTI8uZCY8USN9wHyCcGb4e2MgG735orcLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725547572; c=relaxed/simple;
	bh=FHCfX16+BHCeOGeWyIuc4rUubIfc/6rcZC96HxDTPFA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ahcu3+2VWOOaZGh+i5Rt3uR4N8j8PgS5H2nU/pGi+y88Aa65BVVhQKZTTpsNMF7eT8beTUP1G41IAraSj4P6v4ox+/nGO9tTVYA1YnSisyeE62xbZ5jW1tHj+kYuki1rZf8WppESjrPsohNVD894jR43T+KBOjAvEbuVJyLH1eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FPWVmTz9; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPWVmTz9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725547571; x=1757083571;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FHCfX16+BHCeOGeWyIuc4rUubIfc/6rcZC96HxDTPFA=;
  b=FPWVmTz9u0vsq3IGPYMzWRWGHQXp3ONIt3APE8Q5ZLz6iIHHJZL/LeXc
   9sL2jrXKqJmDPez25wJQenuoKHiC+Lj0kdr5fdRuFt4adihCC9vOdFMhd
   2TmcUuz+HIhHXPeUg3PjwllcNaRlQKSTnfgX3spbGOCWLXLIyfY4AxX6x
   F9fy5WSsm7azhcQElzoHrgNpYjHSCXSogfx0Bt7XcjqVbWz2dtMBcS5iS
   M/LNPA4VluB5Ktq87h8jxbwZArZxwIj2gXrSYNeddHlZvNvw7vlgYiKsA
   J5LQSst1lUTahampqDKQSViyE92Lui/t++8sIHNZwOzDIt55uPn/ZuIAu
   A==;
X-CSE-ConnectionGUID: Ca2L2Y+2TiqXbk7Kb18CeQ==
X-CSE-MsgGUID: r8WILhBUT6m7FtBTpzVLgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="41774584"
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="41774584"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 07:46:10 -0700
X-CSE-ConnectionGUID: gaQyRvSJSiirMc4xaskSzA==
X-CSE-MsgGUID: tkhCCpdMTA6+T/DJ7oIegQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="70444188"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.245.81.98])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 07:46:07 -0700
Date: Thu, 5 Sep 2024 16:46:00 +0200
From: Kinga Stefaniuk <kinga.stefaniuk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, Kinga Stefaniuk <kinga.stefaniuk@intel.com>,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH md-6.12 v14 1/1] md: generate CHANGE uevents for md
 device
Message-ID: <20240905164600.000008ad@intel.linux.com>
In-Reply-To: <e6828f60-e5ae-5c11-1828-f6d75fbfddf7@huaweicloud.com>
References: <20240902083816.26099-1-kinga.stefaniuk@intel.com>
	<20240902083816.26099-2-kinga.stefaniuk@intel.com>
	<CAPhsuW4WTvtQrjusPfGy+C03iXigOdEANQezxqC1XxQ=h5KzBg@mail.gmail.com>
	<e6828f60-e5ae-5c11-1828-f6d75fbfddf7@huaweicloud.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Sep 2024 15:42:00 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
>=20
> =E5=9C=A8 2024/09/05 5:51, Song Liu =E5=86=99=E9=81=93:
> > On Mon, Sep 2, 2024 at 1:38=E2=80=AFAM Kinga Stefaniuk
> > <kinga.stefaniuk@intel.com> wrote: =20
> >>
> >> In mdadm commit 49b69533e8 ("mdmonitor: check if udev has finished
> >> events processing") mdmonitor has been learnt to wait for udev to
> >> finish processing, and later in commit 9935cf0f64f3 ("Mdmonitor:
> >> Improve udev event handling") pooling for MD events on
> >> /proc/mdstat file has been deprecated because relying on udev
> >> events is more reliable and less bug prone (we are not competing
> >> with udev).
> >>
> >> After those changes we are still observing missing mdmonitor
> >> events in some scenarios, especially SpareEvent is likely to be
> >> missed. With this patch MD will be able to generate more change
> >> uevents and wakeup mdmonitor more frequently to give it
> >> possibility to notice events. MD has md_new_events() functionality
> >> to trigger events and with this patch this function is extended to
> >> generate udev CHANGE uevents. It cannot be done directly because
> >> this function is called on interrupts context, so appropriate
> >> workqueue is created. Uevents are less time critical, it is safe
> >> to use workqueue. It is limited to CHANGE event as there is no
> >> need to generate other uevents for now. With this change,
> >> mdmonitor events are less likely to be missed. Our internal tests
> >> suite confirms that, mdmonitor reliability is (again) improved.
> >> Start using irq methods on all_mddevs_lock, because it can be
> >> reached by interrupt context.
> >>
> >> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> >> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com> =20
> >=20
> > I am seeing new failures from mdadm tests, for example, test
> > 01replace. Please run these tests and fix the issues. =20
>=20
> I just test this myself in my VM, I didn't see 01replace failed,
> howerver, test 13imsm-r0_r5_3d-grow-r0_r5_4d start to hang:
>=20
> [16098.862049] INFO: task systemd-udevd:57927 blocked for more than
> 368 seconds.^M
> [16098.863049]       Not tainted 6.11.0-rc1-00078-g761e5afb6ddb-dirty
> #362^M [16098.863802] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.^M
> [16098.865773] ^M
> [16098.865773] Showing all locks held in the system:^M
> [16098.866702] 1 lock held by khungtaskd/31:^M
> [16098.867233]  #0: ffffffff8a789b40 (rcu_read_lock){....}-{1:2}, at:=20
> debug_show_all_locks+0x46/0x320^M
> [16098.868589] 1 lock held by systemd-journal/203:^M
> [16098.869276] 1 lock held by systemd-udevd/57927:^M
> [16098.869966]  #0: ffff8881a61fa1a8=20
> (mapping.invalidate_lock#2){++++}-{3:3}, at:=20
> page_cache_ra_unbounded+0x73/0x2d0^M
> [16098.871477] 4 locks held by mdadm/58163:^M
> [16098.872099]  #0: ffff88817d4b4400 (sb_writers#5){.+.+}-{0:0}, at:=20
> vfs_write+0x32d/0x470^M
> [16098.873303]  #1: ffff888193dcd688 (&of->mutex#2){+.+.}-{3:3}, at:=20
> kernfs_fop_write_iter+0x143/0x280^M
> [16098.874620]  #2: ffff8881323cb010 (kn->active#98){.+.+}-{0:0}, at:=20
> kernfs_fop_write_iter+0x153/0x280^M
> [16098.876005]  #3: ffff888193d4a0a8=20
> (&mddev->suspend_mutex){+.+.}-{3:3}, at: mddev_suspend+0x59/0x380
> [md_mod]^M
>=20
> [root@fedora ~]# cat /proc/57927/stack
> [<0>] wait_woken+0xa4/0xd0
> [<0>] raid5_make_request+0x994/0x2080 [raid456]
> [<0>] md_handle_request+0x17a/0x4b0 [md_mod]
> [<0>] md_submit_bio+0x7c/0x130 [md_mod]
> [<0>] __submit_bio+0x12b/0x190
> [<0>] submit_bio_noacct_nocheck+0x22b/0x6a0
> [<0>] submit_bio_noacct+0x259/0xac0
> [<0>] submit_bio+0x58/0x1d0
> [<0>] mpage_readahead+0x195/0x280
> [<0>] blkdev_readahead+0x1d/0x30
> [<0>] read_pages+0x6e/0x550
> [<0>] page_cache_ra_unbounded+0x1c6/0x2d0
> [<0>] do_page_cache_ra+0x4f/0x80
> [<0>] force_page_cache_ra+0x78/0xc0
> [<0>] page_cache_sync_ra+0x60/0x460
> [<0>] filemap_get_pages+0x13f/0xba0
> [<0>] filemap_read+0x122/0x590
> [<0>] blkdev_read_iter+0x7a/0x210
> [<0>] vfs_read+0x27f/0x400
> [<0>] ksys_read+0x85/0x180
> [<0>] __x64_sys_read+0x21/0x30
> [<0>] x64_sys_call+0x45e7/0x4600
> [<0>] do_syscall_64+0xd5/0x230
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
> Does user space need to change as well?
>=20
> Thanks,
> Kuai
>=20
> >=20
> > Thanks,
> > Song
> >=20
> >=20
> > .
> >  =20
>=20
>=20

Hi

Thanks for your review. I rebased my patch to md-6.12 branch and met
the same symptoms as Kuai. I need to investigate it and will be back
with my findings or new patch version. Maybe there is a problem with
tests, because I can only reproduce it when I run all of the tests.
While running them one-by-one I don't see this problem.

Thanks,
Kinga
