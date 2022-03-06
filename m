Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87747C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  6 Mar 2022 10:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiCFKgo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Mar 2022 05:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiCFKgm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Mar 2022 05:36:42 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4893B41FBE;
        Sun,  6 Mar 2022 02:35:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E6C591F38E;
        Sun,  6 Mar 2022 10:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646562949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ncyEBdB3ccJeT/v1FwGpzA012uU/apTZMynZ78KjLtY=;
        b=hN6/UQ0u7uGcE9vcylCAyQFjqcWaClXVfmJAO5v03VKAxjQA8DRJd69De0wynuQvaR5QA7
        XRoRJyqA7Z2MfgY7mn+1zt5ReCNLMB1/tst7yvW/l2XhmGi1apjTgkCVJsnh2U+rAfVOQd
        HjVvXvC+a+ZWK7qhAxAP7w1gDcDIXrQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646562949;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ncyEBdB3ccJeT/v1FwGpzA012uU/apTZMynZ78KjLtY=;
        b=SE2Cb90Y+Z+G8eIIJIf69ZN8iJ8wnVqsHRxZ7+DexDeYNLKKCh8cAYlBaUZGCZomNgLU08
        PjmAHoD8ivL1hjBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F29613510;
        Sun,  6 Mar 2022 10:35:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oL/ZNoOOJGJjDwAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 06 Mar 2022 10:35:47 +0000
Message-ID: <084b5385-ebe7-5fca-8b56-a66276005e78@suse.de>
Date:   Sun, 6 Mar 2022 18:35:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
From:   Coly Li <colyli@suse.de>
Subject: bcache patches for Linux v5.18
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

I have technical problem to send patches via email this time, please 
consider to pull the bcache changes from my bcache tree. They can be 
applied on top of your for-5.18/drivers branch.

We have 2 patches for Linux v5.18, both of them are from Mingzhe Zou. 
The first patch improves bcache initialization speed by avoid 
unnecessary cost of cache consistency, the second one fixes a potential 
NULL pointer deference in bcache initialization time,

Please take them for Linux v5.18, thanks in advance.

Coly Li


The following changes since commit dcde98da997075053041942ecf97d787855722ec:

   Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2022-03-05 
15:49:45 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/colyli/linux-bcache.git/ 
for-next

for you to fetch changes up to 387ac428d163b6fffa923618624505e7afe0b53d:

   bcache: fixup multiple threads crash (2022-03-06 18:14:43 +0800)

----------------------------------------------------------------
Mingzhe Zou (2):
       bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU 
false sharing
       bcache: fixup multiple threads crash

  drivers/md/bcache/btree.c     |  6 ++++--
  drivers/md/bcache/writeback.c | 17 +++++++++++------
  2 files changed, 15 insertions(+), 8 deletions(-)
