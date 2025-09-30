Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F88242D76
	for <linux-raid@vger.kernel.org>; Tue, 30 Sep 2025 07:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759217013; cv=none; b=WrDgJwCG8bWT7HiIKBThwS4duG2oov2QQuwhccl2G6LRavrH3CEqkf0waf9Z1h1jim5iwcoDek/l4d8qK85S+fQH2bHQcx7R6wjt+c4y6zAa3obP5jHvDtVpIuKZVyU5XtDTcv4FeytufdduKdHiUBrF16HuWRB5ARpbCkcpkUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759217013; c=relaxed/simple;
	bh=fZ7AnJL/FEbXq+ELoFynvc0U9fhvsanBza/G6zZmiWk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NnbYjzKdjxBcUqh5JYQonux7hDfJKeMf7wDf/U/sgHKDDr2bJyTae4CS3dciv4H1XbNcUxkv61VxL5O2ocvcGgU5XI0wEO8qmHquYRzuLWAuTJISmyvKSpcSa4UT9Ax5jpdBzrTDhVZq1/cC1GMIOS9LsY49jbwJoq2iHihJe/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cbTzz1RBtzYQtvV
	for <linux-raid@vger.kernel.org>; Tue, 30 Sep 2025 15:23:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6B6601A0B60
	for <linux-raid@vger.kernel.org>; Tue, 30 Sep 2025 15:23:28 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBnK2Nuhdtoifw4BQ--.44607S3;
	Tue, 30 Sep 2025 15:23:28 +0800 (CST)
Subject: Re: [PATCH 1/1] md: delete mddev kobj before deleting gendisk kobj
To: Xiao Ni <xni@redhat.com>, yukuai1@huaweicloud.com
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250928012424.61370-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8a6a1f1d-4900-f824-fb26-b9a28380560f@huaweicloud.com>
Date: Tue, 30 Sep 2025 15:23:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250928012424.61370-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnK2Nuhdtoifw4BQ--.44607S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww18JrWUCw1rKrWkKw1DAwb_yoW8GrWfpr
	WrGF45trZ8XrWakwnruayxWFyrA3s8Xr1rtFWakw1Sv347XrykWF1rKrW0gFnrC39aqF4j
	9a1UWrn3tF1UKFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUehL0UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/09/28 9:24, Xiao Ni Ð´µÀ:
> In sync del gendisk path, it deletes gendisk first and the directory
> /sys/block/md is removed. Then it releases mddev kobj in a delayed work.
> If we enable debug log in sysfs_remove_group, we can see the debug log
> 'sysfs group bitmap not found for kobject md'. It's the reason that the
> parent kobj has been deleted, so it can't find parent directory.
> 
> In creating path, it allocs gendisk first, then adds mddev kobj. So it
> should delete mddev kobj before deleting gendisk.
> 
> Before commit 9e59d609763f ("md: call del_gendisk in control path"), it
> releases mddev kobj first. If the kobj hasn't been deleted, it does clean
> job and deletes the kobj. Then it calls del_gendisk and releases gendisk
> kobj. So it doesn't need to call kobject_del to delete mddev kobj. After
> this patch, in sync del gendisk path, the sequence changes. So it needs
> to call kobject_del to delete mddev kobj.
> 
> After this patch, the sequence is:
> 1. kobject del mddev kobj
> 2. del_gendisk deletes gendisk kobj
> 3. mddev_delayed_delete releases mddev kobj
> 4. md_kobj_release releases gendisk kobj
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Xiao Ni<xni@redhat.com>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

