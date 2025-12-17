Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E39F34C145
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765977859; cv=none; b=GUeX52jzSL1RLleGVLN/oBXTDBsaDPSKdvyNysx88i/xzx0fBFqGj7AuUi2/mD8yWj1iJhbecJinPq9Jf04pMvOzSCcmqP8mwZZrP6Yl6ihEdBkbacmlx+UTHaQsT76YsujxKqNsdKy1Drg2ye9rwV0Am7HVKt+DQVvRAFC6xW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765977859; c=relaxed/simple;
	bh=lUcj3aj8a9f7Z1r3yFdWX4TEqWatf1jW7WO/zg1ujQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=krcspYXyCSUxaXL3EGhT3A5dVojYBSbykwosLTQvq4KxgZvpUQ2dJ5nwbw68VvRKFkltU9We4mdFKZCwAtDPrBF1o16VM5jRs3gDxbvGIrAJfvJUPTvl9afiQXbR+0kLE4GfrliEA3w+Wvxj9fWHRZ460XoWUJxXZQ7UCLrB2B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWZJN6sd2zKHLt0
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 21:24:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1F9F340562
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 21:24:14 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_f8rkJpozAPAg--.53433S3;
	Wed, 17 Dec 2025 21:24:13 +0800 (CST)
Message-ID: <825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com>
Date: Wed, 17 Dec 2025 21:24:12 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: yukuai@fnnas.com, BugReports <bugreports61@gmail.com>,
 linux-raid@vger.kernel.org, xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_f8rkJpozAPAg--.53433S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFyfCw18Cw1fKryxCw43GFg_yoW7Xw18p3
	W8JFW0krW7GF1xJa1Ivw1Iga48JrZ8uw4DJr18Xw10yasxKF95Z3yvgr4Yka4q9r15Kas2
	v3WkKFWjvrZ8JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	_MaUUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/17 15:06, Yu Kuai 写道:
> Hi,
> 
> 在 2025/12/17 14:58, BugReports 写道:
>> Hi,
>>
>> i hope i am reaching out to the correct mailing list and this is the
>> way to correctly report issues with rc kernels.
>>
>> I installed kernel 6.19-rc 1 recently (with linux-tkg, but that should
>> not matter).  Booting the 6.19 rc1 kernel worked fine and i could
>> access my md raid 1.
>>
>> After that i wanted to switch back to kernel 6.18.1 and noticed the
>> following:
>>
>> - I can not access the raid 1 md anymore as it does not assemble anymore
>>
>> - The following error message shows up when i try to assemble the raid:
>>
>> |mdadm: /dev/sdc1 is identified as a member of /dev/md/1, slot 0.
>> mdadm: /dev/sda1 is identified as a member of /dev/md/1, slot 1.
>> mdadm: failed to add /dev/sda1 to /dev/md/1: Invalid argument mdadm:
>> failed to add /dev/sdc1 to /dev/md/1: Invalid argument - The following
>> error shows up in dmesg: ||[Di, 16. Dez 2025, 11:50:38] md: md1
>> stopped. [Di, 16. Dez 2025, 11:50:38] md: sda1 does not have a valid
>> v1.2 superblock, not importing! [Di, 16. Dez 2025, 11:50:38] md:
>> md_import_device returned -22 [Di, 16. Dez 2025, 11:50:38] md: sdc1
>> does not have a valid v1.2 superblock, not importing! [Di, 16. Dez
>> 2025, 11:50:38] md: md_import_device returned -22 [Di, 16. Dez 2025,
>> 11:50:38] md: md1 stopped. - mdadm --examine used with kerne 6.18
>> shows the following : ||cat mdadmin618.txt /dev/sdc1: Magic : a92b4efc
>> Version : 1.2 Feature Map : 0x1 Array UUID :
>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host
>> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1
>> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB
>> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data
>> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :
>> before=264112 sectors, after=0 sectors State : clean Device UUID :
>> 9f185862:a11d8deb:db6d708e:a7cc6a91 Internal Bitmap : 8 sectors from
>> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512
>> entries available at offset 16 sectors Checksum : f11e2fa5 - correct
>> Events : 2618 Device Role : Active device 0 Array State : AA ('A' ==
>> active, '.' == missing, 'R' == replacing) /dev/sda1: Magic : a92b4efc
>> Version : 1.2 Feature Map : 0x1 Array UUID :
>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host
>> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1
>> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB
>> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data
>> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :
>> before=264112 sectors, after=0 sectors State : clean Device UUID :
>> fc196769:0e25b5af:dfc6cab6:639ac8f9 Internal Bitmap : 8 sectors from
>> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512
>> entries available at offset 16 sectors Checksum : 4d0d5f31 - correct
>> Events : 2618 Device Role : Active device 1 Array State : AA ('A' ==
>> active, '.' == missing, 'R' == replacing)|
>> |- Mdadm --detail shows the following in 6.19 rc1 (i am using 6.19
>> output as it does not work anymore in 6.18.1): ||/dev/md1: Version :
>> 1.2 Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1 Array
>> Size : 1929939968 (1840.53 GiB 1976.26 GB) Used Dev Size : 1929939968
>> (1840.53 GiB 1976.26 GB) Raid Devices : 2 Total Devices : 2
>> Persistence : Superblock is persistent Intent Bitmap : Internal Update
>> Time : Tue Dec 16 13:14:10 2025 State : clean Active Devices : 2
>> Working Devices : 2 Failed Devices : 0 Spare Devices : 0 Consistency
>> Policy : bitmap Name : gamebox:1 (local to host gamebox) UUID :
>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Events : 2618 Number Major Minor
>> RaidDevice State 0 8 33 0 active sync /dev/sdc1 1 8 1 1 active sync
>> /dev/sda1|
>>
>>
>> I didn't spot any obvious issue in the mdadm --examine on kernel 6.18
>> pointing to why it thinks this is not a valid 1.2 superblock.
>>
>> The mdraid still works nicely on kernel 6.19 but i am unable to use it
>> on kernel 6.18 (worked fine before booting 6.19).
>>
>> Is kernel 6.19 rc1 doing adjustments on the md superblock when the md
>> is used which are not compatible with older kernels (the md was
>> created already in Nov 2024)?
> 
> I believe this is because lbs is now stored in metadata of md arrays, while this field is still
> not defined in old kernels, see dtails in the following set:
> 
> [PATCH v9 0/5] make logical block size configurable - linan666 <https://lore.kernel.org/linux-raid/20251103125757.1405796-1-linan666@huaweicloud.com/>
> 
> We'll have to backport following patch into old kernels to make new arrays to assemble in old
> kernels.
> 
> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huaweicloud.com
> 
> +CC Nan, would you mind backport above patch into stable kernels?
> 

Sent to stable from 6.18 to 5.10

https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u
https://lore.kernel.org/stable/20251217130935.2712267-1-linan666@huaweicloud.com/T/#u

-- 
Thanks,
Nan

