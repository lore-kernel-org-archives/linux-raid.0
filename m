Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8363DF01C
	for <linux-raid@vger.kernel.org>; Fri,  9 Oct 2026 05:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791522377; cv=none; b=IslfS1uQk4FCYsExA/aATMmfsU6UH6NjJhI7Cw9nrpxCgCzcMlvL0LsYYsgySeLVh06xCoeVhwa2uKoPXmK/FhBowhoYXx9DdD2ZqBG0ecAMC4PNXCvZcyI84fAYDN/OWuaFmSZyKexiU9Cssx5UxUAZM3ccVuniwDrhZ0DJBCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791522377; c=relaxed/simple;
	bh=wtQ6f26B9YBjtTSlKhisR0GW7IeKtM74Pebp6OmpaIw=;
	h=References:Cc:From:Content-Type:To:Subject:In-Reply-To:Date:
	 Message-Id:Mime-Version; b=eY+yO2/mBi7ucELFHumSM5ETKKZneJ/MImmcI1KZiHWy0peI8ECdF1EprJzu1rjXZ4sRS6HJl/JVpm34ZG/Xyg1DcpdTciq+bzZfPwUCLalEft9kvnDTRo1NKEQ6wJms3DFD09Bb956tXiFMJJeJLaGVgRluAZhvKSswHGQqjnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Yqv47QIl; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Yqv47QIl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791522362;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gK0Jex4XNDbar3unxpIBIy8PPLLlyDNdQQhFWDGVP3g=;
 b=Yqv47QIlTZQE+zX7D+kniI1h+zQ5oX2RA7CyKi70xOhkbA+776aP0dLA1RP8EmWzzV3ZZ1
 OOqiFlXzQEKm7i5z/bbe5gjuAY58JLDCN2C+nYjld6X1ADpEtzsHX3mi0alOPGgl66nWj2
 v7vRbmEr90SDvELPR6SH2Rd2WKyQrlV+uSWDS145JshIW58hFUb6dQop2VZMvWMtn9akCB
 1Wwcf6xDOMFKXjCZjHBCm8gaR2WmwZK2FORra1oONRVUvxKkfY+fWPHPHw1yNGlN2dx5R3
 0iM6SK+gA0ONf86qZz28IOjJgReAvZrKOJNGZuz8P82UgwQXHEztE4yrj5yTLw==
References: <20260923112159.94175-1-chengzhihao1@huawei.com> <20260923112159.94175-3-chengzhihao1@huawei.com>
Received: from [192.168.1.104] ([39.182.0.35]) by smtp.larksuite.com with ESMTPS; Fri, 09 Oct 2026 05:06:00 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
From: "yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26ac87639+0ca007+vger.kernel.org+yukuai@fygo.io>
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<shli@kernel.org>, <neil@brown.name>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3 2/4] md: Handle pers->run failure in level_store
In-Reply-To: <20260923112159.94175-3-chengzhihao1@huawei.com>
Date: Fri, 9 Oct 2026 13:05:57 +0800
Message-Id: <c7cc46af-708c-42fe-a82c-f6b2b5d145ea@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/23 19:21, Zhihao Cheng =E5=86=99=E9=81=93:
> Set 'raid_disks' after raid5_run() failure will trigger an
> null-ptr-deref problem:
>   BUG: kernel NULL pointer dereference, address: 0000000000000038
>   RIP: 0010:raid5_check_reshape+0xad
>   Call Trace:
>    update_raid_disks+0x124
>    raid_disks_store+0x145
>    md_attr_store+0xd7
>    sysfs_kf_write+0x7c
>
> The trigger process is simple:
>   mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 /dev/sda /dev/sd=
b
>   --force --assume-clean # create raid1
>   echo 5 > /sys/block/md0/md/level
>    level_store
>     mddev->pers =3D pers
>     mddev->private =3D priv
>     raid5_run
>      fail to abort (eg. raid5_create_ctx_pool fails)
>      mddev->private =3D NULL
>   echo 10 > /sys/block/md0/md/raid_disks
>    raid_disks_store
>     if (mddev->pers) // true
>      update_raid_disks
>       raid5_check_reshape
>        conf =3D mddev->private
>         conf->algorithm =3D mddev->new_layout // null-ptr-deref !
>
> Similar process exists in do_md_stop->__md_stop_writes->raid5_quiesce.
> Similar process exists in raid10 too.
>
> Fix it by handling the error from pers->run, next active-type order will
> restart the mddev.
>
> Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the =
personality managing an array")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>   drivers/md/md.c | 29 ++++++++++++++++++++++++++++-
>   1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 02798f2dbf0e..ff78bf8656ff 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -97,6 +97,7 @@ static struct workqueue_struct *md_misc_wq;
>   static int remove_and_add_spares(struct mddev *mddev,
>   				 struct md_rdev *this);
>   static void mddev_detach(struct mddev *mddev);
> +static void __md_stop(struct mddev *mddev);
>   static void export_rdev(struct md_rdev *rdev);
>   static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
>  =20
> @@ -4243,7 +4244,33 @@ level_store(struct mddev *mddev, const char *buf, =
size_t len)
>   		mddev->in_sync =3D 1;
>   		timer_delete_sync(&mddev->safemode_timer);
>   	}
> -	pers->run(mddev);
> +	rv =3D pers->run(mddev);
> +	if (rv) {
> +		/*
> +		 * ->run() has released the private data of the new personality,
> +		 * while the old one has already been released as well. There is
> +		 * nothing to fall back to, so stop the array to avoid leaving
> +		 * 'mddev->pers' pointing to a personality which has no private
> +		 * data, and reminds user to try to active the mddev again.
> +		 */
> +		pr_warn("md: %s: failed to run %s after takeover, please try to active=
\n",
> +			mdname(mddev), pers->head.name);

Usually takeover can be performed on a live array, and with a live fs mount=
ed, so
I don't think it's acceptable for the array to be in this state in the case
pers->run failed.

Is it possible to split pers->run into two parts? One for static checking a=
nd
memory allocation, so the next pers->run that will never fail. Which means =
we can
keep the old pers active until we can make sure the new pers activation cal=
lback will
not fail.

> +		if (mddev->pers->sync_request && mddev->to_remove =3D=3D NULL)
> +			mddev->to_remove =3D &md_redundancy_group;
> +		if (md_bitmap_enabled(mddev, true))
> +			mddev->bitmap_ops->flush(mddev);
> +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
> +		mddev_destroy_serial_pool(mddev, NULL);
> +		__md_stop(mddev);
> +		rdev_for_each(rdev, mddev)
> +			if (rdev->raid_disk >=3D 0)
> +				sysfs_unlink_rdev(mddev, rdev);
> +		set_capacity_and_notify(mddev->gendisk, 0);
> +		mddev->changed =3D 1;
> +		md_new_event();
> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
> +		goto out_unlock;
> +	}
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);

--=20
Thanks,
Kuai
