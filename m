Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FD623814A
	for <linux-raid@vger.kernel.org>; Tue, 22 Jul 2025 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753181723; cv=none; b=gIzWK1Jg/w6fNzn5GlGgiLM7SjKXgKEjqzWjx5IDvKpN+qd01wCjYGGNRQqWncrcnfn+CyUwSGQzNA0rLI1+S0rFQ8jwi/SBuaRAKZPBnpCJrlvb5WMvQ7XkAW0ML9yaRfP0XZCEcMAiQkJDIebHMLvBIiwExCmVxbduiPVCnPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753181723; c=relaxed/simple;
	bh=cxrhgVlqrEpDmsizSqOK67WDOWpp97hzgT66JFe4S6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G48spevyOf9zTSRRzHgpNqoIxl2tnzAffMARQkZuuTMTMyPobZiKQwGVXFgmeCjtCEDmU2fMV3jF4PCa8cfhPBhpu56JPLy8f5NkqY+xYySQ906FfGZPkYsZ/0a89DG6nmUaTBJDGP3+l1Nsqk1AvmOlOVoiG+GLgWwYAc334cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lqUx4Q7C; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lqUx4Q7C"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3e2a7908838so11223225ab.0
        for <linux-raid@vger.kernel.org>; Tue, 22 Jul 2025 03:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753181720; x=1753786520; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kCGB4JVEWQPGbMOdFd5s/uKXIDZysHiJf3fGRU+901A=;
        b=lqUx4Q7Crra7KAJ2+l2baj65PnaHXz3rMpJ7t7QnJ5Ni9TcKWX4hywj6K/ZcNXgiZn
         dJMjSqp4BfrKQlI4Dp11fwHZ13AY2bzSuiTM/4ALfKiPhMLO3haq2BrccwYDi/eJ1qod
         2nIuG0+hFtI5OaWCYc9quUDAtEKJvq/zdY6ckpI2nz43vc8HmRXR4ugn5ErF5ex2bESV
         NEFNDSNQlyvH0CJ79Q+vlUWwHxkA9r4sk/nAkskU/4lwd2JfVmAGzdan3RLoEAbdaAqR
         p1XU8H3vLkRPkCrcMZFm/Jul6fQZgB3GGQoJVXLr44zuVzkc2z3ZmrmbM3ycJ4P3QxTW
         7NRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753181720; x=1753786520;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCGB4JVEWQPGbMOdFd5s/uKXIDZysHiJf3fGRU+901A=;
        b=KBvYrRxkEJ2Xd71fTYMK1KDCsCdEcWMnWcRASZH9FC6BUthRHyTJ6BERtstZvKBzr0
         y31I4W4ttFhfihjTr2o33608yKWjUW7Z++Rk949kmApt21O9pG8R0sDn6yg4HD+EpKv0
         9dy6hYi08fPvR+jJr69S5TehDOjSroQbLiqXjk2fGxu2jTD4hJ7a2dD3buf+1nWeHRgG
         1SdREg34bpK4LlmEREmZ4PbYHRbB/EtF8tGm74epRnza0d4cAxyJEEmW0mtUV90NK8qu
         3YkIG722BJmAb2ol2uLSkQ+BDGKFHQRSlNJViqZkXs85m1hV7R/lxFCfBum+kVq9tEmJ
         1VAg==
X-Forwarded-Encrypted: i=1; AJvYcCVvQpJ+0KYfK0TkgPWrQgt34gPoLclnaS7IQYVrxow0nc2cvHe3/J52oVL4oV9mhGxKpIgCXMh4eN2Y@vger.kernel.org
X-Gm-Message-State: AOJu0YzK2Kt2EBtcjWcg57FLHFvfQT8qQiAq9PiINbvk3KIGpUErL/qc
	dQkYVUgyPG2oLzn4YNFk/KY3hMOev9lIqnEIerJg/VfABF0wH5D6EauAXcxeGW1VdnI=
X-Gm-Gg: ASbGnctQdOpaSQj9cMD9U1hh/MzyhdVojA+wbGxX9Q3m0iRV2Rzpek0nNy4wk2PoO7f
	8kN6fp7dWmu1a+RtaD2h4F5Bhfg6AZ9ZG8eHgwKVy4zqX47HaKqB0g7Db06TNDT6XNBJ8MlNt95
	REYEpNHahsYH4aPtRdEeSZsKWPtnX1b+046uEZnr6FriSaeg15l8psgVHQs50wj3bqOunCRl5Ts
	gtk1KKFeXxS/YNCd9RfiGlrI0gRATW30TpZp3zRaj69wuCh5emi73ELK0BSKzBAd5W6CdBk8WYB
	wa2GVYcwzFSshsDUdqJyU7mDQ7f1gTOBANlA9BS5OyEQ0Os4UtPMt4Ofu9hhIg0IiUjs4E0DCGE
	ya/6daahKggnC3GB9JrCYDR9OQDqZ5A==
X-Google-Smtp-Source: AGHT+IFhGIhkcxG8WVotbt6GuS397VZJ1v/JxbuctxMMn19Zw3OkHAGOwUFZXV4jKwX3Dfh0UgFehA==
X-Received: by 2002:a05:6e02:370f:b0:3dc:804b:2e74 with SMTP id e9e14a558f8ab-3e282e66f82mr312708975ab.19.1753181720447;
        Tue, 22 Jul 2025 03:55:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084c9bb3e2sm2475025173.62.2025.07.22.03.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 03:55:19 -0700 (PDT)
Message-ID: <88d45974-8ce7-4f22-8221-7f6b9ea15c41@kernel.dk>
Date: Tue, 22 Jul 2025 04:55:19 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.17-20250722
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com, john.g.garry@oracle.com, zhengqixing@huawei.com,
 ryotkkr98@gmail.com, xni@redhat.com
References: <20250722060937.3547082-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250722060937.3547082-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/25 12:09 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling following changes from md-6.17 on your for-6.17/block
> branch, this pull request contains:
> 
>  - call del_gendisk synchronously, from Xiao
>  - cleanup unused variable, from John
>  - cleanup workqueue flags, from Ryo
>  - fix faulty rdev can't be removed during resync, from Qixing

Pulled, thanks.

-- 
Jens Axboe

