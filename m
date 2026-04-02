Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB4E56A;
	Thu,  2 Apr 2026 02:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775095763; cv=none; b=semsCaaUC9KM8bjm/mk2SoTxlMON+ypDVPlV6aATwgz3zT8pcctchyb58QBVpiOeVhTcQAsP38TeENepjwZmIgXnh0xAfBY5kc1LjowP0wN6h4j26Fr9QTb0aFzZcEDPK+/HWzMYpSaIKQAaHHG9njv+WN1qo0iIs369RnHM82E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775095763; c=relaxed/simple;
	bh=Pbxq2ZPMMGinygfip0128pkCmB5SmZr1rHTRwWfKZwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQuOQ56V8xacX/Q7HvFAj5h8kpTz5V63imcFCESOpaXoqcYa1Bm7BWhCIBsmLljSksTJ2Zi+3HUNnN735uN9JPqmYwsCPTwE6FGCucn0jdTABMmhBeLTTOxrzsZJPKmleXXgZBgospLE+9vT5aBJkwPkKHnq3tseO9LlI635K6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fmQHv33hnzKHMMr;
	Thu,  2 Apr 2026 10:08:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EDE7640575;
	Thu,  2 Apr 2026 10:09:17 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP1 (Coremail) with SMTP id cCh0CgA3OtrMz81p5NRFDA--.14772S3;
	Thu, 02 Apr 2026 10:09:17 +0800 (CST)
Message-ID: <9388198d-ee38-b25f-aa6e-a90d78610923@huaweicloud.com>
Date: Thu, 2 Apr 2026 10:09:16 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: fix array_state=clear sysfs deadlock
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org
Cc: xni@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20260330055213.3976052-1-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260330055213.3976052-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3OtrMz81p5NRFDA--.14772S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4kZrWUZF4DJFy7XFy3XFb_yoW5ZFW8pr
	Z7G34Y9r4qkF1UAa9rW3W8ua45C3WktrZrGF4fCw4vva4rWwn7Gr1UWFn8XF15KrZ3Ga1j
	v3WUXa98Ca45CF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/3/30 13:52, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> When "clear" is written to array_state, md_attr_store() breaks sysfs
> active protection so the array can delete itself from its own sysfs
> store method.
> 
> However, md_attr_store() currently drops the mddev reference before
> calling sysfs_unbreak_active_protection(). Once do_md_stop(..., 0)
> has made the mddev eligible for delayed deletion, the temporary
> kobject reference taken by sysfs_break_active_protection() can become
> the last kobject reference protecting the md kobject.
> 
> That allows sysfs_unbreak_active_protection() to drop the last
> kobject reference from the current sysfs writer context. kobject
> teardown then recurses into kernfs removal while the current sysfs
> node is still being unwound, and lockdep reports recursive locking on
> kn->active with kernfs_drain() in the call chain.
> 
> Reproducer on an existing level:
> 1. Create an md0 linear array and activate it:
>     mknod /dev/md0 b 9 0
>     echo none > /sys/block/md0/md/metadata_version
>     echo linear > /sys/block/md0/md/level
>     echo 1 > /sys/block/md0/md/raid_disks
>     echo "$(cat /sys/class/block/sdb/dev)" > /sys/block/md0/md/new_dev
>     echo "$(($(cat /sys/class/block/sdb/size) / 2))" > \
> 	/sys/block/md0/md/dev-sdb/size
>     echo 0 > /sys/block/md0/md/dev-sdb/slot
>     echo active > /sys/block/md0/md/array_state
> 2. Wait briefly for the array to settle, then clear it:
>     sleep 2
>     echo clear > /sys/block/md0/md/array_state
> 
> The warning looks like:
> 
>    WARNING: possible recursive locking detected
>    bash/588 is trying to acquire lock:
>    (kn->active#65) at __kernfs_remove+0x157/0x1d0
>    but task is already holding lock:
>    (kn->active#65) at sysfs_unbreak_active_protection+0x1f/0x40
>    ...
>    Call Trace:
>     kernfs_drain
>     __kernfs_remove
>     kernfs_remove_by_name_ns
>     sysfs_remove_group
>     sysfs_remove_groups
>     __kobject_del
>     kobject_put
>     md_attr_store
>     kernfs_fop_write_iter
>     vfs_write
>     ksys_write
> 
> Restore active protection before mddev_put() so the extra sysfs
> kobject reference is dropped while the mddev is still held alive. The
> actual md kobject deletion is then deferred until after the sysfs
> write path has fully returned.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 521d9b34cd9e..02efe9700256 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6130,10 +6130,16 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   	rv = entry->store(mddev, page, length);
> -	mddev_put(mddev);
>   
> +	/*
> +	 * For "array_state=clear", dropping the extra kobject reference from
> +	 * sysfs_break_active_protection() can trigger md kobject deletion.
> +	 * Restore active protection before mddev_put() so deletion happens
> +	 * after the sysfs write path fully unwinds.
> +	 */
>   	if (kn)
>   		sysfs_unbreak_active_protection(kn);
> +	mddev_put(mddev);
>   
>   	return rv;
>   }

LGTM

-- 
Thanks,
Nan

