Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F631E7D0AF
	for <linux-raid@archiver.kernel.org>; Thu, 21 Sep 2023 22:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjIUWNc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjIUWNP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Sep 2023 18:13:15 -0400
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1151BC7
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 15:03:52 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 4D3F740652;
        Thu, 21 Sep 2023 22:03:50 +0000 (UTC)
Date:   Fri, 22 Sep 2023 03:03:40 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     linux-raid@vger.kernel.org
Cc:     Kirill Kirilenko <kirill@ultracoder.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        heinzm@redhat.com
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
Message-ID: <20230922030340.2eaa46bc@nvm>
In-Reply-To: <ZQy5dClooWaZoS/N@redhat.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
        <ZQy5dClooWaZoS/N@redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 21 Sep 2023 17:45:24 -0400
Mike Snitzer <snitzer@kernel.org> wrote:

> I just verified that 6.5.0 does have this DM core fix (needed to
> prevent excessive splitting of discard IO.. which could cause fstrim
> to take longer for a DM device), but again 6.5.0 has this fix so it
> isn't relevant:
> be04c14a1bd2 dm: use op specific max_sectors when splitting abnormal io
> 
> Given your use of 'writemostly' I'm inferring you're using lvm2's
> raid1 that uses MD raid1 code in terms of the dm-raid target.
> 
> Discards (more generic term for fstrim) are considered writes, so
> writemostly really shouldn't matter... but I know that there have been
> issues with MD's writemostly code (identified by others relatively
> recently).
> 
> All said: hopefully someone more MD oriented can review your report
> and help you further.
> 
> Mike  

I've reported that write-mostly TRIM gets split into 1MB pieces, which can be
an order of magnitude slower on some SSDs: https://www.spinics.net/lists/raid/msg72471.html

Nobody cared to reply, investigate or fix.

Maybe your system hasn't frozen too, just taking its time in processing all
the tiny split requests.

-- 
With respect,
Roman
