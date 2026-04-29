Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB41B382379
	for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 11:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777461066; cv=none; b=lYXKwE/HAXNFG2DY+fCKbpqHzslcNhRNcG/nymppW/gXT5WpYbk6BwguElOyO0toL7hX/nL4/K9wO1V5ozCs9NcFlD7lm75ebwgfMFzfo2+I8qHs6+Re11/oRiJdX7or0WUfH7TWp8R4HlVSigYbRbgY2ADvVteMAcsFYmUGWtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777461066; c=relaxed/simple;
	bh=OZfjfrsOIGNg2pYe2TcYF2uAizks6vjcDfRE3umDtw8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=jV2SGKSfElYEbgiy+nE31z2hMCZW4y+orfjqFjQmAlRP0Lx7QWBa3GUctp9CgKsZ2zCJhUIzirYLlu2+SUfJSdjBPjl/ciuI7jnFfGNxFnj0T9tNACX0KOVut+oxgJkWUAMFihKVGfGIGCGgaexBJ8NPmjn1XLHrcko4LYDmLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JjoHaoUQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ehdZe0Oi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JjoHaoUQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ehdZe0Oi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777461064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5XCYLZ13z0DOz+c/+usDPDwigS+pWv/1/KhNbmBtMnk=;
	b=JjoHaoUQq5T73eU3JLWsuBnhpSNf9LphNL3NiOJEbMNIQKQ4ljAut1vEkqlixGk5WqsKTD
	FfFxxMR46wktEUlFTEpeyIwxLmS9ekKuGoXa6QMipYzNjBb1+bj75io8r2BDoCrGpOmz6m
	XsYKl8BK8tsbj0QupXpeKB4R2w6WjHg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-LWi7DR-wNASHoqZsr_y5Cw-1; Wed, 29 Apr 2026 07:11:02 -0400
X-MC-Unique: LWi7DR-wNASHoqZsr_y5Cw-1
X-Mimecast-MFC-AGG-ID: LWi7DR-wNASHoqZsr_y5Cw_1777461062
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50edf0245b0so82057811cf.1
        for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777461062; x=1778065862; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5XCYLZ13z0DOz+c/+usDPDwigS+pWv/1/KhNbmBtMnk=;
        b=ehdZe0Oi83CLtCT25zMpBnTOKpep5LfrFLdWpZUbM921E6Giq0Q9AGu9Lu5vNeo+Sy
         l61ZsFw5Isu4chQf0GZmou2rTovTrnwVIZRMnwO4jbUdGs/aT0t7niZdjOFw9dA4ulzl
         4Xv7QkI9JFoROtTDrPa38BjMZxykXZ6w5OtHe0bXSwJaywOg507q4Ic2Z62yvcaZa9n7
         xCom4bIjbduHO/dsDIlaJCQ5JqvKroQcfP1T7JjmaV1pQZlZ6mlygdESZWbxLSx1xfjT
         AxS30/sFAMAKEpFxDe1eWWhVe3nzNb2Yios9NMgBYOTTRcHoCOT61MDI8xqfmALLSzmh
         EA+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777461062; x=1778065862;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5XCYLZ13z0DOz+c/+usDPDwigS+pWv/1/KhNbmBtMnk=;
        b=GtM9oU2QC6UzMEuk6Il6iltLHuaWcCU9zsHiz2nLkgrd1edm3VjduXWYu7bfk68ieE
         Nes/hhnozw1ODWzdyQ/THIH4Ppb0BniI9547vzHApLZzIob8mirA+99Wq7myhqMKYeIl
         fOvl/cy2mCxPCrBMHHuio2ZYmLgu5X4MRw7DsWN0JJe3bBlbj5TqdyyEJ/sXoJ9W1w8V
         8IUKpA8DYtHYvWU/994q0mOdTT9BbgZHMjT9brQg8WUv5ZMf+0hcHJf0ex8Ee2XcXNiT
         EzJS3Dx4zlnc+HyI348fxeJ44E4y31gsVDvML11wOi/B7uhRFGb5wZ7hr2ylswOKD5G4
         Oztg==
X-Forwarded-Encrypted: i=1; AFNElJ8IHfXmy3AbPlj5iI8K3/eQDgp4N99ghdvqBB07998Bk34SQ/jhxukidcOjXVTSyPcC+eoyI6tQ9jXt@vger.kernel.org
X-Gm-Message-State: AOJu0YxxS9mFRzffpzDAUTLrc0qbzn+V62bQFRWZx1A2OY65pk6IrKMb
	p+DAoxt4HwavKGxjq8wGRTux2cL5RKzutc7+en9GAEr7huQl1UzhYre9kiG6hDvCcgzTK9icwiJ
	t7QIKhvfYEuOdAI7p3nrMPsJRnz2QY+5lK2jbRobLMJ8FCCpdtXWQIo/0Qx3A5dM=
X-Gm-Gg: AeBDieszpCQ5Trdxp/HiZc9LmH8JLY0AdpXzJQO4cjOg/YZ1+/SMw8HOFN7e9f0s9Mp
	ZDX7Y4VVSCRFXIG9gsDb4ChHXYJq9cbqAMaetTD7YkPFV7wpXSPrNtrkB8JAAZZPAnbOGkBSxF1
	QSFNOC/HDLOnamWI5JhL3iGGiOzLZrid28+ryEGITJs3Yxmoj0FpZ72MXkZGkN8Q6xau9u26l9L
	pti1SYygRaIGE+7Nfrufb3+8WK/etvcfMuLJDhRrH/n/CGzva1aUOIM+B2yUpv2dkwC6RfZ45Am
	mAwBQZ/w/9r6cL9p3vMHcA8eeC3zFrIIikJXaMoHaLX42El2hASpHov8oMCTupDi8YuPW9NYjVH
	T8ielFBEge84tdoGY0IhyJS+RZ2QWMHo11sl/Xqrpd25coogLogzf9Q==
X-Received: by 2002:ac8:59d4:0:b0:50e:5eba:caec with SMTP id d75a77b69052e-5100e1ede28mr95099841cf.54.1777461062086;
        Wed, 29 Apr 2026 04:11:02 -0700 (PDT)
X-Received: by 2002:ac8:59d4:0:b0:50e:5eba:caec with SMTP id d75a77b69052e-5100e1ede28mr95099301cf.54.1777461061542;
        Wed, 29 Apr 2026 04:11:01 -0700 (PDT)
Received: from [192.168.50.139] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5101ae3ced9sm14644301cf.14.2026.04.29.04.10.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 04:11:00 -0700 (PDT)
Message-ID: <f861791b-d539-45ce-8575-5ec74d58d15d@redhat.com>
Date: Wed, 29 Apr 2026 07:10:59 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] md/raid5: Fix bio retry on interrupted reshape
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

When a bio encounters LOC_INSIDE_RESHAPE during a reshape that is
interrupted (stopped or unable to progress), the code sets
bi->bi_status = BLK_STS_RESOURCE to signal the block layer for retry.
However, bio_endio() is never called, so the block layer never
receives the completion notification and the retry never happens.

This causes I/O to hang when a filesystem is layered over RAID5 and
reshape gets stuck.

Fix this by calling bio_endio(bi) before md_free_cloned_bio(bi) so
the block layer is properly notified of the BLK_STS_RESOURCE status
and can retry the request.

Tested stripes and stripe size conversions under load comparing
files multiple times during each conversion (i.e. MD reshape) on
ext4 after dropping caches degrading the RaidLV each time and
no data corruption.

Fixes: https://lwn.net/Articles/757123/

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  drivers/md/raid5.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6e79829c5acb..9a3475429ef4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6217,6 +6217,7 @@ static bool raid5_make_request(struct mddev 
*mddev, struct bio * bi)

      mempool_free(ctx, conf->ctx_pool);
      if (res == STRIPE_WAIT_RESHAPE) {
+        bio_endio(bi);
          md_free_cloned_bio(bi);
          return false;
      }
-- 
2.47.3

