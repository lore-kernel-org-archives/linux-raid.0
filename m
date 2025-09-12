Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE4828C869;
	Fri, 12 Sep 2025 09:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757669262; cv=none; b=fy8+pthBzDfgB9KOFIjtvxx6GruCQ8lfjQ2mlx9XCUvWJ+yY7VLNvj7LTuJc2GQ9XchSzf23ru1v7luc116Lhz8zaIzXpvmYKmfB/BL2SMuzfSuZLqlFqz5FtFk9DJbRendKTW3cfS8uOikc6CNVb/xM5vX5ydVS/PEwCtFrtbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757669262; c=relaxed/simple;
	bh=720/zIWhAlDuqcsPVNMXqKSTawd7ur0AsR4/E5qvKlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Co0HYrRA8H0x+hAQo0qXvz/HwCCD0e6TcfCRPCLZJfXMoOnkhYqZS6kuw3aGB9w/JRxIdlcrerGz769JWzfNcq3hGt/LYcPbMLjfkdJRAcwDNzWNh6FK4FkJa2Fc0fxdjcsxV+L8ykIa6dboRaeEe0127EVd40IzJ+7yzdhtsBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cNTbr21c3zKHNh1;
	Fri, 12 Sep 2025 17:27:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A21AD1A12CA;
	Fri, 12 Sep 2025 17:27:36 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDXIY6H58No+SH7CA--.42419S3;
	Fri, 12 Sep 2025 17:27:36 +0800 (CST)
Message-ID: <f2e02c19-98e8-30eb-1965-27b4c50ffeeb@huaweicloud.com>
Date: Fri, 12 Sep 2025 17:27:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 2/2] md: allow configuring logical_block_size
To: Paul Menzel <pmenzel@molgen.mpg.de>, Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, xni@redhat.com,
 hare@suse.de, martin.petersen@oracle.com, bvanassche@acm.org,
 filipe.c.maia@gmail.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250911073144.42160-1-linan666@huaweicloud.com>
 <20250911073144.42160-3-linan666@huaweicloud.com>
 <3759cfba-93a3-4252-99a3-97219e50bdf5@molgen.mpg.de>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <3759cfba-93a3-4252-99a3-97219e50bdf5@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXIY6H58No+SH7CA--.42419S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUOo7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I
	8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0E
	jII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC
	6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
	WUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIY
	CTnIWIevJa73UjIFyTuYvjfUFYFADUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/11 16:05, Paul Menzel 写道:
> Dear Nan,
> 
> 
> Thank you for your patch. Some minor nits. i’d write logical block size 
> without underscores in the summary and commit message body, if the variable 
> is not referenced.
> 

[...]

Hi Paul,

Thaks for your review. I'll address the points you mentioned in the next
patch version.

-- 
Thanks,
Nan

