Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5842EC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 02:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbhLJCL2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbhLJCL2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 21:11:28 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E603C061746
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 18:07:54 -0800 (PST)
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity
 failed
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639102072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSg0qQsTtwH9hwcpjFM+j+qucI21eCsUxNZqtvK1ln4=;
        b=b5cwL78EnVJjYIdYmjP2eYRk3sFj89sP5yWDAWWWfo0s2I7U88LtOuKXHvAng9GgJ4Blc5
        ftjg0zs23flc2KIMq5hp9f2rv5GBOVU0R3HqqpUrclmeWvF/IXRnPejLqr4+utyrVR11iC
        5EIfW6ehPuAt8cV9jHX1vJSlJp5SFf0=
To:     Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com>
 <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <CALTww29Q57wDf4eWn31ChaU4dW7A=DehdtVkL-8oyzfxnwZY6w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <c77770d1-3496-9fb9-9035-0c4d259572db@linux.dev>
Date:   Fri, 10 Dec 2021 10:07:47 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww29Q57wDf4eWn31ChaU4dW7A=DehdtVkL-8oyzfxnwZY6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/10/21 9:18 AM, Xiao Ni wrote:
> On Fri, Dec 10, 2021 at 2:02 AM Song Liu <song@kernel.org> wrote:
>> On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni <xni@redhat.com> wrote:
>>> It doesn't free memory when register integrity failed. And move
>>> free conf codes into a single function.
>>>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>   drivers/md/raid0.c | 18 +++++++++++++++---
>>>   1 file changed, 15 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>>> index 62c8b6adac70..3fa47df1c60e 100644
>>> --- a/drivers/md/raid0.c
>>> +++ b/drivers/md/raid0.c
>>> @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
>>>          return array_sectors;
>>>   }
>>>
>>> +static void free_conf(struct r0conf *conf);
>>>   static void raid0_free(struct mddev *mddev, void *priv);
>>>
>>>   static int raid0_run(struct mddev *mddev)
>>> @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
>>>          dump_zones(mddev);
>>>
>>>          ret = md_integrity_register(mddev);
>>> +       if (ret)
>>> +               goto free;
>>>
>>>          return ret;
>>> +
>>> +free:
>>> +       free_conf(conf);
>> Can we just use raid0_free() here? Also, after freeing conf,
> At first I used raid0_free too. But it looks strange after adding
> acct_bioset_exit
> in raid0_free. Because if creating stripe zones failed, it doesn't
> need to free conf,
> although it doesn't have problems that passes NULL to kfree.

Maybe something like this, just FYI.

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 62c8b6adac70..c24bec49b36f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -377,6 +377,12 @@ static int raid0_run(struct mddev *mddev)
                         return ret;
                 mddev->private = conf;
         }
+
+       if (acct_bioset_init(mddev)) {
+               pr_err("md/raid0:%s: alloc acct bioset failed.\n", 
mdname(mddev));
+               return -ENOMEM;
+       }
+
         conf = mddev->private;
         if (mddev->queue) {
                 struct md_rdev *rdev;
@@ -413,6 +419,11 @@ static int raid0_run(struct mddev *mddev)
         dump_zones(mddev);

         ret = md_integrity_register(mddev);
+       if (ret) {
+               raid0_free(mddev, mddev->private);
+               mddev->private = NULL;
+               acct_bioset_exit(mddev);
+       }

         return ret;
  }

Thanks,
Guoqing
