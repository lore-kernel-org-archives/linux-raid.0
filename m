Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D5DC77B75
	for <linux-raid@archiver.kernel.org>; Tue,  9 May 2023 02:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjEICdK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 22:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjEICdJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 22:33:09 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C3124
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 19:33:08 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QFhz41KCjz4f3kpG
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 10:33:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBXwLPfsFlkRgE7JA--.37872S3;
        Tue, 09 May 2023 10:33:05 +0800 (CST)
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     Roger Heflin <rogerheflin@gmail.com>,
        David Gilmour <dgilmour76@gmail.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com>
 <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
 <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com>
 <CAO2ABioUC9Wy=7FaPAP+AUmd5S-Xanj2d9JJYkqU4BL8DxW5Bg@mail.gmail.com>
 <b1252ee9-4309-a1a9-d2c4-3e278a3e70b6@huaweicloud.com>
 <CAO2ABioXHT9c4qPx5S4dKsMZLyE0xLGBzST5tSTu8YPmX4FxYQ@mail.gmail.com>
 <51a28406-f850-5f4e-1d2d-87c06df75a9d@huaweicloud.com>
 <CAO2ABiqEoi4iB__b7KdYu_jQqmeB8joh5xurHNeXj9583mcjjA@mail.gmail.com>
 <1392b816-bdaf-da5f-acc8-b6677aa71e3b@huaweicloud.com>
 <CAO2ABiqkg7HobNvXRWrid36+uYwZ3yHqLmbft_FQwzD9-B7mRg@mail.gmail.com>
 <CAAMCDec_qt0wsfQ6d1CWc4e3hYtzXabw_sK9ChjMUSkA0cPxXg@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d32a481b-4160-da34-8a1e-303c44d835f7@huaweicloud.com>
Date:   Tue, 9 May 2023 10:33:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDec_qt0wsfQ6d1CWc4e3hYtzXabw_sK9ChjMUSkA0cPxXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBXwLPfsFlkRgE7JA--.37872S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWkCryxtryfAry7WFyrCrg_yoWDGFbE9r
        yvyay7J34DJFZ0yw4fKFsYvry0vrs0gry7tayktr12qry5ZFsruF4vv34fur9xJ3s2y3sx
        Grs5X34kAr90vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
        r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/09 6:53, Roger Heflin 写道:
> On Mon, May 8, 2023 at 6:57 AM David Gilmour <dgilmour76@gmail.com> wrote:
>>
>> Ok, well I'm willing to try anything at this point. Do you need
>> anything from me for a patch? Here is my current kernel details:
> 
> grep -i mdadm /etc/udev/rules.d/* /lib/udev/rules.d/*
> 
> If you can find a udev rule that starts up the monitor then move that
> rule out of the directory, so that on the next assemble try it does
> not get started.
> 
> If this is the recent bug that is being discussed then anything
> accessing the array after the reshape will deadlock the array and the
> reshape.

It's not anything accessing the array, in fact, it's only the io accross
reshape position can trigger the deadlock.

I just posted a fix patch in the other thread by failing such io while
reshape can't make progress. However, I'm not sure for now if this will
break mdadm, for example, will mdadm must read something from array to
make progress?

Thanks,
Kuai
> .
> 

