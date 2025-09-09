Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4157362093
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431697; cv=none; b=r0uqcJ0VZjcoZj5thsrywawDChsjgHDMFUZH+5n6mVn6KKBgHL0+d7J0Q0sP+OxmwaAT8FSdxF2mNgnVkHbhJsG2g0+1jRfro94hX3npKJSjlRV51a18sKTKzE389i/GjtGj5yx6p1bx6FbIhd2AbhofVkdk2c6NZJrqn9O+vKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431697; c=relaxed/simple;
	bh=zdmMTS66pDXSVVeEoILIIh+RFkwTTy3dD9US6WLNHvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iicBK8msw9yqIo6JzAk806sVyHbCjrsXl6A8tWx83XAnfTVArW8JpeuEIoYhZfBiSnVwfXoecKbLkIaBYGSLTFfH2j6y3MlgSJhVrwkMgqL7WGjM6/96A7xpBrwDa2GjP9cWNB11tcmbEG63EBvqimN5rx4o11PcedDfDDRL/DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WnE546bA; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WnE546bA"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-88735894d29so207789939f.1
        for <linux-raid@vger.kernel.org>; Tue, 09 Sep 2025 08:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757431695; x=1758036495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jN1Kj7K7CkcC2gypxZGow6Wd+LfV+1NytZv39KYFilg=;
        b=WnE546bAGlo5G+8fg8jwTZo4lmsOMgNuGpIiLHtxNJ8GJ7O3Po14xHWH77y80XNtmG
         TjyfjohcywWIVVHmy70qFv2w4685MgZSg4ec/xc39NOAtoAxWSPJW4CGL6F+V+G7Gvaf
         Uf0d+Lv2fg2cqeIdD+0ln3wa0nCHnoZiImMzinbEyh7DIzvILb7/oHvq7mTtEnBPSVxK
         xH7m4MlU06X1aUwaV1vcjgokNNf8wScfBjQzp50AwKwqMk/SSowjDIa9N+t4o/00JiJl
         W/kIGX4EKBUjQktsif9voUWtpzY5ruvCxLcJM/H7Sfs12ReWECAitqF9zdhiixW5xgGp
         xPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431695; x=1758036495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jN1Kj7K7CkcC2gypxZGow6Wd+LfV+1NytZv39KYFilg=;
        b=FppR4OZMqF26Lh18mB3j/ekCtwewgF65BSAcwHpAwp0c2oQsm2ItflP2ffte8SSdt9
         J7jObqRIYGG4Blto8uuL5Pc9t3DbaTo0m8gESQlo1CoJ3qpq04rVMIlaRWRK77OoWGXO
         /m1pfeaWE5PKNBtBXZJ4vpQfrChTm6nGpfS0z8WUZlQTqS+CvnAR5AK7Uy99Pk12h7td
         Yffs13ckveYhOuV6SrnTJq5pkJIVlynwPL59xkB07gJEgn8AlDu/NLnCHnlnZ4kCvuT2
         yUFskO33Rg/83TFdkkQ2jHL2gKwQEF9lkoTDYHWCQUYbT49as5ctwhbn5i1hy78Ri6Cv
         wTVw==
X-Forwarded-Encrypted: i=1; AJvYcCX1OL8tCmcfyFvzNVUxW6CtsSnBBvjvF74RKOFJh2NJDvodMMkYyDcoVk1Zm0vsYpM8g3crHrzBQvG6@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/LwzUpcbGuie8YAsd0YXohcmY1h6j7wf7SiVqaTOPzJ38FYKV
	weJbOub2K0kMNpNbMsjsayi/tsCOG8zSGfGQpUsTiaZkB4et/MwKyCvvpbYtRshXhRM=
X-Gm-Gg: ASbGncu0Ro8F7JsvsRToqzaeJBsvkZejie80MkFHvw0fstwPdv5SDewiukLrAZQ+wAf
	AvnJcanjYyTAr7Qk28vACxIKCMq8sHhGWqnRgxtGr3tdaYPRk20SCMc9gMu93SoRjhABG8o2iFl
	uxp7vQDyfo9x/znOfyFb+JIDxpAylAJYZv8Jt6qaBkaV5hVbX+YnRwsriFwuiJ+yljDnqWCVdBx
	QF6tf+5b/qpkbkZZX7fr6pUo0XBqmXN/NZCaOTXhCAV8v/VWRFhvEyID7B9oLAUVZwH9NxUZ+BI
	gmEFSpnTYeYcdB1HZ8BAm6AGorrj5phlWudg+SwnjvXxQyFfkMAdMNu1Lx+Vwf+Kw+9XRmTzORm
	1JwKVBgctwDSLfbQ5i0wIxu0Zebu9GA3nHLnavAHk
X-Google-Smtp-Source: AGHT+IHxQYn//P6OlMBv4Hjw7zsJ7Uk1Uew3KWJj5QRX2MyObcGnhrIGAx1/Aj6Ur5T/j8o5uW59sg==
X-Received: by 2002:a05:6e02:1d99:b0:3f6:5e25:a5cc with SMTP id e9e14a558f8ab-3fd87781510mr141362695ab.23.1757431694832;
        Tue, 09 Sep 2025 08:28:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5103baa86e9sm5847043173.9.2025.09.09.08.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 08:28:14 -0700 (PDT)
Message-ID: <165f4091-c6c9-40f7-9b41-e89bfdd948cf@kernel.dk>
Date: Tue, 9 Sep 2025 09:28:12 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-6.18/block 00/16] block: fix reordered IO in the case
 recursive split
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, colyli@kernel.org,
 hare@suse.de, dlemoal@kernel.org, tieren@fnnas.com, bvanassche@acm.org,
 tj@kernel.org, josef@toxicpanda.com, song@kernel.org, yukuai3@huawei.com,
 satyat@google.com, ebiggers@google.com, kmo@daterainc.com,
 akpm@linux-foundation.org, neil@brown.name
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250905070643.2533483-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250905070643.2533483-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Can you spin a new version with the commit messages sorted out and with
the missing "if defined" for BLK_CGROUP fixed up too? Looks like this is
good to go.

-- 
Jens Axboe
