Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794557484;
	b=mjFBIUMNXbhVmIkObr0XXKOJRT1iNeOKrbFLOw+Z+WIQnGn6OOnY1oXu67WHqfMaBe/+
	 UMXK0VHdwOMdbCTCQhviw5MM5H+DjSrIhInbAZFBDbSbj8BFAu4UWYoVm14p6sZtOmUs2
	 gub9Xhj/S5ok7ffD4zAM+JU/X7rB3a2ZQvFtfRLvcqrFQC7eCYO8s4lMN9rZjaMeYHURq
	 pgszm3iVRohE+j+0K3Dt41phCZTb/aDH4SS+98SOce4ixPMJNaWnAuo/DeCzNrGZP88RA
	 s9jNqS89Il3931phmcWj2P32f6amAYwGkzAUH2QKQvdroxmdGgUyBzdpClwgX5cJTFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794557484;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ky1fNcYST3cXVSIleurQJpPQOjWYx5UwkSzn2L6E/3w=;
	b=fpNsgEqFY+TAPSqDPIZCdcvDcVlCBUlURZ77szPXh8MOGTEfRvx0zL1otrd5Hcj8yQqz
	 VgHS0UJLF7BCKCRvjMf731sZ99V/qKNAr1QOwDowItmyOBRdsbCO9qqHd+URKamCx8EPW
	 7QRAUie+VRBix39kFft31CTPlvUoHejyoe7i+tIAzVd/h1pqB5iKCqJbpl4sFNUtHXRZ/
	 t9FLa0IpILGBuw2LVqNO5cHwQpag0G0+6IKaRm8SaQF9/0xL8olFNrqi4/D6kmts/wEZr
	 YL4Y8MgFrjk96eUEblJVxi8ZvuBW3XQNJF1OpQaDV3Awh31itCY9z31br+msz6RT5aQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=RoiB4+Uo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C1B606A32A
	for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 08:11:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49C1B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=RoiB4+Uo
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4cd28978b8so12029366b.3
        for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 00:11:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794557482; cv=none;
        d=google.com; s=arc-20260327;
        b=aPSeqGcq9HVK92WwKDoGBZiahJYpQhpMAbz0SJ8ZcHu1Z/lQQx5V76NMFEc25DISfY
         a6Fg8Ff3wNT38ccHFmsvjcyF6TTR28X+tN/cng/l6qiN99KnV59NFmcc3nNtk++Qx5vj
         b1B7bwnJkVmrvC6v1CusHx0E46xLo/0VDAikrEjYfpV1t1ebJ24KlNEOsMEMBbdYJeZc
         yToMbpW53WYdGmk0M3z1ufO3UV4L9e/lTbFXLpPNS5Azc1J2RTYRideLE1EZm2gGRx4X
         bXhcjkokCa8g/fJjNJ19stzXWdkhWXJOZUA5b1AWyBRZZjC60qMdL6BNQT4RHAqIefvx
         BLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ky1fNcYST3cXVSIleurQJpPQOjWYx5UwkSzn2L6E/3w=;
        fh=gb2N+dGgXDz1itFdRH8XFnf3/SGhiiV0gzGjtqKbRk4=;
        b=itnRKcAELYHwtBbpivcBSstrW/akoJ2mMKMNSCdiNMYsmhQeTFHliVFWRyDE9U5L0S
         53G0Pm0xfiJIpYLAabaAItAJbwWoPD4ykbeG+zCe9+X6M5c975qF/rNZBclHqYs84p3I
         xnzYdLKSf759em3QxBA/8AlcADZMkaJqmDt7S34gB207g1DiF9tLInqAe7OB7aSfGOyG
         seEcRjCuwpS9HwkYMTrnxryJWN95b85oyS30u0CxNPBSorJlmg7PHCUZj5tB5cuvVCe7
         vXam24yetFKF3LcV/q4YxqeE6KWjAhHGqsFNteE5b4+4tptPn/2bB/Y6ZrQ/6JZazjXX
         SPHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1794557482; x=1795162282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ky1fNcYST3cXVSIleurQJpPQOjWYx5UwkSzn2L6E/3w=;
        b=RoiB4+UoGSczVUtmvGGqpCMRdVCJB7IYCoFNsDaXMTFxQglY8TD9+u00qf9xfVBLTM
         OVUgTPCC25F+Ez/mrvl6dgpMVGIzbBpmJ9drIsW6Q8/HCtCMvvdBsAbH1cmmbBkAF/ye
         4GMeoWkKO6XKgzzBCJu6ad8YOym0QKOKJf3Zd+oceBCFSAeoiLl68MzvSGU54u3HPl3k
         MJ8UxTZ08ogM3OjhlkTAwNiK0rv1R5b5Q+EhfIIQ+lcA1+vQFiumEDay+FpnpOKcfrhe
         W/742E3xH6z0ccxiwYHGJ9YgELqSd1U/kuJHlJo7Wk7kF45PJ/vt5MNigvWAn4elvSAx
         ODNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794557482; x=1795162282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ky1fNcYST3cXVSIleurQJpPQOjWYx5UwkSzn2L6E/3w=;
        b=YiKRQ9fP7yqo1teMRn4Vylc4gOTNxVD+K5urB8xG/GDFIK5jOUnoVZDahkUdTBwtyw
         RJWnOc8jdsPHEizNnGRM17o05dRYqzvlD5GguCJJsouEW5tDALQ0dR5DKw/4Rm3NI7dt
         0tKo+lCZFRGih4nEwG88Apea6oxd8t6BIgSGX5kuPUp6ETgg8iG+CaahYgEhXlnjnsaX
         P6mhzAhaySoOeUKh6bvrdH8OlabGmpjHvFYpx3+RTrBxcFOUpbY5SDUjswsYwEerVAUH
         //s4Z9eRn42gVss8EsRmayUF1t/NsQ/x0v3g3at7v5qAxzK0eUJDI0S1U+Wf9lmq5rM9
         2HQg==
X-Forwarded-Encrypted: i=1; AL+hErFycl+nIa71UqhhnxLbayiGlP1ukxKMEGggSOXDd6sA94kzr1Fe262/6zmmbAodnvV/8zY2i+2GF5hg@vger.kernel.org
X-Gm-Message-State: APuU4Z9pV834nbtQqiEbQeQveg62XGJAH2hk6DwHjncHefDd8oLOaIjq
	V/jtCNUzNEUKdfI22o+LC/JSgCtQmF8DwEpGx4AYDs2Aqwt2jm3z+N/pOlvQyWSb+grrjbqOH3C
	hh2/wo6dXTCDnR4OUsNbhL888K2tEX+wyd/vS8sdfEQ==
X-Gm-Gg: AYBFou1SwxSOfgsj2Pe7V2w6PWktBAI41pdL2fPq7Znv4Hk4xWYm0dEFBdfupah2kA0
	4vjn9z04lqqKz0ePHZbNwcHBnqmTyAimGmwDFWqCzl+djEXbVw4ltMFWhSOmQuEgtv3pIXSebBm
	UeJjQAULvxhNfeZvgar1k3IXrosRlzHo55AAJLfs1EaLc/3XJupOyu/CODByG8alFUQ7d3qOPCA
	u02+2S/ZOm4O9bSXIrVNayH1LBaxsbVOhBMVRJqVzQdRPaEMcw7Hec7bsCwHCSRYqm9VbC7/EyR
	JmG52IyrbxME68SibDyvs8FIxFihOrMLmTqs9+D1ABmFAeh8eW27NzH5EuETXfARh//25VBBlWh
	CKmliUhY3Cu1p2A1jLzK03p5yzN3o+A7qx1ABErrLjHtjVu2cAwVqTx4X9elir2vGe//M+Q==
X-Received: by 2002:a17:906:f183:b0:c2e:3698:dbba with SMTP id
 a640c23a62f3a-c509642ceeamr126451666b.4.1794557481497; Fri, 13 Nov 2026
 00:11:21 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112134700.372702-2-jinpu.wang@cloud.ionos.com> <202611130354.oOiDWpa1-lkp@intel.com>
In-Reply-To: <202611130354.oOiDWpa1-lkp@intel.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Fri, 13 Nov 2026 09:11:10 +0100
X-Gm-Features: AclHuK_ijeVtZl53-Nr24xIboJn-g0mWRkSzGcLkYkpL9J_f9DfqfuDTwKSOTUg
Message-ID: <CAMGffE=bCVxcuDzUdGk=btfu-bdHhwofHQ6qkgx7UmQTpvSyhQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] block: suspend bio based disks around queue limits updates
To: kernel test robot <lkp@intel.com>, sashiko-reviews@lists.linux.dev
Cc: Yu Kuai <yukuai@fygo.io>, Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, all

I will fix the __releases(&disk->queue->limits_lock) annotation in
next version, will wait a bit if any other comments.

Thanks!


On Thu, Nov 12, 2026 at 8:18=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Jack,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Jack-Wang/block-su=
spend-bio-based-disks-around-queue-limits-updates/20261112-144659
> base:   6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> patch link:    https://lore.kernel.org/r/20261112134700.372702-2-jinpu.wa=
ng%40cloud.ionos.com
> patch subject: [PATCH v4 1/2] block: suspend bio based disks around queue=
 limits updates
> config: arm-randconfig-1002-20261112 (https://download.01.org/0day-ci/arc=
hive/20261113/202611130354.oOiDWpa1-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 1=
b1fed44d3dcca649a9877915d57c3357a98124e)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20261113/202611130354.oOiDWpa1-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611130354.oOiDWpa1-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from block/blk-map.c:12:
> >> block/blk.h:680:10: warning: releasing mutex 'disk->queue->limits_lock=
' that was not held [-Wthread-safety-analysis]
>      680 |                 return queue_limits_commit_update(disk->queue,=
 lim);
>          |                        ^
>    block/blk.h:681:9: warning: releasing mutex 'disk->queue->limits_lock'=
 that was not held [-Wthread-safety-analysis]
>      681 |         return queue_limits_commit_update_frozen(disk->queue, =
lim);
>          |                ^
>    2 warnings generated.
> --
>    In file included from block/blk-sysfs.c:14:
> >> block/blk.h:680:10: warning: releasing mutex 'disk->queue->limits_lock=
' that was not held [-Wthread-safety-analysis]
>      680 |                 return queue_limits_commit_update(disk->queue,=
 lim);
>          |                        ^
>    block/blk.h:681:9: warning: releasing mutex 'disk->queue->limits_lock'=
 that was not held [-Wthread-safety-analysis]
>      681 |         return queue_limits_commit_update_frozen(disk->queue, =
lim);
>          |                ^
> >> block/blk-sysfs.c:909:3: warning: mutex '(kobj - #undefined)->queue->l=
imits_lock' is not held on every path through here [-Wthread-safety-analysi=
s]
>      909 |                 blk_disk_resume(disk);
>          |                 ^
>    block/blk-sysfs.c:897:9: note: mutex acquired here
>      897 |                 lim =3D queue_limits_start_update(q);
>          |                       ^
>    3 warnings generated.
>
>
> vim +680 block/blk.h
>
>    675
>    676  static inline int blk_disk_commit_limits(struct gendisk *disk,
>    677                                           struct queue_limits *lim=
)
>    678  {
>    679          if (disk->fops->suspend)
>  > 680                  return queue_limits_commit_update(disk->queue, li=
m);
>    681          return queue_limits_commit_update_frozen(disk->queue, lim=
);
>    682  }
>    683
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
