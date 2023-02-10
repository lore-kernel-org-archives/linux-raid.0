Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A254C636D4
	for <linux-raid@archiver.kernel.org>; Fri, 10 Feb 2023 02:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjBJCKm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Feb 2023 21:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBJCKl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Feb 2023 21:10:41 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099096E9B6
        for <linux-raid@vger.kernel.org>; Thu,  9 Feb 2023 18:10:39 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PCcdj6LtXz4f3m6x
        for <linux-raid@vger.kernel.org>; Fri, 10 Feb 2023 10:10:33 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
        by APP4 (Coremail) with SMTP id gCh0CgCH77KZp+VjID1TDQ--.15159S3;
        Fri, 10 Feb 2023 10:10:36 +0800 (CST)
Message-ID: <639bcf6e-b8b1-e002-a61f-93ec7ad04bbd@huaweicloud.com>
Date:   Fri, 10 Feb 2023 10:10:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Li Nan <linan666@huaweicloud.com>
To:     david.sloan@eideticom.com
Subject: =?UTF-8?Q?question_about_5e8daf906f89_=28=22md=3a_Flush_workqueue_m?=
 =?UTF-8?B?ZF9yZGV2X21pc2Nfd3EgaW4gbWRfYWxsb2MoKeKAnSk=?=
Cc:     linux-raid@vger.kernel.org, yangerkun@huawei.com,
        yukuai@huawei.com, song@kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: gCh0CgCH77KZp+VjID1TDQ--.15159S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY27kC6x804xWl14x267AKxVWUJVW8JwAF
        c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
        0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
        wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY
        6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr
        0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxG
        rwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
        VjvjDU0xZFpf9x07URwZ7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
Commit log says there is race condition in md_rdev_misc_wq, but I find 
nothing wrong with it. Could you tell me how to trigger the bug?

Thansks,
nan.

