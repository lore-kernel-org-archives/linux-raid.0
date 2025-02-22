Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B3115853B;
	Sat, 22 Feb 2025 01:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186504; cv=none; b=bbTuTjCktS+o4cROuLZFUyrOXh3g2ObPXnFI7YpJrqYj79q88AM5A9m22BcIEMovWnYgzHfreNZRIVQaqdflXungYkhVsL14rSZ3SHqqcWYd/egvOYoHJ9QFCGlY0UTP9/R25QVvZFxQtOagEdp+mkzdiPP3NQZPowK69G2DVCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186504; c=relaxed/simple;
	bh=bIskem6ovqlX9E6bDZg1T7wY12lCPzsr2+fVJvYNtUw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nrW8elCYUiN7ATjy7aHZmalzrmpbyhwDS17xQ0zd2vkibJyB/2fXVzUsM2WA4aKDLCbPL6Vbi/O5Vol91nAjY5TpBtM4y+wiE1g6eHHMXaw6TwlrqDvKmvrvN+x6Nd3R8MwDb0vwZ8lk5Io5s5gficB8opMe6+4n1u86CiRh4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z084W48tCz4f3jt4;
	Sat, 22 Feb 2025 09:07:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EBDF61A06D7;
	Sat, 22 Feb 2025 09:08:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2B6I7lnyLYhEg--.16062S3;
	Sat, 22 Feb 2025 09:08:11 +0800 (CST)
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
To: Guillaume Morin <guillaume@morinfr.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
 <Z7alWBZfQLlP-EO7@bender.morinfr.org>
 <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
 <6748f138-ad52-b7c5-ac53-1c7fa6fab9b7@huaweicloud.com>
 <Z7cwexr7tLRIOlNx@bender.morinfr.org>
 <40203778-f217-6789-9c83-ebed3720627b@huaweicloud.com>
 <Z7iZh56mykLW82SN@bender.morinfr.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fd4dc27c-501b-404d-6f96-8a4628883ccd@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:08:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z7iZh56mykLW82SN@bender.morinfr.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2B6I7lnyLYhEg--.16062S3
X-Coremail-Antispam: 1UD129KBjvdXoWruF45WF45Zry7JrWkXr48Crg_yoWDJrX_C3
	yDCFWDXw45XrW29a4Yyan5Zr47GF4jkwnxGF18CrWxJFZ8XF45GFySgrZ5Arn09FWrtry5
	t34rXF4SqrW8GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/02/21 23:19, Guillaume Morin Ð´µÀ:
> 2) Instead of mddev_free() being called for mddev N+1 like in 1, I wonder
> what's preventing mddev_free() being called for mddev N (the one we're
> iterating about). Something like
> 
> CPU1							CPU2
> list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> if (!mddev_get(mddev))
>      continue;
> spin_unlock(&all_mddevs_lock);
> 						        mddev_free(mddev) (same mddev as CPU1)
> 
> mddev_free() does not check the active atomic, or acquire the
> reconfig_mutex/md_lock and will kfree() mddev. So the loop execution
> on CPU1 after spin_unlock() could be a UAF.
> 
> So I was wondering if you could clarify what is preventing race 2?
> i.e what is preventing mddev_free(mddev) from being calling kfree(mddev)
> while the md_notify_reboot() loop is handling mddev.

I said already, please take a look how mddev_put() works, mddev_free()
can't be called untill the reference is released after mddev_get().

Thanks,
Kuai

