Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6064333E1;
	Mon, 23 Jun 2025 03:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750649217; cv=none; b=PptiwfAVMPMYsTx5jZwXBMh5fuq0ebgQZVU1BRwr5bAKb+WVwoYf/AKaT6NFg5XSCnWDbgE0L4JYw3UpxvDntdLDNrpQfmT0Jkkn/15HX29LWfgKwqflPAHnTLE1imVacen7498vhkzxnt1zAFLiPF+Wh+XDQY/OP0SDvaHe1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750649217; c=relaxed/simple;
	bh=WdmwsV4RrM53+CBdi66ef+Ad/UizQrCayWPkdNZ5Ado=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=STJyxAmpXmXnTGPjdDUD+wqBKd7pnq2ELzfeTnHQHE4KoNGkBtzEngUGLehwc6wdx7bdYfY3/PJcqc/O4gTZkb+WUuIwYJ26Rawp9slpnnpSmxFy8axC4EwwsZjE5LlCzaKSPP0J9fgxn0yggr/1exIBU/I4wynUJ93JasYlMhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bQYQt4QtXzYQtxQ;
	Mon, 23 Jun 2025 11:26:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8945B1A0C2F;
	Mon, 23 Jun 2025 11:26:45 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3219zyVhohsx9QQ--.62896S3;
	Mon, 23 Jun 2025 11:26:45 +0800 (CST)
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
To: Wang Jinchao <wangjinchao600@gmail.com>
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
 <35358897-5009-4843-8234-136bd5756e0b@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dd532c80-2597-deff-4a3e-3d8ce88cbc19@huaweicloud.com>
Date: Mon, 23 Jun 2025 11:26:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <35358897-5009-4843-8234-136bd5756e0b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3219zyVhohsx9QQ--.62896S3
X-Coremail-Antispam: 1UD129KBjvdXoWrurWDXr18Gw1DXF1fuFWfXwb_yoWDGrc_CF
	Wrtay7KF43WFWxJFy2yry3Zwn8trW5AryDZF40qr45X395JFW5Jrn7tr97Wrs3CayrK3Z0
	kw4UWa17A39aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/23 11:18, Wang Jinchao 写道:
> Comparing mempool_create_kmalloc_pool() and mempool_create(), the former 
> requires the pool element size as a parameter, while the latter uses 
> r1bio_pool_alloc() to allocate new elements, with the size calculated 
> based on poolinfo->raid_disks.
> The key point is poolinfo, which is used for both r1bio_pool and 
> r1buf_pool.
> If we change from mempool_create() to mempool_create_kmalloc_pool(), we 
> would need to introduce a new concept, such as r1bio_pool_size, and 
> store it somewhere. In this case, the original conf->poolinfo would lose 
> its meaning and become just r1buf_poolinfo.
> So I think keeping poolinfo is a better fit for the pool in RAID1.
> 

I said multiple times it's a fixed size and won't change, you don't need
to store it. Not sure if you get this. :(

conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
			offsetof(struct r1bio, bios[mddev->raid_disks *2]);

Thanks,
Kuai

