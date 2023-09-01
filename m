Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DD2CA0FE1
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 15:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbjIAPkO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjIAPkM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 11:40:12 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA1310EF
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 08:40:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693582801; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=a1+Z9mwfu597WqGZEJaK82O5vNHVIMbynAllL4aI9Zov34xxg4yBBNPXL1bWEWvBq/8+4Wo8ZTKCD7MrdxiH6AvbNyQ6AScz1g31rzyE7sVbOksBzc9kfSshqmWYrjs9jsVb5322SV7OtV5T/hcBg6IW6G+qq9+bUpH8V3sdBhc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693582801; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=t7SWBnsIJvuLez8+i84+u/9ht5ip7+J6f4c1o1+dqGY=; 
        b=T97izRvFD8X8TDU8GYX0OlBbFvI0pGTu0HPG3JU+JBg3eMyk1uU0pxVgYr43gbh24syzLUl73mL293/FxU7AxOlLnPazeJNVNnPqR6bVuOBKfDMArsPkHwAdQYv0pobpDQGy8Zh2zhd3Sqw0FVlVjzWqnnrpJIPE1hruDwW8mFA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693582798511232.28822953165934; Fri, 1 Sep 2023 17:39:58 +0200 (CEST)
Message-ID: <8bc3dfc4-758b-2ea7-132f-4413253da15d@trained-monkey.org>
Date:   Fri, 1 Sep 2023 11:39:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Add secure gethostname() wrapper
Content-Language: en-US
To:     Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20230616194555.6452-1-blazej.kucman@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230616194555.6452-1-blazej.kucman@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/16/23 15:45, Blazej Kucman wrote:
> gethostname() func does not ensure null-terminated string
> if hostname is longer than buffer length.
> For security, a function s_gethostname() has been added
> to ensure that "\0" is added to the end of the buffer.
> Previously this had to be handled in each place
> of the gethostname() call.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  Monitor.c   |  3 +--
>  lib.c       | 19 +++++++++++++++++++
>  mapfile.c   |  3 +--
>  mdadm.c     |  3 +--
>  mdadm.h     |  1 +
>  super-ddf.c |  3 +--
>  6 files changed, 24 insertions(+), 8 deletions(-)

Applied!

Thanks,
Jes


