Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317D11DB142;
	Fri, 24 Jan 2025 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737709882; cv=none; b=Bkg7KlrqdTPSIGL+WjjVhJlRoJqbaLs18O1T+1qQPrVkFIX0Hr9SWidBz/Ww7cE6/0jk7IlwiiKbZu0UoIjrWZbNNwq0PUXCAWhALmhyrV3fwL6uF/V9RZvPZFvwhhmAJYJyIIygl7KMzr509wwzUonf9J4ArqWnNg0JT+93cPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737709882; c=relaxed/simple;
	bh=BeBaoBEzXBskGwRBeesggArCD7gBQe/f8BK7SOQUSSI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fDxwavG0ql/HYqEjm7Y/D3IM0mFdYV8dyQjKnRPJtbOf1YS/hZYQYwGAJsm72m6UwBGChr7ZY5sqm7MoUhcR3CKqdHTdITcAMPiK2cnEHyfCoca8Os1VxFqyWU57dCEKhLRCMDs+KhcCayVv60H6zjwtpD0A79KPcZkwFPscwoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YfX9C1Sg6z4f3jdg;
	Fri, 24 Jan 2025 17:10:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DC2661A0CCD;
	Fri, 24 Jan 2025 17:11:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgB3ysQxWZNnSItGBw--.22094S3;
	Fri, 24 Jan 2025 17:11:15 +0800 (CST)
Subject: Re: [REGRESSION] kernel panic at bitmap_get_stats+0x2b/0xa0 since
 6.12
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, LKML <linux-kernel@vger.kernel.org>,
 linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
 song@kernel.org, pmenzel@molgen.mpg.de
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Darren Kenny <darren.kenny@oracle.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ca3a91a2-50ae-4f68-b317-abd9889f3907@oracle.com>
 <e6b8d928-36d3-d2e5-a773-2f73b8f92bbc@huaweicloud.com>
 <6b72aec8-cc23-27d1-38ae-827bf800f21d@huaweicloud.com>
 <48589759-88c1-4d13-9f08-321484180a7f@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <92e93025-664a-2312-c856-681f8cb55a3c@huaweicloud.com>
Date: Fri, 24 Jan 2025 17:11:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <48589759-88c1-4d13-9f08-321484180a7f@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3ysQxWZNnSItGBw--.22094S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	oOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/24 16:13, Harshit Mogalapalli 写道:
> Thanks for the patch. After applying the below patch the problem is not 
> reproducible anymore. The boot succeeds without panic.

Thanks for the test, I'll cook a patch soon, with following tag:

Reported-and-tested-by: Harshit Mogalapalli 
<harshit.m.mogalapalli@oracle.com>

Thanks,
Kuai

