Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5925C77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 10 May 2023 01:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjEJBNR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 May 2023 21:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjEJBNQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 May 2023 21:13:16 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B9149C8
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 18:13:15 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QGH8Q3tM6z4f3mW1
        for <linux-raid@vger.kernel.org>; Wed, 10 May 2023 09:13:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCH77Km71pkWdB9JA--.59024S3;
        Wed, 10 May 2023 09:13:11 +0800 (CST)
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Johan Verrept <johan@verrept.eu>,
        Yu Kuai <yukuai1@huaweicloud.com>, Jove <jovetoo@gmail.com>
Cc:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        songliubraving@meta.com, Logan Gunthorpe <logang@deltatee.com>,
        David Gilmour <dgilmour76@gmail.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
 <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
 <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
 <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
 <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
 <5862fb1d-33e0-acb1-d740-dd6fda27eaf4@huaweicloud.com>
 <753b096d-5dfc-3c47-eee4-07f1e4931b7b@verrept.eu>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bdb2fa5f-3ec2-e920-4822-80d482c9b713@huaweicloud.com>
Date:   Wed, 10 May 2023 09:13:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <753b096d-5dfc-3c47-eee4-07f1e4931b7b@verrept.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCH77Km71pkWdB9JA--.59024S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JF17WryktFy3Kw43Zr4UCFg_yoW3XFcEqr
        4q934v9ryjqanruFs7tFZ09Fnaq3y0q347J34UuF47Cry5JF4DGFWUWr93W3W8GrsrK3ZI
        qr4jqry7Z3sa9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Johan

在 2023/05/10 4:18, Johan Verrept 写道:
> 
> Hi Kuai,
> 
>> Here is the first verion of the fixed patch, I fail the io that is
>> waiting for reshape while reshape can't make progress. I tested in my
>> VM and it works as I expected. Can you give it a try to see if mdadm
>> can still assemble? 
> 
> Assemble seems to work fine and the reshape resumed.
> 

That's great, thanks for testing.

David, you can try this patsh as well, your case is different but
I think this patch will work.

Thanks,
Kuai
> I see this error appearing:
> 
>      md/raid456:md0: array is suspended or not read write, io accross 
> reshape position failed, please try again after reshape.
> 
>  From what I can see in your patch, this is what is expected.
> 
> Best regards,
> 
>      Johan
> 
> 
> .
> 

