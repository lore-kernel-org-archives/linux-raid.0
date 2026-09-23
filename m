Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0704A4848
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164452; cv=none; b=k6hlh+FR9fluz7B1rnzR95bRAN9Zc9Oyi3UNrAuMEPTttFSXlU59/31NZC9Au/uDpDHEMzhhXdHszkUbbr/1vfDsq1pexQWTBCz/RBdKsdxZznrxVxluaEQxBIMdf0ruttOi9J8pg1vLu4OMyrB/o8uHG1EnDnXviDuoa5P+cV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164452; c=relaxed/simple;
	bh=9ZmM+jiL87tKv8iSq4DAirsiwl+m6LAEZToL7w69uMY=;
	h=From:Mime-Version:Content-Type:To:Cc:In-Reply-To:Subject:Date:
	 Message-Id:References; b=izHJePNtgBaSrxreSioHEV76PnGIVbDf3BjxDtw4UJZmfkQaIh5tKblve61ky8j8MSvFKMuTj1ONwqyCOHybavgiX11zA820sIP90zbGbJbs5aE2nkU1PV8gjXeRjESQQ2/R44tIaqtZqfY3Bvdf2SxXJrFHcOF48rMYYok886Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=hzttUqZ5; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="hzttUqZ5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790164437;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=s2WEN+twqWGY/7x8wbQRYCNNGCL94CtSF6LCaX7n0H0=;
 b=hzttUqZ5OCqKMZMqzjo7fcnpx8XxGyiFowzROYguqe2cg3Kx1LHQuNzUCItiJNiiBZtJdQ
 IPNLEoPXvBCJJyDvjUf97wfMgb4NrtY6XBa5PZ7+ddVvY2fPmLb1Y2+29J3Hjb7LT8srVA
 QXdGiggRpHkIFGLpGVcCpU8/+M+ibbzH8LDgAwjE0juTVeunb0fqSNMmEDAV7WD6PSJIc4
 IP7kzvBHW2Jw8dHxggPX1E93PulOgVMgznEcMNxh8DLhAxL4UnTxAQyB197HS4taP/1mZs
 0XRq4LTe7FhgTmUYww63Q63HDYG2S3Mo7y1jtj7y9FoZBT3k10DekegYG2n4JA==
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.179]) by smtp.larksuite.com with ESMTPS; Wed, 23 Sep 2026 11:53:55 +0000
To: "By" <xiaobai050@gmail.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260923071017.23563-1-xiaobai050@gmail.com>
X-Lms-Return-Path: <lba+26ab3bdd4+1e1ddd+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH] md: prevent opening an array before its sysfs kobject is ready
Date: Wed, 23 Sep 2026 19:53:52 +0800
Message-Id: <a19e3020-272b-4f93-8535-00fa07002d91@fygo.io>
References: <20260923071017.23563-1-xiaobai050@gmail.com>

Hi,

=E5=9C=A8 2026/9/23 15:10, By =E5=86=99=E9=81=93:
> md_alloc() publishes the gendisk with add_disk() before it initializes
> and registers mddev->kobj. A concurrent open can issue ADD_NEW_DISK in
> this window, causing bind_rdev_to_array() to pass the uninitialized
> mddev kobject as a parent to kobject_add(). This triggers a kobject
> warning.
>
> Set MD_CLOSING before publishing the disk so md_open() rejects opens
> until the kobject and sysfs attributes are ready. Clear the bit under
> open_mutex, which md_open() holds while checking it.
>
> Compile-tested with ARCH=3Darm64 defconfig and drivers/md/md.o. The
> upstream syzbot report has no reproducer, so this race was not tested
> at runtime.
>
> Fixes: 7df835a32a8b ("md: fix a lock order reversal in md_alloc")
> Reported-by: syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D95eeb4ada2349a2170ea
> Assisted-by: LLM
> Signed-off-by: By <xiaobai050@gmail.com>
> ---
>   drivers/md/md.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63..11b0b6b13 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6385,6 +6385,8 @@ struct mddev *md_alloc(dev_t dev, char *name)
>  =20
>   	disk->events |=3D DISK_EVENT_MEDIA_CHANGE;
>   	mddev->gendisk =3D disk;
> +	/* add_disk() exposes the device before its md kobject is registered. *=
/
> +	set_bit(MD_CLOSING, &mddev->flags);
>   	error =3D add_disk(disk);
>   	if (error)
>   		goto out_put_disk;
> @@ -6406,6 +6408,9 @@ struct mddev *md_alloc(dev_t dev, char *name)
>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>   	mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "array_st=
ate");
>   	mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "level");
> +	mutex_lock(&mddev->open_mutex);
> +	clear_bit(MD_CLOSING, &mddev->flags);
> +	mutex_unlock(&mddev->open_mutex);

I don't like this fix, it introduces a race window that open md device will=
 fail. Instead,
since all bind_rdev_to_array() is already protected by reconfig_mutex, can =
this problem be
fixed by holding reconfig_mutex for both add_disk and kobject_add?

>   	mutex_unlock(&disks_mutex);
>   	return mddev;
>  =20

--=20
Thanks,
Kuai
