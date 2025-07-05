Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378D51DFFD
	for <linux-raid@vger.kernel.org>; Sat,  5 Jul 2025 12:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751718906; cv=none; b=EuuNadjzEeQAM+HokdnRSw8DS81gy01C40ra51fMnyMOFfTsuRzk/2L1rGwnJnIOrbhZw/eR+dHqzHyz0HqGp1AdfBWNMez0OsVBTiOPjE4zMJC6aKboNcjjp5hX8w0FDkLp6B0abIYMhNt0W6qsfvuoCt/4lQHMGm9MS6xozZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751718906; c=relaxed/simple;
	bh=3cEV4eIYEJPxXrKPRQyON/c4yTOuisZwuw9lhDsw3xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZV2lddhdH5sDoWDPPKXlhR9tsbzZg8v2M3liJZoOYNEB42rOPLN7gagl5vQH95raL38rDQd1/gyBm8NPWfSVB7GlWGlS6cBdEptxGDF9Ax7Wl9xKveDh7yKrnj/syecYvfMpJXWlMmfa3BRa2od6YOapzEmlTkDe6Nkfvi4T0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=liLOW06a; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="liLOW06a"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3ddb4a7ac19so6219215ab.3
        for <linux-raid@vger.kernel.org>; Sat, 05 Jul 2025 05:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751718902; x=1752323702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4F0kHG5wyIF2ScbCIWBu33s5LFA0JK2oxMlRyl8ew2Y=;
        b=liLOW06alKD/g0KLthDBZ09iAg6YNy9pzIfM9Y+hG18JB1Qab3haqFHLPV1eqluDUj
         b8t9Nb5Huu9IYgqvjT7TDrx7L0kH7evt3t5LCSAos59ZkE0bFyVCXkWcMlClBkfdJKhK
         nSs+obgPyFFE8+LRF8wzqJ9q71muVTRxvy9jZ6MJPTjPq3yKvHSmcUmKBi2d8gXRFS4f
         3wWbSU97QYxmA5zDkF8s4yO7o3I7n/fJSONBP3+v9R8msDQdj8U3D7w/G6agRNGL+1I9
         0X9ZH02jKnpeIKwaYPY1W66k3MRX16jj1NbQMPJWvNeKTYMuzM2NTiyTJKFpf41uyH63
         V9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751718902; x=1752323702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4F0kHG5wyIF2ScbCIWBu33s5LFA0JK2oxMlRyl8ew2Y=;
        b=SkDf0bqmztcYOjk5eUH8GOenaU6oUgi0JUD0nMik8HoKqTHSkUya7WS/uxjQXwsNtu
         hSBydfC7ZYQIYhYuuazW9UIDbo8JXJk9kalBUowboak2DBL1iovIGA2DHJ9E3DLVFFiH
         Zfi84maAWhBVaBJ+M6iLRnKOqYHTgZjQ+EpyYVs6Hmc9Lenk0aUUpum027Ym5GEPX76N
         4OeEEUF8CcZFuo1ewMN+cSSLQtF6l/UfGz5rb+8zGjmtAFLhxWSf4+Ba+3ym/jA4gYBv
         PN3Y569zLIO+ME5Y3G0wFaH/8yPALbJj+Rfo5yufF7S9ADDVSGmEyfVbcW1UNeg7EfYu
         KvWg==
X-Forwarded-Encrypted: i=1; AJvYcCWKaoEee2rEaPnnGp7lFdQWZj38ZlmzXch+Sxz/O/XSxKj4RCASCbGxdDxY44SVG+EmSYdhNuwC2ePF@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzya4bKl+FR4OPvmiClTOX4xdgc77HT2UA0ITBPBjOmN8Sm/Tv
	SfztX4/y5EhhSZLuBWNtFZ2LSdLvO6nrzEsBEXQV60mSISGqZ94LrbI22UW4qPpYh/0=
X-Gm-Gg: ASbGncvnYwFBJYxwEMm/M/3DVrvTh6ATuGvL4kmSQHehAEavf7OWHlQNAvhbQC1HAS4
	OUUbQ7ceThfK8PXSIboSd1I5bA2SSbn/LfA1U7rKFQ/3+S7cbUkGxVdNekGyLfJBbCQSEuN1n4q
	vX03QoRdI1OJRtQQggdkQfY4Fp3T6akl9cn/0iE8N5zr98KI4I+46Amub6VT7DDl8pJ3QI9KYdn
	JmMXgiVXRF+EXvEX7r2xBNCATUkE6SPyALeTJtgs7VxpSrWCjCRAJd+sl6p6LPJA6CmmsouMIhg
	hn+ZbkvQiYRrIFH+6PLimIBc4XcROMW9X4z46ZvwstTtH8oCkbv430aV6kJTePxNVw9XqA==
X-Google-Smtp-Source: AGHT+IFp16x7PpO0Ua13I7CPvOlx2hSh64N2ZPr/YY4VQt+yG5Sub0Vent6xl6d/woMo/YPtaHHAAA==
X-Received: by 2002:a05:6e02:380e:b0:3df:2e87:7184 with SMTP id e9e14a558f8ab-3e13ef15a8fmr20166135ab.20.1751718901949;
        Sat, 05 Jul 2025 05:35:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e1004eae7csm12261715ab.69.2025.07.05.05.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jul 2025 05:35:01 -0700 (PDT)
Message-ID: <05d35869-13d0-4b9f-88a2-14c1ae1608b0@kernel.dk>
Date: Sat, 5 Jul 2025 06:34:59 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.16-20250705
To: Yu Kuai <yukuai@kernel.org>, linux-raid@vger.kernel.org, song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com, haakon.bugge@oracle.com, zhengqixing@huawei.com,
 ncroxon@redhat.com, wangjinchao600@gmail.com
References: <20250705120732.6134-1-yukuai@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250705120732.6134-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/5/25 6:07 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling following bugfixes from md-6.16 on your block-6.16
> branch, this pull request contains:
> 
>  - fix uaf due to stack memory used for bio mempool, from Jinchao
>  - fix raid10/raid1 nowait IO error path, from Nigel and Qixing
>  - fix kernel crash from reading bitmap sysfs entry, by Håkon

Pulled, thanks.

-- 
Jens Axboe

