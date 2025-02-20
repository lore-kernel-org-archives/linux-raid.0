Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA2C286291;
	Thu, 20 Feb 2025 04:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740024414; cv=none; b=ZuVCllUP1/SXW/2d083iWVGDYqircyXp0OuIFElC/k2JY+G+XOMBymUXjv2pPgfTDjiDkBbqUwlYA0lx14iJWM0MpDnxEkk+DOVbs4wFOMnNEuEhPaRFqJG/ndyPVK/DDClFcAbUqObjgoNbc17Ods6a+kUS+qxSJwLNX9Kq36I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740024414; c=relaxed/simple;
	bh=wpKPVu2NC4+7qEevIj+8zb8F5+QJMb+HiC5sXIyyQHE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Cd3SBKAYDb27X53dF6GgoPp9KSdgkDi2B282XZGCCFkOgqUC67F8oGS5UDH9FiB2VaLVMM1Xjh25poLQRVoE98xzcac++KXcGPSFUaoMG5F1MxbJ8KGe7T+ttGfBM6t8SLyy1+Wrr3w6GB4p74DpgPOvwEqmMPAYwD1Dd5Ib4MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yz07T5cprz4f3jsy;
	Thu, 20 Feb 2025 12:06:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1C1D51A1714;
	Thu, 20 Feb 2025 12:06:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m19UqrZn271sEQ--.55685S3;
	Thu, 20 Feb 2025 12:06:45 +0800 (CST)
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
To: Guillaume Morin <guillaume@morinfr.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, song@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
 <Z7alWBZfQLlP-EO7@bender.morinfr.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
Date: Thu, 20 Feb 2025 12:06:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z7alWBZfQLlP-EO7@bender.morinfr.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m19UqrZn271sEQ--.55685S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CryxKw4xCr1rKF45WF4DArb_yoW8Xw1fpF
	WkWan3Cr18J34xJ39rJa1kuFyFyw4xJrWDKrWxuw1kAF4DXr93ZrySqFs0grn09a93XFn8
	ta1UK3s5ua48J3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/20 11:45, Guillaume Morin 写道:
> On 20 Feb 11:19, Yu Kuai wrote:
>>
>> Hi,
>>
>> 在 2025/02/20 11:05, Guillaume Morin 写道:
>>> how it was guaranteed that mddev_get() would fail as mddev_free() does not check or synchronize with the active atomic
>>
>> Please check how mddev is freed, start from mddev_put(). There might be
>> something wrong, but it's not what you said.
> 
> I will take a look. Though if you're confident that this logic protects
> any uaf, that makes sense to me.
> 
> However as I mentioned this is not what the crash was about (I mentioned
> the UAF in passing). The GPF seems to be about deleting the _next_
> pointer while iterating over all mddevs. The mddev_get on the
> current item is not going to help with this.
> 

You don't need to emphasize this, it is still speculate without solid
theoretical analysis. The point about mddev_get() is that it's done
inside the lock, it shoud gurantee continue iterating should be fine.

I just take a quick look, the problem looks obviously to me, see how
md_seq_show() handle the iteration.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 465ca2af1e6e..7c7a58f618c1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9911,8 +9911,11 @@ static int md_notify_reboot(struct notifier_block 
*this,
                         mddev_unlock(mddev);
                 }
                 need_delay = 1;
-               mddev_put(mddev);
-               spin_lock(&all_mddevs_lock);
+
+               spin_lock(&all_mddevs_lock)
+               if (atomic_dec_and_test(&mddev->active))
+                       __mddev_put(mddev);
+
         }
         spin_unlock(&all_mddevs_lock);


Thanks,
Kuai

