Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9933BBA01
	for <linux-raid@vger.kernel.org>; Wed,  8 Apr 2026 12:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775652956; cv=none; b=KI12zenakeeLCdzgiQ+MVjqKJYhwpR8Q4pcUq+u8oiK99+5NTdd53OiZVQqX1eYc5BHr4Vn/ytK+I6VUmaZmMXWJ9SIQhfNORZlj+imXTeoU+wm1fNt15O60r0mLBz+3nZlBaA0OelNX3Z+xWSPsfnTEwWJVHudV0GZ1g4aG3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775652956; c=relaxed/simple;
	bh=OIKABSBSw94Ku6fqTn1LdS0SSYTwpVgI9+avoe/SidM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U8JaO03nn+bV/CuRYvZHLPWOTnFWopUVTa4deJyiR5RPA3mRhcpL0o2xIAHvqcrOU4BOFa8VYw8hh7wv7l8kQ+83PexsRSTrhJ/BwcaXRHGlkcDZySd4/o5qBh3RawYfGSTaDlWjqqWH17k+zTcDHxVm62MaHAx1E3fntLr1Y8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ptlwuXPX; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ptlwuXPX"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7dbb6c072f1so5122675a34.2
        for <linux-raid@vger.kernel.org>; Wed, 08 Apr 2026 05:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775652954; x=1776257754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iow//NWmkJUNLbZIPpYAtHvNvwATWc5t7TqLz0HDhJY=;
        b=ptlwuXPXmyvy9/V+JQkfFcUO7jPKtT8eEzwHPzqgpONZ/mk9wzXDx2c/sNh51hQmLK
         6ISxO7TquOo3ftSivBRH5/xCRl37p65pGfw8fKml6zOEVA4QISnJtIY4EiEr3QkLHcxn
         lROWeUmWXaDVcallTypi8Oq1mfARLTk1c6Vpa66JjKDyjHZPrRmDnGem75YKtsVSKuRD
         mHgxdwy6zgU5CnYoGlnPkXtRTGllNhbxFmhbok7RfMBhocFbsG6uzsNj7YPlfIGb7uPQ
         dlGSZQoad9R4oTb4B358uEnMOR1OdtG9PmP9VMK7QEpaCX7GqFd+RpCRbb++zVYPyb5z
         7ASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775652954; x=1776257754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iow//NWmkJUNLbZIPpYAtHvNvwATWc5t7TqLz0HDhJY=;
        b=rxkvLxY5ki8UaVj1QoCi9KRrJvJIvnobTR+oVhZbEvQgOK7wINtqoZfQa2rE+TeEQ1
         U8oEa4oQpaYjLoy2LSYh+Q+crOP+UP7oCQa/hF4DKgfsiveXT3+3sTwVzWg+j5R6g1CK
         5YUETj7dK+rE61np3Tn76Wib3VsuV0u5kqJ8P0TAsa0IyXg/n5PJkvCVliN4a1h4OJBa
         uUiFd3iLi0eXYx+ED+kp7qhCcvOlDIczCFp7tbIp9g5MEtnmrnpBjfGfkYlZl3KpK3NS
         LCt1RNsnee7SNbaoMDvDYr6tYgJGHS99kBbpyj0t67J/6MILOyRNDdOjJOlHcaZ+0Ljl
         J4ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWl9Jjlmh7AQyFex4rSxWD67NuWtiau62ctMUAwW83Z4CFPpjiW/+opkQy2UWaFoBBPEOgr4hcdVbuE@vger.kernel.org
X-Gm-Message-State: AOJu0YwqBv6vexV//fhYaefFLi6/Em3740xyDuOU8/LoV139WduttUjq
	imMyGhdHv2I0CYUZ6pJkqyOdvGGoo/KVvt9VUA8U8BFptI2Ub/n6+fWnMZyec2IcwGY=
X-Gm-Gg: AeBDietY0GfjlcEuHG4SyTUA3bmAE4Kaq8Uzs3qz/o9pss+PDfSR8/xZn0VaX277qFl
	uNC0illV0dEshgB/cqr2rfm4QU6Qhb9F6K8AX3SviDSiFl2u19jVKcwtHHYZ2EnnxZa1X32pbF8
	S6GFuanI41ae+so4sLTcqt0gmZjR+EZ6dFW27cnty5V222R4VWuX9Y1Kwiw3pSnQxzqG/2HKJl1
	aXsV7jYVnEtKvWeM7tqbZSL1D6Om9L4JNppKcpL6EuJrvpy9U+U3LsG6t55p1eQNBab6jkiZAnr
	g///6QTo1REo1o3Fm1qLMqw6CpaECMzG4FRhGjJbHoGEmKUoibwDC0ey9jLTuJNC6OPuNUCtRjg
	4M5jpT/FigftdrIAwBh2+/MJic8cDhSKYJQYvSqCngVT5MqjCy3Xt+tsUL9r0ugAZ8s/lk1RFJF
	Y5aLNcEdKWy5ueIDIofKiXqLDmk3BqLV4iLw7YYoCngoDoAh/y3uR1lJnljnaR3wOWSoxlifbco
	keehSfp1Q==
X-Received: by 2002:a05:6830:67fa:b0:7d7:c87a:4feb with SMTP id 46e09a7af769-7dbb730ef6cmr13869376a34.30.1775652954155;
        Wed, 08 Apr 2026 05:55:54 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbb6c02ffesm11588038a34.10.2026.04.08.05.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 05:55:53 -0700 (PDT)
Message-ID: <82deb095-d259-40ef-9e5d-c9542c2ba860@kernel.dk>
Date: Wed, 8 Apr 2026 06:55:51 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.1-20260407
To: Yu Kuai <yukuai@fnnas.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, song@kernel.org, linan122@huawei.com,
 abd.masalkhi@gmail.com, chiamingc@synology.com, gourry@gourry.net,
 moonafterrain@outlook.com, xni@redhat.com
References: <20260408050517.2109269-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260408050517.2109269-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/26 11:05 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your for-7.1/block branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - avoid a sysfs deadlock when clearing array state (Yu Kuai)
> - validate raid5 journal payloads before reading metadata (Junrui Luo)
> - fall back to the correct bitmap operations after version mismatches (Yu Kuai)
> - serialize overlapping writes on writemostly raid1 disks (Xiao Ni)
> - wake raid456 reshape waiters before suspend (Yu Kuai)
> - prevent retry_aligned_read() from triggering soft lockups (Chia-Ming Chang)
> 
> Improvements:
> - switch raid0 strip zone and devlist allocations to kvmalloc helpers (Gregory Price)
> - track clean unwritten stripes for proactive RAID5 parity building (Yu Kuai)
> - speed up initial llbitmap sync with write_zeroes_unmap support (Yu Kuai)
> 
> Cleanups:
> - remove the unused static md workqueue definition (Abd-Alrhman Masalkhi)

Pulled, thanks.

-- 
Jens Axboe

