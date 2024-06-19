Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5255E1F95E
	for <linux-raid@vger.kernel.org>; Wed, 19 Jun 2024 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718806880; cv=none; b=K2RlOYlBQkSn6aJuQgwxWL7rwnoVQkUUEPg/h43Ht8FR9u/fLBYWZWvVwV7v0a1ztpDjRZlYbOMhLnQcsSGipwadDDySTplNxzlJOCbnQbBxXMrsRGw3YmX3qtbpR4UyKwTFpnVXdqcQ9HVE1uZybuDdXDmsioQjIFAhuUAhLgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718806880; c=relaxed/simple;
	bh=uH4XR4wLXeFFWwFyzqN4liYHhcQFiK7R5SRMOkCV9Yw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZZm66K+i41x2xnho5PmF07oci/Y42EtrkVE12JqgShcC3GJfQrjyhZozCXrCYqnby5km4z2rcuJObS+kl++XKPkz2Sgf9TU5cNi56UocD17HsPOJDC9cEpH7bdVtvic6emgX5/fcPfbWxBRCbcsqNwVcbj+00N/iseVWoKaKTjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MbpDiu1z; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MbpDiu1z"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6c386a3ac43so406234a12.0
        for <linux-raid@vger.kernel.org>; Wed, 19 Jun 2024 07:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718806878; x=1719411678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TrxAc+Uu30dWHZppC8CN0wQM7I31e2d3aLis3drkvvE=;
        b=MbpDiu1zr2r5g5/m9IvUWgBKM6djvABnGCxvHPYDh4TDP4qnXnGnna/dIdsmFnyPg7
         w4liQUOt/FQ+qr0Hw+ZWUTlROSL0YefUHUGYwyFlC0wjSfaIVI3D/GV2NTKG5vwUuDeK
         zq1Fm5zS5o1eVp6SF3RvQDn0NjjA9V5EeSZhEWeCm7eeKrJdBPOuB9eLhD7BJYhcA46j
         Rv6aOHiUcExBK0HRethB4PBTKzmUZHWwnZ86g6N72fTdGF0s5mXOQepNR6wxeDIQp+2R
         50mz5w8RyQuGkoAMvNIc+VCIdxWWNTUTxOYXvO4r9L5ldQJ/sML+ResJ/r3VtbZCRWrY
         x2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718806878; x=1719411678;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TrxAc+Uu30dWHZppC8CN0wQM7I31e2d3aLis3drkvvE=;
        b=obCE3YSzZuLq8LpWWcE3PZRJ9Kkr8a/sATNmGFosOMCmU0+GYaJTzqGycZr2nz65zK
         qZDONGo7e/kddmj3RdORDshzQawfjQkgkO6P5VL1Ba3DxgbPbGQI1L12I8Yv38gxyWNi
         xwCIHqFyYmxY59VoTuGQth36/7CUU0HSmi3Ppe2gsXw137CyAsiXAS/7tAOZHcm/OE3x
         Q8HwHXXH3na6c+liaVomTh3CnADz8zH58IeKdIHVd+q5se/zqc4xKQxrGWn5Mif4HzYj
         0KtQzrJ05HYbJgy55XFWDGbHFN36A7IpleG8T3R65WfEkt31usl8lu71ut0Qyt1NlaId
         001Q==
X-Forwarded-Encrypted: i=1; AJvYcCVthah0jrZrbRnGByMmB7mNsKHRJFzVrmWZkovXn4sYEQpX3TtR4ztv6KLIxhMiFGyjQQ4D1PPtF7lRZpSZdAsfLfnVGrkyzCsohQ==
X-Gm-Message-State: AOJu0YyqEAMAmDZt2qF8E+CMoNN0UvpoNs/XV7/xmnQviCIdHXt7G3xw
	qFkrIWZNccxyzd6Yjvu0OBicSWSwUEAmnX73DNjFSYlaPYyD/shzTaZVLsqyFPY=
X-Google-Smtp-Source: AGHT+IGlNYahWungPdY/VG0D2i+/kOzAqG/9vIEbq77BhnEO6pEhdeI5ihGxkaZBKQBmSE54SEc3pA==
X-Received: by 2002:a05:6a21:33a5:b0:1b8:622a:cf7c with SMTP id adf61e73a8af0-1bcbb727134mr2697727637.3.1718806878609;
        Wed, 19 Jun 2024 07:21:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6b110sm10739431b3a.153.2024.06.19.07.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 07:21:17 -0700 (PDT)
Message-ID: <e8e718ca-7d3a-4bce-b88a-3bcbe1fa32b0@kernel.dk>
Date: Wed, 19 Jun 2024 08:21:14 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move features flags into queue_limits v2
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20240617060532.127975-1-hch@lst.de>
 <171880672048.115609.5962725096227627176.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <171880672048.115609.5962725096227627176.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/24 8:18 AM, Jens Axboe wrote:
> 
> On Mon, 17 Jun 2024 08:04:27 +0200, Christoph Hellwig wrote:
>> this is the third and last major series to convert settings to
>> queue_limits for this merge window.  After a bunch of prep patches to
>> get various drivers in shape, it moves all the queue_flags that specify
>> driver controlled features into the queue limits so that they can be
>> set atomically and are separated from the blk-mq internal flags.
>>
>> Note that I've only Cc'ed the maintainers for drivers with non-mechanical
>> changes as the Cc list is already huge.
>>
>> [...]
> 
> Applied, thanks!

Please check for-6.11/block, as I pulled in the changes to the main
block branch and that threw some merge conflicts mostly due to Damien's
changes in for-6.11/block. While fixing those up, I also came across
oddities like:

(limits->features & limits->features & BLK_FEAT_ZONED)) {

which don't make much sense and hence I changed them to

(limits->features & BLK_FEAT_ZONED)) {

-- 
Jens Axboe

