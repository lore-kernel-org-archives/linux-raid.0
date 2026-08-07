Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADE6346A02
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 18:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786128935; cv=none; b=aoKfr8lGfqNSE82BN+nAqIIRDE5eifLBoGjrbwUbTCXNhe+P90k66f0VTtEIz6FRU9wNDc89D0hxYWSO54LdZBCEzSl3Y0mPl+wRWxHjOlXuiemAdKTuZkiirortCPygQ2ofJSs0q33bRwb9UGxNBeM71VAWxDJUQToW3r/5YVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786128935; c=relaxed/simple;
	bh=rZik1FM3EDjIRoGpoOYJL6zQFjAFg8Op2LgtrMsyD0M=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=shQ9ssGZGna0KhpNI2GVINjOUDZZbRtpX6fkCw6F06v/oU23HvSQ61I0Emkj+BrIgRCTbKfPKjkaK/1ZMdw4Fqwm7czesIpjU20GyQZjHx3FBP5OW31YXUp6TGdntmDq0XD+7JSJID/muvVegwXkq6andPQlZExP9EqSUHFtmOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ScJlOl2i; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJkYkYle; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ScJlOl2i";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJkYkYle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786128933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GuoKsGtds12Ezb/VWfIAgeF2v1zeaKJdOwP5bMm2LdE=;
	b=ScJlOl2iXqGFng2usfOxI2v2qoFRwGu+I/saBgb+9iou2poAUT/jo0lZGL3Rj5XCUFQ0vL
	yNJjs+yNQ6KZmHL4zLwDva4NB0D3SuUPv4sfcA1Mr4Jm3z4fZzckUqosdzwGHTCf+fQd1u
	15SaxC9rRhuRMVgP3pC84BVT+cIMWNc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-ks-1g2NZOE6doQNlxYl01g-1; Fri, 07 Aug 2026 14:55:32 -0400
X-MC-Unique: ks-1g2NZOE6doQNlxYl01g-1
X-Mimecast-MFC-AGG-ID: ks-1g2NZOE6doQNlxYl01g_1786128932
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51a8b0a08d2so29298991cf.0
        for <linux-raid@vger.kernel.org>; Fri, 07 Aug 2026 11:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786128931; x=1786733731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GuoKsGtds12Ezb/VWfIAgeF2v1zeaKJdOwP5bMm2LdE=;
        b=gJkYkYle/E9S+cUBmz+zmtbPrKLJqFy7eZDR2jyO0G/D3FyFfAoTWLKqfkK1Vf80sl
         0gghCPBkQDhIzzRKZ+gglY8cHdJvVDSM2Yh9h/LU7DYbFKws4TqAul6dU6GSFHEOgw5S
         bPdMWJx/Z2Ja/Mf/xg6BR3V2tz5YPUOVslxAilUlc6ggUHH0H8STGs8sUlV7JAvXsCJs
         uCXlMQwnIsLRqbJHa2bctDsppxA424cJPsqVprZsODIdZll5I5Ry9DVsVIA2iPQDukD+
         4ERl73+4TqwaoaQyIPw7NvDzjO+UCaURtd6tnwzwWvBjEhnkBjf2PR9yFR4K6HRsJ10Y
         84aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786128931; x=1786733731;
        h=content-transfer-encoding:content-type:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GuoKsGtds12Ezb/VWfIAgeF2v1zeaKJdOwP5bMm2LdE=;
        b=E8DlChDAHUWAdCZwamrqHiGwbgZ+MayV0Cg2NMibAQ0mR6zWSNwtKqV5/lVFrK1YUp
         5L50VmkSYhlSfMoR9hJFiumapOjIfOUAVDuZ+tZj2xFQYOM96nC4+usKtVVDrVwULwyn
         WXEB7H1V9owqtAZvHoG0gBIuQfvHtY1kNIx5Pf6SIXh5r/Cst9O93L5I7QUIVQ99/Gnw
         TjdKEItYIRaeb3llanOl7CgnCV69hmWMWGFRT12Q18Cb6CfrkCxekeWOAH5MhMtqvUeX
         3CvqhrK4Cw3HUu+T2f09BdOOzWU9jF0M69gaEKXQqeqAgeNv5CrWfZ4xH9c/M5C3AzR8
         e6MQ==
X-Forwarded-Encrypted: i=1; AHgh+RrmTzvUm3DlyJeEXnSrZfGYxmUmGgmc8wRRKjYaFtG7EDEW8b3g89Mb7/NrT3IULaTYmMgbV5OQrTZa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9wANsCvM4g07MfZRqWiF9YwXQl3g3jADmTuU2TeyratvWe6Ha
	prbblJWCExEONL5v6OWT4sG8GKcTiuD5uS7T9aSoKAbdHReydnN6m+FXZle5oZ9nJs2yzZGHB3v
	0qOr0t+zR2bYL76YPRHNZrBY2wp7UJ7noTmDbvArntXgYTJVIxwTXi4mT9SNUSFicgxapNkg=
X-Gm-Gg: AR+sD13x3n6XE00+XpImZbEC9hqKPwp0SJXz+2QrKu9s9n/gObAzXZTxCJtGwMpqHS7
	zCy6s0bY8wzJMPfsS12vldhCu7v9UAb4R8nmxZhlmx4gfigO8jscE0YFw0MBbBA9fW3Fm5YrgAS
	mkfmfjwciOGU6clbefpFneairi6aCSiXnFnDi/RfJ1H4jtiL76L3tBNZSfTYFU0nCnAPjN2xe++
	HviArwe5cEawdcNsWq8lc39txVBfXksF2b1QaAGA0R7H8PGFgM4p8WyihDhohhI7rdYdSEZYoag
	hx0v4ro/+bbJWwS+pkquN8lTW8f57YhwwO0UPhaNSBX43XjkB7ItTS+xTc2MSw1nv2i1cvM0WSP
	iZ5AF7wngcG/3d4UrdmjJ
X-Received: by 2002:a05:622a:54c:b0:51c:84f0:d903 with SMTP id d75a77b69052e-52ce602d792mr256729801cf.17.1786128931540;
        Fri, 07 Aug 2026 11:55:31 -0700 (PDT)
X-Received: by 2002:a05:622a:54c:b0:51c:84f0:d903 with SMTP id d75a77b69052e-52ce602d792mr256729201cf.17.1786128931041;
        Fri, 07 Aug 2026 11:55:31 -0700 (PDT)
Received: from [192.168.50.139] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d1637fa5fsm18122911cf.10.2026.08.07.11.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 11:55:30 -0700 (PDT)
Message-ID: <e86f6b88-ea4f-425a-880d-a3622f3f458a@redhat.com>
Date: Fri, 7 Aug 2026 14:55:29 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: song@kernel.org, yukuai@kernel.org, linux-raid@vger.kernel.org
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] md/md-bitmap: bitmap pages leaked after recovery
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The bitmap pages leaked after recovery if successful writes occur
concurrently during array degradation/recovery.

We performed write I/Os to an MD RAID1 array while it was in a degraded
state or actively undergoing recovery. Even after the array recovery
successfully reached 100%, the disk status returned to normal ([UU]),
and all I/Os completely stopped, the number of bitmap pages
(bitmap: n/N pages in /proc/mdstat) never dropped back to 0, resulting
in a persistent memory leak of bitmap pages.

Bitmap pages remain permanently allocated in the kernel memory even after
the array has fully returned to a healthy state, leading to a kernel
memory leak.

When a disk is re-added and recovery starts, MD_RECOVERY_RUNNING is set
in mddev->recovery.  The else if condition evaluates to false for normal
concurrent writes during recovery. NEEDED_MASK is never applied to these
blocks.

Fixes: 4f0e7d0e03b7
md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
This is becauses removing success caused bitmap_endwrite()
to treat mddev->degraded as a blanket trigger for NEEDED_MASK.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  drivers/md/md-bitmap.c | 9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 1d4a050dab3a..b8be0d079780 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1756,7 +1756,14 @@ static void bitmap_end_write(struct mddev *mddev, 
sector_t offset,
                  sysfs_notify_dirent_safe(
                          bitmap->sysfs_can_clear);
              }
-        } else if (!NEEDED(*bmc)) {
+        /*
+         * Do not set NEEDED_MASK if recovery is actively running.
+         * Writes completing during recovery/resync are already covered by
+         * the recovery thread and setting NEEDED_MASK will cause orphaned
+         * bitmap flags and memory leaks after recovery finishes.
+         */
+        } else if (!test_bit(MD_RECOVERY_RUNNING,
+                &bitmap->mddev->recovery) && !NEEDED(*bmc)) {
              *bmc |= NEEDED_MASK;
          }

-- 
2.47.3

