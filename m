Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55688322522
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285839; cv=none; b=ZZe220OBRiHMXifna8x6E+Z07leWX88av3FkQOlW4zR8G4eKqSIlLOpsdT/gOrwoYiHJcf1GtOCcnG0qPSb/dUoh35n9fchECRtGR7eTJm5mW1iTxZStosTnGHSO0PLhE3nnYXZOe3NXpv6m8nZHdMTY7f2bBSqLQPhxGYoUFgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285839; c=relaxed/simple;
	bh=a6ib6dNJcRxrSFnjcvQa3aJ1134//czhk8IhznCE96A=;
	h=Message-Id:Mime-Version:To:From:Subject:Content-Type:Cc:Date:
	 In-Reply-To:References; b=sqkJmZ9NbBwq5zMbXwQb+P8Gi5geA+nCFvsgBn3XpSO4hLsvKts/0w2QKDOEogC9zDoa4z58IovKHO9AaJOPxYPrVq8FLG/4nbSX0K5rkFDuEIjgr6CEnR3fJS7z1OwJ1AkEybYjkiD5ir1JCBSUu/Lg/sExCLT2uRHC3Erg7dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=TZCxWoqN; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="TZCxWoqN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782285833;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NronrkHsRnEhcFUTWzdQNNyLKOz0OLkb+GALDS2hFL0=;
 b=TZCxWoqNA85TcMZnF12LAY3AKvepsSxY7HP7nBTrjV8AlRo8rg1lTrDxrn1lcubzSUzpP7
 B2OWm/vriu/bM4iULws7StPVf8+2PuCUb/dYp5RRVRe26CexAKCs/6jS1BnNbxamsewwfb
 CUyk7qDG7fPdREvtXhTSalsGSSR69/MF5BcjG1xO7QeUSeaI2/n85DEI3a/+EZIOeibSUb
 fYZYp0Wg8NMfW7dkcDC3aWCAHt+oY+mWaBfLmou0NjflQv0jOLBvR5vgxX6r39W/Tg00qt
 052Qv2yhnzf9KhSn6e+K9zPToWnDiFfflLmkHFX+/6KvhptUkdTPfE2id9G3cg==
Reply-To: yukuai@fygo.io
Message-Id: <7239c50c-b257-4179-827a-9facd48e75e1@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a3b8608+fe7c74+vger.kernel.org+yukuai@fygo.io>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<john.g.garry@oracle.com>, <martin.petersen@oracle.com>, 
	<yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 4/7] md/raid10: raid10_write_request() drops the barrier before calling
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Wed, 24 Jun 2026 07:23:51 +0000
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 24 Jun 2026 15:23:47 +0800
In-Reply-To: <20260623072456.333437-5-abd.masalkhi@gmail.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com> <20260623072456.333437-5-abd.masalkhi@gmail.com>

Hi,

=E5=9C=A8 2026/6/23 15:24, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> bio_submit_split_bioset() and reacquires it afterwards. This is
> unnecessary because bio_submit_split_bioset() does not require
> releasing the barrier protection.

Why is this safe?

It's possible plug is not enabled in this context, and the allocated new
aplit bio will be submitted and enter wait_barrier() again. wait_barrier()
is not supposed to be called recursively. Otherwise deadlock can happend:

t1: sync_thread grab barrier and waiting for nr_pending to be 0 from raise_=
barrier()
t2: wait_barrier() first inc nr_pending, then recursive wait_barrier() wait=
ing
for barrier to be released.

>
> Remove the redundant allow_barrier()/wait_barrier() pair around
> bio_submit_split_bioset().
>
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/raid10.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 840f0446c231..4bc1d5553ec7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1493,10 +1493,8 @@ static bool raid10_write_request(struct mddev *mdd=
ev, struct bio *bio,
>   		if (atomic)
>   			goto err_handle;
>  =20
> -		allow_barrier(conf);
>   		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>   					      &conf->bio_split);
> -		wait_barrier(conf, false);
>   		if (!bio) {
>   			set_bit(R10BIO_Returned, &r10_bio->state);
>   			goto err_handle;

--=20
Thanks,
Kuai
