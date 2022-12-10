Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FB0C4332F
	for <linux-raid@archiver.kernel.org>; Sat, 10 Dec 2022 20:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLJUIb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Dec 2022 15:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLJUIa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Dec 2022 15:08:30 -0500
X-Greylist: delayed 521 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 10 Dec 2022 12:08:29 PST
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77380164A6
        for <linux-raid@vger.kernel.org>; Sat, 10 Dec 2022 12:08:29 -0800 (PST)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 7873F616D5
        for <linux-raid@vger.kernel.org>; Sun, 11 Dec 2022 06:59:45 +1100 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id Iz9b_Q6iPL82 for <linux-raid@vger.kernel.org>;
        Sun, 11 Dec 2022 06:59:45 +1100 (AEDT)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 4B4DF6155B
        for <linux-raid@vger.kernel.org>; Sun, 11 Dec 2022 06:59:45 +1100 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 3440568027E; Sun, 11 Dec 2022 06:59:45 +1100 (AEDT)
Date:   Sun, 11 Dec 2022 06:59:45 +1100
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-raid@vger.kernel.org
Subject: Is it possible to restart --add?
Message-ID: <20221210195945.GA34756@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

When replacing a failed disk with a new one using --add, is it possible to 
restart a partially-complete --add, e.g. after a reboot?

I have a raid-6 with a failed disk, and used --add to add a new disk as a 
replacement. From /proc/mdstat, "finish" told me it would take around 24 
hours to complete the add.

The machine was rebooted some hours into the add, and on restart the md 
was missing the new disk (and the failed disk). I tried to --re-add the 
new disk again, but mdadm told me it's "not possible":

mdadm: --re-add for /dev/sdh1 to /dev/md0 is not possible

I ended up --add'ing the disk again, so the 24 hours to complete started 
again.

Is this expected, and/or is there a way to restart the --add rather than 
starting from the beginning again?

$ mdadm --version
mdadm - v4.1 - 2018-10-01

Thanks,

Chris
