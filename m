Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B081C700C
	for <linux-raid@vger.kernel.org>; Sat, 20 Sep 2025 09:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758362012; cv=pass; b=j69kqCanBBz9eMul3UoTSIDicga9or/5v26XQVHmC8fui68VmqZG8chMiAFwK8ceLwUokfAR62jBHtmBavU06vSLrqSk+/tk0gn3gUPRvb6JK3zg1NnRAcT2F6N33fNKxWk8MCAWJm9u1BeT+z2l6Rva3fBSjeLD5/zcQZDWCHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758362012; c=relaxed/simple;
	bh=6LYO5eSRpAz4W0I/RCePE1Y3jcrxYZFTdGG0g9j6lmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YLMl0evP/nMfzFfMgkbLuE5gfWkEFDhrFnC+BCucwS21el9JpY5CCwcFiwWByYq+bbi+jQQ9QdlWfVCtDEeZM8/q9e0jZJ33H+c3oFSo/ZRwdkso75BHiJgoMrctteM00MdyPvX2gxIe4uhCafoXSdwlKdHD7tgKuxnDgAH6P+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=GWcMkozH; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="GWcMkozH"
ARC-Seal: i=1; a=rsa-sha256; t=1758361994; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UDDyfVVsNZALSA/Y8d6Upjg8mhAfMbrzCsLmskjfoU15Z3LOj9vLMDgbMtecaWi+EeHKiaf1YiX2XL4xZxKCpOvyrPMTm9UbK6UdFhyC729VtG4HPp0FYPAyzDKLQybPXeDU9boDF8zxPvnL4o+S0hf5QodfW0n9OJNTp+c7urg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758361994; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6LYO5eSRpAz4W0I/RCePE1Y3jcrxYZFTdGG0g9j6lmQ=; 
	b=frx3yUfj4+mghRrQ0zQ+lOJcNwjcqx4C3JfxtLmFAn+9ZKJYvrfPt6BkeP51mDPk2wmhmVi5mIQDiUx8BL+8p2dAl2iOp0EODmn7W9NFwxWybTvoybvZKyh3j5Mby5SbRpGGHAxoUuV48ZzERnmBWn/vLUki9CnyFHFV8rsXpFA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758361994;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=6LYO5eSRpAz4W0I/RCePE1Y3jcrxYZFTdGG0g9j6lmQ=;
	b=GWcMkozHkHyMlI+ZjO7uTnDUrokHbgZr3mqnf3fDPMEbGyUl9QSmSXiOdwrOrRvG
	Q8QJBlKGnTJhNEV5S04QeRaTlK0CGy5d5igxNuSr8v8fM4aAoUe9//5G97R6N3yof32
	wXu3DRZaZ4OJOJ7nX7/4lF2c+77CpD1OwyxrIeM4=
Received: by mx.zohomail.com with SMTPS id 1758361991728211.4295895095113;
	Sat, 20 Sep 2025 02:53:11 -0700 (PDT)
Message-ID: <0fd8946a-e10c-4b11-8fc1-7435e4dd77b8@yukuai.org.cn>
Date: Sat, 20 Sep 2025 17:53:08 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Factor out code into md_should_do_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>, Wu Guanghao <wuguanghao3@huawei.com>,
 song@kernel.org
Cc: linux-raid@vger.kernel.org, yangyun50@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <e62894c8-d916-94bc-ef48-3c60e6e1fc5d@huawei.com>
 <d668bc92-e59d-a571-fec7-4e3a6df24b66@huaweicloud.com>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <d668bc92-e59d-a571-fec7-4e3a6df24b66@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

在 2025/9/11 14:23, Yu Kuai 写道:

> 在 2025/09/08 16:20, Wu Guanghao 写道:
>> In md_check_recovery(), use new helper to make code cleaner.
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Thanks
>
>
Applied to md-6.18
Thanks

