Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D143C001DF
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jul 2023 06:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjGaGWj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jul 2023 02:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGaGWi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jul 2023 02:22:38 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB56188
        for <linux-raid@vger.kernel.org>; Sun, 30 Jul 2023 23:22:37 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RDp7X2cKQz4f3nTJ
        for <linux-raid@vger.kernel.org>; Mon, 31 Jul 2023 14:22:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgA30JMnU8dkQ4fiPA--.25855S3;
        Mon, 31 Jul 2023 14:22:33 +0800 (CST)
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
 <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
 <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
 <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
 <0d683096-5084-df23-8c6d-a1725f834b3d@huaweicloud.com>
 <bkou447mvbzpka2xyzojdyywogm3ljdstnfuhf4c3zyribrw55@joxaoryhdiji>
 <8085922e-403b-890e-8710-6ac3d09aa3d4@huaweicloud.com>
 <jm5cxwosgfolegtnkdt7madecheukl73gpgpabgogie5irt74e@v7knmmj537py>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b0a03f40-3e64-b906-c689-9c67b7618d53@huaweicloud.com>
Date:   Mon, 31 Jul 2023 14:22:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <jm5cxwosgfolegtnkdt7madecheukl73gpgpabgogie5irt74e@v7knmmj537py>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgA30JMnU8dkQ4fiPA--.25855S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Gr43GF15Gr1kXr4fXFykuFg_yoW8Jr1xpa
        y0gan7Kr4DJrn3KasrZw1xJFWF93y5tryrGw4DG34DZwnIqFyIv3yrtayY93yUWw4aqa10
        qF1kX34DJryUuaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/31 11:48, Xueshi Hu 写道:
>> Well... I just said reshape can continue is not possible for raid1, and
>> this patch will cause that recovery can't continue is some cases.

> I see. I will reread the relevant code to gain a better understanding of
> "some cases".

It's not that complex at all, the key point is whether your changes
introduce functional changes, if so, does the effect fully evaluated.

In this case, raid1_reshape(all the callers) will set
MD_RECOVERY_RECOVER and MD_RECOVERY_NEEDED to indicate that daemon
thread must check if recovery is needed, if so it will start recovery.

I agree that recovery is probably not needed in this case that
raid_disks is the same, however, note that recovery can be interrupted
by user, and raid1_reshape() can be triggered by user as well, this
means following procedures will end up different:

1. trigger a recovery;
2. interupt the recovery;
3. trigger a raid1_reshape();

Before this patch, the interupted recovery will continue;

This is minor, but I can't say that no user will be affected, and I
really prefer to keep this behaviour, which means this patch can just do
some cleanup without introducing functional changes.

Thanks,
Kuai

