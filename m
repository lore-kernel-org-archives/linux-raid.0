Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE52A184D
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 02:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728354747; cv=none; b=vD3OrlPTk5h11RdumdG5LjU+jB5gpffiqsLvl4d691ZQ62TXDXaCTgLn/k2u5L63y1QpHPtVyFgUjPdtbztA3ywWXQKf8zRemwkrX10nskbYxR5TSTGEzyF8NPRCn/xm9d2yUW2sqGAyQ3YAMuA1qoDFyX6rqt4ojex3nfnlQ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728354747; c=relaxed/simple;
	bh=lvcSVPuUMLa7LJKeQS8Esgv2iy6boqWqQTqC4MgtLUE=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uT2s7qCfKr3qKaWpc5+Bv6c0IRBQi1tNMXyQpk+XfrGhQ7mJCkAwV0roSYj7c6vUUHh2WSvB6fUrPdsZfPMzWjlYmmZZmsxi+g5DLGK0Tb6eOFSMWDp3/StABOqktVfyWMLKY6Zd38Znzbp/Rv09EihXvtTBkZEcWmg55xaZMM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XN0Qx439mz4f3jk3
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 10:32:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4669A1A0568
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 10:32:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXTMizmQRnaaftDQ--.31310S3;
	Tue, 08 Oct 2024 10:32:21 +0800 (CST)
Subject: Re: Null dereference in raid10_size, I/O lockup afterwards
To: Yu Kuai <yukuai1@huaweicloud.com>, ValdikSS <iam@valdikss.org.ru>,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>
 <e12e1789-5a07-4d42-8f06-afa99d820444@valdikss.org.ru>
 <3de753c8-86ee-6e7c-fe06-7c0693e95bbd@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7a21c8d6-3012-6816-b1d8-0bebdd7b10cc@huaweicloud.com>
Date: Tue, 8 Oct 2024 10:32:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3de753c8-86ee-6e7c-fe06-7c0693e95bbd@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXTMizmQRnaaftDQ--.31310S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw18AF48JrWxGr13Gw43Awb_yoW8Xr4xpa
	9rKFyrAr4UG3yUGa4Dt3yDua15KFy7W39Fkr17Ar18Za95ZFZxZayUJrWjgFnxXFs3Aa40
	vay5t3yfCF45tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUSNtxUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/08 9:49, Yu Kuai 写道:
> Hi,
> 
> 在 2024/10/05 10:55, ValdikSS 写道:
>> On 05.10.2024 04:35, ValdikSS wrote:
>>> Fedora 39 with 6.10.11-100.fc39 kernel dereferences NULL in 
>>> raid10_size and locks up with 3-drive raid10 configuration upon its 
>>> degradation and reattachment.
>>>
>>> How to reproduce:
>>>
>>> 1. Get 3 USB flash drives
>>> 2. mdadm --create -b internal -l 10 -n 3 -z 1G /dev/md0 /dev/sda 
>>> /dev/sdb /dev/sdc
>>> 3. Unplug 2 USB drives
>>> 4. Plug one of the drive again
>>>
>>> Happens every time, every USB flash reattachment.
>>
>> Reproduced on 6.11.2-250.vanilla.fc39.x86_64
> 
> Can you use addr2line or gdb to see which codeline is this?
> 
> RIP: 0010:raid10_size+0x15/0x70 [raid10]

 From code review, looks like this can only happen if raid10_run() return
0 while mddev->private(the raid10 conf) is still NULL. Can you also give
the following patch a test?

Thanks,
Kuai

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..b7f2530ae257 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4061,9 +4061,13 @@ static int raid10_run(struct mddev *mddev)
         }

         if (!mddev_is_dm(conf->mddev)) {
-               ret = raid10_set_queue_limits(mddev);
-               if (ret)
+               /* don't overwrite ret on success */
+               int err = raid10_set_queue_limits(mddev);
+
+               if (err) {
+                       ret = err;
                         goto out_free_conf;
+               }
         }

         /* need to check that every block has at least one working 
mirror */


> 
> Thanks,
> Kuai
> 
> .
> 

