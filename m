Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279B0387583
	for <linux-raid@vger.kernel.org>; Thu, 26 Feb 2026 05:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772084689; cv=none; b=TS0BDegxheq1fERH1lCVuYp0I7QdvWh5bF4gDEO6zEqUgeZROFvgOVMYbNAVWcI8nsuFo3fb68sv70wUBPrbwZ+A8T8tIYPqyerP0fogEzM96cmcpkGj/kt8H8I07jtMhN366zJ55uMSLjVQJ9AsCWlTeWMhlywIvNLVCs/Io0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772084689; c=relaxed/simple;
	bh=UzvXluGcKcZ4OSGMY6z4wFYis9uxUn7Br0+qus+PHSU=;
	h=From:Mime-Version:References:Cc:In-Reply-To:Subject:Date:
	 Message-Id:Content-Type:To; b=ka6AqUr8PpD7LXCQSLaw9gvMzAsptuBd67/oWTW5rJBdd+WI7uJ4aQJZsLAeH62JUQpBI7wwoz66x+jfWdh7bS1l75RjhEM1nu+KyI8PyKYFJyfmbsPKotbyGVlsXw/9Y/L5JIAKFtUQiJOQTrHVgnBkFHTIrlqdWsOO+RKT/sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=1A6A0Apr; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="1A6A0Apr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772084681;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UMuRrqqKiErhPCdFXV1kQNu/i86Sax8+grVS0vFhOBw=;
 b=1A6A0AprZ2LQxPTLJQzcv1RyFz53RHfpJGBd0tLBpb9eOi+wHAYvWI//FsonNxsGgMaI1Y
 sKxHhS57eSlW4CI+2imTF7ZwVkySBRCASbN/d8AH+e950Q6yaiZ4JWSmj3XkAFt1REml0V
 VG/Q3gCTiPPYEygqpEDQfaldW7ISsPEsmp/4M6rFw9C8vTVYWX7kB7w//bXOg3FdS9PT3I
 rpD4hBiJA60Y0boY/m02b93Cwx9KZgo3uevnW9cYxGi7Hfw6+yBqLGiXJZ+HNdnII5b29D
 YaUpfRcM9mOlMazTczAfaEGmjMCNeznNmvB9Lq38nH6IpKmhkpZLw8XVJ4/zgg==
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20260203095156.2349174-1-yangxiuwei@kylinos.cn>
Cc: <linux-raid@vger.kernel.org>
In-Reply-To: <20260203095156.2349174-1-yangxiuwei@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2699fddc7+1022d7+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH 1/1] md/raid5: don't set bi_status for requeued IO in STRIPE_WAIT_RESHAPE
Date: Thu, 26 Feb 2026 13:44:37 +0800
Message-Id: <71e50b0e-0669-4a40-84d5-3c3061dfb229@fnnas.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>, <song@kernel.org>, 
	<snitzer@kernel.org>, <xni@redhat.com>, <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.140]) by smtp.feishu.cn with ESMTPS; Thu, 26 Feb 2026 13:44:38 +0800

Hi,

=E5=9C=A8 2026/2/3 17:51, Yang Xiuwei =E5=86=99=E9=81=93:
> When reshape is interrupted, IO that needs to be requeued incorrectly
> sets bi->bi_status to BLK_STS_RESOURCE. This causes md_free_cloned_bio()
> to copy the error status to the original bio, which is wrong because
> requeued IO should be retried, not failed.
>
> This was found during LVM testing where reshape operations under I/O
> load would cause I/O errors and filesystem corruption.
>
> Remove the bi_status assignment to prevent incorrect error marking.
>
> Fixes: 41425f96d7aa ("dm-raid456, md/raid456: fix a deadlock for dm-raid4=
56 while io concurrent with reshape")
>
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>   drivers/md/raid5.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8dc98f545969..128c0b7e9f54 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6038,7 +6038,6 @@ static enum stripe_result make_stripe_request(struc=
t mddev *mddev,
>   	raid5_release_stripe(sh);
>   out:
>   	if (ret =3D=3D STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)=
) {
> -		bi->bi_status =3D BLK_STS_RESOURCE;

This will make the problem much worse, you should notice this bio is return=
ed directly
to user, because reshape is interrupted and nothing can be read or write, a=
nd you're
returning wrong data to user.

>   		ret =3D STRIPE_WAIT_RESHAPE;
>   		pr_err_ratelimited("dm-raid456: io across reshape position while resh=
ape can't make progress");
>   	}

--=20
Thansk,
Kuai
