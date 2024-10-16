Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BB418B48D;
	Wed, 16 Oct 2024 06:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729059120; cv=none; b=cKWHYuAJlaecblBDIP4cPCwGF4yxesjBqrfs8jhW5XYbzybF6oIHD2QPZhft1Ob4FVLTpTE6On2rwly0k52IAQX+bcVcmPlQ6FbYYol8MiDEx99VAAjT9K5b+AJrLXMhFETcUqgIsEhEHuhQO6+k871Zj41Zb9cAjJZT9eMZtds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729059120; c=relaxed/simple;
	bh=WJQhxyDh49Oi3mVNN/Gzfxafsr66Em5h887y/4sZ1+A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=thCPpC7aA90YmMx5QYsuheYQBsrj14Bgq6vRklqNIfuOzApTwdSqlNhuRcnJA3cGdK3r0kcOt2k0UkRD+c7OrP8JjBuxNY3pdScujbmJAw7toSg3+fCUWldipAT6DpgBU5ftYiht2Vi+lx9zeIShX6jjOxtTvcap1b27xeT4M50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XT0wR13tLz4f3jXl;
	Wed, 16 Oct 2024 14:11:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 425651A0568;
	Wed, 16 Oct 2024 14:11:52 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAHPMgmWQ9nKsftEA--.45555S3;
	Wed, 16 Oct 2024 14:11:52 +0800 (CST)
Subject: Re: [PATCH RFC] md: lockless bitmap demo
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241015083557.4033741-1-yukuai1@huaweicloud.com>
 <Zw89BmLBF4S_nX5V@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <518660b5-4b52-b01a-c875-0bda9f75005c@huaweicloud.com>
Date: Wed, 16 Oct 2024 14:11:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zw89BmLBF4S_nX5V@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHPMgmWQ9nKsftEA--.45555S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYy7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF
	0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/10/16 12:11, Christoph Hellwig Ð´µÀ:
> On Tue, Oct 15, 2024 at 04:35:57PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Just implement very basic functions, there are lots of todos.
>>
>> Very limited functional testing(mdadm tests and some manual tests), and
>> following performance test for raid10:
> 
> Can you explain what it does?

Sorry this is actually just a RFT patch, Paul will help to test
performace first. If results really looks good, I will write some
documents to explain the idea and implementation in later version.

Thanks,
Kuai


> 
> .
> 

