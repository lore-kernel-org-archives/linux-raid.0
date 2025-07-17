Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333E12AE96
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 01:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752714461; cv=none; b=iul5vdwQqbQuNoc9878ttbNBl91HH/vldmQ7JmiJg2OQmwxBG0LPYdpqtVIVtq1DZtqz0OywBXKOEU06keNS92hQ4t+Ab5sVLTT1vNZC6b3qCerZlWQ5t5utkeNYqb4w3qTYP+Kk8JKGyQq+8l9gIxrqSCDOdA+7zfcQYDvn6Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752714461; c=relaxed/simple;
	bh=LZpF0mXB/+RO/r1bRV9fzUUh9+RVZZMv3IQR895CV2o=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BEMypnTNmfgrR94ouOex7hHQHWIl5OJTO+wvPZtCcP3VMjFwdHUa2ePzoKygJXV5oIVgMc63e7wBVdL6m1hb7RHAPMAGQJM/sH8CCTGhVgUneXolG2boGSFPyfIS/dLVhJy0AiHTlZQnEY45yjNkBMP35qoQWAYx6voqKFiYxpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bjFCF62WHzKHMhB
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 09:07:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 70D201A018D
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 09:07:36 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxTVTHho_YkRAg--.28806S3;
	Thu, 17 Jul 2025 09:07:35 +0800 (CST)
Subject: Re: Sector size changes creating filesystem problems
To: yukuai@kernel.org, Filipe Maia <filipe.c.maia@gmail.com>,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
 <1cc7f8b1-cd22-40bc-8e8c-45a2cc180849@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d9590f20-72cb-0b86-9a4e-1314d4f48d70@huaweicloud.com>
Date: Thu, 17 Jul 2025 09:07:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1cc7f8b1-cd22-40bc-8e8c-45a2cc180849@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxTVTHho_YkRAg--.28806S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWxWF45ZryUuw4xCrW5trb_yoW8WFy5pF
	47ZF1Fgr1DGw4xZa9xuw4fKw10qFyDX343ZF4UK342kasxCFnxXFn7JryqgFWUAFW5Cr1D
	Xa1kAFZ8Zryruw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

+CC Li Nan

在 2025/07/17 0:21, Yu Kuai 写道:
> Hi,
> 
> 在 2025/7/16 22:30, Filipe Maia 写道:
>> Hi,
>>
>> When a 4Kn disk is added to an mdadm array with sector size 512, its
>> sector size changes to 4096 to accommodate the new disk.
>>
>> Here's an example:
>>
>> ```
>> truncate -s 1G /tmp/loop512a
>> truncate -s 1G /tmp/loop512b
>> truncate -s 1G /tmp/loop512c
>> truncate -s 1G /tmp/loop4Ka
>> losetup --sector-size 512  --direct-io=on /dev/loop0  /tmp/loop512a
>> losetup --sector-size 512  --direct-io=on /dev/loop1  /tmp/loop512b
>> losetup --sector-size 512  --direct-io=on /dev/loop2  /tmp/loop512c
>> losetup --sector-size 4096  --direct-io=on /dev/loop3  /tmp/loop4Ka
>> mdadm --create /dev/md2 --level=5 --raid-devices=3 /dev/loop[0-2]
>> # blockdev returns 512
>> blockdev --getss /dev/md2
>> mdadm /dev/md2 -a /dev/loop3
>> mdadm /dev/md2 -f /dev/loop2
>> # blockdev still returns 512
>> blockdev --getss /dev/md2
>> mdadm -S /dev/md2
>> mdadm -A /dev/md2 /dev/loop0 /dev/loop1 /dev/loop3
>> # blockdev now returns 4096
>> blockdev --getss /dev/md2
>> ```
>>
>> This breaks filesystems like XFS, with new mounts failing with:
>> `mount: /mnt: mount(2) system call failed: Function not implemented.`
> Yes, this is a known problem. Li Nan was trying to fix this long time ago.
>>
>> Shouldn't the user be warned when this can happen?
> Kernel should forbid larger lbs new disk, however, this is still a missing
> feature for now.

You can try this set:

https://lore.kernel.org/all/20250304121918.3159388-1-linan666@huaweicloud.com/

> 
> Thanks,
> 
> Kuai
>>
>> Cheers,
>> Filipe
>>
> 
> .
> 

