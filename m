Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128953E00B5
	for <linux-raid@vger.kernel.org>; Mon, 13 Jul 2026 09:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783934386; cv=none; b=i9ViJ/9WY38AIVc8uqS1Wwt5HtqlaD+86cCArif+Gamxl5tGLpmmm2OfNv/oiTXTV2jWhF6uIYpHUjUmLx/7VcnKjpy7pKAfmxosNRdcJgQ1Vn2J3F84/rhyprwxG4Cjvb2BzgRInet1e4s8Brwz8BNCEhYvj65jFzuhsFuhRhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783934386; c=relaxed/simple;
	bh=3ZfdHrAjeIKCtzgFro/qo5aWAh/WGZIlIka4TDu/DAE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dJy2F1+U4UJ80jZmKwcO/VIw9AXsSelzBMORad4X08Q70093318DQiL9TUsPpQS9T8mHXbSmTUtgOg02OsrzMQnwH0gHU/a2Cys9AoqMBA46bysSpJdMfPFUCLJSRV2S9P5sRqgGItjmFHj/cHVvYEftAX1HxzQooWg+WQGnzO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a8/hl2dZ; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a8/hl2dZ"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69c19a37eeaso5681861a12.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Jul 2026 02:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783934383; x=1784539183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f5qgJIYE3jPPN16EaxeYkTdaYU5IoLrksy2JUMgb8Rk=;
        b=a8/hl2dZfjdhZMcnMa6sUds7vxP+A/fKRCLW1yNGzA7hZAYC/aYL05PW8hAO54ydhL
         LJiMd2LoXHkbtldGn17+RRQSZl39gDJsCNpS6JvUPLigVPbBELpEVcw069YfWh+wds+i
         9rpU/4zJ97L/eGf1saWtXsYnWk5vi2vUAf1m32+yMhVL1rlvkGJujoBou/PIQlBqzcU6
         pZBx3Ix2EBe3vLtbbOqMHwrgh0riOqQlaMZ03NK/FZhQ2aBAPy3Xb1kWrbMfOAetgbTW
         XpNFiN0hwr7AgLEebXznaocdACMFPTFCiC7a/y+NlSFPjzh1Zrnrr7VhVaiO4rhgCl7G
         gHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783934383; x=1784539183;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f5qgJIYE3jPPN16EaxeYkTdaYU5IoLrksy2JUMgb8Rk=;
        b=Po0pQzCyx4F2nWqyo8YGdJ4xtINZu3k+7M7uC+cZ6v16jGyjaQlvInnXt+8M3tzb3z
         7+wyRWRVspFEDSLM/O804lAQM/MZ2PJ+t55zokY+GegeSarnS5rpFHv9F9hk0O+liX/r
         KFfz/Sqk051kkOH2+OMsMel+k7kaZ1fGjKBXvsAc69FBWx+iAFle8NZKw5yTX8myZKIC
         mE9nRhVRztG0ezp3wv3a/C25ETt4dwYYABLkWN51gJrE+R2zYPOda9fif0CYw9XIUBUi
         XlmdSwYTmR5i8NpTxCiuUCnQ+Mg4kPepkVVEdA0qjerfXMzcbNNYWXnxJRzIqrr2S1dR
         2aRg==
X-Forwarded-Encrypted: i=1; AHgh+RrlJcJPLr1JFGUHWFFBePPbVuzyElv9qrLSy8KJz3jK8vjG8bVTlow7/f6nNOKGVO0RLl1YiUM0SuBF@vger.kernel.org
X-Gm-Message-State: AOJu0YzSLORI7ku8CJ0ywKE+OQ66BGjzxJ4AOnSru5dFSkuCjhAxZMef
	eNrzvvi/rHZIVKbrZ3qzEmOKDNOR42hGxIOj9RmSNT1iSnqmlxq7EQxluil+oUC8vII=
X-Gm-Gg: AfdE7ckMSxd2Ig5s+P1ha/GHwTYz3n648Fx3mRT5Lf1vr+VI3/K2DRu3pBJ1CJnnsZK
	0ChYgkh/56YJhHDUsVSu/aj6igrSXOsWoTiZDuL+wKayU2H2Xnxvo0AMEzyuWDG6+afXmOTJ3rr
	yN3+eVZDjHCtDcek9pU+Mu7XCoPyoWQbgbox9jM9toi1CrgmVlh9V9JY5SV41cYjGByzBOf0pw5
	eFf8N4vHyIRGTshWpnlihRlpCsWknllIBJj4caL5p8dCC8ImYP+XEtKQNcKbCaO0k3cINOIzRUV
	IWk85CIeEGkltYOJNvNXr9AzXPYV2yZc0XmrlP2Jupp3xXn50R+V1P3WdJ7DKNvO1QSY6SbJ93q
	zwZw9O9+zG/DX16WnSuDc1u0G9twyRIytwfnranaW9HReGC5P50N0IR9MifWk4XT947f1aULg94
	0WkOLV5w==
X-Received: by 2002:a17:907:783:b0:c16:c65:56b5 with SMTP id a640c23a62f3a-c161e8e97b6mr384403166b.24.1783934383403;
        Mon, 13 Jul 2026 02:19:43 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38d2fdd777csm3373649a91.1.2026.07.13.02.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 02:19:42 -0700 (PDT)
Message-ID: <32c03d5d-d5b4-4954-9bc7-d7f64e46fda1@suse.com>
Date: Mon, 13 Jul 2026 18:49:37 +0930
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Cc: hch@lst.de, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <cover.1779412152.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi David,

I know you hate this way to fix the problem, but considering it's 
already 7.2-rc3, if you do not like this method I think it's time for 
you to submit your alternative.

My existing patches still apply on the latest for-next and is known to 
avoid the extra warning from RAID6 lib.

Thanks,
Qu

在 2026/5/22 18:53, Qu Wenruo 写道:
> [CHANGELOG]
> RFC->v1:
> - Remove unused btrfs_chunk_map::io_(align|width) members
>    To make space for the new member.
> 
> - Fix a duplicated bg->flags assignment in fill_dummy_bgs()
>    Just exposed by the last patch which also touches that code.
> 
> - Use a dedicated member to record the on-disk chunk type
>    So it's less fragile than the RFC patch.
> 
> The single-data-RAID56 (2 disks raid5 or 3 disks raid6) is not a feature
> that should be supported in the first place, thus raid56 is going to
> remove such support.
> 
> Meanwhile rejecting single-data-RAID56 will cause existing btrfs users
> unable to mount their fs, even if there is only a single
> empty chunk with that flag, mostly caused by some degraded mount.
> 
> So to avoid impacting existing users, implement an internal
> single-data-RAID56 to RAID1/RAID1C3 mapping, to co-operate with the
> upstream raid56 lib changes.
> 
> Qu Wenruo (3):
>    btrfs: remove btrfs_chunk_map::io_(align|width) members
>    btrfs: remove duplicated block group type assignment
>    btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
> 
>   fs/btrfs/block-group.c |  3 +--
>   fs/btrfs/volumes.c     | 25 ++++++++++++++++++-------
>   fs/btrfs/volumes.h     | 10 ++++++++--
>   3 files changed, 27 insertions(+), 11 deletions(-)
> 

