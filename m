Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85351A238C
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682243; cv=none; b=ScHlb/1YBj7dcrwIEMyAVoz3wbs3j7Ot0CS+pmMcVs57Zk3i6CIuDvXUw1VPUiypufkVDhWcOOr1AWVvuhpxh8Zq3JdaRVgWo8z1xoJLoCYy5JfCwdBSKFYxgd8BZ3cy5nfHeaHkf+SinA23ZM+zwGOHkqZ+QKwUsx18Xq3f+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682243; c=relaxed/simple;
	bh=wBKfia70waosjnGlVCGc1j0Le3sD+EaKKkFSusPJU3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KekBZ2Hz8Jv0IBFVQdBWIqAA0+gam0gDw0EgLi8zz+DKDx/PrKuQN5AhGxl+TyxDutukrCxqJAVLCGp0uVfPqNAt9GHPOitafWAA9hshEg8GBlG79mt0Z8y5Jtd3xRWgXZpvKE3wPWH6rKHmUvh7eviQblRWfmWa94cKP17SKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoGUiAkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoGUiAkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FB9C4CEE7;
	Wed, 16 Jul 2025 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752682242;
	bh=wBKfia70waosjnGlVCGc1j0Le3sD+EaKKkFSusPJU3Q=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HoGUiAkrT/T7NfHliGYfJv+U10gr/UUGBzijOYBtxFnvupEedfBxI59dt6fE2+S/J
	 Wrqr0TvKEfFAF9o6PEN17YpWjF7j53Le5eDx8UnNk1vKIlMNccBfURu5YONXKfHHZG
	 OHAoa3DBWvHlieXU8UCQnegh19lZeDqBGEYGf/3N6TNcFyYXqbfp7AeLLa2/qtA9IT
	 zyGMz9g0FVJijMzvqThSEG2zk2tt8jpIq1SOyzguU+qakVDfdaGu4VNdK6GmNnlZ2w
	 YXRPx+JZEcMNi4N53z29NqtfyV1mza1EAAisUZWC2fI3QCCol7kaOejppL4ej6W6oQ
	 +DqqwyFCY737w==
Message-ID: <edf26246-3700-41ec-956d-3fe4cc7d9c40@kernel.org>
Date: Thu, 17 Jul 2025 00:10:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH] md/raid10: fix set but not used variable in
 sync_request_write()
To: John Garry <john.g.garry@oracle.com>, song@kernel.org,
 yukuai3@huawei.com, xni@redhat.com
Cc: linux-raid@vger.kernel.org
References: <20250709104814.2307276-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250709104814.2307276-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/7/9 18:48, John Garry 写道:

> Building with W=1 reports the following:
>
> drivers/md/raid10.c: In function ‘sync_request_write’:
> drivers/md/raid10.c:2441:21: error: variable ‘d’ set but not used [-Werror=unused-but-set-variable]
>   2441 |                 int d;
>        |                     ^
> cc1: all warnings being treated as errors
>
> Remove the usage of that variable.
>
> Fixes: 752d0464b78a ("md: clean up accounting for issued sync IO")
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Applied to md-6.17

Thanks

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..30b860d05dcc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2438,15 +2438,12 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   	 * that are active
>   	 */
>   	for (i = 0; i < conf->copies; i++) {
> -		int d;
> -
>   		tbio = r10_bio->devs[i].repl_bio;
>   		if (!tbio || !tbio->bi_end_io)
>   			continue;
>   		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
>   		    && r10_bio->devs[i].bio != fbio)
>   			bio_copy_data(tbio, fbio);
> -		d = r10_bio->devs[i].devnum;
>   		atomic_inc(&r10_bio->remaining);
>   		submit_bio_noacct(tbio);
>   	}
