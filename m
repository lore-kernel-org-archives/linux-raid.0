Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B51FC7EC
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 09:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079667; cv=none; b=A0pFykE6tgB+z0DR7a6dAqeQSVriVWBQFd3g6EaAxLST1DcRaVKR3wEqSaS8VXWMHEYzHQg//jiXZ/w2+vlDREwXOSeJLmgFRMHEsqK1uHZk0VqYwTWvs+U6RYHPPRve0zpfUBeYc7BztHGAZhuqb44lmxRTUNZJzrtZ+dLQh4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079667; c=relaxed/simple;
	bh=aGqz4juZPSXjDDmlmQzyIQajIjsNAak6vm5Rzv9mbQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmeWKZxm8MEwOZ/edHzLq6I1AB2zcOs686a5X4LfbgPpIUn2Oa8Mu+hoBphaXTR/b7p/lTO3sBJ6tk6VSfR+BvBEQPJp+gAGGHgACiRgC2rpsM+WxUC3dWGqnemiboDUOouIIFeLjW/c5YrsRfYs1D5nADTf2EpDiU6c9HVH5gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1F3E361E6479A;
	Tue, 04 Mar 2025 10:13:47 +0100 (CET)
Message-ID: <05a09a19-a37c-4da0-b773-745ce75b2444@molgen.mpg.de>
Date: Tue, 4 Mar 2025 10:13:45 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] md/raid10: Don't print warn calltrace for discard
 with REQ_NOWAIT
To: Xiao Ni <xni@redhat.com>
Cc: yukuai1@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org
References: <20250304090950.18337-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250304090950.18337-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Xiao,


Thank you for your patch.


Am 04.03.25 um 10:09 schrieb Xiao Ni:
> There is no need to print warn call trace. And it also can confuse

Why is there no need?

> qe and mark test case failure.

What is *qe*?

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid10.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 15b9ae5bf84d..0441691130c7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1631,7 +1631,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>   		return -EAGAIN;
>   
> -	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> +	if (bio->bi_opf & REQ_NOWAIT) {
>   		bio_wouldblock_error(bio);
>   		return 0;
>   	}


Kind regards,

Paul
