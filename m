Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAC8C678D4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 08:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCFIbJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 03:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCFIbI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 03:31:08 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020F9AD02
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 00:31:05 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aefdc.dynamic.kabel-deutschland.de [95.90.239.220])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5C4FC61CC40F9;
        Mon,  6 Mar 2023 09:31:04 +0100 (CET)
Message-ID: <6e0c915c-a9f4-17b4-97a1-abac9fc1a68d@molgen.mpg.de>
Date:   Mon, 6 Mar 2023 09:31:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6/6] mdmon improvements for switchroot
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
 <167745678753.16565.5052083348539533042.stgit@noble.brown>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <167745678753.16565.5052083348539533042.stgit@noble.brown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Neil,


Thank you for your patch.

Am 27.02.23 um 01:13 schrieb NeilBrown:

For commit message summary, I’d use a statement – maybe:

mdmon: Improve switchroot

> We need a new mdmon@mdfoo instance to run in the root filesystem after
> switch root, as /sys and /dev are removed from the initrd.
> 
> systemd will not start a new unit with the same name running while the
> old unit is still active, and we want the two mdmon processes to overlap
> in time to avoid any risk of deadlock which a write is attempted with no
> mdmon running.

I do not understand the part after *deadlock*.

> So we need a different unit name in the initrd than in the root.  Apart
> from the name, everything else should be the same.
> 
> This is easily achieved using a different instance name as the
> mdmon@.service unit file already supports multiple instances (for
> different arrays).
> 
> So start "mdmon@mdfoo.service" from root, but
> "mdmon@initrd-mdfoo.service" from the initrd.  udev can tell which
> circumstance is the case by looking for /etc/initrd-release.
> continue_from_systemd() is enhanced so that the "initrd-" prefix can be
> requested.
> 
> Teach mdmon that a container name like "initrd/foo" should be treated
> just like "foo".  Note that systemd passes the instance name
> "initrd-foo" as "initrd/foo".
> 
> We don't need a similar machanism at shutdown because dracut runs

mechanism

> "mdmon --takeover --all" when appropriate.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>   Grow.c                    |    4 ++--
>   mdadm.h                   |    2 +-
>   mdmon.c                   |    6 +++++-
>   systemd/mdmon@.service    |    2 +-
>   udev-md-raid-arrays.rules |    3 ++-
>   util.c                    |    7 ++++---
>   6 files changed, 15 insertions(+), 9 deletions(-)

[…]


Kind regards,

Paul
