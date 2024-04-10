Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828501C2D
	for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 01:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712714215; cv=none; b=ulaBULQRNBwinOVmBDvTsoGC1vZSKvtECGYdlAVWAd4n4mFgbo9mK6aPu3ye86s3Grz89UKXMmZgbd2b0GM+rN04Up//+yxn0RQD+RI7jjAnKcubyZNa56FGdR0VvGoGZOyRh6NiJevdsRO5TuwCt8zNxLqApK5whjItBCYGJMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712714215; c=relaxed/simple;
	bh=0ZZYjmtVWLGHfbN+xuidcjoeszhZM/t8K8NF6cROSuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NWUDCx6N7cMGRghkyznL+hq5YHV4QVH9oLR/dQ5Q0MxLBC7NM35FOsRMtY2/1/4AJLnOZU6gme1NSVUcDdYgj+K/SCAiRiJ6m0EUWo7ZHzxncbhIpVdWn69lkPCKaxx12tJw26LfdBuFpW6XM6Sekmdo7r/WPW4LBZLdb2wdlnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VDmCV3vTNz4f3jZc
	for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 09:56:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id EAB041A016E
	for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 09:56:42 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgAnmAvZ8RVmBukhJw--.38914S3;
	Wed, 10 Apr 2024 09:56:42 +0800 (CST)
Message-ID: <90ebc7c2-624c-934b-1b5b-e8efccfda209@huaweicloud.com>
Date: Wed, 10 Apr 2024 09:56:41 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: regression: drive was detected as raid member due to metadata on
 partition
To: =?UTF-8?Q?Sven_K=c3=b6hler?= <sven.koehler@gmail.com>,
 linux-raid@vger.kernel.org
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAnmAvZ8RVmBukhJw--.38914S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur4rWrW3CFy7XF1fXFWUArb_yoW5XFy8pF
	W7JFWFgr1DGws7Wa48Aa1xKas5C34kZay3t3W5try8Awn8Jas2vr1vvw45uFWjvFZ3A3Wj
	vr1UWrWUua90gFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzW
	lkUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

Hi, Köhler

在 2024/4/9 7:31, Sven Köhler 写道:
> Hi,
> 
> I was shocked to find that upon reboot, my Linux machine was detecting 
> /dev/sd[abcd] as members of a raid array. It would assign those members to  
> /dev/md4. It would not run the raid arrays /dev/mdX with members 
> /dev/sda[abcd]X for X=1,2,3,4 as it usually did for the past couple of years.
> 
> My server was probably a unicorn in the sense that it used metadata version 
> 0.90. This version of software RAID metadata is stored at the _end_ of a 
> partition. In my case, /dev/sda4 would be the last partition on drive 
> /dev/sda. I confirmed with mdadm --examine that metadata with the identical 
> UUID would be found on both /dev/sda4 and /dev/sda.
> 

I am trying to reproduce it, but after reboot, md0 started with members
/dev/sd[bc]2 correctly. And mdadm will waring if assemble by 'mdadm -A'.

   # mdadm -CR /dev/md0 -l1 -n2 /dev/sd[bc]2 --metadata=0.9
   # mdadm -S --scan
   # mdadm -A --scan
   mdadm: WARNING /dev/sde2 and /dev/sde appear to have very similar 
superblocks.
         If they are really different, please --zero the superblock on one
         If they are the same or overlap, please remove one from the
         DEVICE list in mdadm.conf.
   mdadm: No arrays found in config file or automatically

Can you tell me how you create and config the RAID?

> Here's what I think went wrong: I believe either the kernel or mdadm 
> (likely the latter) was seeing the metadata at the end of /dev/sda and 
> ignored the fact that the location of the metadata was actually owned by a 
> partition (namely /dev/sda4). The same happened for /dev/sd[bcd] and thus I 
> ended up with /dev/md4 being started with members /dev/sda[abcd] instead of 
> members /dev/sda[abcd]4.
> 
> This behavior started recently. I saw in the logs that I had updated mdadm 
> but also the Linux kernel. mdadm and an appropriate mdadm.conf is part of 
> my initcpio. My mdadm.conf lists the arrays with their metadata version and 
> their UUID.
> 
> Starting a RAID array with members /dev/sda[abcd] somehow removed the 
> partitions of the drives. The partition table would still be present, but 
> the partitions would disappear from /dev. So /dev/sda[abcd]1-3 were not 
> visible anymore and thus /dev/md1-3 would not be started.
> 
> I strongly believe that mdadm should ignore any metadata - regardless of 
> the version - that is at a location owned by any of the partitions. While 
> I'm not 100% sure how to implement that, the following might also work: 
> first scan the partitions for metadata, then ignore if the parent device 
> has metadata with a UUID previously found.
> 
> 
> I did the right thing and converted my RAID arrays to metadata 1.2, but I'd 
> like to save other from the adrenaline shock.
> 
> 
> 
> Kind Regards,
>    Sven
> 
> .

-- 
Thanks,
Nan

