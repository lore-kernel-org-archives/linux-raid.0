Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95C221A425
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 06:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749622628; cv=none; b=evVeCtJbB+biZp0U0xwo4r6R4LzZOdAKFj09MBPdAUpJBeaumsZhnyMolD5HBZvEw7cbCWsuDNu2nZLKjwuX8NSAhTZGXuMl7IymLQF5X5AfGDf8b5W3hhwMDNDvgkxlNe7aI55TtVNzXsnE/nkAbBa9z9gZE6x17XgWvfM38L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749622628; c=relaxed/simple;
	bh=ZkpCUWDDqVRBf9F/CL3iR7dzKrFy2mg2kwy27QGxydo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VRMZBnWAdKB9RHDVpujOMLi5Hkgs7rMzLguzOS9K5sqjAlKpSvvabcmpdEvxjsMBXospSMzTYTWHkwhmaKQtpFfE+FcYQ/PwQk85f5QsIjm2vLUQ+ookVJMa4Nn2Thes23mmVlCWeGuDMz6lnXpiY/wsA4AFMsCtH/FY/yHqWWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bHFmv5j1dzYQvDv
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 14:17:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C6A121A0F6E
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 14:17:02 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l5eH0loJW2pPA--.61721S3;
	Wed, 11 Jun 2025 14:17:02 +0800 (CST)
Subject: Re: [PATCH 3/3] md: remove/add redundancy group only in level change
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250610072022.98907-1-xni@redhat.com>
 <20250610072022.98907-4-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6183b583-aabf-be2d-de9e-35809ec6f8fd@huaweicloud.com>
Date: Wed, 11 Jun 2025 14:17:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250610072022.98907-4-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l5eH0loJW2pPA--.61721S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF
	0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUouWlDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/10 15:20, Xiao Ni Ð´µÀ:
> del_gendisk is called in synchronous way now. So it doesn't need to handle
> redundancy group in stop path separately.
> 
> Signed-off-by: Xiao Ni<xni@redhat.com>
> ---
>   drivers/md/md.c | 2 --
>   1 file changed, 2 deletions(-)

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

