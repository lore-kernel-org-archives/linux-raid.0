Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794561027;
	b=vpiWOgXTF/mKSlwOiRGS6DpV1pFRMfIhnUWbPgi8zqaimzSBdBdl+iZtUZqHfyjaRCwF
	 85PqFHOesUqJF0xcMIpL4Zf0mQptI0mwvtO6XueXbTJw+tBq0mBhJX1xC+F8a3c3rXk+m
	 40SCjuTv0s2MYJUUH5uGEJy2hWtY1rQ3uswcCOa2UgvC8UZC1FdVCdRnRwQimI0VTvELv
	 jZIKf28Ahn2j9zbsnlXxQUsS0sHz6g0qjYhwVGaFxPWTmdHyOkfZ0xFwQJ+skQJT3htqW
	 CFNHX2Yzis0yWDHMVDqmvh8uUV4zUw/zUQuxzC92BhBQdwANw/kCo1NJK5k/FYoW8TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794561027;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:X-Lms-Return-Path:
	 References:Content-Type:Content-Transfer-Encoding:Cc:Subject:From:
	 Mime-Version:In-Reply-To:Date:Message-Id:To;
	bh=JZv/8a6xlPqjgVv3t4ui4NZADMkXue+y2Bu/LqiLKuI=;
	b=O9+dtW/IMwaEXHk0gsXg438JDpv1nCjtdGy+7zpEykJlVg5UqBaVWHdUHpz85NERMnPo
	 /YkorxIoqd8vIG5IEjjHaUgE/gvVo5jbBay9hXcsBozAcHy65cKeSPUqg3wH46inuE8o/
	 U9eLAzn+iipiGsaitesq6hubn41aOOUMqHI/GA0x6KONLtvpKM7HCGFQcOj7UM7e9Skzf
	 ublwKMGW6zgYSNEaPqYJGSjLAsy3QWnIA0wG+3bu/TZ70NutqQh6g/T23FDFMXtYxeLmo
	 pZKtZFIqJyF7lS7fn8opNEZIsjq6jZlBdZke6Y4noHbfAMFj9xglRxw+QZ8f2XD87lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kaihong.com;
	spf=pass smtp.mailfrom=kaihong.com;
	arc=none smtp.remote-ip=115.124.28.147
Received: from out28-147.mail.aliyun.com (out28-147.mail.aliyun.com [115.124.28.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0798606A31C;
	Fri, 13 Nov 2026 09:10:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0798606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaihong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaihong.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436259|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0185699-0.0226055-0.958825;FP=14408058661728966394|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033071099199;MF=wangjichen@kaihong.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.k1AZD3M_1794561017;
Received: from localhost(mailfrom:wangjichen@kaihong.com fp:SMTPD_---.k1AZD3M_1794561017 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 17:10:18 +0800
X-Lms-Return-Path: <lba+16af6d3f3+2a1356+fygo.io+wangjichen@kaihong.com>
References: <20261103115530.2913093-1-wangjichen@kaihong.com> <90fee426-1a0c-4964-bf20-8175a64917a4@fygo.io> <8b878c802e81b6b8dc57299e05cbda9f3dc94e50.3c3928d4.e7a4.4b9f.86dd.da76b4f384c7@feishu.cn>
	<b9b085a3-b56e-41e3-b88c-2f1618c3835f@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: "yu kuai" <yukuai@fygo.io>, "Jens Axboe" <axboe@kernel.dk>, 
	"Song Liu" <song@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	"Xiao Ni" <xiao@kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>, 
	<syzbot+cd254889291ef8666036@syzkaller.appspotmail.com>
Subject: Re: [PATCH] md: avoid block autoload while importing rdev under reconfig_mutex
From: =?utf-8?q?=E7=8E=8B=E7=BB=A7=E6=99=A8?= <wangjichen@kaihong.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <b9b085a3-b56e-41e3-b88c-2f1618c3835f@fygo.io>
Date: Fri, 13 Nov 2026 17:10:10 +0800
Message-Id: <8b878c802e81b6b8dc57299e05cbda9f3dc94e50.422483e0.e2d5.4ed7.8248.226993ae6e49@feishu.cn>
To: <yukuai@fygo.io>


> From: "yu kuai"<yukuai@fygo.io>
> Date:=C2=A0 Wed, Nov 11, 2026, 18:38
> Subject:=C2=A0 Re: [PATCH] md: avoid block autoload while importing rdev =
under reconfig_mutex
> To: "=E7=8E=8B=E7=BB=A7=E6=99=A8"<wangjichen@kaihong.com>, "yu kuai"<yuku=
ai@fygo.io>
> Cc: "Jens Axboe"<axboe@kernel.dk>, "Song Liu"<song@kernel.org>, "Li Nan"<=
magiclinan@didiglobal.com>, "Xiao Ni"<xiao@kernel.org>, <linux-block@vger.k=
ernel.org>, <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>, <=
syzbot+cd254889291ef8666036@syzkaller.appspotmail.com>
> Hi,
>=C2=A0
> =E5=9C=A8 2026/11/11 14:32, =E7=8E=8B=E7=BB=A7=E6=99=A8 =E5=86=99=E9=81=
=93:
> >> From: "yu kuai"<yukuai@fygo.io>
> >> Date:=C2=A0 Sun, Nov 8, 2026, 11:18
> >> Subject:=C2=A0 Re: [PATCH] md: avoid block autoload while importing rd=
ev under reconfig_mutex
> >> To: "Wang Jichen"<wangjichen@kaihong.com>, "Jens Axboe"<axboe@kernel.d=
k>, "Song Liu"<song@kernel.org>, "Li Nan"<magiclinan@didiglobal.com>, "Xiao=
 Ni"<xiao@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.ke=
rnel.org>, <linux-raid@vger.kernel.org>, "yu kuai"<yukuai@fygo.io>
> >> Cc: <syzbot+cd254889291ef8666036@syzkaller.appspotmail.com>
> >> Hi,
> >> =C2=A0=C2=A0
> >> =E5=9C=A8 2026/11/3 19:55, Wang Jichen =E5=86=99=E9=81=93:
> >>> From: wangjichen <wangjichen@kaihong.com>
> >>>
> >>> md_import_device() runs with mddev->reconfig_mutex held from md_ioctl=
().
> >>> Opening a member disk via bdev_file_open_by_dev() triggers legacy blo=
ck
> >>> autoload (blk_probe_dev), which takes major_names_lock. md_probe() ca=
n
> >>> run under that lock and call md_alloc(), which takes disks_mutex and
> >>> reconfig_mutex =E2=80=94 a lockdep ABBA with the ioctl path.
> >> =C2=A0=C2=A0
> >> Is this a real deadlock? mddev is already existed from md_import_devic=
e(),
> >> while md_alloc() just allocate a new mddev, so the reconfig_mtuex is n=
ot
> >> the same.
> > Hi Kuai,
> >
> > Thanks for the question.
> >
> > You're right that md_ioctl() holds reconfig_mutex on the existing array
> > mddev, while md_alloc() takes reconfig_mutex on a newly allocated mddev=
 =E2=80=94
> > they are different per-device mutex instances, not the same lock.
> >
> > The syzbot/lockdep report is about a lock *class* cycle, not a
> > single-mddev self-deadlock. Lockdep treats all &mddev->reconfig_mutex a=
s
> > one class, so the dependency it reports is:
> >
> > =C2=A0=C2=A0 reconfig_mutex -> major_names_lock -> disks_mutex -> recon=
fig_mutex
> >
> > Concrete race (syzbot extid cd254889291ef8666036, C repro on QEMU):
> >
> > - Thread doing ADD_NEW_DISK on array A holds A's reconfig_mutex, then
> > =C2=A0=C2=A0 md_import_device() opens a member via bdev_file_open_by_de=
v(), which
> > =C2=A0=C2=A0 with legacy autoload calls blk_probe_dev() and takes major=
_names_lock.
> >
> > - Concurrent open of an unregistered md node takes major_names_lock in
> > =C2=A0=C2=A0 blk_probe_dev(), runs md_probe() -> md_alloc() for device =
B, takes
> > =C2=A0=C2=A0 disks_mutex, then B's reconfig_mutex.
> >
> > Without lockdep, the same ABBA ordering between threads can still hang;
> > the syzbot report includes the standard CPU0/CPU1 "Possible unsafe
> > locking scenario" text for this chain.
>=C2=A0
> I still don't understand how is the ABBA deadlock possible, md_alloc() ho=
ld
> reconfig_mutex before add_disk() and kobject_add() for mddev->kobj, there=
 is no
> concurrent context that can hold reconfig_mutex before md_alloc() hold it=
.
>=C2=A0
> >
> > For context on when reconfig_mutex entered the md_alloc() path: the cyc=
le
> > became visible after the fix for the half-initialised kobj window:
> >
> > =C2=A0=C2=A0 ca39f7502425 ("md: fix mddev->kobj lifetime")
> > =C2=A0=C2=A0 d1472ca2ca5d ("md: don't hand out the array before md_allo=
c() has added
> > =C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 mdde=
v->kobj")
> >
> > The latter holds reconfig_mutex across add_disk() and kobject_add() so
> > ioctls wait instead of touching an uninitialised mddev->kobj (Fixes:
> > ca39f7502425). That closes the kobject race but completes this lockdep
> > ring with ioctl + legacy autoload on the other side.
>=C2=A0
> For this test case, you can just use mddev private lockdep class to initi=
alize
> reconfig_mutex, or if there is still other lockdep wanings please attach =
the
> report.
>=C2=A0
Hi Kuai,
Thanks for the follow-up and for the suggestion to use a per-mddev lockdep
class for reconfig_mutex.
I implemented that on top of current mainline (same repro setup as before:
syzbot C repro cd254889 on QEMU, 6628e7d4-era config, CONFIG_LOCKDEP,
CONFIG_BLOCK_LEGACY_AUTOLOAD). In mddev_init() I use lockdep_register_key()
and mutex_init_with_key(&mddev->reconfig_mutex, &mddev->reconfig_lockdep_ke=
y),
with lockdep_unregister_key() in mddev_destroy(), following the pattern in
drivers/phy/phy-core.c.

With this change, the repro still reports a circular locking dependency (fu=
ll
report from guest dmesg below). The chain is still:
=C2=A0 disks_mutex --> &mddev->reconfig_mutex --> major_names_lock

The ioctl side still shows md_ioctl -> md_add_new_disk -> md_import_device =
->
bdev_file_open_by_dev -> blk_probe_dev under major_names_lock while ioctl
holds &mddev->reconfig_mutex. The concurrent side is md_probe -> md_alloc
trying to take disks_mutex while already under major_names_lock.

So in my testing, per-mddev reconfig lock classes alone do not silence this
particular syzbot repro; the reconfig -> major_names edge via legacy autolo=
ad
in md_import_device() remains. For comparison, my earlier patch that used
bdev_file_open_by_dev_autoload(..., false) from md_import_device() did not
trigger this WARNING on the same repro (QEMU, before/after on 6628e7d4 bzIm=
age).
Full lockdep report (dmesg excerpt from the repro run on the lockdep-class
tree):
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
7.4.0-rc1-00001-g2308e050e32d-dirty #2 Not tainted
------------------------------------------------------
repro/4976 is trying to acquire lock:
(disks_mutex){+.+.}-{4:4}, at: md_alloc+0x3e/0x1080
but task is already holding lock:
(major_names_lock){+.+.}-{4:4}, at: blk_probe_dev+0x25/0x190
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #2 (major_names_lock){+.+.}-{4:4}:
=C2=A0=C2=A0 =C2=A0 =C2=A0 lock_acquire+0x1bf/0x370
=C2=A0=C2=A0 =C2=A0 =C2=A0 __mutex_lock+0x173/0x1dd0
=C2=A0=C2=A0 =C2=A0 =C2=A0 blk_probe_dev+0x25/0x190
=C2=A0=C2=A0 =C2=A0 =C2=A0 blk_request_module+0x16/0xb0
=C2=A0=C2=A0 =C2=A0 =C2=A0 blkdev_get_no_open+0xa0/0x100
=C2=A0=C2=A0 =C2=A0 =C2=A0 bdev_file_open_by_dev+0x72/0x210
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_import_device+0x120/0x490
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_add_new_disk+0xa90/0x1ac0
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_ioctl+0x2a4e/0x3ba0
=C2=A0=C2=A0 =C2=A0 =C2=A0 blkdev_ioctl+0x366/0x6c0
=C2=A0=C2=A0 =C2=A0 =C2=A0 __x64_sys_ioctl+0x18f/0x210
=C2=A0=C2=A0 =C2=A0 =C2=A0 do_syscall_64+0x132/0x7e0
=C2=A0=C2=A0 =C2=A0 =C2=A0 entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&mddev->reconfig_mutex){+.+.}-{4:4}:
=C2=A0=C2=A0 =C2=A0 =C2=A0 lock_acquire+0x1bf/0x370
=C2=A0=C2=A0 =C2=A0 =C2=A0 __mutex_lock+0x173/0x1dd0
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_alloc+0x3cf/0x1080
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_alloc_and_put+0x17/0xe0
=C2=A0=C2=A0 =C2=A0 =C2=A0 add_named_array+0x23d/0x380
=C2=A0=C2=A0 =C2=A0 =C2=A0 param_attr_store+0x197/0x300
=C2=A0=C2=A0 =C2=A0 =C2=A0 module_attr_store+0x57/0x80
=C2=A0=C2=A0 =C2=A0 =C2=A0 sysfs_kf_write+0xef/0x150
=C2=A0=C2=A0 =C2=A0 =C2=A0 kernfs_fop_write_iter+0x397/0x580
=C2=A0=C2=A0 =C2=A0 =C2=A0 vfs_write+0xc1a/0x1150
=C2=A0=C2=A0 =C2=A0 =C2=A0 ksys_write+0x121/0x240
=C2=A0=C2=A0 =C2=A0 =C2=A0 do_syscall_64+0x132/0x7e0
=C2=A0=C2=A0 =C2=A0 =C2=A0 entry_SYSCALL_64_after_hwframe+0x77

-> #0 (disks_mutex){+.+.}-{4:4}:
=C2=A0=C2=A0 =C2=A0 =C2=A0 check_prev_add+0xeb/0xe60
=C2=A0=C2=A0 =C2=A0 =C2=A0 __lock_acquire+0x1661/0x2110
=C2=A0=C2=A0 =C2=A0 =C2=A0 lock_acquire+0x1bf/0x370
=C2=A0=C2=A0 =C2=A0 =C2=A0 __mutex_lock+0x173/0x1dd0
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_alloc+0x3e/0x1080
=C2=A0=C2=A0 =C2=A0 =C2=A0 md_probe+0x6d/0x100
=C2=A0=C2=A0 =C2=A0 =C2=A0 blk_probe_dev+0x116/0x190
=C2=A0=C2=A0 =C2=A0 =C2=A0 blk_request_module+0x16/0xb0
=C2=A0=C2=A0 =C2=A0 =C2=A0 blkdev_get_no_open+0xa0/0x100
=C2=A0=C2=A0 =C2=A0 =C2=A0 blkdev_open+0x143/0x500
=C2=A0=C2=A0 =C2=A0 =C2=A0 do_dentry_open+0x68e/0x14f0
=C2=A0=C2=A0 =C2=A0 =C2=A0 vfs_open_consume+0xcc/0x460
=C2=A0=C2=A0 =C2=A0 =C2=A0 path_openat+0x1c16/0x2240
=C2=A0=C2=A0 =C2=A0 =C2=A0 do_file_open+0x216/0x470
=C2=A0=C2=A0 =C2=A0 =C2=A0 do_sys_openat2+0x139/0x1d0
=C2=A0=C2=A0 =C2=A0 =C2=A0 __x64_sys_open+0x11c/0x1c0
=C2=A0=C2=A0 =C2=A0 =C2=A0 do_syscall_64+0x132/0x7e0
=C2=A0=C2=A0 =C2=A0 =C2=A0 entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:
=C2=A0Chain exists of:
=C2=A0=C2=A0 disks_mutex --> &mddev->reconfig_mutex --> major_names_lock
=C2=A0Possible unsafe locking scenario:
=C2=A0=C2=A0 =C2=A0 =C2=A0 CPU0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=C2=A0 CPU1
=C2=A0=C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=C2=A0 ----
=C2=A0 lock(major_names_lock);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock(&mddev->reconfig_mutex);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock(major_names_lock);
=C2=A0 lock(disks_mutex);
=C2=A0*** DEADLOCK ***
locks held by repro/4976: 1, last CPU#0:
=C2=A0#0: (major_names_lock){+.+.}-{4:4}, at: blk_probe_dev+0x25/0x190
stack backtrace:
=C2=A0CPU: 0 UID: 0 PID: 4976 Comm: repro Not tainted 7.4.0-rc1-00001-g2308=
e050e32d-dirty #2 PREEMPT(full)
=C2=A0Call Trace:
=C2=A0 dump_stack_lvl+0x116/0x1b0
=C2=A0 print_circular_bug+0x2e8/0x420
=C2=A0 check_noncircular+0x12d/0x150
=C2=A0 check_prev_add+0xeb/0xe60
=C2=A0 __lock_acquire+0x1661/0x2110
=C2=A0 lock_acquire+0x1bf/0x370
=C2=A0 __mutex_lock+0x173/0x1dd0
=C2=A0 md_alloc+0x3e/0x1080
=C2=A0 md_probe+0x6d/0x100
=C2=A0 blk_probe_dev+0x116/0x190
=C2=A0 blk_request_module+0x16/0xb0
=C2=A0 blkdev_get_no_open+0xa0/0x100
=C2=A0 blkdev_open+0x143/0x500
=C2=A0 do_dentry_open+0x68e/0x14f0
=C2=A0 vfs_open_consume+0xcc/0x460
=C2=A0 path_openat+0x1c16/0x2240
=C2=A0 do_file_open+0x216/0x470
=C2=A0do_sys_openat2+0x139/0x1d0
=C2=A0 __x64_sys_open+0x11c/0x1c0
=C2=A0 do_syscall_64+0x132/0x7e0
=C2=A0 entry_SYSCALL_64_after_hwframe+0x77/0x7f
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

How would you like to proceed?
- lockdep class only (accept remaining ordering warnings for this path), or
- also break the ioctl-side reconfig -> major_names link (e.g. no legacy
=C2=A0 autoload under reconfig_mutex, as in my earlier [PATCH]), or
- a block-layer change under major_names_lock, or something else?
I can send a revised patch on the list once you confirm which direction you
prefer. I am happy to drop or combine pieces of my earlier patch accordingl=
y.

Thanks,
Jichen

> >
> > This patch does not revert that behaviour. It only breaks the ioctl-sid=
e
> > edge by not triggering legacy block autoload while reconfig_mutex is
> > held: md_import_device() uses bdev_file_open_by_dev_autoload(..., false=
).
> > Member disks are expected to already exist for normal mdadmin usage; th=
e
> > syz repro still gets -ENXIO for bogus minors, but on a fixed kernel the=
re
> > is no lockdep warning (Tested with syzbot's C repro on QEMU, 6628e7d4
> > bzImage, before/after).
> >
> > If maintainers prefer a block-layer approach instead (e.g. not calling
> > md probe callbacks under major_names_lock in blk_probe_dev()), I'm happ=
y
> > to respin.
> >
> > Thanks,
> > Jichen
> >
> >> =C2=A0=C2=A0
> >>> Add bdev_file_open_by_dev_autoload() and use autoload=3Dfalse from
> >>> md_import_device(); member devices must already be present in the
> >>> block layer (normal mdadmin usage).
> >>>
> >>> Link: https://syzbot.org/bug?extid=3Dcd254889291ef8666036
> >>> Reported-by: syzbot+cd254889291ef8666036@syzkaller.appspotmail.com
> >>> Tested-by: Wang Jichen <wangjichen@kaihong.com>
> >>> Signed-off-by: Wang Jichen <wangjichen@kaihong.com>
> >>> ---
> >>> =C2=A0=C2=A0 block/bdev.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 +++=
+++++++---
> >>> =C2=A0=C2=A0 drivers/md/md.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A08 +++=
+++--
> >>> =C2=A0=C2=A0 include/linux/blkdev.h | =C2=A02 ++
> >>> =C2=A0=C2=A0 3 files changed, 18 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/block/bdev.c b/block/bdev.c
> >>> index f20f91b31..e78936556 100644
> >>> --- a/block/bdev.c
> >>> +++ b/block/bdev.c
> >>> @@ -1076,8 +1076,8 @@ static unsigned blk_to_file_flags(blk_mode_t mo=
de)
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return flags;
> >>> =C2=A0=C2=A0 }
> >>> =C2=A0 =C2=A0
> >>> -struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void =
*holder,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_holde=
r_ops *hops)
> >>> +struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mo=
de,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *holder=
, const struct blk_holder_ops *hops, bool autoload)
> >>> =C2=A0=C2=A0 {
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct file *bdev_file;
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct block_device *bdev;
> >>> @@ -1088,7 +1088,7 @@ struct file *bdev_file_open_by_dev(dev_t dev, b=
lk_mode_t mode, void *holder,
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
return ERR_PTR(ret);
> >>> =C2=A0 =C2=A0
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev =3D blkdev_get_no_open(dev, true);
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev =3D blkdev_get_no_open(dev, autoloa=
d);
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!bdev)
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
return ERR_PTR(-ENXIO);
> >>> =C2=A0 =C2=A0
> >>> @@ -1110,6 +1110,13 @@ struct file *bdev_file_open_by_dev(dev_t dev, =
blk_mode_t mode, void *holder,
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return bdev_file;
> >>> =C2=A0=C2=A0 }
> >>> +EXPORT_SYMBOL(bdev_file_open_by_dev_autoload);
> >>> +
> >>> +struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void =
*holder,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_holde=
r_ops *hops)
> >>> +{
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return bdev_file_open_by_dev_autoload(de=
v, mode, holder, hops, true);
> >>> +}
> >>> =C2=A0=C2=A0 EXPORT_SYMBOL(bdev_file_open_by_dev);
> >>> =C2=A0 =C2=A0
> >>> =C2=A0=C2=A0 struct file *bdev_file_open_by_path(const char *path, bl=
k_mode_t mode,
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index 03e35386a..d3717e2e8 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -3858,9 +3858,13 @@ static struct md_rdev *md_import_device(dev_t =
newdev, int super_format, int supe
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err)
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
goto out_clear_rdev;
> >>> =C2=A0 =C2=A0
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev->bdev_file =3D bdev_file_open_by_de=
v(newdev,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * md_ioctl() holds reconfig_mutex; lega=
cy autoload in bdev open takes
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * major_names_lock via blk_probe_dev() =
and can deadlock with md_probe().
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev->bdev_file =3D bdev_file_open_by_de=
v_autoload(newdev,
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BLK_OPEN_READ | BLK_OPEN_WRITE,
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0super_format =3D=3D -2 ? &claim_rdev : rdev, NULL);
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0super_format =3D=3D -2 ? &claim_rdev : rdev, NULL, false);
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(rdev->bdev_file))=
 {
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
pr_warn("md: could not open device unknown-block(%u,%u).\n",
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 MAJOR(newdev), MINOR(newdev));
> >>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>> index 0c2010230..e5121101a 100644
> >>> --- a/include/linux/blkdev.h
> >>> +++ b/include/linux/blkdev.h
> >>> @@ -1699,6 +1699,8 @@ struct blk_holder_ops {
> >>> =C2=A0 =C2=A0
> >>> =C2=A0=C2=A0 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t=
 mode, void *holder,
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
const struct blk_holder_ops *hops);
> >>> +struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mo=
de,
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *holder=
, const struct blk_holder_ops *hops, bool autoload);
> >>> =C2=A0=C2=A0 struct file *bdev_file_open_by_path(const char *path, bl=
k_mode_t mode,
> >>> =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
void *holder, const struct blk_holder_ops *hops);
> >>> =C2=A0=C2=A0 int bd_prepare_to_claim(struct block_device *bdev, void =
*holder,
> >> =C2=A0=C2=A0
> >> --=C2=A0
> >> Thanks,
> >> Kuai
> >> =C2=A0=C2=A0
>=C2=A0
> --=C2=A0
> Thanks,
> Kuai
>=C2=A0
