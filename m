Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E62AC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 08:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiEKIKs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 04:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243300AbiEKIKr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 04:10:47 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DD7F0D
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 01:10:42 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652256640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wz5xUPxmRyiFpVC+ZH6Stb7dh9SvDE4d9EOyf42S5UU=;
        b=al9OsCtTXd8wLpqntxtwfrkBG2uI7WzCN/qYG31HvBqRY3QDw/0MP0HyJ689mIQcxlCWF5
        74Sm9UNIRE76o+KEgXA7kZewAn/G7cbpSIAiMfEDCiTFBjXQtuLGr9t/apAE/zqEumHK2Y
        38ON51e9Uin+mpON1xPXvr70ZPeMHpQ=
To:     Song Liu <song@kernel.org>, Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de>
 <e50fa5ee-156a-aa22-fc49-390cefa3875f@linux.dev>
 <675626ff-f18b-78ab-f5a0-2ee44ab0d399@molgen.mpg.de>
 <CAPhsuW4ZVkzQa=UKz=TR52ye23RAyubUOgdhT7=OGqTR8uWwVw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <52e9aa65-581a-63fc-272a-0477f8c6e873@linux.dev>
Date:   Wed, 11 May 2022 16:10:31 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4ZVkzQa=UKz=TR52ye23RAyubUOgdhT7=OGqTR8uWwVw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------6E55EC5C81E390700FB70AEC"
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------6E55EC5C81E390700FB70AEC
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/11/22 2:02 AM, Song Liu wrote:
> On Tue, May 10, 2022 at 5:35 AM Donald Buczek <buczek@molgen.mpg.de> wrote:
>> On 5/10/22 2:09 PM, Guoqing Jiang wrote:
>>>
>>> On 5/10/22 8:01 PM, Donald Buczek wrote:
>>>>> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
>>>>> md-next.
>>>> I think, this can be used to get a double-free from md_unregister_thread.
>>>>
>>>> Please review
>>>>
>>>> https://lore.kernel.org/linux-raid/8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de/
>>> That is supposed to be addressed by the second one, pls consider it too.
>> Right, but this has not been pulled into md-next. I just wanted to note, that the current state of md-next has this problem.

Thanks for reminder.

>> If the other patch is taken, too, and works as intended, that would be solved.
>>
>>> [PATCH 2/2] md: protect md_unregister_thread from reentrancy
> Good catch!
>
> Guoqing, current 2/2 doesn't apply cleanly. Could you please resend it on top of
> md-next?

Hmm, no issue from my side.

~/source/md> git am 
0001-md-protect-md_unregister_thread-from-reentrancy.patch
Applying: md: protect md_unregister_thread from reentrancy

~/source/md> git log --oneline |head -5
dc7147a88766 md: protect md_unregister_thread from reentrancy
5a36c493dc82 md: don't unregister sync_thread with reconfig_mutex held
49c3b9266a71 block: null_blk: Improve device creation with configfs
db060f54e0c5 block: null_blk: Cleanup messages
b3a0a73e8a79 block: null_blk: Cleanup device creation and deletion

Anyway, it is attached. I will rebase it to your latest tree if 
something gets wrong.

Thanks,
Guoqing

--------------6E55EC5C81E390700FB70AEC
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-md-protect-md_unregister_thread-from-reentrancy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-md-protect-md_unregister_thread-from-reentrancy.patch"

From a2da80f62f15023e3fee7a02488c143dfff647b3 Mon Sep 17 00:00:00 2001
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Date: Fri, 29 Apr 2022 16:49:09 +0800
Subject: [PATCH 2/2] md: protect md_unregister_thread from reentrancy

Generally, the md_unregister_thread is called with reconfig_mutex, but
raid_message in dm-raid doesn't hold reconfig_mutex to unregister thread,
so md_unregister_thread can be called simulitaneously from two call sites
in theory.

Then after previous commit which remove the protection of reconfig_mutex
for md_unregister_thread completely, the potential issue could be worse
than before.

Let's take pers_lock at the beginning of function to ensure reentrancy.

Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a70e7f0f9268..c401e063bec8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7962,17 +7962,22 @@ EXPORT_SYMBOL(md_register_thread);
 
 void md_unregister_thread(struct md_thread **threadp)
 {
-	struct md_thread *thread = *threadp;
-	if (!thread)
-		return;
-	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
-	/* Locking ensures that mddev_unlock does not wake_up a
+	struct md_thread *thread;
+
+	/*
+	 * Locking ensures that mddev_unlock does not wake_up a
 	 * non-existent thread
 	 */
 	spin_lock(&pers_lock);
+	thread = *threadp;
+	if (!thread) {
+		spin_unlock(&pers_lock);
+		return;
+	}
 	*threadp = NULL;
 	spin_unlock(&pers_lock);
 
+	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 	kthread_stop(thread->tsk);
 	kfree(thread);
 }
-- 
2.31.1


--------------6E55EC5C81E390700FB70AEC--
