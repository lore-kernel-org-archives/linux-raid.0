Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439CFC433F5
	for <linux-raid@archiver.kernel.org>; Sun,  6 Mar 2022 14:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiCFO4i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Mar 2022 09:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiCFO4i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Mar 2022 09:56:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7A354BF8;
        Sun,  6 Mar 2022 06:55:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 913711F37D;
        Sun,  6 Mar 2022 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646578544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5D+rozMKHqiwrNf7CgYcK3jmfmKFLqxQXtyCiYe+80=;
        b=wCjrwXauk5eoHzl3KE9wufgtkH23YoKTkwywRYtOyoONiFAxJJaE7SQkph0uSXea2E16ki
        6rsOnLNH9vllgb7BTcEpACmuz9aPWhyM9uAHxTmJnwOYqa/sii+Y/yCx/XLLV5ya/8exUp
        mxg5oBO9U4qllpkUDOP12/DDnLw56zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646578544;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5D+rozMKHqiwrNf7CgYcK3jmfmKFLqxQXtyCiYe+80=;
        b=8sd2UFxxCKiULn83eZrfTo1y/E9q78PUnAWkkXIZUtcEE1Kf1PaW0juAzhi1eIUqC6v7IO
        LRSA62xlUqHMb+DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12434132C1;
        Sun,  6 Mar 2022 14:55:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rOagOGzLJGJKUQAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 06 Mar 2022 14:55:40 +0000
Message-ID: <3b93c0db-316e-d227-e98e-be7a6f4e2907@suse.de>
Date:   Sun, 6 Mar 2022 22:55:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: bcache patches for Linux v5.18
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <084b5385-ebe7-5fca-8b56-a66276005e78@suse.de>
 <c94f9c70-7052-0bae-ca0e-9b9ccc48c46b@kernel.dk>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <c94f9c70-7052-0bae-ca0e-9b9ccc48c46b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/6/22 10:17 PM, Jens Axboe wrote:
> On 3/6/22 3:35 AM, Coly Li wrote:
>> Hi Jens,
>>
>> I have technical problem to send patches via email this time, please
>> consider to pull the bcache changes from my bcache tree. They can be
>> applied on top of your for-5.18/drivers branch.
>>
>> We have 2 patches for Linux v5.18, both of them are from Mingzhe Zou.
>> The first patch improves bcache initialization speed by avoid
>> unnecessary cost of cache consistency, the second one fixes a
>> potential NULL pointer deference in bcache initialization time,
>>
>> Please take them for Linux v5.18, thanks in advance.
> I can take a git pull, but don't base it on something that isn't a tree
> of mine. If I pull your branch right now, I'll get a ton of unrelated
> changes.

I see, my for-next branch is not 100% clone the for-5.18/drivers branch, 
although the patches are verified on top of it.


> If you want to do a git pull vs sending patches, base it on
> for-5.18/drivers instead.
>
Copied. Now I pull my for-next branch from your for-5.18/drivers branch, 
and they are same, and the two patches are added on top of it.

Here is the updated pull request, could you please try it again? Thanks.


The following changes since commit 13d4ef0f66b7ee9415e101e213acaf94a0cb28ee:

   floppy: use memcpy_{to,from}_bvec (2022-03-04 12:29:21 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/colyli/linux-bcache.git 
for-next

for you to fetch changes up to 887554ab96588de2917b6c8c73e552da082e5368:

   bcache: fixup multiple threads crash (2022-03-06 22:33:45 +0800)

----------------------------------------------------------------
Mingzhe Zou (2):
       bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU 
false sharing
       bcache: fixup multiple threads crash

  drivers/md/bcache/btree.c     |  6 ++++--
  drivers/md/bcache/writeback.c | 17 +++++++++++------
  2 files changed, 15 insertions(+), 8 deletions(-)



