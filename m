Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA2538F96
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 07:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713425481; cv=none; b=WRJybi3WTQqV5VkcW/05VAjBCI0iU5fAbje7r/GWE4aThMvhDJAQMiHUX9ggAdnfukiebPEHtB6+ZrEmCNvCayvWPvnU5wLqeZGeEQ2MvvpYHF//qJIBqg+gsAj7Cm6njbwPDSatIuONz5igqwbD9RM2uazwDJjetfoHb3MHrVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713425481; c=relaxed/simple;
	bh=tP0P8MAot1WM2ypcdPyKuQhxCOjQNqRdg4l0D2qqubw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qLiNHV4j6Rc5zmk1bgWmOynNAbYyBlvGGnczjkIfEgFH1g67EDcQbJZwSJVdXWcQ7h/j9AdWjb5JZQR6hGqEogj0NA1ipc3WdQLuUMEL1sF88KT+mJPMYiymP7MhKRmQXu0wHFN/aVMBvoNVumOotqgr3KX8vCV4rHjR+38H4ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VKqFn6YVdz4f3m8T
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 15:31:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 91EF31A016E
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 15:31:14 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgCnyw4_zCBmq2gVKg--.45828S3;
	Thu, 18 Apr 2024 15:31:12 +0800 (CST)
Message-ID: <cffea7de-edf4-c97b-3fc7-c87038123593@huaweicloud.com>
Date: Thu, 18 Apr 2024 15:31:11 +0800
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
 Li Nan <linan666@huaweicloud.com>, linux-raid@vger.kernel.org
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
 <90ebc7c2-624c-934b-1b5b-e8efccfda209@huaweicloud.com>
 <08a82e10-dc6b-41f9-976a-e86a59cfd54d@gmail.com>
 <fe14b4b4-9ab2-93f5-85a8-3416d79dffa2@huaweicloud.com>
 <5a4a9b82-2082-4d25-906d-ee01b10fad65@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <5a4a9b82-2082-4d25-906d-ee01b10fad65@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCnyw4_zCBmq2gVKg--.45828S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy3AF45Ar17XrW5XF4rAFb_yoWfArXE9F
	Wj9F1qgw18t39xZrs8Jr4Sga17G39rtrWFyr1UXrsxt34rG3Z2yrZxuF1Fvwn7tFZ5Jr9x
	Z343Xr47WanI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
	6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
	Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUb0PfJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2024/4/14 5:37, Sven Köhler 写道:

[...]

>>
>> I used your command and config, updated kernel and mdadm, but raid also
>> created correctly after reboot.
>>
>> My OS is fedora, it may have been affected by some other system tools? I
>> have no idea.
> 
> The Arch kernel has RAID autodetection enabled. I just tried to reproduce 
> it. While mdadm will not consider /dev/sd[ab] as members, the kernel's 
> autodetection will. For that you have to reboot.
> 

It is not about autodetection. Autodetection only deals with the devices in
list 'all_detected_devices', device is added to it by blk_add_partition().
So sdx will not be added to this list, and will not be autodetect.

> I used this ISO in a VM with 2 harddisks to reproduce the issue: 
> https://mirror.informatik.tu-freiberg.de/arch/iso/2024.04.01/archlinux-2024.04.01-x86_64.iso 
> 
> 
> 
> Kind Regards,
>    Sven
> 
> 
> .

-- 
Thanks,
Nan

