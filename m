Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F74A33062
	for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749883595; cv=none; b=lMBXTX9/3MFV2NlT2bOqV4f4gD05R4OTHifV6Qg+LEGz+dTEBA7iEXTsyIwLACLaLhUYWm4Uhf4HsC3bSOAl5plad8i77upD8VP1n4PI/ErUG2GX5DDM/CRtGeaDOaE+zntAcmmvio+E+tcL+a9bRcxcQb/tiWWYdT0Uq3zOffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749883595; c=relaxed/simple;
	bh=lcgNTFNDO6jsNrrB8QPTNMSDejhAWuLLL6pdkXH0XOc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hSAK4ovMdUMZlprGB84qlcLPQovFACkYSDnCimA2pUQ2SXsFOIP/9H6aUSXOFgX4BGx1k0T8jqeJ3gghe1wouReEgP0ylXVntSfT+6SCaOoLcHyhRrCDwmVM9v0lerl1NyA4YqbYKg4yzAc8Qqr0nGrswy3FFWpNCrAikjnUzck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bK6HW73YjzKHNRH
	for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 14:46:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 58AF51A17E0
	for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 14:46:30 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni1_FGk1oljnjPQ--.7445S3;
	Sat, 14 Jun 2025 14:46:30 +0800 (CST)
Subject: Re: [PATCH V6 0/3] md: call del_gendisk in sync way
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611073108.25463-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9025cf32-097f-10a3-eb25-dfe4c4b7de7c@huaweicloud.com>
Date: Sat, 14 Jun 2025 14:46:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250611073108.25463-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1_FGk1oljnjPQ--.7445S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw1UZFyrWFWkCw43KFyDKFg_yoWDGFX_WF
	y8Xas3Jw1UJF1xAa45tr1Fvry7KFW7urWkJFyrXF43trW3Jr1fXr1qkw48Zw1ruFZ3Cr15
	tr45Cry8Ar4qkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUOgAwDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/11 15:31, Xiao Ni Ð´µÀ:
> Now del_gendisk is called in a queue work which has a small window
> that mdadm --stop command exits but the device node still exists.
> It causes trouble in regression tests. This patch set tries to resolve
> this problem.
> 
> v1: replace MD_DELETED with MD_CLOSING
> v2: keep MD_CLOSING
> v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop path
> and adjust the order of patches
> v4: only remove the codes in stop path.
> v5: remove sysfs_remove in md_kobj_release and change EBUSY with ENODEV
> v6: don't initialize ret and add reviewed-by tag
> 
> Xiao Ni (3):
>    md: call del_gendisk in control path
>    md: Don't clear MD_CLOSING until mddev is freed
>    md: remove/add redundancy group only in level change
> 
>   drivers/md/md.c | 49 ++++++++++++++++++++++++++-----------------------
>   drivers/md/md.h | 26 ++++++++++++++++++++++++--
>   2 files changed, 50 insertions(+), 25 deletions(-)
> 

Applied to md-6.16

Thanks,
Kuai

