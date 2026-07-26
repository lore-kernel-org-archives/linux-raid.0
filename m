Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37437288C0E
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785092207; cv=none; b=Pmx4itU+UDHZObIaVobarHUc5DVEE+ctPy1ADsf8F9rbZu8nzV7WSJKrrQkQ9bNjwgd6NUaEF27tO4q0XcJcjOz0Obvd37c3rCm6u95OZfvbBAzmeGGkudc/il0AkpsELzX3LFnUuccqlDNXeV/63QGont15jR8gI16L8pYeTDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785092207; c=relaxed/simple;
	bh=PC9UbpBEosFiHmE8YA248xLUf2DTD2qxAB1rbceuJj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ily/xYKlT4JKTjzGDuGGxZcmyj/67YU1pmOqD1YitZq2W6ULhxDtwZ5QfmLcmoOJD8OJ3Q12en1kSjjZ5hRUYjVvT2y5CyFlkeMC08ZkLedLeFuqnmtGOt981bC2XB8GzRsmOBhZbtPqOn2XxXA2h54w+e7Cgy1qKTlMtApgkgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ofqwA761; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ofqwA761"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-495437bb891so18491425e9.1
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785092204; x=1785697004; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qupflK8iXoDh4KFHUKqHaRiN+EfApzg+gs90R8aqEB4=;
        b=ofqwA761HZL2q+szPl9D7B7EJeM46Y+T0p+SmixljRl/t4VngrVeoPeS4axMZsSGqz
         l+xoPu+3PAlXDNI5uEYQH0egDrgwgL9BEllxiDv5oepQRUqE9IxsnevhnwL1ZPMna0Xt
         EXL48h5CC6JYTtodo/CRe0QSWa+W2WOna2Arv/uNiqukSM7chNggtFrmxdzT+QBT15gz
         M5p1RC3b1Zdu72J5jojihRsvscxpl8zfCqkrusWdypcynA+BVe+jUGQa8zOhZ9jSXQe3
         F5ZfPc4/6ktOVlDCaoCFNqZocIAhzMXRcee4Nta7pOv8wqjm6mJ4LmzX+EvJ73Qtao85
         /o/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785092204; x=1785697004;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qupflK8iXoDh4KFHUKqHaRiN+EfApzg+gs90R8aqEB4=;
        b=HXESu/iK5Vw9L/M7E1lPhG+rTbMFkhDlaJpvnVdcraN5ReJe2a6993NYEN/kWM4wAn
         R0GauyNcLpBi+Koy5D+aOnn+YERwvoRFeo3hoKVPVcJ/t5lyNpYuQMtq5sRoc5/fFkL5
         9OYmlrFnptG/ofdv8zCle8M5lCW4e3SjyKVislaH4Pgf+olXydwf4xYf1Lcbh3zOdBub
         e2JAHeRcYdZ5PQmcsDy0RdsgEiUuT0tvZnIrTofVp9Z2IFL1t5zkX/f9UG2lICD7KJ+z
         12dRj6Etnwwhrgqa3ibu1u1vT4jTgSyJA27BONFuhTUjQjOR0sf6k85zhP9DscAGiVfq
         fZeg==
X-Gm-Message-State: AOJu0YyXnqHGE2Kc7KnN64D6CHcjpuQgrM2rAVjuRjETB8k4z7ft8PPP
	0X23FCdh1h+ls8niRDcN8xAF4CHds67UaCK3T+qk8OPyWH5y4jaMq1cR4mwAjmoSuA==
X-Gm-Gg: AR+sD12vdKfiujcpcFCpTo7P3o+bOfktTLfuUIUp6Piyq1vynGTdTLg2LlY15y5IllJ
	j8+DaEdr1LhUCRvvlAnJqmzr/DsqubJDAKPqTQhQal7Y91yjhNw+6NnAiEn4/fbXytMkr3Fd2fx
	AYec+RsWkbzYfhkjBBM9vg7/ctrGcr5qXfiNNEFj1XpiN65+qQcJbqawm1gQbC3SBtq2Kfob542
	GrV8lowaz27Dcilg8PHECps/606mSzfmMWrS1rWUT7YwollMGGxK4eHqHKoLTwOyEmzo2Epy+3o
	RYkjDuzrGUBNM592WGQZpuWPO3gvS+cBn/ciL6Fz3URaGvky8Bl00ckkGb32IWsDxbvGgKkYw8N
	mGFzWio4gSFQSTwbBiuDYG0GAAHC7etJ9s2PWfwLIG7L/FWvW3yO3R5B1v8wpNGruk92M8KHcRU
	gXJtp1vBxGeYS4p20BSVi3F6YxiS8nFGcNgrVdgPSUFn95mTYNVxQ6LeAMoS3LAQgIwMmHj6BIk
	3wZ4peMJD5SjXR1FqQTFVfieqg8s3FveHzJCk566rjeHGfOFE2s
X-Received: by 2002:a05:600c:1d0c:b0:495:3c6f:7c18 with SMTP id 5b1f17b1804b1-496b5b3b22cmr79955665e9.3.1785092203837;
        Sun, 26 Jul 2026 11:56:43 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f2639csm154318645e9.10.2026.07.26.11.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 11:56:43 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Chen Cheng <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>
Subject: Re: [PATCH v7 0/3] md/raid10: fix r10bio width mismatches across reshape
Date: Sun, 26 Jul 2026 20:56:37 +0200
Message-ID: <20260726185640.2222714-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260711100352.425177-1-chencheng@fnnas.com>
References: <20260711100352.425177-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Cheng,

Independent confirmation of the bug this series fixes, in case more
evidence helps it land.

While running a KASAN campaign against the llbitmap reshape v2 series
(base 55b77337 — unrelated to your fix) every raid10 grow under IO hit
both faces of the width mismatch:

  BUG: KASAN: slab-out-of-bounds in free_r10bio+0x97/0x110
  Read of size 8 at addr ffff888149044ec8 by task ksoftirqd/2/28
   free_r10bio+0x97/0x110
   raid10_end_write_request+0x260/0x500
   blk_update_request+0x18b/0x6b0
  Allocated by task 232:
   mempool_alloc_noprof+0x108/0x1d0
   raid10_make_request+0x18b/0x1100

  BUG: KASAN: slab-out-of-bounds in raid10_make_request+0x214/0x1100
  Write of size 192 at addr ffff88814da7aa48 by task fio/460
   __asan_memset+0x23/0x50
   raid10_make_request+0x214/0x1100

(192 bytes = 6 x sizeof(struct r10dev) memset into a 4-disk
allocation.)

456 reports across 5 grow cycles (n2, 4->6 disks, four fio randwrite
jobs) on the plain base kernel. The mempool face matches your 2/3
exactly: the 256 preallocated r10bios keep the old width, so any
allocation that dips into the reserve after the grow is a guaranteed
OOB write, not just a read.

The storm is dense enough that raid10 grow under IO is not testable
under KASAN at all right now — which is how we ran into it, and why
we would like to see this land.

We plan to run v7 through the same rig and will follow up with the
result.

Thanks,
Mykola
