Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487711DFC4
	for <linux-raid@vger.kernel.org>; Sat, 27 Jan 2024 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706337837; cv=none; b=Z1KtqRvza8Hmte1ypihr+JoGdDBoKGcM6NudagZ56yN5IniERXUMiiHECsFbWu2sR70FdlK+1WwYuYKmTV0+LWImYmQiKa57cdqe7AafgDDyHiE7v11HiV76vpKgJ5ItNkWJ4M2uk/B989SlDHpPA5RwYJQyWMSdWs5lUbekDf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706337837; c=relaxed/simple;
	bh=amisdaXtPxi1mvXwY5m6N5YhNVpXGN51mYyRMdw/XuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hLp/9LleG8lGh3hrtfGb3OdpF8Hlaz8Pc704U0QAqoV2ZZanfU2RqARM14BX7qmm8osnDMalD7pmI9DBxsl/jW1aeVaDtVz82Fp74oL2hp567/4mb6X0ke0zy/QAbvc0VQURtLTyvWClYQ3Vi3kMP09EvGD4lIX+DSEKAydeSEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TMQ4r4y4sz4f3jXX
	for <linux-raid@vger.kernel.org>; Sat, 27 Jan 2024 14:43:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id ADA291A0232
	for <linux-raid@vger.kernel.org>; Sat, 27 Jan 2024 14:43:44 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgAnmAseprRlHhmfCA--.6190S3;
	Sat, 27 Jan 2024 14:43:44 +0800 (CST)
Message-ID: <144ad5ee-e24b-3d77-63c9-d911f3589134@huaweicloud.com>
Date: Sat, 27 Jan 2024 14:43:42 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: New device added but i did a mess
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
 Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAnmAseprRlHhmfCA--.6190S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw4kZF4rKF48KrWUCw1UAwb_yoW8Wr13pF
	98t3ZrAFs7Jw4Ikay7Aw10qay5trW8Zay3G3W5t34UAFs8CF10yr97Kw45AF93Zwn8tayI
	va97Wr98ZFySqFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
	x4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14
	v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE
	67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2024/1/25 22:49, Gandalf Corvotempesta 写道:
> Ok, i think i did a mess.
> I have a 3 way mirror with 3 drives on it
> All drives are working, not failed.
> I would like to replace one of these drive (because it's very old)
> with a new drive.
> I would like to to the add and replace in the same phase, without
> reducing the redundancy level
> I did this multiple times before, during the sync, the array is a 4 way mirror
> 
> BUT this time i think i did an issue, i've just run this:
> 
> $ mdadm /dev/md0 --add /dev/sdd1 --replace /dev/sda1 --with /dev/sdd1

It is right.

> 
> sda was marked failed immediately, and sdd1 is marked as active sync.
> Less than 1 second.
> 
> Is this ok or i've just added a blank drive and forced the removal of
> a working one ?
> 
> Honestly, and this is something that comes to mind right now, the
> partition is very very small, like 64MB so 1 second sync (on a SSD)
> could be ok.
> 
> but:
> 1. which is the right command to run to add-sync-remove a not-failed disk  > 2. how can I ensure that sdd is working as expected and data were
> synced properly?

you can check dmesg. The following means the beginning and ending of
recovery:
   md: recovery of RAID array md0
   md: md0: recovery done.

Also, you can get more information with 'mdadm -D /dev/md0'
syncing:
     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        3       8       48        0      spare rebuilding   /dev/sdd
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc

sync success:
     Number   Major   Minor   RaidDevice State
        3       8       48        0      active sync   /dev/sdd
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc

        0       8        0        -      faulty   /dev/sda

-- 
Thanks,
Nan

