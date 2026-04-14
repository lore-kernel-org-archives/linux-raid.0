Received: from mail-108-mta121.mxroute.com (mail-108-mta121.mxroute.com [136.175.108.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE0C1DCB24
	for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776130451; cv=none; b=olsIu3EDa6WTAJ23xV1UqIdcYgqBl0FFcwdZciCkeQV+qhRfnp97QYBt1pz3sowW2Jgs3sqWs08hBwYS0aeAKu45Ydx8pu3l+jtzNjwPHhhgpVLZAG5ZmSEgBUvpQ1tbEdTIi8hb5oFOSMYkRFnAlfSxY90yMJ/W1y/7XLuWwu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776130451; c=relaxed/simple;
	bh=65wyp3E473q3cPWKhu0d8QdZ1vasYZilIoTTRWFWu2w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RpbSuNcMJJXqEou04EViyGqZwFmRTNuXws+JnHfLpSfkIT5rl37oF7w9mFQear8vFp6gXuEBch4nbMCTePHxatuDsuEXD5yJcuHf+YHhbe11b42kIeCuCBrgZMq4BuDLCQSLehqXJ6PJHYfxPS3RvvU7d2Jc+bt7I1nG8i6ldM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=dupXwnHV; arc=none smtp.client-ip=136.175.108.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="dupXwnHV"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta121.mxroute.com (ZoneMTA) with ESMTPSA id 19d899b1e7a00032bf.006
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 14 Apr 2026 01:28:57 +0000
X-Zone-Loop: f3a5a9ae906d599cd8ac0485ca08889170a571c212a7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bwKl389HggphIjcNcM0l3ZnumC07Nc1a7tFYVzaVGD4=; b=dupXwnHVPDfUgYYKtZExWs/t+M
	x8XdqKgQld1eaqbj9iu0tFsdQxlZgdl3sHfj+QV9HhCQ6ieVdWM8YOPJP3zw/l+YFubTmv6U9SMJ5
	L4KnsUdo8LCIIcs52KS+081V2G1Vv8o1tUCp/6z2htNdC3/uKyDdKGITEqXFZBo2qjnBJS3n9ZXyb
	Z5h2WdYif6twu44J/KvIa/FKdyGuBKQohFWcl2lA0ZjNLhSPsPHqxVuOLsovyTV6xdrmyDC9q/gfv
	esU7BbHkSIy0su5lsq5UfVB2aQBWrSjUEh+HeFnExiibC0SvO3nXn8OysU8I27VDb50+hcQHe2zyL
	9rbLitjw==;
From: Su Yue <l@damenly.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai@fnnas.com>,  Greg
 Kroah-Hartman <gregkh@suse.de>,  linux-raid@vger.kernel.org,
  linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH v2] md: fix kobject reference leak in md_import_device()
In-Reply-To: <20260413141759.2970973-1-lgs201920130244@gmail.com> (Guangshuo
	Li's message of "Mon, 13 Apr 2026 22:17:59 +0800")
References: <20260413141759.2970973-1-lgs201920130244@gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 14 Apr 2026 09:28:48 +0800
Message-ID: <fr4y8h4f.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Mon 13 Apr 2026 at 22:17, Guangshuo Li 
<lgs201920130244@gmail.com> wrote:

> md_import_device() initializes rdev->kobj with kobject_init() 
> before
> checking the device size and loading the superblock.
>
> When one of the later checks fails, the error path still frees 
> rdev
> directly with kfree(). This bypasses the kobject release path 
> and leaves
> the kobject reference unbalanced.
>
> The issue was identified by a static analysis tool I developed 
> and
> confirmed by manual review.
>
> After kobject_init(), release rdev through kobject_put() instead 
> of
> kfree().
>
> Fixes: f9cb074bff8e ("Kobject: rename kobject_init_ng() to 
> kobject_init()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> v2:
>   - note that the issue was identified by my static analysis 
>   tool
>   - and confirmed by manual review
>
>  drivers/md/md.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6d73f6e196a9..4ce7512dc834 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3871,6 +3871,9 @@ static struct md_rdev 
> *md_import_device(dev_t newdev, int super_format, int supe
>
>  out_blkdev_put:
>  	fput(rdev->bdev_file);
> +	md_rdev_clear(rdev);
> +	kobject_put(&rdev->kobj);
> +	return ERR_PTR(err);
>
Why not just:

out_blkdev_put:
	kobject_put(&rdev->kobj);
	fput(rdev->bdev_file);
out_clear_rdev:
	md_rdev_clear(rdev);
out_free_rdev:
	kfree(rdev);
	return ERR_PTR(err);

--
Su
