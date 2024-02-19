Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F06163
	for <linux-raid@vger.kernel.org>; Mon, 19 Feb 2024 01:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708305228; cv=none; b=cIDkD0GN81M8ze3sja6Z6ZAT/6iGPrNJ033qwoqv1q2h5TXjrzIyMq7PCR60amN63gF9pRU1yNQg225ABYSopQM4347FOAsod77p7DazncnWVe3M+ic+SEBc/pbwnhkaQLkQft8zTbBNXWWHAGxu2lznxfDDtIu+66vJHgrkhDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708305228; c=relaxed/simple;
	bh=eSIwSmvqSDyzbNokPHMvy8N32ixfdIkhZyv0OQNHk3w=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=t5bPo1FxQP7z3KJWmee1/YI3jUZFQNsoCw2CNvf2ZE3yAh2/JLj7+mTeraJ/KIyclt0U7oL1IDU1kxKxNMllDN9vAPKK7XFBfE/g8SY8WvMNdkoyTKmxZHDPDQ4dgvn7P+1KoiEp/sCAjf42zu9QRSOQwNVyPNuAFXmbwrg33j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TdPgL61Xjz4f3l1K
	for <linux-raid@vger.kernel.org>; Mon, 19 Feb 2024 09:13:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DE57A1A0232
	for <linux-raid@vger.kernel.org>; Mon, 19 Feb 2024 09:13:41 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBFEq9JlGMPNEQ--.36220S3;
	Mon, 19 Feb 2024 09:13:41 +0800 (CST)
Subject: Re: Array will not resync.
To: simd@vfemail.net, "linux-raid@vger.kernel.org"
 <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20240218112349.61a97801@firefly>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7b07aac9-9242-879b-44b2-df4acb7a4043@huaweicloud.com>
Date: Mon, 19 Feb 2024 09:13:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240218112349.61a97801@firefly>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBFEq9JlGMPNEQ--.36220S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1UJr1kXFy3CrWkWF4rZrb_yoW8Xw48pa
	1rWa47ArWktFs7GrW8uFW0kayFkr1kArW5Gwn0qa18uryYgryIkF47Gay5Ww1qyr9YgFy7
	ZFs5GryrAFyFyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/19 0:23, simd@vfemail.net Ð´µÀ:
> Hello,
> 
> I cannot get my RAID 6 array to resync.
> 
> I'm using mdadm version v4.1. I've tried kernels 5.18.X, 6.0.X, and
> 6.3.X on Devuan (Debian) Linux.
> 
> % echo resync > /sys/devices/virtual/block/md127/md/sync_action
> 
> Does nothing.
> 
> % mdadm --assemble --update=resync /dev/md127
> 
> Does nothing.

Please note that resync is one-time after assemble the array the first
time, you can't resync again after the array is clean.

> 
> I should see a status change to resync with mdadm --detail /dev/md127 and
> hear some activity from the drives.
> 
> I tried adding the verbose option, but it only lists the recognizing of
> the drives and adding them to the array.
> 
> The array currently has some mismatches which need to be corrected. It's
> currently registering all devices in "active sync" status and says that
> it is "clean".

What you want is "echo check > sync_action", then "cat mismatch_cnt", if
there are really mismatches, "echo repair > sync_action" to fix it.

Thanks,
Kuai

> 
> I tried setting the flag, in misc mode, to readonly and then back to
> readwrite but that still doesn't allow the array to be resync'd.
> 
> In desperation, I tried unplugging one of the drives, it holds most/all
> of the mismatches -- the SATA cable was going bad, and then I touch(1)ed a
> file on the FS and unmounted the FS. Although the array recognized the
> failure of the drive, it did not start resync the array upon adding the
> drive back into the array.
> 
> 
> 
> 
> Any ideas how to resync the array?
> 
> Thanks,
> David
> 
> .
> 

