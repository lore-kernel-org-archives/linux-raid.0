Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABECC77B61
	for <linux-raid@archiver.kernel.org>; Thu, 27 Apr 2023 08:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbjD0IJV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 04:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0IJU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 04:09:20 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF802D71
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 01:09:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q6T0W1qQgz4f3nJN
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 16:09:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3rLCqLUpkEPH+IA--.22003S3;
        Thu, 27 Apr 2023 16:09:16 +0800 (CST)
Subject: Re: [question] solution for raid10 configuration concurrent with io
To:     Xiao Ni <xni@redhat.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, logang@deltatee.com,
        guoqing.jiang@linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
 <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f442f2d1-122e-44fb-5bad-fc14a35e782a@huaweicloud.com>
Date:   Thu, 27 Apr 2023 16:09:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3rLCqLUpkEPH+IA--.22003S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYj7kC6x804xWl14x267AKxVW8JVW5JwAF
        c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
        0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
        wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
        64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
        1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJ
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/27 14:53, Xiao Ni 写道:

>> // assum that rdev is NULL, and replacement is not NULL
> 
> How can trigger this? Could you give the detailed commands?
> 

This is just because raid10_remove_disk() set rdev to NULL first, and
then replace rdev with replacement. This is temporary but io can
concurrent with this temporary status.

raid10_remove_disk

  p = conf->mirrors + number;
  rdevp = &p->rdev;
  *rdevp = NULL;
  // here!
  p->rdev = p->replacement;
  p->replacement = NULL;

Thanks,
Kuai

