Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057EEC7EE23
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 02:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjE3CVj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 22:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjE3CVi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 22:21:38 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B2DA0
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:21:36 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVbJH2v2Yz4f3lV6
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 10:02:39 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7M+WXVkbZAPKg--.15970S3;
        Tue, 30 May 2023 10:02:40 +0800 (CST)
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
 <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
 <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
 <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
Date:   Tue, 30 May 2023 10:02:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7M+WXVkbZAPKg--.15970S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFW7Zw4fWF43GF1kXw43ZFb_yoWftFgE93
        W8AFykJwsrAws2qF17Krs0g3yqgay3AFyUXr97JwnF93yfWr4jqFyDG3s7A3WUXFySqwn8
        WFsYgw18G3WI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb7xYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/30 9:36, Guoqing Jiang 写道:
> 
> 
> On 5/29/23 16:40, Xiao Ni wrote:
>> It's the data which customers read that can be wrong. So it's a
>> dangerous thing. Because customers use the data directly. If it's true
>> it looks like there is a race between non aligned read and recovery
>> process.
> 
> But did you get similar report from customer from the past years? I am not
> sure it is reasonable to expect the md5sum should be match under such
> conditions (multiple processes do write/read with recovery in progress).
> 
> Maybe the test launched 32 processes in parallel is another factor, not 
> sure
> it still happens with only 1 process which means only do read after write.

May I ask if these processes write the same file with same offset? It's
insane if they do... If not, this cound be a problem.

> 
> Anyway, I think io accounting is irrelevant.

Yes, I can't figure out why io accounting can be involved.

Thanks,
Kuai
> 
> Thanks,
> Guoqing
> .
> 

