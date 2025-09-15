Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899C2DC790;
	Mon, 15 Sep 2025 02:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757902552; cv=none; b=YtfUHVzxN/FGhTU+QdIQAsBPSHnaTKkAf2lYnMikYV3Wxk3pL76Hn7X0DByTiuyzKorRrk71JNqiHqDEFhmKJB4Uu4kDYaK2GkZEPF2eQhIAYNOQJ3tDZTZfEWY6j9GIv44ucQ3ilQ+KbZMo1PSqzTprOCP1nf5mW1UY61rGBF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757902552; c=relaxed/simple;
	bh=wk9cxB3e82vYRXRXSwGgpB9vFtSquVnq6ILEBPGlYbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lf2eibQduQqDpN3t8XPzvkQUL7Dq85TqIcMq2xAMN5M8sMoTs0U9z433nHb9HSiyYa/SxjDkUksOOQBwlPIds0yvnVH6qdh+TDWTmxSWRwHFmrihy7azZYDjo4RvScaIs+yU8ZKEiqsJMUi595go8zvqwp5OuDT8dv2dNlkGMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cQ7tB4KRjzYQv4n;
	Mon, 15 Sep 2025 10:15:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2682D1A1305;
	Mon, 15 Sep 2025 10:15:45 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY7NdsdounEuCg--.53887S3;
	Mon, 15 Sep 2025 10:15:43 +0800 (CST)
Message-ID: <9041896d-e4f8-c231-e8ea-5d82f8d3b0d2@huaweicloud.com>
Date: Mon, 15 Sep 2025 10:15:41 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 2/2] md: allow configuring logical_block_size
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 martin.petersen@oracle.com, bvanassche@acm.org, filipe.c.maia@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250911073144.42160-1-linan666@huaweicloud.com>
 <20250911073144.42160-3-linan666@huaweicloud.com>
 <CALTww2_z7UGXJ+ppYXrkAY8bpVrV9O3z0VfoaTOZtmX1-DXiZA@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww2_z7UGXJ+ppYXrkAY8bpVrV9O3z0VfoaTOZtmX1-DXiZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY7NdsdounEuCg--.53887S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1kJFW7GFWDury8tr45Awb_yoW8Ar18pa
	ykZa15K3Z5tFyjy3Z7Z3Z2ga4jgw4xKa1UGry3Gw17u3y5uF1a9r4Igayjga4jyr1S9ry2
	vr4qqr1SvF929aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/15 8:33, Xiao Ni 写道:
> Hi Nan
> 
> On Thu, Sep 11, 2025 at 3:41 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> Previously, raid array used the maximum logical_block_size (LBS) of
>> all member disks. Adding a larger LBS during disk at runtime could
>> unexpectedly increase RAID's LBS, risking corruption of existing
>> partitions.
> 
> Could you describe more about the problem? It's better to give some
> test steps that can be used to reproduce this problem.

Thanks for your review. I will add reproducer in the next version.

>>
>> Simply restricting larger-LBS disks is inflexible. In some scenarios,
>> only disks with 512 LBS are available currently, but later, disks with
>> 4k LBS may be added to the array.
>>
>> Making LBS configurable is the best way to solve this scenario.
>> After this patch, the raid will:
>>    - stores LBS in disk metadata.
>>    - add a read-write sysfs 'mdX/logical_block_size'.
>>
>> Future mdadm should support setting LBS via metadata field during RAID
>> creation and the new sysfs. Though the kernel allows runtime LBS changes,
>> users should avoid modifying it after creating partitions or filesystems
>> to prevent compatibility issues.
> 
> Because it only allows setting when creating an array. Can this be
> done automatically in kernel space?
> 
> Best Regards
> Xiao

The kernel defaults LBS to the max among all rdevs. When creating RAID
with mdadm, if mdadm doesn't set LBS explicitly, how does the kernel
learn the intended value?

Gunaghao previously submitted a patch related to mdadm:
https://lore.kernel.org/all/3a9fa346-1041-400d-b954-2119c1ea001c@huawei.com/

-- 
Thanks,
Nan

