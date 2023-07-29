Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8981C001DF
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 03:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbjG2Dg1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Jul 2023 23:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjG2DgZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Jul 2023 23:36:25 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274781BD1
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 20:36:23 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RCVXd61Bmz4f3kkF
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 11:36:17 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHoZQwicRkA0w8PA--.63159S3;
        Sat, 29 Jul 2023 11:36:18 +0800 (CST)
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
Date:   Sat, 29 Jul 2023 11:36:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHoZQwicRkA0w8PA--.63159S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKF18Ar43tF17XryrXry7Wrg_yoWfKFcEva
        yqk3yvqw1IvFW7K3WDA34jg397Xr1DWFy5XFWrCF18t34Dua12qryrJw17uw13WF4vkrs0
        kFWj9a4Fy34IkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
        r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/29 11:29, Xueshi Hu 写道:
>>>> I think this is wrong, you should at least keep following:
>>>>
>>>>           set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>>>           set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>>>           md_wakeup_thread(mddev->thread);
>>>>
>>> I fail to comprehend the rationale behind the kernel's need to invoke
>>> raid1d() repeatedly despite the absence of any modifications.
>>> It appears that raid1d() is responsible for invoking md_check_recovery()
>>> and resubmit the failed io.
>>
>> No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
>> so that md_check_recovery() can start to reshape.
> I apologize, but I am still unable to comprehend your idea.
> If mmdev->delta_disks == 0 , what is the purpose of invoking
> md_check_recovery() again?

Sounds like you think raid1_reshape() can only be called from
md_check_recovery(), please take a look at other callers.

Thanks,
Kuai

