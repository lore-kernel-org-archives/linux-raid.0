Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17110C433ED
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 20:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76CC61057
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 20:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhETU0Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 16:26:25 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35836 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbhETU0Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 16:26:25 -0400
X-Greylist: delayed 2835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 16:26:24 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 14KJbjaK024577
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 20 May 2021 20:37:46 +0100
From:   Nix <nix@esperi.org.uk>
To:     Phil Turmel <philip@turmel.org>
Cc:     Leslie Rhorer <lesrhorer@att.net>, Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>,
        Christopher Thomas <youkai@earthlink.net>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: My superblocks have gone missing, can't reassemble raid5
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
        <20210517112844.388d2270@natsu>
        <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
        <20210517181905.6f976f1a@natsu>
        <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
        <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
        <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
        <e4258686-7673-9f5f-d333-fbbb95c066b1@turmel.org>
Emacs:  it's all fun and games, until somebody tries to edit a file.
Date:   Thu, 20 May 2021 20:37:45 +0100
In-Reply-To: <e4258686-7673-9f5f-d333-fbbb95c066b1@turmel.org> (Phil Turmel's
        message of "Wed, 19 May 2021 09:41:04 -0400")
Message-ID: <87lf89nqly.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-INFN-TO-Metrics: loom 1233; Body=6 Fuz1=6 Fuz2=6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19 May 2021, Phil Turmel spake thusly:

> weekly scrubs

*Weekly*? Scrubbing my arrays takes three or four days. If I ran them
weekly the machine would never have time to do anything else!

(I run them every couple of months. Doing them more often than that
feels too much like the machine's only job is to scrub itself :)
obviously I have good backups too. The scrubs have never spotted
anything at fault in ten years or so of scrubbing at more or less this
frequency -- more often in the past, when disks were smaller and scrubs
took less time.)

If the storage machinery on this system is so badly off that it's
misreading bits more often than that I think I have bigger problems.
