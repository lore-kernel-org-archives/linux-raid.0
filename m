Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448AE2ECD1D
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 06:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776840071; cv=none; b=EnSTjfMVxxq35f1v4/ySbKXgJDDoJJXDin1ww8vr34lpYSK7XEzfBFz1U8ILLtirbBNJjvCJYKib5yBV7bX1y6mA2AKep/vMORVPHnti9BZVmiRHo0Vn1l3ZLHdcNjN/Y90936GSBy5e42Mj/jtOdUmQg1wieADqIamy5ncTR4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776840071; c=relaxed/simple;
	bh=SkdRahZQ1eheSR+//c7o1GraR5jS1J5Lnqk8+BskRhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gUVQLsf8mX13qUqNhyUZ6GdPR9UnPVSomJDivN3bTtiPG9JPmUKHyMy3j4I2vQ5XqYxZoxnTrmgw90xHvgt4UcdPWaa/qBEX9LMdwsgNkoTGNyc4DTwy0jASzkaEF8JZX3OlxX1AZJEqG9S4ZjHS2LPfnB8VEs9RGMspN640ya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af111.dynamic.kabel-deutschland.de [95.90.241.17])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 601864C2C37D70;
	Wed, 22 Apr 2026 08:40:44 +0200 (CEST)
Message-ID: <6e6e4340-2181-4a79-9284-7ed167aab807@molgen.mpg.de>
Date: Wed, 22 Apr 2026 08:40:42 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] md/raid10: prepare per-r10bio dev slot tracking
To: Chen Cheng <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fnnas.com, chenchneg33@gmail.com
References: <20260422023317.796326-1-chencheng@fnnas.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260422023317.796326-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Cheng,


Am 22.04.26 um 04:33 schrieb Chen Cheng:
> From: Chen Cheng <chencheng@fnnas.com>
> 
> raid10 reuses r10bio objects from both r10bio_pool and r10buf_pool. Track
> the number of devs[] slots used by each request in the r10bio itself and
> initialize it whenever one of these objects is reused.
> 
> No functional change yet. A later patch will use this width when reshape
> changes conf->geo.raid_disks.

Your Signed-off-by: line is missing.

> ---
>   drivers/md/raid10.c | 4 ++++
>   drivers/md/raid10.h | 1 +
>   2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0653b5d8545a..e93933632893 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1540,6 +1540,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>   	r10_bio->sector = bio->bi_iter.bi_sector;
>   	r10_bio->state = 0;
>   	r10_bio->read_slot = -1;
> +	r10_bio->used_nr_devs = conf->geo.raid_disks;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
>   			conf->geo.raid_disks);
>   
> @@ -1727,6 +1728,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	r10_bio->mddev = mddev;
>   	r10_bio->state = 0;
>   	r10_bio->sectors = 0;
> +	r10_bio->used_nr_devs = geo->raid_disks;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
>   	wait_blocked_dev(mddev, r10_bio);
>   
> @@ -3061,6 +3063,8 @@ static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
>   	else
>   		nalloc = 2; /* recovery */
>   
> +	r10bio->used_nr_devs = nalloc;
> +
>   	for (i = 0; i < nalloc; i++) {
>   		bio = r10bio->devs[i].bio;
>   		rp = bio->bi_private;
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index ec79d87fb92f..92e8743023e6 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -127,6 +127,7 @@ struct r10bio {
>   	 * if the IO is in READ direction, then this is where we read
>   	 */
>   	int			read_slot;
> +	unsigned int		used_nr_devs;

Most entries have a comment describing the use. Maybe add one too, or at 
least a blank line, so it’s clear that the existing comment is just for 
`read_slot`?

>   
>   	struct list_head	retry_list;
>   	/*

 From a performance and resource usage point of view, will increasing 
the struct have a negative impact?

The diff looks good.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
