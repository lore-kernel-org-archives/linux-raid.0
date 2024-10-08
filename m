Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AD0225D9
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 01:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352163; cv=none; b=QS+aD0DJGE0diyvovVCqOHAmhdtEJ3EjfxfqRmKgFyoWKjGbUJ54f55SJAMgYgpDY4WAgP678zzf+OXsN+vtC966v9I2zOBNRsYXBZKWyFkxL4p/pm8rVJeOJkvnYsgqWtuajDDqe+cXqBVx18B6mTMimhvnIxtPBuLK9+F1DXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352163; c=relaxed/simple;
	bh=sziLTrGxZ225zOsN+dCOsGPC/rDeb4EcYT1/yjVjBig=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=T9496YNlB2PsN29gPXjrm2wxnAww3CUX7zy2dcWuPq0E/g3ZSPwFqYsFwWvQMYHyeYZOnQBCEQM1GLdpPPjTio0x75CHRzbOtB5oMHM4dsL9VXLtfHZtKvmvESnJWv9MKSd52QE3OMmVtC+H14g45Svkx5FEB2hlmLjXM2P0V8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XMzT80zZCz4f3jR1
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 09:49:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E64BE1A0568
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 09:49:16 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDH+sabjwRnS9TqDQ--.14221S3;
	Tue, 08 Oct 2024 09:49:16 +0800 (CST)
Subject: Re: Null dereference in raid10_size, I/O lockup afterwards
To: ValdikSS <iam@valdikss.org.ru>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>
 <e12e1789-5a07-4d42-8f06-afa99d820444@valdikss.org.ru>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3de753c8-86ee-6e7c-fe06-7c0693e95bbd@huaweicloud.com>
Date: Tue, 8 Oct 2024 09:49:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e12e1789-5a07-4d42-8f06-afa99d820444@valdikss.org.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+sabjwRnS9TqDQ--.14221S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw43GrWUCw45Kr48WFWUXFb_yoWxZrg_uF
	1Fvr97G3WUKw10vw4qqrnY9r1kWF4Sgas7JrykJF4Ik3yF9r9Ivr1UWFykZ343Ca4UZrsI
	qryjgFWxCrZrujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UNvtZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/05 10:55, ValdikSS 写道:
> On 05.10.2024 04:35, ValdikSS wrote:
>> Fedora 39 with 6.10.11-100.fc39 kernel dereferences NULL in 
>> raid10_size and locks up with 3-drive raid10 configuration upon its 
>> degradation and reattachment.
>>
>> How to reproduce:
>>
>> 1. Get 3 USB flash drives
>> 2. mdadm --create -b internal -l 10 -n 3 -z 1G /dev/md0 /dev/sda 
>> /dev/sdb /dev/sdc
>> 3. Unplug 2 USB drives
>> 4. Plug one of the drive again
>>
>> Happens every time, every USB flash reattachment.
> 
> Reproduced on 6.11.2-250.vanilla.fc39.x86_64

Can you use addr2line or gdb to see which codeline is this?

RIP: 0010:raid10_size+0x15/0x70 [raid10]

Thanks,
Kuai

