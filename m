Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735D1C38A02
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJ1Pn0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJ1PnY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:43:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309DA1CA597
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:43:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CF87A21D3A;
        Fri, 28 Oct 2022 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666971802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2+wtU6zde7xyrANO9zO5XcjX9Ex+l4+AvdqE0G5zNM=;
        b=nZahF8B+8KqWZyLpaAzCwGIsP+iCScyAXCTOoKqcdNqnqD3UsjHyD+7JotRL/4SxAnnJuu
        UiGtltTx8zMZvP9fdpyYrbmpV+GeMWKTYkjzUzaiNxvBhCIdov7lOsS1qd1f0Q+Ax/47RM
        lRg9j76JzyYjyns1SyT1LI3ykvrtAEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666971802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2+wtU6zde7xyrANO9zO5XcjX9Ex+l4+AvdqE0G5zNM=;
        b=TH3j/l+luECoFNh4+0FzrdkvysH8M/0TYM5WSp/bRr+fWLctICS6EHC7Guw/lpoG61SKyj
        mRJSBbYwrqAxRDDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D2D0E13A6E;
        Fri, 28 Oct 2022 15:43:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UVcLJpn4W2P+UwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:43:21 +0000
Message-ID: <ed212b9a-8a56-63a9-a637-146c99beed3b@suse.de>
Date:   Fri, 28 Oct 2022 23:42:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 0/9] Mdmonitor refactor and udev event handling
 improvements
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220907125657.12192-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Along the way we observed many problems with current approach to event handling in mdmonitor.
> It frequently doesn't report Fail and DeviceDisappeared events.
> It's due to time races with udev, and too long delay in some cases.
> While there was a patch intending to address time races with udev, it didn't remove them completely.
> This patch series presents alternative approach, where mdmonitor wakes up on udev events, so that
> there should be no more conflicts with udev we saw before.
>
> Additionally some code quality improvements were done, to make the code more maintainable.

Hi Mateusz,

I am not familiar with the udev stuffs, and take some time to review all 
this series. Overall I am fine with this series, except for the code 
comment style like,
/**
  * It seems not md kernel code comment style
  */


And I leave my comments in each patch, please check them.

Thanks.


Coly Li



>
> Mateusz Grzonka (9):
>    Mdmonitor: Split alert() into separate functions
>    Mdmonitor: Make alert_info global
>    Mdmonitor: Pass events to alert() using enums instead of strings
>    Mdmonitor: Add helper functions
>    Add helpers to determine whether directories or files are soft links
>    Mdmonitor: Refactor write_autorebuild_pid()
>    Mdmonitor: Refactor check_one_sharer() for better error handling
>    Mdmonitor: Improve udev event handling
>    udev: Move udev_block() and udev_unblock() into udev.c
>
>   Create.c  |   1 +
>   Makefile  |   3 +-
>   Manage.c  |   3 +-
>   Monitor.c | 707 ++++++++++++++++++++++++++++++++----------------------
>   lib.c     |  42 ----
>   mdadm.h   |   6 +-
>   mdopen.c  |  19 +-
>   udev.c    | 191 +++++++++++++++
>   udev.h    |  38 +++
>   util.c    |  46 ++++
>   10 files changed, 713 insertions(+), 343 deletions(-)
>   create mode 100644 udev.c
>   create mode 100644 udev.h
>

