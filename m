Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962C9E6FE31
	for <linux-raid@archiver.kernel.org>; Tue, 26 Sep 2023 01:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjIZBKc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 21:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjIZBKb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 21:10:31 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A588310E
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 18:10:24 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RvhVz17QRz4f3lWC
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 09:10:19 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgDnfd17LxJlMnqcBQ--.24968S3;
        Tue, 26 Sep 2023 09:10:21 +0800 (CST)
Subject: Re: request for help on IMSM-metadata RAID-5 array
To:     Joel Parthemore <joel@parthemores.com>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230923162449.3ea0d586@nvm>
 <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
 <20230923203512.581fcd7d@nvm>
 <72388663-3997-a410-76f0-066dcd7d2a63@parthemores.com>
 <4d606b3d-ccec-e791-97ba-2cb5af0cc226@huaweicloud.com>
 <02a12a6d-eac4-51a1-e5ab-3df4d79bb87b@parthemores.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <86dd0750-d060-eada-dc16-03a783c3bd1d@huaweicloud.com>
Date:   Tue, 26 Sep 2023 09:10:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <02a12a6d-eac4-51a1-e5ab-3df4d79bb87b@parthemores.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgDnfd17LxJlMnqcBQ--.24968S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZry3uF48Jw4kWr4fWFyxuFg_yoW3KrbE9F
        4j9anrW3ykWF10qw42q3ya9rW5Ca10yF1vqFy3Z3W7WryDXan3XrW0y34fZrn7Wr18Grs8
        tFW7Zr43Z3929jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4AFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/25 23:57, Joel Parthemore 写道:
> 
> Den 2023-09-25 kl. 03:43, skrev Yu Kuai:
>> Hi,
>>
>> 在 2023/09/24 2:49, Joel Parthemore 写道:
>>> So, dd finally sped up and finished. It appears that I have lost none 
>>> of my data. I am a very happy man. A question: is there anything 
>>> useful I am likely to discover from keeping the RAID array as it is a 
>>> bit longer before I recreate it and copy the data back?
>>
>> It'll be much helper for developers to collect kernel stack for all 
>> stuck thread(and it'll be much better to use add2line).
> 
> 
> Presuming I can re-create the problem, let me know what I should do to 
> collect that information for you. I'm very much a newbie in that area.

You can use following cmd:

for pid in `ps -elf | grep " D " | awk '{print $4}'`; do ps $pid; cat 
/proc/$pid/stack; done

Thanks,
Kuai

> 
> Joel
> 
> .
> 

