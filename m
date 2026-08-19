Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E60220F49
	for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2026 12:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787143670; cv=none; b=XpEOif4yXk6kzTDNaYl8E+qma0npZqY4c0fKau/5CcohPQMFfJiIo5P9agYcIN1Nv6Z6aZr4su15/2xBOahlhdLygmcBL1zu1k3n4bgOSNFtBICBuUEZj0Y+D7TCb+UI1Xbb6Pc8i13Vc/sm5Llb3uHUe4ea+SyiDcYO9rRk4iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787143670; c=relaxed/simple;
	bh=yCojdyMW6I/uiNi8iqA3d8mj4JNJb+/9NTfjul/I72s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=hhOP5FTvr0eW2Xw8pn3LjCm1JNi0sln1M0t3kgWOqI/rdEMb3J/zwPaUfU/2QxWEfgDl7Aubx6hkHglV2pYztYRgkV6+MFhd1cqdFwmf+hgDqoYLbn1y3odQJf73dEdZG2tuRZc47MevQe3hOQtQPpr1OoXHrg3n59zhRl9QY8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NlnaJumd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eYbu87Co; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NlnaJumd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eYbu87Co"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787143667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krsJhF+4QDKOU/a9i3/+lbS1D649tolWLCZpdcArOq0=;
	b=NlnaJumdBsAjXhjVVzZ3sSQ9XQ8zlyORLpKhYVErHcvRmJ06PkDKhmfjBpj4+lfo+6AbZE
	u0xXHN8RJCiNY6mS/KUQg4WFvrMa1sWA9BrUY46eCnCoP3nBG7ueTWoQ0mQzbGxQS/YgzN
	VZs5Vo0wagRnzOuVo5+Z2OR23PeSnTg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-DQNMgwMzPbqZ8Mgkt67aiA-1; Wed, 19 Aug 2026 08:47:33 -0400
X-MC-Unique: DQNMgwMzPbqZ8Mgkt67aiA-1
X-Mimecast-MFC-AGG-ID: DQNMgwMzPbqZ8Mgkt67aiA_1787143653
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1c7f135bso15805211cf.0
        for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2026 05:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787143653; x=1787748453; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=krsJhF+4QDKOU/a9i3/+lbS1D649tolWLCZpdcArOq0=;
        b=eYbu87CoJKj/ZrcvkO7yGrhpgFb1b060t6sNze+Pvr9V136Ttq2dBSBKs8Prr/8Ya8
         RKseCcGA9Lot4J0RYnbT5b71lkGTrfsjKwv+383eQ44u9o+I2nRYKzPeFosZpB4o5vpt
         0GiBTyXwhRr7ba+hffisvcPiCneQX5vcZvSXaaU4N/LQcSdE17XyfgdKbswg4hhcWp3r
         bPWvvCiTuK6vzJz4UrNB57xDdIZut6jccDXcg4/uXrhudURvlFPdnS+iZIlSb8rjTRnV
         +0Ps7bSO5xipRL1oyBHeVvsAWJmYxmlyZjswfISi1QDygvhSHf+1O2nF+NyYCICtPVFb
         B8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787143653; x=1787748453;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=krsJhF+4QDKOU/a9i3/+lbS1D649tolWLCZpdcArOq0=;
        b=YQh19nFIvLlmyXbJ7hdHN1rL7oY7aHKAezag1iBA2dG2BewPSzJG9rhBx8ZlS+xKQP
         0b1/D2NWyfkySfiKPL1azbhXXRtoQrupB+FoeIoeoPtJu+xvm3XG96FeU/12FZWcpLum
         ctZWmLcNVMnuAxYBF621M5phi9HBv73hO0KLl1WxCQxyk1mi0VJvXQyC7xclic426Qnn
         wK7QJm6o2BSIsL8aovdnYcvY3uQTtvI9SAaYDkhKipJXGbn7VWDO//j9WjfunTeLORbN
         NffJ64lPXwLjDYaurnnyAiLxfx7wHXE6BMXDcb3yDjz+xF85g2WUwCcgTa0Q+OZ/C8Rw
         LYYw==
X-Forwarded-Encrypted: i=1; AHgh+Rqc1cCk615rU3CkxYrmZy/zmyQ32ni1tD0iB8tyZDDHr65OQzsMI+QnHN4oy0kO6wf19UUQkJuwOGkt@vger.kernel.org
X-Gm-Message-State: AOJu0YyktmlY37Hsf/LdgnUDkvnDDweTsmdwyYa0B6+/TCjiuL6DciDI
	hsRLmBJwjPVixzzZwiBZVGpPhdWs+LYwcRs1UdB2vOU7JPD4HQSgpc+ZrnhCeUkWLXz3COkBu6v
	vdxHBGit8lnE57/YWnCBDtR3zu5YZHI/gc7zC254tA8Q2wXDF7I3P9xoN3aOG+Vw6F7nHHq0=
X-Gm-Gg: AR+sD11OBh5GEma+F39FAt6nJXp32kfVjqRJF/QszRG5jLIe2U3FZ1qokaRGsPWgJoS
	306OqZ219vGU6qWs+HkkHcK72pYWNw+e3WEv91ASrwdBpxY81+uokIdW8+GGCzL+DYBlQRtjitT
	Hzgx1s0zpscqzP6/D1MyL6NcUzI+8dbpmq9Z8AiFLDXYf2+JK13tuZZKrEo+XaTZU/kHMd/zlGE
	GrmTGWLcou6M6KeQIc6zlfBa3ImTI7rR1pzvXHHeyK0kAE8xXcl03QlOT1XlWhrrs6sHah3Nk2g
	Fv++bSuytVmG/yk2aQLP3VdJZChmWWcLk5Q6n7eKt+sQ5Vk+mRXfCqLGshMBdGBcggj7LouKcHU
	SsPhcF7M+puSrODpayOmL+w==
X-Received: by 2002:a05:622a:1aa9:b0:519:5680:1b5 with SMTP id d75a77b69052e-52dd5c428femr37288191cf.21.1787143652943;
        Wed, 19 Aug 2026 05:47:32 -0700 (PDT)
X-Received: by 2002:a05:622a:1aa9:b0:519:5680:1b5 with SMTP id d75a77b69052e-52dd5c428femr37287631cf.21.1787143652453;
        Wed, 19 Aug 2026 05:47:32 -0700 (PDT)
Received: from [192.168.50.139] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5edb4f75sm13701846d6.1.2026.08.19.05.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 05:47:31 -0700 (PDT)
Message-ID: <d290110b-67d4-4fc7-b67a-859b75d79b3b@redhat.com>
Date: Wed, 19 Aug 2026 08:47:31 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-bitmap: bitmap pages leaked after recovery
From: Nigel Croxon <ncroxon@redhat.com>
To: song@kernel.org, yukuai@kernel.org, linux-raid@vger.kernel.org
References: <e86f6b88-ea4f-425a-880d-a3622f3f458a@redhat.com>
Content-Language: en-US
In-Reply-To: <e86f6b88-ea4f-425a-880d-a3622f3f458a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/7/26 2:55 PM, Nigel Croxon wrote:
> The bitmap pages leaked after recovery if successful writes occur
> concurrently during array degradation/recovery.
>
> We performed write I/Os to an MD RAID1 array while it was in a degraded
> state or actively undergoing recovery. Even after the array recovery
> successfully reached 100%, the disk status returned to normal ([UU]),
> and all I/Os completely stopped, the number of bitmap pages
> (bitmap: n/N pages in /proc/mdstat) never dropped back to 0, resulting
> in a persistent memory leak of bitmap pages.
>
> Bitmap pages remain permanently allocated in the kernel memory even after
> the array has fully returned to a healthy state, leading to a kernel
> memory leak.
>
> When a disk is re-added and recovery starts, MD_RECOVERY_RUNNING is set
> in mddev->recovery.  The else if condition evaluates to false for normal
> concurrent writes during recovery. NEEDED_MASK is never applied to these
> blocks.
>
> Fixes: 4f0e7d0e03b7
> md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
> This is becauses removing success caused bitmap_endwrite()
> to treat mddev->degraded as a blanket trigger for NEEDED_MASK.
>
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  drivers/md/md-bitmap.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 1d4a050dab3a..b8be0d079780 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1756,7 +1756,14 @@ static void bitmap_end_write(struct mddev 
> *mddev, sector_t offset,
>                  sysfs_notify_dirent_safe(
>                          bitmap->sysfs_can_clear);
>              }
> -        } else if (!NEEDED(*bmc)) {
> +        /*
> +         * Do not set NEEDED_MASK if recovery is actively running.
> +         * Writes completing during recovery/resync are already 
> covered by
> +         * the recovery thread and setting NEEDED_MASK will cause 
> orphaned
> +         * bitmap flags and memory leaks after recovery finishes.
> +         */
> +        } else if (!test_bit(MD_RECOVERY_RUNNING,
> +                &bitmap->mddev->recovery) && !NEEDED(*bmc)) {
>              *bmc |= NEEDED_MASK;
>          }
>
Looking for review and feedback...


