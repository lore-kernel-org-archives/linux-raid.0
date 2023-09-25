Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63660CE7A91
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 03:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjIYDF4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Sep 2023 23:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjIYDFz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Sep 2023 23:05:55 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE15A4
        for <linux-raid@vger.kernel.org>; Sun, 24 Sep 2023 20:05:49 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rv76Y6Vs5z4f3kkJ
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 11:05:41 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCHHt4G+RBlL4xPBQ--.13374S3;
        Mon, 25 Sep 2023 11:05:42 +0800 (CST)
Subject: Re: [PATCH] md: do not require mddev_lock() for all options
To:     Song Liu <song@kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230913085502.17856-1-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW6qk=XbbOxtzr0FGVuZHLr4kbzODkTSPjcBmK4YYGWWKw@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <175273eb-35a2-507d-ec0c-0685e7f6acd7@huaweicloud.com>
Date:   Mon, 25 Sep 2023 11:05:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6qk=XbbOxtzr0FGVuZHLr4kbzODkTSPjcBmK4YYGWWKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCHHt4G+RBlL4xPBQ--.13374S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWfuFWfXrW3XFW3uryxuFg_yoWkWrXEqF
        1ft3s7Xay8tr4xtw4Ykr4Iqw48GF4fWr4DA3y8Ar18Aa4Ut3yDA34DAasrK3y3Xayqq3s0
        vw1fXrW2kry3JjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
        0EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1wL05UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



在 2023/09/23 5:04, Song Liu 写道:
> Hi Mariusz,
> 
> Sorry for the late reply.
> 
> On Wed, Sep 13, 2023 at 1:55 AM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
>>
>> We don't need to lock device to reject not supported request
>> in array_state_store().
>> Main motivation is to make a room for action does not require lock yet,
>> like prepare to stop (see md_ioctl()).
> 
> I made some changes to the commit log:
> 
>      md: do not require mddev_lock() for all options
> 
>      We don't need to lock device to reject not supported request
>      in array_state_store().
>      Main motivation is to make a room for action does not require lock yet,
>      like prepare to stop (see md_ioctl()).
> 
> But I am not sure what you meant by "make a room for action does not
> require lock yet". Could you please explain?

Yes, this sounds confusing, if 'action does not require lock', then it
shound not be blocked by array_state_store() with or without this patch.

> 
> Otherwise, the code looks reasonable to me.

Changes look good to me, after clarify commit message, feel free to add

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> 
> Thanks,
> Song
> .
> 

