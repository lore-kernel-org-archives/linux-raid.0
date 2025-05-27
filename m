Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA5E1C5D61;
	Tue, 27 May 2025 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336433; cv=none; b=f/gwbqF+LvTKYp5LpwDLiDmLz+6vnl5BDJ4e2xIY3aImPqYiKhvNOgTa2HjpU/tTTIdeiquRnHTVbNs0auoqiMVeleNmZgD/9341TnouOjbhiMR9Z0hyhS+c1WPwpcvF14t9yWroByKrNrHSTPpVmVjyZZ8ZBv0H3I+QbsfgvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336433; c=relaxed/simple;
	bh=vTxtSLPHRSprqIwcwlQ7ULXrGnxhvtBnoPuE4aZbL4k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ly68Fh0T5a/ENcu7Phiwk55caXzB6Zndrx1l08RudLEciG6DjIeVmVFM1K5AtTGCyzT2+eTWDKIffADlDYfze+cQ04v8tR3OsQWOz8HNmJaEpGtFvMXdX5Kh8EyK2Z/6GfrjOqy7Fo90ILy12gkZgC1Snt+vZMLLN2FZtuZ9P2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b665t4xHDz4f3jcm;
	Tue, 27 May 2025 17:00:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ED3571A07BB;
	Tue, 27 May 2025 17:00:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m18rfzVolkmiNg--.44075S3;
	Tue, 27 May 2025 17:00:27 +0800 (CST)
Subject: Re: [PATCH 23/23] md/md-llbitmap: add Kconfig
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-24-yukuai1@huaweicloud.com>
 <20250527082911.GB32108@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cd0b3e69-40e1-62e9-4229-8fcf49b189ac@huaweicloud.com>
Date: Tue, 27 May 2025 17:00:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250527082911.GB32108@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m18rfzVolkmiNg--.44075S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYN7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	W8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7V
	Ub7GYJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/27 16:29, Christoph Hellwig Ð´µÀ:
> On Sat, May 24, 2025 at 02:13:20PM +0800, Yu Kuai wrote:
>>   	MD_PERSONALITY = 0,
>>   	MD_CLUSTER,
>> -	MD_BITMAP, /* TODO */
>> +	MD_BITMAP,
>>   };
>>   
>>   enum md_submodule_id {
>> @@ -39,7 +39,7 @@ enum md_submodule_id {
>>   	ID_RAID10	= 10,
>>   	ID_CLUSTER,
>>   	ID_BITMAP,
>> -	ID_LLBITMAP,	/* TODO */
>> +	ID_LLBITMAP,
> 
> Please just drop the TODO annotation from the initial patch.
> 

I guess this is no longer a problem with one single patch.

Thanks,
Kuai

> .
> 

