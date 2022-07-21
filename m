Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C25EC43334
	for <linux-raid@archiver.kernel.org>; Thu, 21 Jul 2022 16:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiGUQVx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Jul 2022 12:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGUQVw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Jul 2022 12:21:52 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308545006E
        for <linux-raid@vger.kernel.org>; Thu, 21 Jul 2022 09:21:49 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id F1FE761EA192A;
        Thu, 21 Jul 2022 18:21:46 +0200 (CEST)
Message-ID: <4cea4ea7-7d59-da76-6518-ef12ec51c09e@molgen.mpg.de>
Date:   Thu, 21 Jul 2022 18:21:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Ternary Operator (was: [PATCH mdadm v2] super1: report truncated
 device)
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>
 <20220721101907.00002fee@linux.intel.com>
Cc:     Neil Brown <neilb@suse.de>, Jes Sorensen <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220721101907.00002fee@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Mariusz,


Am 21.07.22 um 10:19 schrieb Mariusz Tkaczyk:

> On Wed, 13 Jul 2022 13:48:11 +1000 NeilBrown wrote:

[…]

>> +	}
>> +	printf("          State : %s%s\n",
>> +	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",
>> +	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : "");
> 
> Could you use standard if instruction to make the code more readable? We are
> avoiding ternary operators if possible now.

That’s news to me. Where is that documented? If find the operator quite 
useful in situations like this.


Kind regards,

Paul
