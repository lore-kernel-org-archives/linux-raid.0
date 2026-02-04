Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE5A33373D
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770223548; cv=none; b=nmxhu8kOqKGqu90RXf6N3Npmetzjb03cKUEpCfXHIGsMIVHvFCltd+AYq4DkHo89MOue1THqKKsGfy0nxfl9XFVpjoi16VpoDMLwIluz6Ptmj4DHShhf+y5+IxYopHcAluy7ibhM375g7jNor8kKWq0GQLcwVqupCB7dtevJKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770223548; c=relaxed/simple;
	bh=gawCp7nAkeFa6SOOHLUjIcNwIoVCVhmmIEMrFyT9vC8=;
	h=To:Mime-Version:Content-Type:Subject:Message-Id:References:Cc:
	 In-Reply-To:From:Date; b=u86H3OekCgKm3yV08/RbyDCyL+o3HJXLFt9Ak7awao1wi8W/9JeloFZN6kGQwHtArxFauIlIoLhosvqUpaywbHSkVriHCR42o84DwElU7Atto+11q+jbT3EdXtChAXaiJcvlLZ4kZDDHOnOagAv7rF0Sz+KjiZdfx/I4GkY2UL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=sSstEcNS; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="sSstEcNS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770223542;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4YlOxzA7XxhoNAoWqnXpgGYvIfqFoQQLNBGt5xWrLOE=;
 b=sSstEcNSz+5vKabg42fXaBfNjK9M+LulerTJKXxE89Vo6V0zZAyvUMDNg6CQAGO4Pn+v2G
 SKXjM91DHnYFqMw3TuAEaTpGX8yUEYLUraZK9T1hep4wWMlpBFtRTmgOs9Rbi21+6ie9JI
 Qr9LwRGewKBjD17Vi8201bpel1fkv9woquECdcbVadzNYLRE1QzQSDHu68Z8q8xrzyzwOe
 AiKbT+F7Q7EHoyZcX6lsHJubOzDsdqT9yw5Mv+HXiOwoe6m5NVMSYFU9Vu5dopC39kWJG9
 TYp8KhAYl8npQUro05YVm+sbostZ04adaoucDHVvtblbpAjSSaP/9VITSWSPJQ==
To: <linan666@huaweicloud.com>, <song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v2 03/14] md/raid1: use folio for tmppage
Message-Id: <b19b6eb8-b5c1-4ca2-a80e-f177370085bf@fnnas.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-4-linan666@huaweicloud.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
In-Reply-To: <20260128075708.2259525-4-linan666@huaweicloud.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:45:40 +0800
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Thu, 5 Feb 2026 00:45:38 +0800
Content-Language: en-US
X-Lms-Return-Path: <lba+2698377b4+b6c0c7+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/1/28 15:56, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> Convert tmppage to tmpfolio and use it throughout in raid1.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid1.h |  2 +-
>   drivers/md/raid1.c | 18 ++++++++++--------
>   2 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index c98d43a7ae99..d480b3a8c2c4 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -101,7 +101,7 @@ struct r1conf {
>   	/* temporary buffer to synchronous IO when attempting to repair
>   	 * a read error.
>   	 */
> -	struct page		*tmppage;
> +	struct folio		*tmpfolio;
>  =20
>   	/* When taking over an array from a different personality, we store
>   	 * the new thread here until we fully activate the array.
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 407925951299..43453f1a04f4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2417,8 +2417,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>   			      rdev->recovery_offset >=3D sect + s)) &&
>   			    rdev_has_badblock(rdev, sect, s) =3D=3D 0) {
>   				atomic_inc(&rdev->nr_pending);
> -				if (sync_page_io(rdev, sect, s<<9,
> -					 conf->tmppage, REQ_OP_READ, false))
> +				if (sync_folio_io(rdev, sect, s<<9, 0,
> +					 conf->tmpfolio, REQ_OP_READ, false))
>   					success =3D 1;
>   				rdev_dec_pending(rdev, mddev);
>   				if (success)
> @@ -2447,7 +2447,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>   			    !test_bit(Faulty, &rdev->flags)) {
>   				atomic_inc(&rdev->nr_pending);
>   				r1_sync_page_io(rdev, sect, s,
> -						conf->tmppage, REQ_OP_WRITE);
> +						folio_page(conf->tmpfolio, 0),
> +						REQ_OP_WRITE);
>   				rdev_dec_pending(rdev, mddev);
>   			}
>   		}
> @@ -2461,7 +2462,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>   			    !test_bit(Faulty, &rdev->flags)) {
>   				atomic_inc(&rdev->nr_pending);
>   				if (r1_sync_page_io(rdev, sect, s,
> -						conf->tmppage, REQ_OP_READ)) {
> +						folio_page(conf->tmpfolio, 0),
> +						REQ_OP_READ)) {
>   					atomic_add(s, &rdev->corrected_errors);
>   					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on =
%pg)\n",
>   						mdname(mddev), s,
> @@ -3120,8 +3122,8 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>   	if (!conf->mirrors)
>   		goto abort;
>  =20
> -	conf->tmppage =3D alloc_page(GFP_KERNEL);
> -	if (!conf->tmppage)
> +	conf->tmpfolio =3D folio_alloc(GFP_KERNEL, 0);
> +	if (!conf->tmpfolio)
>   		goto abort;
>  =20
>   	r1bio_size =3D offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
> @@ -3196,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>   	if (conf) {
>   		mempool_destroy(conf->r1bio_pool);
>   		kfree(conf->mirrors);
> -		safe_put_page(conf->tmppage);
> +		folio_put(conf->tmpfolio);

Is this safe? folio_put() can't be called with NULL.

>   		kfree(conf->nr_pending);
>   		kfree(conf->nr_waiting);
>   		kfree(conf->nr_queued);
> @@ -3310,7 +3312,7 @@ static void raid1_free(struct mddev *mddev, void *p=
riv)
>  =20
>   	mempool_destroy(conf->r1bio_pool);
>   	kfree(conf->mirrors);
> -	safe_put_page(conf->tmppage);
> +	folio_put(conf->tmpfolio);

Same here.

>   	kfree(conf->nr_pending);
>   	kfree(conf->nr_waiting);
>   	kfree(conf->nr_queued);

--=20
Thansk,
Kuai
