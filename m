Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6C1F8697
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738938248; cv=none; b=WewTW8LteYWzeBX2JGV1q1ELkhg0uW8ZihK8IFmgwLQ4BvTVTFkP6RaiwVImSa84R/TD6e+DzJODxQ/NPteNmL91sT2u3L9T9XrMMwOAWiROky7lv1z9MPIQ053xDpVt0HyncDmvIm9BKMQJ4stQe7Bz74ok4RAGD5CMRp0tOSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738938248; c=relaxed/simple;
	bh=xJiTuJ04x99xy159+jCyQ8Ce5WOYHm64JKzQsfK1esM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwWSP15zmPzlE5STFZ3J+zlssRJEtwWJ8k2j3YzVrKVDmmx/4S/dmsu8SmVNjPPw/5Rq1wNzIooZ+R2DwoElOxxgdikL4Zc6n4cYnb2BFPo8e5LQ8cE7pIJXxUKnwruIRkVR1qIKGuPflk9oad9hzK1c4NRkdNfrUBuNZHTg8lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T6KSDaeX; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T6KSDaeX"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3ce7c4115e8so10461865ab.1
        for <linux-raid@vger.kernel.org>; Fri, 07 Feb 2025 06:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738938244; x=1739543044; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2z7FCWRgHSptGPZRuDybBscH4GLcJ9CjjGFcobgapdM=;
        b=T6KSDaeXZZb0DVyXhbAYDAdOTiPZWqkco8F2PQDnqa38Oxg/tXaqyg3Oh7xU3QNWqP
         Xf691zedfrot5/6GCiI3tTatoYcvBzhzBc7yj+k4thqFT8sQ/ETPG4Ce6o8OEuyJ6cxx
         yYWrCj+5SJfoFVgeQ2r9FW7a9Fr+Z+BlOkUZ5ZcJxv9TZXQMX7SUP32Fwyw10Qf3GITv
         HcXEpU0yY0diNgJxEvXImGDRnm7iMZiYKZ6Ti5n30U8Yv0sSMU2e8AjVdn/5HMPB3D88
         w7ZTw9TfJOnLPv3oDROc3AFzTTIuHRcMNCFU6nIf2Vu5hpvYG5JhOMIxKJ9LAVWmpLNG
         eRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738938244; x=1739543044;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2z7FCWRgHSptGPZRuDybBscH4GLcJ9CjjGFcobgapdM=;
        b=NIFgAQBk1u+V7UpF1WTMTebCzkGHQrid5qiUiaI7v6lsW8oisMJnCBoM3iAYQkueSZ
         NWmsfWLyE/6qqWeyuRJKEUlOzELwiuoo46Fa5rjFxcb8MPzBcLl5d6VxDLvG0sxL3NjP
         O3SyXHlR1qudq8cXEjvM3Ubop75X5WZXPetCTgvnslnhXqkzgi9aSy+lDhBgStgwBulD
         4KP63qQqGR2lYcoeFbw2zH69iXS03njMGHju0JNynIC1EWJkeI6yF89dVwBTqZqGcOqF
         TMpReRcuaQNyC4L2UqXByT5M6DVMcreArKEu/dZgYKNK6FoLvcW5HVDXB4Vi3hx/OTP6
         N1kw==
X-Forwarded-Encrypted: i=1; AJvYcCW0oij7kLZZHGJIIP242KZwWcxbK6rzOHnXloJFDh/qDezOdRTx2TzscwvEq94Zat6eGNnqS1vP1kEo@vger.kernel.org
X-Gm-Message-State: AOJu0YxXoOs2dbivFT+GHdtgVIUejbVSsJ3pjrFuzHlXH3dHcli3Usbj
	UysJu2vA4E0Y3o42a//lrAtAjmwfn3o9rgMia150JKkLhuQOqt0jJfLYV+WBVnU=
X-Gm-Gg: ASbGncsrGV8qceXxM+unippP9v2qZ4LEz79kKZFU52562PLkbjs9YsgjoXd6HPetCIT
	QGRZz40CBnjLgavmYG4sD0Z5RISS5IW4yJEAdQM982r46xQAEw7QzUvRCohcyOWjLdH93XrJM6g
	Jxx+MccPYD+7f8BWieVtHOIomV2lPdiejRU4wE9N91b52Ip5lWts40ybQwNTqoWKxf9a304Vyq4
	ImkVoHz/RKD17MAJCJcZOM4YiX4QzgZFR6Ajgwg44VT43xGCVGY6PHf1PKjNsuyRaPESj/V78+0
	gJ0lEtu3gU0=
X-Google-Smtp-Source: AGHT+IFdeQSm08xhJzuYkPjF3l3rUJT+nvWE8LBNfyDmHn3Ue+/xncBTB1G+MDR0uW2Z8YOWVj0maQ==
X-Received: by 2002:a05:6e02:2485:b0:3d0:47ad:dc86 with SMTP id e9e14a558f8ab-3d05a6df6e3mr75511105ab.10.1738938243767;
        Fri, 07 Feb 2025 06:24:03 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ecda7e16e5sm376990173.65.2025.02.07.06.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 06:24:03 -0800 (PST)
Message-ID: <9ce78aed-ff7c-41b1-bd9e-93e53f94340d@kernel.dk>
Date: Fri, 7 Feb 2025 07:24:02 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.14 20250206
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>
References: <E81687C5-CD10-4726-9BBB-378CFAC323D8@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <E81687C5-CD10-4726-9BBB-378CFAC323D8@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/25 9:25 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-6.14
> branch. This patch, by Bart Van Assche, fixes an error handling path
> for md-linear. 

Pulled, thanks.

-- 
Jens Axboe

