Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4279EC61DA4
	for <linux-raid@archiver.kernel.org>; Tue,  7 Mar 2023 01:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCGB1y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 20:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCGB1x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 20:27:53 -0500
X-Greylist: delayed 543 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Mar 2023 17:27:51 PST
Received: from out-63.mta1.migadu.com (out-63.mta1.migadu.com [IPv6:2001:41d0:203:375::3f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A23F4BE91
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 17:27:51 -0800 (PST)
Message-ID: <5be00f6c-22ee-1af3-c5ed-d92863d7f442@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678151926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=crFIcr4bgnXNaqnGbvggQbdpzUCxWPHITHXV68P7xMA=;
        b=FfAnxY/pW51zaWcTY11csqBns/HNsKTBYvHCrv64bP4E1I2TzCWcc3ESG6k89MdKPxkx+C
        kWNiK3pyaezBEZFogCxvUhV5Xrna/WhHQTw1X65z/gLQx8w209VpDLdj4NISqdj56kH6Gd
        7v5Opvgu4myBRQxWGIl7XNykS+9Xp48=
Date:   Tue, 7 Mar 2023 09:18:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 00/34] address various checkpatch.pl requirements
To:     heinzm@redhat.com, linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
References: <cover.1678136717.git.heinzm@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/7/23 05:27, heinzm@redhat.com wrote:
> From: heinzm <heinzm@redhat.com>
>
> This patch series addresses checkpatch.pl reuirements.
>
> It is grouped into patches addressing errors first then warnings.
> Each patch fixes flaws in one semantical respect (e.g. fix spaces).
>
> Series passed upstream regression tests succesfully.
>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> Reviewed-by: Nigel Croxon <ncroxon@redhat.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Tested-by: Nigel Croxon <ncroxon@redhat.com>
> Tested-by: Xiao Ni <xni@redhat.com>
>
> Heinz Mauelshagen (34):
>    md: fix required/prohibited spaces [ERROR]
>    md: fix 'foo*' and 'foo * bar' [ERROR]
>    md: fix EXPORT_SYMBOL() to follow its functions immediately [ERROR]
>    md: adjust braces on functions/structures [ERROR]
>    md: correct code indent [ERROR]
>    md: move trailing statements to next line [ERROR]
>    md: consistent spacing around operators [ERROR]
>    md: don't initialize statics/globals to 0/false [ERROR]
>    md: else should follow close curly brace [ERROR]
>    md: remove trailing whitespace [ERROR]
>    md: do not use assignment in if condition [ERROR]
>    md: add missing blank line after declaration [WARNING]
>    md: space prohibited between function and opening parenthesis [WARNING]
>    md: prefer seq_put[cs]() to seq_printf() |WARNING]
>    md: avoid multiple line dereference [WARNING}
>    md: fix block comments [WARNING]
>    md: add missing function identifier names to function definition arguments [WARNING]
>    md: avoid redundant braces in single line statements [WARNING]
>    md: place constant on the right side of a test [WARNING]
>    md: avoid pointless filenames in files [WARNING]
>    md: avoid useless else after break or return [WARNING]
>    md: don't indent labels [WARNING]
>    md: fix code indent for conditional statements [WARNING]
>    md: prefer octal permissions [WARNING]
>    md: remove bogus IS_ENABLED() macro [WARNING]
>    md autodetect: correct placement of __initdata [WARNING]
>    md: prefer using "%s...", __func__ [WARNING]
>    md pq: adjust __attribute__ [WARNING]
>    md: prefer 'unsigned int' [WARNING]
>    md: prefer kmap_local_page() instead of deprecated kmap_atomic() [WARNING]
>    md raid5: prefer 'int' instead of 'signed' [WARNING]
>    md: prefer kvmalloc_array() with multiply [WARNING]
>    md: avoid splitting quoted strings [WARNING]
>    md: avoid return in void functions [WARNING]

Most of them do have empty log ...

And I don't think it makes sense to run checkpatch on old code.

Thanks,
Guoqing
