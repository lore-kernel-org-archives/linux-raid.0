Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F995283C9E
	for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766069656; cv=none; b=tKA+RRtcGeljm21k07J8kB3CHvNziYQpSqkA5ZeaaQyIaUJscLQJsehjFxE7JNFG2313hNITgtSxH5l8/3oA8Cm+e1vbNmMilHh+5ExEVO0O3t8aAdNe3UtGXRIw0n1uEhYApxxek845Nd7zegEDXtdZW7HCSk1pg5UYPQqgfXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766069656; c=relaxed/simple;
	bh=mrPUkSO5f0aYRQvWmM+Nctfmb7KXsQo+tdbsJ486Bgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kaA6cfrHymRSCN+Agk5fIh423UbS9N4FOTpFLl6bMPZ6kzFTEX5wCnqipG5GbOIxWr11lIjDyX6EeASB90DlITDy12iyfNhXjjx+iz0WlGnes9z7qhjVQFBNEgA895Qn3JyZP0fZLvt5VfQMnp9VOVEl6nNORz0BbbUpMW1qTJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dXDFb1XP1zKHMXd
	for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 22:53:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 00D7A4057D
	for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 22:54:06 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_eIFURpHgONAg--.16169S3;
	Thu, 18 Dec 2025 22:54:01 +0800 (CST)
Message-ID: <c6389212-3651-c85a-a713-693351aaf690@huaweicloud.com>
Date: Thu, 18 Dec 2025 22:54:00 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: Bugreports61 <bugreports61@gmail.com>, Li Nan <linan666@huaweicloud.com>,
 yukuai@fnnas.com, linux-raid@vger.kernel.org, xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com>
 <af9b7a8e-be62-4b5a-8262-8db2f8494977@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <af9b7a8e-be62-4b5a-8262-8db2f8494977@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_eIFURpHgONAg--.16169S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtw17uw17Cw4xWw45GF1Utrb_yoWfZwbE9w
	42q3s7C3Z7Jw40gF4vyF9aqrWvgr4Fv348JrWFkr4xG34fZFs3WrZ5uF9xGrn8W34vyFnx
	GF4DAwsxuw1vvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
	Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUejgxUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/18 18:41, Bugreports61 写道:
> Hi,
> 
> 
> reading the threads it was now decided that only newly created arrays will 
> get the lbs adjustment and patches to make it work on older kernels will 
> not happen:
> 
> 
> How do i get back my md raid1 to a state which makes it usable again on 
> older kernels ?
> 
> Is it  safe to simply mdadm --create --assume-clean /dev/mdX /sdX /sdY on 
> kernel 6.18 to get the old superblock 1.2 information back without loosing 
> data ?
> 
> 
> My thx !
> 

In principle, this works but remains a high-risk operation. I still
recommend backporting this patch and add module parameters to mitigate the
risk.

https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u

This issue will be fixed upstream soon. The patch is under validation and
expected to be submitted tomorrow. However, the existing impact cannot be
undone – apologies for this.

-- 
Thanks,
Nan

