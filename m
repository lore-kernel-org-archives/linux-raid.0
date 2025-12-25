Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA181A0BD6
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 08:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766650798; cv=none; b=flrihsraSdXZ/JMZLGA0cO4Df5aSDpFjzsmFwU8B7WZyB57Tz2rLRBQBrhYW0T/Ulb1tuC+sUbFw0jr7803aQXGBbwUWKNyGFfjz1VjKdDwuh820kYdvfkiQPinCD511H+Nm3pVvqNWk+B42demb/xQ3JwvsvxhPd1h3OBDu0I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766650798; c=relaxed/simple;
	bh=XA3Z1GzpkuOQ7EZbEwvHRk2AIyYhJ9SaD1am8AhVpGA=;
	h=Content-Type:To:Message-Id:In-Reply-To:Cc:From:Mime-Version:
	 References:Subject:Date; b=ceaNF4BR0CVJKthJGfR/k15UfIW+iwz8iE+RbmmJjuZU4xTZbl8kVoFbg+z8X4DsHB7ibzLux5Z2JmnIGRdql/LOo2DILEEqClzqQgEn4RHyOnu2LDh5TE5zAvpqpQyLoihsndPwRxK0ygU1SI1prCihtCmWa/VRboMMqAE2Nos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=p+1rVUCw; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="p+1rVUCw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766650790;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=zdnheeggaBkkbN+ZogQ2ehp/0RBx4UOoigLLYO391qk=;
 b=p+1rVUCwUNTGLPAyzHrlvifxlWJnpWwyvHZzUTrlUNd4dt8LjgDZZpGnbwfH18KBw2SL6A
 47I93ur5EYLUeEi0tDrpSZ5jVKUVRqmIic7JwkQjcAJS8A8SaZFNPihkdqaZva9DQgtBKg
 x+hli4jk+AI4c2bBcEYlgOtgfbqWf/1QKGvHvFY6j/G1Nu1otFENtX85n1nxgdH9OoyyXD
 ewkxXur4VGWfvGu0sg9YHGRMP0tCqcqtzPSBgqMFWqGvHu2jcCzq+m9bGTAJM9YNZ9in0H
 Yo1AR5sCR0kpMjnG3jNg2umTmyLcfte4D21YflDvR1LTrJzscyq46gqjqQ6J+A==
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 25 Dec 2025 16:19:47 +0800
Reply-To: yukuai@fnnas.com
To: "dannyshih" <dannyshih@synology.com>, <song@kernel.org>
Message-Id: <75dd6e7d-383e-44c0-978a-42c286a3d9c3@fnnas.com>
Content-Language: en-US
In-Reply-To: <20251218090656.10278-1-dannyshih@synology.com>
X-Lms-Return-Path: <lba+2694cf3a4+18f291+vger.kernel.org+yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20251218090656.10278-1-dannyshih@synology.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] md: suspend array while updating raid1 raid_disks via sysfs
Date: Thu, 25 Dec 2025 16:19:46 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/12/18 17:06, dannyshih =E5=86=99=E9=81=93:
> From: FengWei Shih <dannyshih@synology.com>
>
> When an I/O error occurs, the corresponding r1bio might be queued during
> raid1_reshape() and not released. Leads to r1bio release with wrong
> raid_disks.

Please be more specific about the problem, mempool_destroy() will warn abou=
t
object still in use, and free r1bio with updated conf->raid_disks will caus=
e
problem like memory oob.

>
> * raid1_reshape() calls freeze_array(), which only waits for r1bios be
>    queued or released.
>
> Since only normal I/O might be queued while an I/O error occurs, suspendi=
ng
> the array avoids this issue.
>
> Signed-off-by: FengWei Shih <dannyshih@synology.com>
> ---
>   drivers/md/md.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e5922a682953..6424652bce6e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4402,12 +4402,13 @@ raid_disks_store(struct mddev *mddev, const char =
*buf, size_t len)
>   {
>   	unsigned int n;
>   	int err;
> +	bool need_suspend =3D (mddev->pers && mddev->level =3D=3D 1);

Perhaps just suspend the array unconditionally, this will make sense.

>  =20
>   	err =3D kstrtouint(buf, 10, &n);
>   	if (err < 0)
>   		return err;
>  =20
> -	err =3D mddev_lock(mddev);
> +	err =3D need_suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev=
);
>   	if (err)
>   		return err;
>   	if (mddev->pers)
> @@ -4432,7 +4433,7 @@ raid_disks_store(struct mddev *mddev, const char *b=
uf, size_t len)
>   	} else
>   		mddev->raid_disks =3D n;
>   out_unlock:
> -	mddev_unlock(mddev);
> +	need_suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
>   	return err ? err : len;
>   }
>   static struct md_sysfs_entry md_raid_disks =3D

--=20
Thansk,
Kuai
