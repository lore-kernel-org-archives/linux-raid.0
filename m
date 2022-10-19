Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8196BC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 20:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJSUQg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 16:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJSUQf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 16:16:35 -0400
X-Greylist: delayed 406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 13:16:31 PDT
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFA41C77EC
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 13:16:31 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 5430FEC9A1; Wed, 19 Oct 2022 16:09:44 -0400 (EDT)
References: <20221017045234.GI20480@jpo>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: now that i've screwed up and apparently get to start over ...
Date:   Wed, 19 Oct 2022 16:07:17 -0400
In-reply-to: <20221017045234.GI20480@jpo>
Message-ID: <87sfjjefsn.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


David T-G <davidtg-robot@justpickone.org> writes:

> Then GRUB puked all over itself and I can't get the stupid thing running
> at all now.  I've disconnected /dev/sde, I've disconnected all USB
> external drives, I've disconnected all internal drives, I've swapped out
> /dev/sda and put /dev/sde back, and I get that GRUB can't boot from a GPT
> disk ... except that /dev/sda has always been that!

GRUB can boot from GPT just fine.  Assuming you are booting in EFI mode,
it just has to have an EFI system partition, and be registered with the
EFI firmware.  You can't just copy the partitions to a new drive and
remove the old drive and expect it to boot.  You will need to
grub-install on the new drive to register it with the EFI firmware.

