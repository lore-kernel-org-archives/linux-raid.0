Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDAB284682
	for <linux-raid@vger.kernel.org>; Sun, 10 May 2026 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778447823; cv=none; b=Vl2qgvnLfhVeJnOXw/8gqhA0m7aiaQ4KD/0DWsFc2M0re1P+Mg6erM2er01r535aD+/JK/jvGEzszUbghrnPIPL4wuchKow3NlS+1NoSjVuhCA4L/yyb00/uLlt61U3OcW8OAcmQ5Dye6Pkx8/D5wtXgxU059BXkBFJG30pvKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778447823; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pToz6Dwfqee+TXZkvR4suuQKwv/YdWCYhdi4ISypWtAe99Q0KZzCzyrsmKuCztOYar51fpbJTpW/1yMMOFSiwaYCALNiZ7N8H3CoTcgbBeWSYaCeVD83BliFT407BSKvmYZu0YU9A9XJdf3ZZF+CKus63G/61oHeHJzYSEaTfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-449de065cb3so3398086f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 10 May 2026 14:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778447820; x=1779052620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=s2z5t7vdt4bgXVPF50r8UM8wvU4rXv0URqt1DHGgtFInewsOP8LUOB6HW6q5h2XxFb
         EhsT5pcSfVF9Fu0n4O5XF1LaZJC6MQm1VC8aBljS380Eg9oBvdq+3UZI2eYeHllujiDm
         K0UDSrUs20ldACb/SPYGS2x0IKaVAD8J4y4Vrm6i0UN/tozqVkrE9b60tqOpiT090Elg
         oe81V4M11E7r1NgY7hCP76MXUM2RgJ3ScJaaV9ObcpXeUDFPKQIRE/bWBkc99urTAI+w
         HfewFwdOI4TKb0nbEPe6LCztPXp2QI13r/fvLl8JWw+s5iiwJCFeL2Ja8RBYaRlgxBpd
         hz3w==
X-Gm-Message-State: AOJu0YzD9DDTQL4o7KZrIeEBqcmMXhPNGzPloNp72s6E/QfM7MNzhDHx
	2fOVUnlOp/Ck8gk29mfVfts8PJHj9C8AxG+pdNG3nlPWVT1jn0lNYv2y
X-Gm-Gg: Acq92OFHEBP94P1BoRCUWCvH461TH4Sn3MYzZlVAgCX3Q9c+45Bi6/268DHUH3BfY0/
	DkXjgj97rhw59bvhCHGvY47jckL+gvclq3eaq12vOweGIFAIfEXinEj4wWNJPc9jWU43ptxjcGF
	iV38vlumerLqNPuiqLhd0kM9ghKshtxfMyCK/Gp9a+7UoEbrIhdJmV/5YDgvR4aB7yzzF8jgwCq
	KQ6ECH9Inv3vesRrzdA+qRcMh68xHQGEEEWFKYBmfQt7xWelVq8Wxcep26YlN2a/BCUKX6uYb3y
	l7AWY87rz4McbSER47Qg+rH+dohjpgBMayvYg3IYuVXXSX9NKjwgA5X0yDjJ4MsnBux+QE1mus0
	3KNsoc/uM8mcLjqt85Wunh+aYXcMFDqSPRqmYnArXhx5tOirxz4SMxLQ4kKwgyVcyrcecpyqr/5
	d2m4oSqlm1Q30FzXxLJ/4=
X-Received: by 2002:a05:6000:40dc:b0:43d:309b:9c4f with SMTP id ffacd0b85a97d-4515b056c90mr33856929f8f.6.1778447820304;
        Sun, 10 May 2026 14:17:00 -0700 (PDT)
Received: from [10.100.102.74] ([89.138.75.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4549120eab7sm20199922f8f.23.2026.05.10.14.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 14:16:59 -0700 (PDT)
Message-ID: <dbdec07e-1567-4107-90dd-530181a7d369@grimberg.me>
Date: Mon, 11 May 2026 00:16:57 +0300
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member
 devices to RAID device
To: Chaitanya Kulkarni <kch@nvidia.com>, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de
Cc: linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
 kmodukuri@nvidia.com
References: <20260416212633.72650-1-kch@nvidia.com>
 <20260416212633.72650-3-kch@nvidia.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20260416212633.72650-3-kch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
