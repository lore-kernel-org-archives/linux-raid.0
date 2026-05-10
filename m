Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACEF284682
	for <linux-raid@vger.kernel.org>; Sun, 10 May 2026 21:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778447814; cv=none; b=a1u2Qe+6gm6k3tM2FFRP2qYKO65SgO6XXR9TmOkDpjrPaH/1w7JANbhJSRqBdFmIKRhyxCe66PVq/AEz+ge/0E7g38AEiScAgkPf/uGbNDSNvXrw7e6saJxJqZ10SLsSwn44jfYqOqA3RulE5gn75KmT2dIK6HW6ad+/CZ2eOac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778447814; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oaHRA3zeWcHCZE7Gbzdy+muHT0DaAsitLjFy6Yx9zyeAELOr0apALd+Ujz4elAyNxG80ODccJ0OIYD1toeopbYccxGpsV5adeL6JQxurtkZX5Gcg9nnUsimVRfk8qGq6UED97UBlUEj/qDHDTJ6/gm5nhzqyB+2gN3JJsbUty3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so27467655e9.0
        for <linux-raid@vger.kernel.org>; Sun, 10 May 2026 14:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778447811; x=1779052611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=PFYG3BWSJjD/gc4NkcYhCogK229jnk4PQQT1MptdMpn8FmHNj19ThCyof6E6Woycpv
         FAN5yRZME1uUO6D6Q3Xu06RO8T6tTHEwP9VK1LY94/pZCz7P3ZwI0IXbCNHwDAW59AvH
         msT/zKrH4PbRNJZP248CkwZt2LDD6RyePINA2mL2A0m0Lwjs5J0tLH6Lox77rqYAmDQL
         at1VfphvnIDvorVESq8jAjzyaTIe9qjT7s21CLtbMfeQqnVPWMH0IcFqDIkdmh1KkbjK
         R7HAOxdaQ0tJLlTqykibmkf9XaIJIFr8N2A9/KntcwEboj/kczhVjTqYgrVBs97RSFL/
         6Q8Q==
X-Gm-Message-State: AOJu0YzVQ0ezlslQw+qDOelk9S7DtaPWmNm27lQF6o1vzbTiYLT0L++C
	HQJk5oYaaCoDQUV7okFYgyzM674Ws9xBh8nck5SjrQarBJNqACx0AVmIA2e66g==
X-Gm-Gg: Acq92OHqUZS017VaouIYo5K3KhAVpXVlkhsHV81wUKVH5fR2f0ayDuK5Igz0/fSk6dH
	zfG5DJ1znfLybeo4cwpRXSDFodXUaJoI3bweIhqGdD1qpSy0eqN0JvoG31dWjSY7sP+NvUT1Htf
	ogodb/zU1EH/86MO/dYrxfeQz7q8NO0PWk8PwDraHMo84U8fg4+HdFEwa5gp6dCfsZcfIIYqSWu
	edASgLucH/LuVNAed7Kq7RJbf7CbxWDysz347JkG1ZGWJZKknfIeXki0myuQwQ/hmNOLov+CNW4
	HfDyPOXtV/fu/iog2xQewulanNd/fl51t7FJWFnAk/9kYGj6grwqEbL08j2ytNCxKdWrZCGMydU
	LXpmuwo3fmvNwS6+pBfovnnB9uV0W1OY0FmIw06nxPq4q6SS8g93TJKz4ZN/2JnN6mDO0tD7KNr
	2iIww+z3z1VMJ3b8rXurEfXohCB43KtA==
X-Received: by 2002:a05:600c:444f:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48e5dfd6a6amr242969865e9.6.1778447811464;
        Sun, 10 May 2026 14:16:51 -0700 (PDT)
Received: from [10.100.102.74] ([89.138.75.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d895781sm87643525e9.0.2026.05.10.14.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 14:16:51 -0700 (PDT)
Message-ID: <adf158da-9488-4979-9fc5-73febeb965ba@grimberg.me>
Date: Mon, 11 May 2026 00:16:49 +0300
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
To: Chaitanya Kulkarni <kch@nvidia.com>, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de
Cc: linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
 kmodukuri@nvidia.com
References: <20260416212633.72650-1-kch@nvidia.com>
 <20260416212633.72650-2-kch@nvidia.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20260416212633.72650-2-kch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
