Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D931C1DE2BF
	for <linux-raid@vger.kernel.org>; Thu, 30 Oct 2025 02:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761790320; cv=none; b=YOMe8Md6uqBy9rMjLK8jF/kggiQAeuYr1FUwHCD2R7UKMRPq9yXj/Wwe/C4qbWquq0FoOwCO5Q95lhMqvSq4MiJJvsZC+fU0hDEBLtmnIh1lZoo1nXho0BOVbAqV5IF6s9sdb83+OosRI5X3J00xpzuYQUvu1w0qLfnQsAtPcsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761790320; c=relaxed/simple;
	bh=Iug/CjVleFwOrsYdee2PB1Xj0fm0KOvkBm+wf9Q6QqE=;
	h=To:Date:References:Message-Id:Mime-Version:In-Reply-To:Cc:Subject:
	 Content-Type:From; b=SrQt6m0FDRc6O4alxcaUn7GqsLxBWvTMsXtBSdMEc38EolHn4RTyN61UIqPN7Gd22fYXVNwDOIVM+tuUlAHV0MfZ2NRW5m1IMy3PuHgoGgUV5QcVIKb8FYbFb63dioza40Q393fEEmeuN6Yf5B9ueh4bidjogvjyM4r59fG3qOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=TyQZijpq; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="TyQZijpq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761790305;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jukDf6qaQQ280oVFDLZxQ+91m2LWdMLjEzMARTkJVrk=;
 b=TyQZijpqJJbdifDyxCyQZIFlLr1ZTosMXBvYfX/RHlYi3MQxDF4lwIg9WOBXEIcrt2kxkB
 i25tc65mqSWNzTy39ddH4UQEBfBfPx+kYJwXKH5Zit5SKqAMBxQ2yB6n2INXd5oQ+u5qWU
 5K+W6fuN5zQglPkIRo+bLet9qzRffFdJqxFn6ITrpv4Jd06Ix8368lBscsM5SDpcVS9DbB
 wL8ChFH8RMx+t7W1w30VAt0e+pZvtIadXpQA0Z3MruMmvwCunUupn+PHOI1Zw6OwX+w1yy
 tLb5FKKG9THk4imsONXpbkem8471wQ3ov1ZtO9XGUooGYWqCc9QWj1SnwFp7lQ==
To: "Kenta Akagi" <k@mgml.me>, "Song Liu" <song@kernel.org>, 
	"Shaohua Li" <shli@fb.com>, "Mariusz Tkaczyk" <mtkaczyk@kernel.org>, 
	"Guoqing Jiang" <jgq516@gmail.com>
Date: Thu, 30 Oct 2025 10:11:40 +0800
Content-Transfer-Encoding: quoted-printable
References: <20251027150433.18193-1-k@mgml.me> <20251027150433.18193-3-k@mgml.me>
X-Lms-Return-Path: <lba+26902c95f+354f7d+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 30 Oct 2025 10:11:42 +0800
Message-Id: <d8ba0843-cbeb-4a91-b658-34b21e8b36fe@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
In-Reply-To: <20251027150433.18193-3-k@mgml.me>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 02/16] md: serialize md_error()
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/10/27 23:04, Kenta Akagi =E5=86=99=E9=81=93:
> Serialize the md_error() function in preparation for the introduction of
> a conditional md_error() in a subsequent commit. The conditional
> md_error() is intended to prevent unintentional setting of MD_BROKEN
> during RAID1/10 failfast handling.
>
> To enhance the failfast bio error handler, it must verify that the
> affected rdev is not the last working device before marking it as
> faulty. Without serialization, a race condition can occur if multiple
> failfast bios attempt to call the error handler concurrently:
>
>          failfast bio1			failfast bio2
>          ---                             ---
>          md_cond_error(md,rdev1,bio)	md_cond_error(md,rdev2,bio)
>            if(!is_degraded(md))		  if(!is_degraded(md))
>               raid1_error(md,rdev1)          raid1_error(md,rdev2)
>                 spin_lock(md)
>                 set_faulty(rdev1)
> 	       spin_unlock(md)
> 						spin_lock(md)
> 						set_faulty(rdev2)
> 						set_broken(md)
> 						spin_unlock(md)
>
> This can unintentionally cause the array to stop in situations where the
> 'Last' rdev should not be marked as Faulty.
>
> This commit serializes the md_error() function for all RAID
> personalities to avoid this race condition. Future commits will
> introduce a conditional md_error() specifically for failfast bio
> handling.
>
> Serialization is applied to both the standard and conditional md_error()
> for the following reasons:
>
> - Both use the same error-handling mechanism, so it's clearer to
>    serialize them consistently.
> - The md_error() path is cold, meaning serialization has no performance
>    impact.
>
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md-linear.c |  1 +
>   drivers/md/md.c        | 10 +++++++++-
>   drivers/md/md.h        |  1 +
>   drivers/md/raid0.c     |  1 +
>   drivers/md/raid1.c     |  6 +-----
>   drivers/md/raid10.c    |  9 ++-------
>   drivers/md/raid5.c     |  4 +---
>   7 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 7033d982d377..0f6893e4b9f5 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -298,6 +298,7 @@ static void linear_status(struct seq_file *seq, struc=
t mddev *mddev)
>   }
>  =20
>   static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> +	__must_hold(&mddev->device_lock)

This is fine, however, I personally prefer lockdep_assert_held(). :)

Otherwise LGTM.

Thanks,
Kuai

>   {
>   	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
>   		char *md_name =3D mdname(mddev);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d667580e3125..4ad9cb0ac98c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8444,7 +8444,8 @@ void md_unregister_thread(struct mddev *mddev, stru=
ct md_thread __rcu **threadp)
>   }
>   EXPORT_SYMBOL(md_unregister_thread);
>  =20
> -void md_error(struct mddev *mddev, struct md_rdev *rdev)
> +void _md_error(struct mddev *mddev, struct md_rdev *rdev)
> +	__must_hold(&mddev->device_lock)
>   {
>   	if (!rdev || test_bit(Faulty, &rdev->flags))
>   		return;
> @@ -8469,6 +8470,13 @@ void md_error(struct mddev *mddev, struct md_rdev =
*rdev)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	md_new_event();
>   }
> +
> +void md_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +	spin_lock(&mddev->device_lock);
> +	_md_error(mddev, rdev);
> +	spin_unlock(&mddev->device_lock);
> +}
>   EXPORT_SYMBOL(md_error);
>  =20
>   /* seq_file implementation /proc/mdstat */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 64ac22edf372..c982598cbf97 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -913,6 +913,7 @@ extern void md_write_start(struct mddev *mddev, struc=
t bio *bi);
>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>   extern void md_write_end(struct mddev *mddev);
>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
> +void _md_error(struct mddev *mddev, struct md_rdev *rdev);
>   extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>   extern void md_finish_reshape(struct mddev *mddev);
>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e443e478645a..8cf3caf9defd 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -625,6 +625,7 @@ static void raid0_status(struct seq_file *seq, struct=
 mddev *mddev)
>   }
>  =20
>   static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
> +	__must_hold(&mddev->device_lock)
>   {
>   	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
>   		char *md_name =3D mdname(mddev);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7924d5ee189d..202e510f73a4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1749,11 +1749,9 @@ static void raid1_status(struct seq_file *seq, str=
uct mddev *mddev)
>    * &mddev->fail_last_dev is off.
>    */
>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
> +	__must_hold(&mddev->device_lock)
>   {
>   	struct r1conf *conf =3D mddev->private;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&conf->mddev->device_lock, flags);
>  =20
>   	if (test_bit(In_sync, &rdev->flags) &&
>   	    (conf->raid_disks - mddev->degraded) =3D=3D 1) {
> @@ -1761,7 +1759,6 @@ static void raid1_error(struct mddev *mddev, struct=
 md_rdev *rdev)
>  =20
>   		if (!mddev->fail_last_dev) {
>   			conf->recovery_disabled =3D mddev->recovery_disabled;
> -			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>   			return;
>   		}
>   	}
> @@ -1769,7 +1766,6 @@ static void raid1_error(struct mddev *mddev, struct=
 md_rdev *rdev)
>   	if (test_and_clear_bit(In_sync, &rdev->flags))
>   		mddev->degraded++;
>   	set_bit(Faulty, &rdev->flags);
> -	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>   	/*
>   	 * if recovery is running, make sure it aborts.
>   	 */
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 57c887070df3..25c0ab09807b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1993,19 +1993,15 @@ static int enough(struct r10conf *conf, int ignor=
e)
>    * &mddev->fail_last_dev is off.
>    */
>   static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
> +	__must_hold(&mddev->device_lock)
>   {
>   	struct r10conf *conf =3D mddev->private;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&conf->mddev->device_lock, flags);
>  =20
>   	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk))=
 {
>   		set_bit(MD_BROKEN, &mddev->flags);
>  =20
> -		if (!mddev->fail_last_dev) {
> -			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
> +		if (!mddev->fail_last_dev)
>   			return;
> -		}
>   	}
>   	if (test_and_clear_bit(In_sync, &rdev->flags))
>   		mddev->degraded++;
> @@ -2015,7 +2011,6 @@ static void raid10_error(struct mddev *mddev, struc=
t md_rdev *rdev)
>   	set_bit(Faulty, &rdev->flags);
>   	set_mask_bits(&mddev->sb_flags, 0,
>   		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
> -	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>   	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
>   		"md/raid10:%s: Operation continuing on %d devices.\n",
>   		mdname(mddev), rdev->bdev,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 3350dcf9cab6..d1372b1bc405 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2905,15 +2905,14 @@ static void raid5_end_write_request(struct bio *b=
i)
>   }
>  =20
>   static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
> +	__must_hold(&mddev->device_lock)
>   {
>   	struct r5conf *conf =3D mddev->private;
> -	unsigned long flags;
>   	pr_debug("raid456: error called\n");
>  =20
>   	pr_crit("md/raid:%s: Disk failure on %pg, disabling device.\n",
>   		mdname(mddev), rdev->bdev);
>  =20
> -	spin_lock_irqsave(&conf->mddev->device_lock, flags);
>   	set_bit(Faulty, &rdev->flags);
>   	clear_bit(In_sync, &rdev->flags);
>   	mddev->degraded =3D raid5_calc_degraded(conf);
> @@ -2929,7 +2928,6 @@ static void raid5_error(struct mddev *mddev, struct=
 md_rdev *rdev)
>   			mdname(mddev), conf->raid_disks - mddev->degraded);
>   	}
>  =20
> -	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  =20
>   	set_bit(Blocked, &rdev->flags);
