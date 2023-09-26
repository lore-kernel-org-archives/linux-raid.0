Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAA8E7E636
	for <linux-raid@archiver.kernel.org>; Tue, 26 Sep 2023 13:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjIZNVR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Sep 2023 09:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIZNVQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Sep 2023 09:21:16 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C4BB4
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 06:21:09 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rw0k967Zkz4f3l8C
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 21:21:05 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnt9bB2hJlZK7GBQ--.35476S3;
        Tue, 26 Sep 2023 21:21:06 +0800 (CST)
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
To:     Kirill Kirilenko <kirill@ultracoder.org>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Roman Mamedov <rm@romanrm.net>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
 <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
 <d45ffbcd-cf55-f07c-c406-0cf762a4b4ec@huaweicloud.com>
 <a4d3f9b0-15d5-4a90-f2c1-cad633badbbf@ultracoder.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3bc0af74-95cd-e175-830c-6030a768e64f@huaweicloud.com>
Date:   Tue, 26 Sep 2023 21:21:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a4d3f9b0-15d5-4a90-f2c1-cad633badbbf@ultracoder.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnt9bB2hJlZK7GBQ--.35476S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZryxZrW7Cw4fJryftF1UJrb_yoW8Jr1fpF
        yDJa13Cw4qqF92v34DA3ZrWFWFvws8Ar13Gr1kWrWav3WqgFyfJr4Ik3yruryjqF48Ww1q
        qanrX34fuFZ7A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/26 21:12, Kirill Kirilenko 写道:
> On 26.09.2023 06:28 +0300, Yu Kuai wrote:
>> I still don't quite understand what you mean 'kernel freeze', this patch
>> indeed fix a problem that diskcard bio is treated as normal write bio
>> and it's splitted.
>>
>> Can you explain more by how do you judge 'kernel freeze'? In the
>> meantime dose 'iostat -dmx 1' shows that disk is idle and no dicard io
>> is handled?
> 
> I mean, keyboard and mouse stop working, screen stops updating,
> sound card starts playing last audio buffer endlessly. At the same time,
> the disk activity indicator goes off.

This means cpu is busy with something, in this case you must use top or
perf to figure out what all your cpus are doing, probably issue io and
handle io interrupt.

> 
> I've attached the last output of 'iostat -dmx 1'. My RAID1 LV is 'dm-4',
> the underlying PVs are 'nvme0n1' and 'sda'. But the update interval
> is 1 second, may be at the moment of freezing all discards have already
> been completed.

iostat shows that disk is handling about 600 write, 1200 discard and 900
flush each second. I'm not sure what 'disk activity indicator goes off'
means, but your disk is really busy with handling all these io.

Thanks,
Kuai

> 

