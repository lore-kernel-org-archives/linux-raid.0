Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5E3A32
	for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 01:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713578380; cv=none; b=TC0f6tKQVICJi5G3kg+N8c+7sQfAi+BJSNKNW3mOnbUc9oCHS2G/fzsv5UId1iTueLZ9l1abJWg6YA58VFkh3uGulbxOCSQRJiFfggPbG62DivNZZW6G+btGAog8VDuCaGv+aFn3SPs+33p2QOfYNPZLLcqRfxnRm82bfFwvrSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713578380; c=relaxed/simple;
	bh=QW4CaPBOwxijinbmeH20nzoTnMrJa4MzDgFPkSOEmgs=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bvQoqFFp8CC9ecxv44XXu4zZGiEtXK1esE7X0aVFFbnPBaOkyuUx/ggMQodZcd3oWqxjDdXnSYvV0V9jxuhvnxdpzbk1XFbZuc6TL3uOgjGe82ZXqB1iBn6s2eybqhvj8E6gxgQj7FMYLY+EXuj6yCcP+qt+POJJBfSt4zZEp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VLvp512Jfz4f3lfG
	for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 09:59:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2EBAA1A017A
	for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 09:59:34 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn9g6EISNmqRrJKQ--.36652S3;
	Sat, 20 Apr 2024 09:59:34 +0800 (CST)
Subject: Re: RAID performance limited by single kernel thread mdX_raid6 ?
To: Tom Crane <T.Crane@rhul.ac.uk>, linux-raid@vger.kernel.org
References: <d26a7e97-b120-45ee-9063-e156d79b3e37@rhul.ac.uk>
Cc: "yukuai (C)" <yukuai3@huawei.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ef6626c8-a0ad-7eef-d1cd-ccd3fdfbabf8@huaweicloud.com>
Date: Sat, 20 Apr 2024 09:59:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d26a7e97-b120-45ee-9063-e156d79b3e37@rhul.ac.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn9g6EISNmqRrJKQ--.36652S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy7GFWUtryfur4xur47CFg_yoW8Xw4Dpr
	ZrZ3WfCrZ7AFWxCw1vka17u348A393Xw17GFy5Kr1xXFy5WF40qr1xKFWF93yvganYkr1U
	tw1UArnYyw1vvaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
	k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UNvtZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/04/13 1:35, Tom Crane 写道:
> We have a newly built RAID6 array built using the LVM subsystem. It
> comprises 12-off 1TB NVME drives and 12 stripes to match the number of
> drives.
> 
> The performance seems to be limited by the single [mdX_raid6] kernel
> thread which 'top' shows is maxed out at 100% CPU (on a single core)
> when performance testing the array.

No, IO fast path is not involved with the daemon thread. Daemon thread
is used to handle IO errer, sync IO, update sb, handle spares...

Thanks,
Kuai

> 
> The kernel is a fairly old one (Redhat's 3.10.0-1160.114.2.el7.x86_64)
> on a Centos7 system.  A cursory googling of the topic does not suggest
> that later kernels (e.g. Redhat's 5.14.0-362.18.1.el9_3.x86_64 should we
> upgrade the system to an EL9 distro) have multi-threaded this... Can
> anyone comment ?
> 
> 
> Many thanks
> 
> Tom Crane.
> 
> ps. I'm not subscribed to this ML so please CC me when replying.
> 
> This email, its contents and any attachments are intended solely for the 
> addressee and may contain confidential information. In certain 
> circumstances, it may also be subject to legal privilege. Any 
> unauthorised use, disclosure, or copying is not permitted. If you have 
> received this email in error, please notify us and immediately and 
> permanently delete it. Any views or opinions expressed in personal 
> emails are solely those of the author and do not necessarily represent 
> those of Royal Holloway, University of London. It is your responsibility 
> to ensure that this email and any attachments are virus free.
> 
> .
> 

