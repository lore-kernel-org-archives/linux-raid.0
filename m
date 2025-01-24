Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9283018A93E
	for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737750111; cv=none; b=WXg484vrw4lS/6KmPicerNb3asE69BDx4HIZpeoKhRjLgHAbUVLr/e5RAyYxqFixklJYqAVtuCxdH+TZjTPch/UOw5tIUqwUNnTlJg7yUtukpKdVrvspu3ltcNnPKaBeIDKRI2xYCGtCTXRItTHCf/ME839lNi287gSbxV5mD3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737750111; c=relaxed/simple;
	bh=NBjom+0VR2ALmuOGZ4O3CSpFYZZk7mDD827O5lCVDYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r4V7dRTQEIoPNt1Ij5XDUsG0Kv24q5Zez8Zzu1CsgxVf31dwRfIEM45kpUnxsWOxYnpoq+HdYh3CU7zk63LFjWi3SDEHMLWQf2ZXzlIUlwqapY1RuNeikfImnvjMvAMOCue5iao8xuJ4P2xAunQ/F5LkbDJg8RrI8bOXfVV74g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RC25ESyU; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RC25ESyU"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso8126475ab.1
        for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 12:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737750107; x=1738354907; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J8p21TZEeSEsBdQTI1Mhi+6LHzIdPxcMPaf4odagn98=;
        b=RC25ESyUh44zoixdgPFAM4vCii3LmjAfpImoxHykO8p5IAosmbdBfrBAGidHIDBW5N
         tRRDISOQQXMElPOSmGYGr4DgvC7en7eJ0UJ0j08Tz9Kv1rwF0ZkaO5gBy9fKRC4O7NXl
         rYNWHEFBY3XVVKY0Su/kn8Ozh6895MDjPUvkhagWygt3uz7paW7SR248ueQTaWsO/FeM
         J1f8JloAdIWeS1ZCOKHUpZwRMm8BmqRVZE8S6Q9VLeM8ctf+yE38ZmGvwCanwCtwS+Ie
         ug+JV3zjO2gqL8MwzeisQdAs7G7BWUVj421zkH2yzaJX9lJHfsp4FrooBbaxaZxB8uaA
         ks+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737750107; x=1738354907;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8p21TZEeSEsBdQTI1Mhi+6LHzIdPxcMPaf4odagn98=;
        b=PgarvRqfEMPJcz2aOQ2t3khhW5TqdB3BEHwFJvWxqs7ZdtknKs8OuHc2cFf4kBvyF7
         x53nB2F6TnEve14TJNfjzTqPlsrmlwciFgirq868N8ctKX1wc9AEcKGCFFGl/rwDdu04
         5egVPi7cK9ankhchqkFGK7VJbEuNY6wzPHnyb1FiO4MipRWrXIet9+lnbStb4f7FAljq
         XoO/zgyZpGkaL6EeYerGhu639A/QyIACBvKSP5ARHof7eHkiXl8tBkUd5b2skfwuqX4T
         uvzE9GQBEjP8XIA7rNBBfJ9u/EAAN4taknx+tKcL8uZjNqWCGstH1tqRiAhj/fYKFK5o
         u2qA==
X-Forwarded-Encrypted: i=1; AJvYcCUROu/7vkH3+t8/jRZy1pRBfOuZIicQ9Wf21+r58J9YZpHROvrZ7Dz66m1yiTjTcRXKEsMcJZm8CZYY@vger.kernel.org
X-Gm-Message-State: AOJu0YwAddYq771AXIcmIt5QKjwQ5zPET/ommX3CEVJBmmAqe3D8idPl
	JsYmXSfEO8sbbnQYh9tHzd90ky4lcesc4Te6bA/tJgyZ5KZHJKBjIqOvHwO9Ruw=
X-Gm-Gg: ASbGncujQpOOhI5a6nJmHb1kVoQTon5DGKsdziSC5zjsrOPeAYQv3voAsTAIzycgfrh
	IIm/I2j+vJjhFXtWD5pUjnHwo7yUQgpiea0/gbkHcvARVLFkpfvI7A7UdQ3L8CEaZOsVpup4gwx
	qlE/8iFMtZp6LOgenWdtq80wkl9NYn9UrD/P+6KCm1lo3Rydv6jU+F0JP2FsNgGmqsd1dsX+QFq
	2qW7v4g1Im15bq6hK3vm4nOLksIfIyx8vLg7hDT0XonRuFpsFdUl2reltwslmR62915/K0FfrRK
	sw==
X-Google-Smtp-Source: AGHT+IGyc2u/gBjOT5BRixvmU0BoZiYZqez7yL/fwn3J/+LnNhKDosTL+GtYys41iiljuHflxdEHUg==
X-Received: by 2002:a92:c245:0:b0:3cf:bc71:94ef with SMTP id e9e14a558f8ab-3cfbc719579mr68330835ab.17.1737750107302;
        Fri, 24 Jan 2025 12:21:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da039a8sm835665173.21.2025.01.24.12.21.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 12:21:46 -0800 (PST)
Message-ID: <bf4a0bfd-75a8-4c7e-81cc-f3b69afba86b@kernel.dk>
Date: Fri, 24 Jan 2025 13:21:45 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.14 20250124
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Song Liu <song@kernel.org>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 "himanshu.madhani@oracle.com" <himanshu.madhani@oracle.com>
References: <FF2AE8AC-2831-4458-9D57-6660160421B0@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <FF2AE8AC-2831-4458-9D57-6660160421B0@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/24/25 12:30 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix for md-6.14 on top of your
> block-6.14 branch. 
> 
> This change, by Yu Kuai, fixes a md-cluster regression introduced in
> 6.12 release. 

Pulled, thanks.

-- 
Jens Axboe

