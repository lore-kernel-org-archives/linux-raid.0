Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE917C4361B
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 19:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7222320679
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 19:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502807AbgLNTw3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502763AbgLNTwP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Dec 2020 14:52:15 -0500
Subject: Re: [dm-devel] [git pull] 2 reverts for 5.11 to fix v5.10 MD regression
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607975495;
        bh=I/sdAJZBdXw8dflqCakQkk0ldThTWdmK7ENon60xIKg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nZjN84+T9eQSb1xtul5jT4aNoyymMrhAeuK6H+3k9qXZ1HTC44okd6CKwnK3ONKmz
         nyaZI3xhXnajVNvjJn+DiKE4bYbzSSf4seDpOm1O2nok3hsrNHA/adw2mhi46/ccnN
         QA2Jbs/52v2fkCviqXmEa8NOQHUIi2EXGzUot2eq8cAF9/shysfLyCBvT4ckMpXK3N
         CSrd6WjuV/n8O4RgtPWQoROrjBYpuW2LWJ/vF6JbWz0A+rocFCajbdqp4G2//cUEQK
         aXDAINSq8dxG3z8wdtLfg2/tyAKp9YovSdeuPhLLnRjF018cIh/zZM/1Yif2gaeuH7
         nUQ3jd1PEJUTA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201214174757.GC2290@redhat.com>
References: <20201214174757.GC2290@redhat.com>
X-PR-Tracked-List-Id: device-mapper development <dm-devel.redhat.com>
X-PR-Tracked-Message-Id: <20201214174757.GC2290@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.11/revert-problem-v5.10-raid-changes
X-PR-Tracked-Commit-Id: 0941e3b0653fef1ea68287f6a948c6c68a45c9ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ae1985b50afaf76aaa09946ee36b59eaecb2ffae
Message-Id: <160797549531.21325.3757928272782363287.pr-tracker-bot@kernel.org>
Date:   Mon, 14 Dec 2020 19:51:35 +0000
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, axboe@kernel.dk,
        linux-raid@vger.kernel.org, davej@codemonkey.org.uk,
        gregkh@linuxfoundation.org, linux-block@vger.kernel.org,
        song@kernel.org, dm-devel@redhat.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The pull request you sent on Mon, 14 Dec 2020 12:47:57 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.11/revert-problem-v5.10-raid-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ae1985b50afaf76aaa09946ee36b59eaecb2ffae

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
