Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55D6C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 00:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhLIAvl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhLIAvl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Dec 2021 19:51:41 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8DEC061746
        for <linux-raid@vger.kernel.org>; Wed,  8 Dec 2021 16:48:08 -0800 (PST)
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639010886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JXjvpq+POzAed39CIWta9xbbGkSUXLGwlPnpmpCSjIQ=;
        b=Uvh5K8WMMoZUiH/VO5Mhiz8DNCUhKkQrfH/mx1H5y0yR8TL2Pv6T841ovV4BaUCktHSFHA
        +GkVGL2VY/A3hid//jYWlB89lD0gs9n2uWkRbjjGPh23O51P6DEzgU5kUT2R+GAmurr930
        D90MmutSYsh2XTqzs0fIAEF0DMsfxmc=
To:     Heinz Mauelshagen <heinzm@redhat.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, Song Liu <song@kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Brassow, Jonathan" <jbrassow@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
 <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
 <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
 <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
 <a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
 <3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
 <abe73176-03ca-9305-2005-677edc6ef158@linux.dev>
 <CAM23VxrYRbWEUsCsez2QOQM9oWKxSv432rc9oZCj5zEPmtND0A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <4beac38d-8932-9081-23ca-4552311697f0@linux.dev>
Date:   Thu, 9 Dec 2021 08:47:58 +0800
MIME-Version: 1.0
In-Reply-To: <CAM23VxrYRbWEUsCsez2QOQM9oWKxSv432rc9oZCj5zEPmtND0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/9/21 12:35 AM, Heinz Mauelshagen wrote:
> NACK, see details below.
>
> On Wed, Dec 8, 2021 at 3:24 PM Guoqing Jiang <guoqing.jiang@linux.dev 
> <mailto:guoqing.jiang@linux.dev>> wrote:
>
>
>
>     On 12/1/21 1:27 AM, Paul Menzel wrote:
>     >
>     >>>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>     >>>>>>> index cab12b2..0c4cbba 100644
>     >>>>>>> --- a/drivers/md/dm-raid.c
>     >>>>>>> +++ b/drivers/md/dm-raid.c
>     >>>>>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct
>     dm_target
>     >>>>>>> *ti, unsigned int argc, char **argv,
>     >>>>>>>         if (!strcasecmp(argv[0], "idle") ||
>     !strcasecmp(argv[0],
>     >>>>>>> "frozen")) {
>     >>>>>>>                 if (mddev->sync_thread) {
>     >>>>>>> set_bit(MD_RECOVERY_INTR,
>     >>>>>>> &mddev->recovery);
>     >>>>>>> - md_reap_sync_thread(mddev);
>     >>>>>>> + md_reap_sync_thread(mddev, false);
>     >>>>>
>     >>>>> I think we can add mddev_lock() and mddev_unlock() here and
>     then
>     >>>>> we don't
>     >>>>> need the extra parameter?
>     >>>>
>     >>>> I thought it too, but I would prefer get the input from DM
>     people
>     >>>> first.
>     >>>>
>     >>>> @ Mike or Alasdair
>     >>>
>     >>> Hi Mike and Alasdair,
>     >>>
>     >>> Could you please comment on this option: adding mddev_lock() and
>     >>> mddev_unlock()
>     >>> to raid_message() around md_reap_sync_thread()?
>
>     Add Heinz and Jonathan, could you comment about this? Thanks.
>
>     >>
>     >> The issue is unfortunately still unresolved (at least Linux
>     5.10.82).
>     >> How can we move forward?
>
>     If it is not applicable to change dm-raid, another alternative
>     could be
>     like this
>
>     --- a/drivers/md/md.c
>     +++ b/drivers/md/md.c
>     @@ -9409,8 +9409,12 @@ void md_reap_sync_thread(struct mdev *mddev)
>              sector_t old_dev_sectors = mddev->dev_sectors;
>              bool is_reshaped = false;
>
>     +       if (mddev_is_locked(mddev))
>     +               mddev_unlock(mddev);
>              /* resync has finished, collect result */
>              md_unregister_thread(&mddev->sync_thread);
>     +       if (mddev_is_locked(mddev))
>     +               mddev_lock(mddev);
>              if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>                  !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>                  mddev->degraded != mddev->raid_disks) {
>     diff --git a/drivers/md/md.h b/drivers/md/md.h
>     index 53ea7a6961de..96a88b7681d6 100644
>     --- a/drivers/md/md.h
>     +++ b/drivers/md/md.h
>     @@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev
>     *mddev)
>       }
>       extern void mddev_unlock(struct mddev *mddev);
>
>     +static inline int mddev_is_locked(struct mddev *mddev)
>     +{
>     +       return mutex_is_locked(&mddev->reconfig_mutex);
>     +}
>     +
>
>
> Patch is bogus relative to the proposed mddev_unlock/mddev_lock logic 
> in md.c around the
> md_unregister_thread() as it's failing to lock again if it was holding 
> the mutex before as it again
> calls mddev_locked() after having the mutex unlocked just before the 
> md_unregister_thread() call.
>
> If that patch to md.c holds up in further analysis, it has to keep the 
> mddev_is_locked() result
> and unlock/lock conditionally based on its result.
>

Yes, that was my intention too, thanks for pointing it out.

@@ -9407,10 +9407,16 @@ void md_reap_sync_thread(struct mddev *mddev)
  {
         struct md_rdev *rdev;
         sector_t old_dev_sectors = mddev->dev_sectors;
-       bool is_reshaped = false;
+       bool is_reshaped = false, is_locked = false;

         /* resync has finished, collect result */
+       if (mddev_is_locked(mddev)) {
+               is_locked = true;
+               mddev_unlock(mddev);
+       }
         md_unregister_thread(&mddev->sync_thread);
+       if (is_locked)
+               mddev_lock(mddev);

Thanks,
Guoqing
