Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CEB28F52D
	for <linux-raid@vger.kernel.org>; Fri,  9 May 2025 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746786398; cv=none; b=JqCpqmE+c/h3Iz6nM4y1pHunm9pQbZJDR1C6p0pmosqr4LdJ3VXgyHDp/ZnQWWArRu0pcwdVgkxQCQnonl6kUWwDOSrtDlEJP3wHw6dLdM5dSIWy6ixQHLtiEO5an+qu9yHhnr/AhrMpi8Et/MC49POVawr3JKeWegF+kS3aluM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746786398; c=relaxed/simple;
	bh=cg0N2SYEDE4dxqOdAcmc0PXSaVIkDz8ThD08Ut0y+vE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=C6flHPpZkiBFdPUcKHf95IG1HumBRhbaHC4BYI3wl5Fazod2lmE0VYTmVfamJgiG8o6qNhpl3CvzFeH/G6kkGv6Br0vcGI+zrJzKzPigugFl7JHjFIuln45/HK9lvMhHayQEgaOq/bd/rqn83qDnRoVgARXF8JHNHvV34UqNCN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4Zv4t30s8dzKHMfN
	for <linux-raid@vger.kernel.org>; Fri,  9 May 2025 18:26:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D4AD91A09EB
	for <linux-raid@vger.kernel.org>; Fri,  9 May 2025 18:26:33 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l5Y2B1orH+RLw--.10528S3;
	Fri, 09 May 2025 18:26:33 +0800 (CST)
Subject: Re: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, ncroxon@redhat.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250507021415.14874-1-xni@redhat.com>
 <20250507021415.14874-3-xni@redhat.com>
 <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com>
 <CALTww29siTuVSpCOJB7j47DxWFMcZV9RHkX=VfdxU0OyA4TsFg@mail.gmail.com>
 <c994b86c-cd40-1778-81d4-fdb3066053ef@huaweicloud.com>
 <CALTww28OBZZYdD_fJdFjmsjo51cn7CvVrKe=yserF+xvMd5f0A@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <04bc114d-08f8-b703-de7e-2f828f41321b@huaweicloud.com>
Date: Fri, 9 May 2025 18:26:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww28OBZZYdD_fJdFjmsjo51cn7CvVrKe=yserF+xvMd5f0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l5Y2B1orH+RLw--.10528S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWrur1Uuw4kJw1kGFW5Awb_yoWDArc_Wr
	nYyr40k3s7Wr4vqa15Kr18GrZrt3y5Wr1UXFW5A3y7tw1aqrWrCF1kuws7ur4ayFZYkrnY
	9F1DZ347ArZ8tjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/09 18:20, Xiao Ni 写道:
> On Fri, May 9, 2025 at 6:08 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/05/09 17:33, Xiao Ni 写道:
>>> The two places clear MD_CLOSING rather than setting MD_CLOSING.
>>> MD_CLOSING is set when we really want to stop the array (STOP_ARRAY
>>> cmd and clear>array_state_store). So the two places clear MD_CLOSING
>>> for other situations which look good to me.
>>
>> No, MD_CLOSING can be set first in the two cases, do something and then
>> be cleared, that's why I said temporarily.
> 
> So you mean mddev_get should pass in this case (between setting
> MD_CLOSING and clearing MD_CLOSING)? It doesn't allow get mddev now
> without this patch. This should be right.

I don't understand what you mean "It doesn't allow get mddev now without
this patch", for example, the ioctl STOP_ARRAY_RO will set MD_CLOSING
temporarily, but never set MD_DELETED, mddev_get() can always pass.

Thanks,
Kuai

> 
> Regardes
> Xiao
> 
>>
>> Thanks,
>> Kuai
>>
> 
> 
> .
> 

