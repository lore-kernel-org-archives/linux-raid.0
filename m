Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794378764;
	b=gSE6ivNVByQdqs+DjadBpUDygKmUoX2DH3b2L3N4/q+Yl8tdEhUQnNUpaz7V+Q2U7MZp
	 HPpQ/9YsufQ/BNhuzlH3zgkSW5ZwZ/Yg9ls6bEvUD7Y8xln3FVIIHLWSffy8AGB1beRJX
	 BtuD/x7OsTtrOkK1DncerZ9R7mnTZfy9UawTE8Y8eO1MWGbBXu637FAe0szHj7o82ZyRW
	 SuQ4rGdt0cj+/7hVqPR4hDGV0dtOsVcRHOJgBKS1RRLkMA4yGn80IIOYY+1f0y29q85Gs
	 TnJq+/zqPpqYNrbPXREyooKZQIbn9vmIOfbcsgvGQj5kiiA+/phWWX5ObfQv/k738Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794378764;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:X-Lms-Return-Path:
	 References:Message-Id:To:Cc:Subject:From:Mime-Version:Content-Type:
	 Date:In-Reply-To:Content-Transfer-Encoding;
	bh=PuwfvEnwqO0+M6GUOFtsXMZ8uJz8SZx/2buZdVxTArU=;
	b=kfntUZ+OkGweq02NNN6lvrZVeV4aXe8yqFunIi4hQ51vMOOeQRVt9aDlf3pB2eQ8sEsE
	 MRQt7gHXTpgIF1A+TPM71URqEI2tvpCQIipkGzMGhAjZgNCH1ScTkjfsW8N3/MprjFwoH
	 hwDvZpYUHm/Bmtjn9uNCTxTNqZdPDFmNHkBbXWzj6+ipuTmaeqWI2iwR7KYY+lzx8g9uz
	 k62fmW2r9v43SI/yYUS/t8Y0rsw8vXMGMF4bGtZiU2ZyWeegLxzo8lqYdSy82En/MKJ23
	 6DZ3b8LZdiRvpABS70PL7Z1bIT1POfxEBbmp9hHLSWgJ6T2fzdAEgYvDY91gxJSZUEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kaihong.com;
	spf=pass smtp.mailfrom=kaihong.com;
	arc=none smtp.remote-ip=115.124.28.121
Received: from out28-121.mail.aliyun.com (out28-121.mail.aliyun.com [115.124.28.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584D2606A320;
	Wed, 11 Nov 2026 06:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 584D2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaihong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaihong.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436259|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0289249-0.0145536-0.956522;FP=9760352779942500346|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033045099153;MF=wangjichen@kaihong.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.k.bVXEY_1794378749;
Received: from localhost(mailfrom:wangjichen@kaihong.com fp:SMTPD_---.k.bVXEY_1794378749 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 14:32:30 +0800
X-Lms-Return-Path: <lba+16af40bfb+923b9e+vger.kernel.org+wangjichen@kaihong.com>
References: <20261103115530.2913093-1-wangjichen@kaihong.com>
	<90fee426-1a0c-4964-bf20-8175a64917a4@fygo.io>
Message-Id: <8b878c802e81b6b8dc57299e05cbda9f3dc94e50.3c3928d4.e7a4.4b9f.86dd.da76b4f384c7@feishu.cn>
To: <yukuai@fygo.io>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>, 
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
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 14:32:26 +0800
In-Reply-To: <90fee426-1a0c-4964-bf20-8175a64917a4@fygo.io>
Content-Transfer-Encoding: quoted-printable


> From: "yu kuai"<yukuai@fygo.io>
> Date:=C2=A0 Sun, Nov 8, 2026, 11:18
> Subject:=C2=A0 Re: [PATCH] md: avoid block autoload while importing rdev =
under reconfig_mutex
> To: "Wang Jichen"<wangjichen@kaihong.com>, "Jens Axboe"<axboe@kernel.dk>,=
 "Song Liu"<song@kernel.org>, "Li Nan"<magiclinan@didiglobal.com>, "Xiao Ni=
"<xiao@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.kerne=
l.org>, <linux-raid@vger.kernel.org>, "yu kuai"<yukuai@fygo.io>
> Cc: <syzbot+cd254889291ef8666036@syzkaller.appspotmail.com>
> Hi,
>=C2=A0
> =E5=9C=A8 2026/11/3 19:55, Wang Jichen =E5=86=99=E9=81=93:
> > From: wangjichen <wangjichen@kaihong.com>
> >
> > md_import_device() runs with mddev->reconfig_mutex held from md_ioctl()=
.
> > Opening a member disk via bdev_file_open_by_dev() triggers legacy block
> > autoload (blk_probe_dev), which takes major_names_lock. md_probe() can
> > run under that lock and call md_alloc(), which takes disks_mutex and
> > reconfig_mutex =E2=80=94 a lockdep ABBA with the ioctl path.
>=C2=A0
> Is this a real deadlock? mddev is already existed from md_import_device()=
,
> while md_alloc() just allocate a new mddev, so the reconfig_mtuex is not
> the same.

Hi Kuai,

Thanks for the question.

You're right that md_ioctl() holds reconfig_mutex on the existing array
mddev, while md_alloc() takes reconfig_mutex on a newly allocated mddev =E2=
=80=94
they are different per-device mutex instances, not the same lock.

The syzbot/lockdep report is about a lock *class* cycle, not a
single-mddev self-deadlock. Lockdep treats all &mddev->reconfig_mutex as
one class, so the dependency it reports is:

=C2=A0 reconfig_mutex -> major_names_lock -> disks_mutex -> reconfig_mutex

Concrete race (syzbot extid cd254889291ef8666036, C repro on QEMU):

- Thread doing ADD_NEW_DISK on array A holds A's reconfig_mutex, then
=C2=A0 md_import_device() opens a member via bdev_file_open_by_dev(), which
=C2=A0 with legacy autoload calls blk_probe_dev() and takes major_names_loc=
k.

- Concurrent open of an unregistered md node takes major_names_lock in
=C2=A0 blk_probe_dev(), runs md_probe() -> md_alloc() for device B, takes
=C2=A0 disks_mutex, then B's reconfig_mutex.

Without lockdep, the same ABBA ordering between threads can still hang;
the syzbot report includes the standard CPU0/CPU1 "Possible unsafe
locking scenario" text for this chain.

For context on when reconfig_mutex entered the md_alloc() path: the cycle
became visible after the fix for the half-initialised kobj window:

=C2=A0 ca39f7502425 ("md: fix mddev->kobj lifetime")
=C2=A0 d1472ca2ca5d ("md: don't hand out the array before md_alloc() has ad=
ded
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 mddev->kobj")

The latter holds reconfig_mutex across add_disk() and kobject_add() so
ioctls wait instead of touching an uninitialised mddev->kobj (Fixes:
ca39f7502425). That closes the kobject race but completes this lockdep
ring with ioctl + legacy autoload on the other side.

This patch does not revert that behaviour. It only breaks the ioctl-side
edge by not triggering legacy block autoload while reconfig_mutex is
held: md_import_device() uses bdev_file_open_by_dev_autoload(..., false).
Member disks are expected to already exist for normal mdadmin usage; the
syz repro still gets -ENXIO for bogus minors, but on a fixed kernel there
is no lockdep warning (Tested with syzbot's C repro on QEMU, 6628e7d4
bzImage, before/after).

If maintainers prefer a block-layer approach instead (e.g. not calling
md probe callbacks under major_names_lock in blk_probe_dev()), I'm happy
to respin.

Thanks,
Jichen

>=C2=A0
> >
> > Add bdev_file_open_by_dev_autoload() and use autoload=3Dfalse from
> > md_import_device(); member devices must already be present in the
> > block layer (normal mdadmin usage).
> >
> > Link: https://syzbot.org/bug?extid=3Dcd254889291ef8666036
> > Reported-by: syzbot+cd254889291ef8666036@syzkaller.appspotmail.com
> > Tested-by: Wang Jichen <wangjichen@kaihong.com>
> > Signed-off-by: Wang Jichen <wangjichen@kaihong.com>
> > ---
> > =C2=A0 block/bdev.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 ++++++++++-=
--
> > =C2=A0 drivers/md/md.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A08 ++++++--
> > =C2=A0 include/linux/blkdev.h | =C2=A02 ++
> > =C2=A0 3 files changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/block/bdev.c b/block/bdev.c
> > index f20f91b31..e78936556 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -1076,8 +1076,8 @@ static unsigned blk_to_file_flags(blk_mode_t mode=
)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return flags;
> > =C2=A0 }
> > =C2=A0=C2=A0
> > -struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *h=
older,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_holder_o=
ps *hops)
> > +struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mode=
,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *holder, =
const struct blk_holder_ops *hops, bool autoload)
> > =C2=A0 {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct file *bdev_file;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct block_device *bdev;
> > @@ -1088,7 +1088,7 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk=
_mode_t mode, void *holder,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return E=
RR_PTR(ret);
> > =C2=A0=C2=A0
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev =3D blkdev_get_no_open(dev, true);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev =3D blkdev_get_no_open(dev, autoload)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!bdev)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return E=
RR_PTR(-ENXIO);
> > =C2=A0=C2=A0
> > @@ -1110,6 +1110,13 @@ struct file *bdev_file_open_by_dev(dev_t dev, bl=
k_mode_t mode, void *holder,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return bdev_file;
> > =C2=A0 }
> > +EXPORT_SYMBOL(bdev_file_open_by_dev_autoload);
> > +
> > +struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *h=
older,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_holder_o=
ps *hops)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0return bdev_file_open_by_dev_autoload(dev,=
 mode, holder, hops, true);
> > +}
> > =C2=A0 EXPORT_SYMBOL(bdev_file_open_by_dev);
> > =C2=A0=C2=A0
> > =C2=A0 struct file *bdev_file_open_by_path(const char *path, blk_mode_t=
 mode,
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 03e35386a..d3717e2e8 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3858,9 +3858,13 @@ static struct md_rdev *md_import_device(dev_t ne=
wdev, int super_format, int supe
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out=
_clear_rdev;
> > =C2=A0=C2=A0
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev->bdev_file =3D bdev_file_open_by_dev(=
newdev,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * md_ioctl() holds reconfig_mutex; legacy=
 autoload in bdev open takes
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * major_names_lock via blk_probe_dev() an=
d can deadlock with md_probe().
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev->bdev_file =3D bdev_file_open_by_dev_=
autoload(newdev,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 BLK_OPEN_READ | BLK_OPEN_WRITE,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0super_format =3D=3D -2 ? &claim_rdev : rdev, NULL);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0super_format =3D=3D -2 ? &claim_rdev : rdev, NULL, false);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(rdev->bdev_file)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_warn(=
"md: could not open device unknown-block(%u,%u).\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 MAJOR(newdev), MINOR(newdev));
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 0c2010230..e5121101a 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1699,6 +1699,8 @@ struct blk_holder_ops {
> > =C2=A0=C2=A0
> > =C2=A0 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, v=
oid *holder,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const st=
ruct blk_holder_ops *hops);
> > +struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mode=
,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *holder, =
const struct blk_holder_ops *hops, bool autoload);
> > =C2=A0 struct file *bdev_file_open_by_path(const char *path, blk_mode_t=
 mode,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *ho=
lder, const struct blk_holder_ops *hops);
> > =C2=A0 int bd_prepare_to_claim(struct block_device *bdev, void *holder,
>=C2=A0
> --=C2=A0
> Thanks,
> Kuai
>=C2=A0
