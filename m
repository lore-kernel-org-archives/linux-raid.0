Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351E3B3C17
	for <linux-raid@vger.kernel.org>; Fri,  9 Oct 2026 04:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791520341; cv=none; b=SLTvV71nqIfcjxLsHJ6LF8s0ne9dCqcRxro1HdNgXRFgZPi3+4uk5RVvqeX8OZ/UOcPkmGhO8GL1+c7yQH8ljoK/RjKmJXjrribZkehsjSXX2NI44lLBissiyA+HiuodT9bcT1Z4F6ZJBCl/esyq/dQX8IFvM/19KCdlitvwn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791520341; c=relaxed/simple;
	bh=SXHNQMA/QgUPMGOYJic222s3Lbc0nYzw8Bc8LR7BqQ4=;
	h=References:From:Date:To:In-Reply-To:Subject:Message-Id:
	 Content-Type:Cc:Mime-Version; b=JWK+4rrO8QnViy33wVi0AHUM5j9sATJj0REL2BoFCZ+F1KXs/hFuykKLP2Nq65Wyb3Rsl0xCq8WgFYApjwAAmS8W/ubPosNxhPlCnSRaFgz1Du8firE4W4fQSY+DZeE65nquOrZdQIL+37QIhbzwuKE6EqklrLpy0kw7MrM/LU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=lQhIJpgh; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="lQhIJpgh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791520323;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=81uGY0hgHlKbXZcqXUCspN1ySN2y70a98TySzMIz39w=;
 b=lQhIJpghnZo1EBYE7KOUVvwWvA+44o3amfVAex/thaVzOdVizFBXAidNAE8qq1JRBg/JnI
 WfqFFkieX/GtwFmLA6xmUZFuQuDYM/w/7vgBoYS2nspdAzDynrkBxnpoNrQzZ5iz8LD2qE
 sSg77fgQJvzqwnSasQ58YSybTglzuZBDFzCd6RueOmOU/Na2QmjvuPb831FiyZxjfKAjfd
 mEGQWwjHLpJAn4CNkntjgI+P2tVruZkVxu2lAzu+phM7L5nIECRLRy85I/T480Iqx6D6gb
 m0yeNFkivrzafl3hIhqUNt/Ofwd6Mo6UGUDN2kTDtAZayDFZGH3meQBcIq9Drg==
Received: from [192.168.1.104] ([39.182.0.35]) by smtp.larksuite.com with ESMTPS; Fri, 09 Oct 2026 04:32:02 +0000
References: <20260923112159.94175-1-chengzhihao1@huawei.com> <20260923112159.94175-2-chengzhihao1@huawei.com>
From: "yu kuai" <yukuai@fygo.io>
Date: Fri, 9 Oct 2026 12:31:58 +0800
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26ac86e43+1c2086+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<shli@kernel.org>, <neil@brown.name>, "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260923112159.94175-2-chengzhihao1@huawei.com>
Subject: Re: [PATCH v3 1/4] md/raid5: Hide the origin mddev->thread before takeover
Message-Id: <1194977a-ef25-4ad3-9bec-df27b6adc4b4@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/9/23 19:21, Zhihao Cheng =E5=86=99=E9=81=93:
> The raid5 takeover invokes setup_conf and allocates strip heads, but
> it wakes up the wrong thread, which lefts strip heads in the list
> 'conf->released_stripes' and not being processed. If raid5_run fails,
> the strip heads won't be released, which triggers the following slab
> warnings (CONFIG_SLUB_DEBUG):
>   BUG raid5-md0 (Not tainted): Objects remaining on __kmem_cache_shutdown=
()
>   Object 0x0000000062fad548 @offset=3D3968
>   Object 0x000000007f74683c @offset=3D4960
>   WARNING: mm/slub.c:1268 at __slab_err+0x31/0x40, CPU#0: bash/865
>   RIP: 0010:__slab_err+0x31
>   Call Trace:
>    __kmem_cache_shutdown.cold+0x15b
>    kmem_cache_destroy+0x71
>    free_conf+0xf8
>    raid5_run.cold+0x463
>    level_store+0x64e
>    md_attr_store+0xd7

Is this still a problem with following patch?

[PATCH] md/raid5: drain released_stripes before destroying the cache -=20
Li Youhong=20
<https://lore.kernel.org/all/20260929083916.50620-1-dayou5941@163.com/>

>
> The detailed triggering process is as follows:
>   mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 /dev/sda /dev/sd=
b
>   --force --assume-clean # create raid1, mddev->thread is raid1d
>   echo 5 > /sys/block/md0/md/level
>    level_store
>     raid5_takeover_raid1
>       setup_conf
>        grow_stripes
>         grow_one_stripe
>          sh =3D alloc_stripe
>          raid5_release_stripe
>            md_wakeup_thread(conf->mddev->thread) // wakeup raid1d
>       raid5_run
>        ENOMEM =3D raid5_create_ctx_pool
>        free_conf
>         shrink_stripes
>          drop_one_stripe // no strips found from the conf->inactive_list
>          kmem_cache_destroy(conf->slab_cache)
> 	 __kmem_cache_shutdown
> 	  free_partial
> 	   list_slab_objects // some entries are not released !
>
> Fix it by hiding the origin mddev->thread before takeover, so that
> new allocating strip heads can be put into 'conf->inactive_list',
> which can be found by drop_one_stripe().
>
> Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>   drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++---------
>   1 file changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c091bba95c31..7e87e8a60f5f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -9039,19 +9039,38 @@ static void *raid5_takeover(struct mddev *mddev)
>   	 *  raid4 - trivial - just use a raid4 layout.
>   	 *  raid6 - Providing it is a *_6 layout
>   	 */
> -	if (mddev->level =3D=3D 0)
> -		return raid45_takeover_raid0(mddev, 5);
> -	if (mddev->level =3D=3D 1)
> -		return raid5_takeover_raid1(mddev);
> -	if (mddev->level =3D=3D 4) {
> +	void *ret =3D ERR_PTR(-EINVAL);
> +	struct md_thread *thread;
> +
> +	thread =3D rcu_dereference_protected(mddev->thread,
> +				lockdep_is_held(&mddev->reconfig_mutex));
> +	/*
> +	 * Set mddev->thread to NULL before setup_conf() to avoid waking up
> +	 * wrong thread(eg. raid1), which can prevent the strips from being
> +	 * left unreleased in the error handling path(free_conf) of raid5_run.
> +	 */
> +	rcu_assign_pointer(mddev->thread, NULL);
> +
> +	switch (mddev->level) {
> +	case 0:
> +		ret =3D raid45_takeover_raid0(mddev, 5);
> +		break;
> +	case 1:
> +		ret =3D raid5_takeover_raid1(mddev);
> +		break;
> +	case 4:
>   		mddev->new_layout =3D ALGORITHM_PARITY_N;
>   		mddev->new_level =3D 5;
> -		return setup_conf(mddev);
> +		ret =3D setup_conf(mddev);
> +		break;
> +	case 6:
> +		ret =3D raid5_takeover_raid6(mddev);
> +		break;
>   	}
> -	if (mddev->level =3D=3D 6)
> -		return raid5_takeover_raid6(mddev);
>  =20
> -	return ERR_PTR(-EINVAL);
> +	rcu_assign_pointer(mddev->thread, thread);
> +
> +	return ret;
>   }
>  =20
>   static void *raid4_takeover(struct mddev *mddev)

--=20
Thanks,
Kuai
