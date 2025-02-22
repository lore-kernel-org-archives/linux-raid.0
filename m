Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71945D530;
	Sat, 22 Feb 2025 04:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740198842; cv=none; b=i45YeRB1RCrJdTxpmFpYTSlrpE4BD31nBTe1795L+HEBAlXf4s1jOChy/w/r8fOwyE75Thej97sNG0FJh9IGC/LU+inIlrpthmOIaUh3Qb9ar3iAXpxdFIx8T0TevFAXUFKCzRtxvMTW/04czvtb2VmYwAMXXWaa7nW2BM7oULA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740198842; c=relaxed/simple;
	bh=OyXKfnVF6dBV2H9HG8zJDsj21GVyXwOaR2UpUHOnis8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g31ic2drg3kitRPscYMQxDPmt7pPaiQJ/1oaREeLBcoYY72wuZS6jiv2b2RT+6NpaubB+eBVx6YwYxFwnQTpKS8NseaUPC7YdQzwjEPLm7Mq8nOPD8ie57tCyh5nQOSVko2kTnAKBw2KCF4RZfM4aMy4+gvUzgY1zpXusRdXx8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (ip5f5af50a.dynamic.kabel-deutschland.de [95.90.245.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6E69D61E64783;
	Sat, 22 Feb 2025 05:32:18 +0100 (CET)
Message-ID: <208fde77-d1b9-440e-9a0f-568ef1250a28@molgen.mpg.de>
Date: Sat, 22 Feb 2025 05:32:17 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] badblocks: return boolen from badblocks_set() and
 badblocks_clear()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com,
 yukuai3@huawei.com
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-11-zhengqixing@huaweicloud.com>
 <fe2dedca-0b71-3c80-6958-4bca61707fcc@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <fe2dedca-0b71-3c80-6958-4bca61707fcc@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Zheng,


Thank you for your patch. *boolean* in the summary/title is missing an *a*.

Am 22.02.25 um 02:26 schrieb Yu Kuai:

> Just two simple coding styes below.

I’d put these into a separate commit.

> 在 2025/02/21 16:11, Zheng Qixing 写道:
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> Change the return type of badblocks_set() and badblocks_clear()
>> from int to bool, indicating success or failure. Specifically:
>>
>> - _badblocks_set() and _badblocks_clear() functions now return
>> true for success and false for failure.
>> - All calls to these functions have been updated to handle the
>> new boolean return type.

I’d use present tense: are updated

>> - This change improves code clarity and ensures a more consistent
>> handling of success and failure states.
>>
>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>> ---
>>   block/badblocks.c             | 37 +++++++++++++++++------------------
>>   drivers/block/null_blk/main.c | 17 ++++++++--------
>>   drivers/md/md.c               | 35 +++++++++++++++++----------------
>>   drivers/nvdimm/badrange.c     |  2 +-
>>   include/linux/badblocks.h     |  6 +++---
>>   5 files changed, 49 insertions(+), 48 deletions(-)

[…]


Kind regards,

Paul
