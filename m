Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6491FC2BA4C
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 19:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244466AbiAZThk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 14:37:40 -0500
Received: from ipv6test5.plus.com ([81.174.144.187]:46524 "EHLO
        ipv6test5.plus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiAZThk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Jan 2022 14:37:40 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2022 14:37:39 EST
Received: from [IPV6:2001:470:1b4a::e9a] (custard.lan [IPv6:2001:470:1b4a::e9a])
        by ipv6test5.plus.com (Postfix) with ESMTPSA id D46934970B1A;
        Wed, 26 Jan 2022 19:29:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buttersideup.com;
        s=2021022401; t=1643225380; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RuabK0xJIPI54XFQPZSBqYGVbq2/eb4MWWYfexa+gxI=;
        b=iReFAKfQbZ2BKXA0wUt7tIvHpcjXrOxnQzj5ifgGIa/DyFcQ/LPd8ESvnuCkgoreIsOkZW
        mCWE9sIy0A1ZcCOYswm8+3EcnhP/Q1jMi+3LgofqIbHCSBxOrdL5gp3sJ/jkmb5LRQL5Lo
        rJJByX4+UsP/KGtURc4BqjSZmx942T0=
Message-ID: <fa2149a4-83bf-58f9-1b9f-282c4afe0005@buttersideup.com>
Date:   Wed, 26 Jan 2022 19:29:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
Content-Language: en-GB
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Matt Brown <matthew.brown.dev@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
 <0214ae2639174812948a631ac4e142c8@AcuMS.aculab.com>
 <e2e25fc9-ff40-9183-6ca7-fab4708fa1d0@molgen.mpg.de>
From:   Tim Small <tim@buttersideup.com>
In-Reply-To: <e2e25fc9-ff40-9183-6ca7-fab4708fa1d0@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26/01/2022 12:12, Paul Menzel wrote:

> Sure, I can change that,

FWIW, the GNU Make documentation uses "Number signs" to refer to "#", 
and I think that may cause the least confusion across speakers of 
different dialects of English.

Tim.

