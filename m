Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794393455;
	b=Q4upIZKjzIIyL0WEN/RIC6ZkY+i+m3bIW7xTBAs9HEyt9lBRAMKL2P/r/gZ0zHApPWuK
	 F8ghHvUGbDVoCt2wfd+YgI6m/3j1MNMHPjHjdTW9q4K+tqR/zL1uzUKH4RuoF4s2X7LC6
	 HbKl0weY+kLADsj64/VHV3knhR+3F8ub38WwjykRvx+y2T4KAbmeeJCnVXxqiiq5m7rFP
	 gCHQTBpdSqLc9DgMP7Jp3AjDZRfjogOhCF2jY/g2NyGCQPmkY2E88aVnhT6GNsNwROBws
	 PYPZ1Eq0mOu5dpe0gNTGrOqZL6pL0UzKkyXqNM2ysA1a7MUYN/Q9Exw5E2WQ2R+72Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794393455;
	h=DMARC-Filter:DKIM-Signature:Reply-To:To:Message-Id:Content-Type:
	 Received:Mime-Version:Content-Transfer-Encoding:In-Reply-To:
	 References:Cc:Subject:Date:User-Agent:From:X-Original-From:
	 X-Lms-Return-Path;
	bh=aNSRDIHMfArUzsdQdb8aFfjRjsd0lZAoJPAwWQjeJEQ=;
	b=T5uWeedKIBSLG6s+sZ8m4s8mq8AXH1APWy1v/IqsUx5v4gZwTOnqeQVN4jDI+luGfrEi
	 IptEA01QpmcW94rx6XPgEyL8SRETwP9MEdZKbIW9TKNBemdDFv5PK3pR5ufhTr4+PHF+D
	 vbysu7AHymzJWqePfM51mY/AJdTsiCe5ILi5Z9BrOXl7zH01570t3lXLKnW2YTHfNuBEH
	 JVGAcH6sqInFcFnEX22LCo7/afcCIBIIkXiGpc/YE8f6lTsB274ikUZCBx/zt7EMQPzH8
	 rceVkH2wGYrWQ8FndQ/w1AxfE9GFCROBM3jLCJ97bmxIBUf+V9FEPgO6sieW+cS74Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=OUCNqEDu;
	arc=none smtp.remote-ip=209.127.231.16
Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB639606A326
	for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2026 10:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB639606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=OUCNqEDu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794393445;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aNSRDIHMfArUzsdQdb8aFfjRjsd0lZAoJPAwWQjeJEQ=;
 b=OUCNqEDuQgKhmFpLzuNkvwQ+BkPHWtpEkA9yahNyrhsYIBFSJ6Kh5BDM2V3600QUfIIgXq
 swBV2Mtv5nRWEG/ma3UY1SCtuewMwWGOzWuBbZH/VnoaxDtnm+B1GWMxO/j5XrJnRLU1i7
 Xe5Zs7itOzJ3kFNqjEWlN3WCAHoBxwsx+F6PRQScuf4Nmtq0KeP4rQ/0C5N3vldLnbc++h
 Xu0LUEugIYzSVO1X2MqM7uXXhKA7YAm21TqSqF+fNW6N7Qs6o9gg5iYlkqTC0L9qwrNB7c
 b3q/4XhzJycZW3uMd/SQVOslLG/Vcia8n5cRqCloOLEooYg+Ne6RJu6YfgX6Xw==
Reply-To: yukuai@fygo.io
To: =?utf-8?q?=E7=8E=8B=E7=BB=A7=E6=99=A8?= <wangjichen@kaihong.com>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <b9b085a3-b56e-41e3-b88c-2f1618c3835f@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Wed, 11 Nov 2026 10:37:23 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8b878c802e81b6b8dc57299e05cbda9f3dc94e50.3c3928d4.e7a4.4b9f.86dd.da76b4f384c7@feishu.cn>
References: <20261103115530.2913093-1-wangjichen@kaihong.com> <90fee426-1a0c-4964-bf20-8175a64917a4@fygo.io> <8b878c802e81b6b8dc57299e05cbda9f3dc94e50.3c3928d4.e7a4.4b9f.86dd.da76b4f384c7@feishu.cn>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, 
	<syzbot+cd254889291ef8666036@syzkaller.appspotmail.com>
Subject: Re: [PATCH] md: avoid block autoload while importing rdev under reconfig_mutex
Date: Wed, 11 Nov 2026 18:37:19 +0800
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26af44564+72bb16+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/11 14:32, =E7=8E=8B=E7=BB=A7=E6=99=A8 =E5=86=99=E9=81=93:
>> From: "yu kuai"<yukuai@fygo.io>
>> Date:=C2=A0 Sun, Nov 8, 2026, 11:18
>> Subject:=C2=A0 Re: [PATCH] md: avoid block autoload while importing rdev=
 under reconfig_mutex
>> To: "Wang Jichen"<wangjichen@kaihong.com>, "Jens Axboe"<axboe@kernel.dk>=
, "Song Liu"<song@kernel.org>, "Li Nan"<magiclinan@didiglobal.com>, "Xiao N=
i"<xiao@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.kern=
el.org>, <linux-raid@vger.kernel.org>, "yu kuai"<yukuai@fygo.io>
>> Cc: <syzbot+cd254889291ef8666036@syzkaller.appspotmail.com>
>> Hi,
>>  =20
>> =E5=9C=A8 2026/11/3 19:55, Wang Jichen =E5=86=99=E9=81=93:
>>> From: wangjichen <wangjichen@kaihong.com>
>>>
>>> md_import_device() runs with mddev->reconfig_mutex held from md_ioctl()=
.
>>> Opening a member disk via bdev_file_open_by_dev() triggers legacy block
>>> autoload (blk_probe_dev), which takes major_names_lock. md_probe() can
>>> run under that lock and call md_alloc(), which takes disks_mutex and
>>> reconfig_mutex =E2=80=94 a lockdep ABBA with the ioctl path.
>>  =20
>> Is this a real deadlock? mddev is already existed from md_import_device(=
),
>> while md_alloc() just allocate a new mddev, so the reconfig_mtuex is not
>> the same.
> Hi Kuai,
>
> Thanks for the question.
>
> You're right that md_ioctl() holds reconfig_mutex on the existing array
> mddev, while md_alloc() takes reconfig_mutex on a newly allocated mddev =
=E2=80=94
> they are different per-device mutex instances, not the same lock.
>
> The syzbot/lockdep report is about a lock *class* cycle, not a
> single-mddev self-deadlock. Lockdep treats all &mddev->reconfig_mutex as
> one class, so the dependency it reports is:
>
>  =C2=A0 reconfig_mutex -> major_names_lock -> disks_mutex -> reconfig_mut=
ex
>
> Concrete race (syzbot extid cd254889291ef8666036, C repro on QEMU):
>
> - Thread doing ADD_NEW_DISK on array A holds A's reconfig_mutex, then
>  =C2=A0 md_import_device() opens a member via bdev_file_open_by_dev(), wh=
ich
>  =C2=A0 with legacy autoload calls blk_probe_dev() and takes major_names_=
lock.
>
> - Concurrent open of an unregistered md node takes major_names_lock in
>  =C2=A0 blk_probe_dev(), runs md_probe() -> md_alloc() for device B, take=
s
>  =C2=A0 disks_mutex, then B's reconfig_mutex.
>
> Without lockdep, the same ABBA ordering between threads can still hang;
> the syzbot report includes the standard CPU0/CPU1 "Possible unsafe
> locking scenario" text for this chain.

I still don't understand how is the ABBA deadlock possible, md_alloc() hold
reconfig_mutex before add_disk() and kobject_add() for mddev->kobj, there i=
s no
concurrent context that can hold reconfig_mutex before md_alloc() hold it.

>
> For context on when reconfig_mutex entered the md_alloc() path: the cycle
> became visible after the fix for the half-initialised kobj window:
>
>  =C2=A0 ca39f7502425 ("md: fix mddev->kobj lifetime")
>  =C2=A0 d1472ca2ca5d ("md: don't hand out the array before md_alloc() has=
 added
>  =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 mddev->kobj=
")
>
> The latter holds reconfig_mutex across add_disk() and kobject_add() so
> ioctls wait instead of touching an uninitialised mddev->kobj (Fixes:
> ca39f7502425). That closes the kobject race but completes this lockdep
> ring with ioctl + legacy autoload on the other side.

For this test case, you can just use mddev private lockdep class to initial=
ize
reconfig_mutex, or if there is still other lockdep wanings please attach th=
e
report.

>
> This patch does not revert that behaviour. It only breaks the ioctl-side
> edge by not triggering legacy block autoload while reconfig_mutex is
> held: md_import_device() uses bdev_file_open_by_dev_autoload(..., false).
> Member disks are expected to already exist for normal mdadmin usage; the
> syz repro still gets -ENXIO for bogus minors, but on a fixed kernel there
> is no lockdep warning (Tested with syzbot's C repro on QEMU, 6628e7d4
> bzImage, before/after).
>
> If maintainers prefer a block-layer approach instead (e.g. not calling
> md probe callbacks under major_names_lock in blk_probe_dev()), I'm happy
> to respin.
>
> Thanks,
> Jichen
>
>>  =20
>>> Add bdev_file_open_by_dev_autoload() and use autoload=3Dfalse from
>>> md_import_device(); member devices must already be present in the
>>> block layer (normal mdadmin usage).
>>>
>>> Link: https://syzbot.org/bug?extid=3Dcd254889291ef8666036
>>> Reported-by: syzbot+cd254889291ef8666036@syzkaller.appspotmail.com
>>> Tested-by: Wang Jichen <wangjichen@kaihong.com>
>>> Signed-off-by: Wang Jichen <wangjichen@kaihong.com>
>>> ---
>>>  =C2=A0 block/bdev.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 ++++++++++=
---
>>>  =C2=A0 drivers/md/md.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A08 ++++++--
>>>  =C2=A0 include/linux/blkdev.h | =C2=A02 ++
>>>  =C2=A0 3 files changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/block/bdev.c b/block/bdev.c
>>> index f20f91b31..e78936556 100644
>>> --- a/block/bdev.c
>>> +++ b/block/bdev.c
>>> @@ -1076,8 +1076,8 @@ static unsigned blk_to_file_flags(blk_mode_t mode=
)
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return flags;
>>>  =C2=A0 }
>>>   =20
>>> -struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *h=
older,
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_holder_o=
ps *hops)
>>> +struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mode=
,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *holder, =
const struct blk_holder_ops *hops, bool autoload)
>>>  =C2=A0 {
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct file *bdev_file;
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct block_device *bdev;
>>> @@ -1088,7 +1088,7 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk=
_mode_t mode, void *holder,
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return =
ERR_PTR(ret);
>>>   =20
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev =3D blkdev_get_no_open(dev, true);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bdev =3D blkdev_get_no_open(dev, autoload)=
;
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!bdev)
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return =
ERR_PTR(-ENXIO);
>>>   =20
>>> @@ -1110,6 +1110,13 @@ struct file *bdev_file_open_by_dev(dev_t dev, bl=
k_mode_t mode, void *holder,
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return bdev_file;
>>>  =C2=A0 }
>>> +EXPORT_SYMBOL(bdev_file_open_by_dev_autoload);
>>> +
>>> +struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *h=
older,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct blk_holder_o=
ps *hops)
>>> +{
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return bdev_file_open_by_dev_autoload(dev,=
 mode, holder, hops, true);
>>> +}
>>>  =C2=A0 EXPORT_SYMBOL(bdev_file_open_by_dev);
>>>   =20
>>>  =C2=A0 struct file *bdev_file_open_by_path(const char *path, blk_mode_=
t mode,
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 03e35386a..d3717e2e8 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -3858,9 +3858,13 @@ static struct md_rdev *md_import_device(dev_t ne=
wdev, int super_format, int supe
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err)
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto ou=
t_clear_rdev;
>>>   =20
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev->bdev_file =3D bdev_file_open_by_dev(=
newdev,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * md_ioctl() holds reconfig_mutex; legacy=
 autoload in bdev open takes
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * major_names_lock via blk_probe_dev() an=
d can deadlock with md_probe().
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0rdev->bdev_file =3D bdev_file_open_by_dev_=
autoload(newdev,
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 BLK_OPEN_READ | BLK_OPEN_WRITE,
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0super_format =3D=3D -2 ? &claim_rdev : rdev, NULL);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0super_format =3D=3D -2 ? &claim_rdev : rdev, NULL, false);
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(rdev->bdev_file)) {
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_warn=
("md: could not open device unknown-block(%u,%u).\n",
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 MAJOR(newdev), MINOR(newdev));
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>> index 0c2010230..e5121101a 100644
>>> --- a/include/linux/blkdev.h
>>> +++ b/include/linux/blkdev.h
>>> @@ -1699,6 +1699,8 @@ struct blk_holder_ops {
>>>   =20
>>>  =C2=A0 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, =
void *holder,
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const s=
truct blk_holder_ops *hops);
>>> +struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mode=
,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *holder, =
const struct blk_holder_ops *hops, bool autoload);
>>>  =C2=A0 struct file *bdev_file_open_by_path(const char *path, blk_mode_=
t mode,
>>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *h=
older, const struct blk_holder_ops *hops);
>>>  =C2=A0 int bd_prepare_to_claim(struct block_device *bdev, void *holder=
,
>>  =20
>> --=20
>> Thanks,
>> Kuai
>>  =20

--=20
Thanks,
Kuai
