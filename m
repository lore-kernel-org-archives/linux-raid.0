Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEFE320A
	for <linux-raid@vger.kernel.org>; Thu, 11 Apr 2024 02:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712802364; cv=none; b=KEMi7PwQk4GunyntcqnsEMwZvJvAheB5gVE5Hlh7/JcvdUtF+hPkZIcHFyXCvcuvtVsXyAY+ERehciggM93fuheUQLRQZaKCjA2U4kyUBVTKuB/l/YLolFSkSQHXrX4AeRQEZW6+nqvsfAjKbL5jL2W2VHc53/S1rQI9lDhhKGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712802364; c=relaxed/simple;
	bh=k3v5LMib7RHDEOkyDWg5qUoIM6psw3yaI/YyEFsKT1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mJEZpPFcNoU0yzsfmlaT6buUCa//t07vVHYDFrGKtOdW2u7Ke2MRwsdDDDTR/7Rlihc3Yt6CWLWDvjooEcFSnEHq0WKN8cnrBmyjP7W1j1F8yg/fAngDA1cK415ZBXgvICwARmN+8505Q1Eu4sNahmtR6cd3RiP/Owgl5B3XYlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VFNpk192Tz4f3m6s
	for <linux-raid@vger.kernel.org>; Thu, 11 Apr 2024 10:25:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D06DF1A0199
	for <linux-raid@vger.kernel.org>; Thu, 11 Apr 2024 10:25:58 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgDH6w41Shdm+z6BJw--.36063S3;
	Thu, 11 Apr 2024 10:25:58 +0800 (CST)
Message-ID: <fe14b4b4-9ab2-93f5-85a8-3416d79dffa2@huaweicloud.com>
Date: Thu, 11 Apr 2024 10:25:57 +0800
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
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <08a82e10-dc6b-41f9-976a-e86a59cfd54d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDH6w41Shdm+z6BJw--.36063S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW7Kw1UCF18tFy8KrW7Jwb_yoW8AF4rpr
	s2yw1rKryDJw1kGa1UGr1Ut34UJr1kJ345JFWDJFy8Jr4UXrnFgw4UXF42gr4DXF4fAF15
	X3Z8Grn0vr13Gr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWI
	evJa73UjIFyTuYvjfU5sqWUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

Hi,

在 2024/4/11 4:59, Sven Köhler 写道:
> Hi,
> 
> Am 10.04.24 um 03:56 schrieb Li Nan:
>> Hi, Köhler
>>
>> 在 2024/4/9 7:31, Sven Köhler 写道:

[...]

> 
> I should have mentioned the mdadm and kernel version. I am using mdadm 
> 4.3-2 and linux-lts 6.6.23-1 on Arch Linux.
> 
> I created the array very similar to what you did:
> mdadm --create /dev/md4 --level=6 --raid-devices=4 --metadata=0.90 
> /dev/sd[abcd]4
> 
> My mdadm.conf looks like this:
> DEVICE partitions
> ARRAY /dev/md/4 metadata=0.90  UUID=...
> 
> And /proc/partitions looks like this:
> 
> major minor  #blocks  name
>     8        0 2930266584 sda
>     8        1    1048576 sda1
>     8        2   33554432 sda2
>     8        3   10485760 sda3
>     8        4 2885176775 sda4
>     8       16 2930266584 sdb
>     8       17    1048576 sdb1
>     8       18   33554432 sdb2
>     8       19   10485760 sdb3
>     8       20 2885176775 sdb4
>     8       32 2930266584 sdc
>     8       33    1048576 sdc1
>     8       34   33554432 sdc2
>     8       35   10485760 sdc3
>     8       36 2885176775 sdc4
>     8       48 2930266584 sdd
>     8       49    1048576 sdd1
>     8       50   33554432 sdd2
>     8       51   10485760 sdd3
>     8       52 2885176775 sdd4
> 
> 
> Interestingly, sda, sdb, etc. are included. So "DEVICE partitions" actually 
> considers them.
> 

I used your command and config, updated kernel and mdadm, but raid also
created correctly after reboot.

My OS is fedora, it may have been affected by some other system tools? I
have no idea.

-- 
Thanks,
Nan

