Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74B9C77B73
	for <linux-raid@archiver.kernel.org>; Thu, 27 Apr 2023 07:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243112AbjD0Hjb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 03:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243113AbjD0Hj2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 03:39:28 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD58E40F7
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 00:39:22 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q6Ry532MYz4f3k5m
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 15:22:05 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCnD7OeIkpkJKL8IA--.55627S3;
        Thu, 27 Apr 2023 15:22:06 +0800 (CST)
Subject: Re: [question] solution for raid10 configuration concurrent with io
To:     Yu Kuai <yukuai1@huaweicloud.com>, Xiao Ni <xni@redhat.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, logang@deltatee.com,
        guoqing.jiang@linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
 <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
 <3ebb2a0a-3a1c-7e76-c331-f0ebfaed2634@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0a40d86d-be7a-7905-a6db-6045222a184a@huaweicloud.com>
Date:   Thu, 27 Apr 2023 15:22:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3ebb2a0a-3a1c-7e76-c331-f0ebfaed2634@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCnD7OeIkpkJKL8IA--.55627S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYz7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
        6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
        kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
        cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
        Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
        6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72
        CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
        xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUF9a9DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Sorry that synchronize_rcu() is misplaced, it should be right after
rcu_read_unlock():

在 2023/04/27 15:13, Yu Kuai 写道:
> t1:                t2:
> 
> raid10_write_request
>   rcu_read_lock
>   rdev = conf->mirros[].rdev
>                  raid10_remove_disk
>                   ......
>                   // nr_pending is 0, remove disk
>   // read inside rcu
>   rcu_read_unlock
					//set rdev NULL
					synchronize_rcu
> 
>   raid10_write_one_disk
>   // trigger null-ptr-dereference
> 

Thanks,
Kuai
					


