Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D743C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Dec 2021 14:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhLHOT6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 09:19:58 -0500
Received: from out0.migadu.com ([94.23.1.103]:10960 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233375AbhLHOT6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 8 Dec 2021 09:19:58 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1638972981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBDxlLmhIcClgdgclfmBhbzS+yPLXMqj2SXtgQ9pG+w=;
        b=ceIiYTKic4VVQoRFFYQwFQAIMEL6VMt0B2YRl/UAqm7jqcnQKERhB7QzsHaiPxtuMsLG+U
        KOd7rBhukqYBoI4I4VUgwprb1kyBOqcl3j2jzecwwRhAFvFWAQVEXvzbDrIfQgk891HDSi
        2bEKF+8yXTkeXgE496Y/1fST95n6bWc=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
To:     Paul Menzel <pmenzel@molgen.mpg.de>, Song Liu <song@kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, heinzm@redhat.com,
        jbrassow@redhat.com
Cc:     linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
 <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
 <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
 <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
 <a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
 <3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
Message-ID: <abe73176-03ca-9305-2005-677edc6ef158@linux.dev>
Date:   Wed, 8 Dec 2021 22:16:16 +0800
MIME-Version: 1.0
In-Reply-To: <3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/1/21 1:27 AM, Paul Menzel wrote:
>
>>>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>>>>> index cab12b2..0c4cbba 100644
>>>>>>> --- a/drivers/md/dm-raid.c
>>>>>>> +++ b/drivers/md/dm-raid.c
>>>>>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target 
>>>>>>> *ti, unsigned int argc, char **argv,
>>>>>>>         if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], 
>>>>>>> "frozen")) {
>>>>>>>                 if (mddev->sync_thread) {
>>>>>>>                         set_bit(MD_RECOVERY_INTR, 
>>>>>>> &mddev->recovery);
>>>>>>> -                     md_reap_sync_thread(mddev);
>>>>>>> +                     md_reap_sync_thread(mddev, false);
>>>>>
>>>>> I think we can add mddev_lock() and mddev_unlock() here and then 
>>>>> we don't
>>>>> need the extra parameter?
>>>>
>>>> I thought it too, but I would prefer get the input from DM people 
>>>> first.
>>>>
>>>> @ Mike or Alasdair
>>>
>>> Hi Mike and Alasdair,
>>>
>>> Could you please comment on this option: adding mddev_lock() and 
>>> mddev_unlock()
>>> to raid_message() around md_reap_sync_thread()?

Add Heinz and Jonathan, could you comment about this? Thanks.

>>
>> The issue is unfortunately still unresolved (at least Linux 5.10.82). 
>> How can we move forward?

If it is not applicable to change dm-raid, another alternative could be 
like this

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9409,8 +9409,12 @@ void md_reap_sync_thread(struct mdev *mddev)
         sector_t old_dev_sectors = mddev->dev_sectors;
         bool is_reshaped = false;

+       if (mddev_is_locked(mddev))
+               mddev_unlock(mddev);
         /* resync has finished, collect result */
         md_unregister_thread(&mddev->sync_thread);
+       if (mddev_is_locked(mddev))
+               mddev_lock(mddev);
         if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
             mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 53ea7a6961de..96a88b7681d6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev *mddev)
  }
  extern void mddev_unlock(struct mddev *mddev);

+static inline int mddev_is_locked(struct mddev *mddev)
+{
+       return mutex_is_locked(&mddev->reconfig_mutex);
+}
+

BTW, it is holiday season,  so people are probably on vacation.

Thanks,
Guoqing
