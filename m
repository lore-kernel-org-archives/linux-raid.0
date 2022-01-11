Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA60C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 12:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239968AbiAKMel (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:34:41 -0500
Received: from peda.net ([130.234.6.152]:29729 "EHLO lb1.peda.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238836AbiAKMei (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 11 Jan 2022 07:34:38 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 07:34:38 EST
Received: from [84.251.221.37] (dsl-jklbng12-54fbdd-37.dhcp.inet.fi [84.251.221.37])
        by lb1.peda.net (Postfix) with ESMTPSA id DC1C2600008;
        Tue, 11 Jan 2022 14:25:04 +0200 (EET)
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
Cc:     agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From:   Mikko Rantalainen <mikko.rantalainen@peda.net>
Message-ID: <a238949b-f8e2-fc6a-fecc-99df8ec6292a@peda.net>
Date:   Tue, 11 Jan 2022 14:25:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Guoqing Jiang (2021-02-13 02:49 Europe/Helsinki):
> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> doesn't reconfigure array.
> 
> And it could cause deadlock problem for raid5 as follows:
> 
> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>    idle to sync_action.
> 2. raid5 sync thread was blocked if there were too many active stripes.
> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>    which causes the number of active stripes can't be decreased.
> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>    to hold reconfig_mutex.
> 
> More details in the link:
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

I don't understand md well enough to suggest a patch but isn't this
logically a classic two lock deadlock problem where

thread 1:
- lock reconfig_mutex
- blocked for sync that requires SB_CHANGE_PENDING

thread 2:
- (logically) acquire lock SB_CHANGE_PENDING
- blocked for reconfig_mutex before SB_CHANGE_PENDING can be released

?

The classic fix for this kind of deadlock is to require these locks to
be always acquired in constant order and released in reverse order.

If you had a rule that SB_CHANGE_PENDING cannot be set or cleared
without already having reconfig_mutex, wouldn't that prevent this
deadlock? (If I understood the issue correctly, it's currently possible
to set but not clear the SB_CHANGE_PENDING without having reconfig_mutex.)

Another possibility is to expect SB_CHANGE_PENDING to be set as part of
sync process required change to "idle" (write to sync_action). In that
case the logic would be you cannot have reconfig_mutex already locked
before setting (logically acquiring lock) SB_CHANGE_PENDING. So the
transfer from active to idle would require first setting
SB_CHANGE_PENDING, doing the required processing (getting and freeing
reconfig_mutex in process) and then clearing SB_CHANGE_PENDING.
Basically the rule would be you must lock SB_CHANGE_PENDING before you
can lock reconfig_mutex.

If I've understood correctly SB_CHANGE_PENDING is not technically a lock
but it's logically used like it were a lock.

Would either of these make sense for the overall design?

Obviously, if it doesn't hurt the performance too much, using a single
lock for everything that needs to be serialized would be much easier.

-- 
Mikko
