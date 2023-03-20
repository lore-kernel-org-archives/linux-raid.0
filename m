Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEA7C7618A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 17:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjCTRke (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 13:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjCTRjw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 13:39:52 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CE96A55
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 10:35:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679332539; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=K76DknHscbBDTU0sSSyTfCJ7L7AnY22/d6D+2Y0FwRBH6lLhVDwK3AAVRn/c9UMbAhjV+QJjj6+BHK85nFlkZkMDomwot0/Ojv/KP/8u4X/MykpfWGSXJWZuTpXEXuzNFoGDN6TS7IX7K0wKAF2m+H6Td8XMP0XpoAAOYw9/rUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679332539; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=kij+Nu6TPAtImDW5velvx+sq066vqEQd8TLn6gSAZs4=; 
        b=GTIe+oP5MxVon2FuTT85geq3m5pEzEE9uQRdEwagk7wt5PsjOcYgv7ErdYHd4FQGWTvBWAPJGkE+b7k3uUtR7hHJv6TFjpsJQ8riaqQb0vUB6EyTf6Pq8acwR4TBKnO4W6W3wNXebWDkoCjmFG1nUiaWGKFSRnjoOHnrt19mqiE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1679332537517401.9625151952937; Mon, 20 Mar 2023 18:15:37 +0100 (CET)
Message-ID: <c36ee145-c258-5a02-f268-30c145996759@trained-monkey.org>
Date:   Mon, 20 Mar 2023 13:15:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH - mdadm] mdopen: always try create_named_array()
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikolay Kichukov <hijacker@oldum.net>
References: <167875238571.8008.9808655454439667586@noble.neil.brown.name>
 <318ff554-0694-64e1-72bd-d941a775a16f@trained-monkey.org>
 <167926378352.8008.3450187952660050637@noble.neil.brown.name>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <167926378352.8008.3450187952660050637@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/19/23 18:09, NeilBrown wrote:
> On Mon, 20 Mar 2023, Jes Sorensen wrote:
>> On 3/13/23 20:06, NeilBrown wrote:
>>>
>>> mdopen() will use create_named_array() to ask the kernel to create the
>>> given md array, but only if it is given a number or name.
>>> If it is NOT given a name and is required to choose one itself using
>>> find_free_devnm() it does NOT use create_named_array().
>>>
>>> On kernels with CONFIG_BLOCK_LEGACY_AUTOLOAD not set, this can result in
>>> failure to assemble an array.  This can particularly seen when the
>>> "name" of the array begins with a host name different to the name of the
>>> host running the command.
>>>
>>> So add the missing call to create_named_array().
>>>
>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217074
>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>
>> Applied!
> 
> Thanks.
> 
> Do you have plans for releasing 4.3?  I'd like this patch to be in a
> numbered release for at least a few months before we change the kernel
> Kconfig to allow md to be built without CONFIG_BLOCK_LEGACY_AUTOLOAD.

No immediate plans, but no reason why we shouldn't do it. I think
Mariusz has some pending changes he wants to get in as well, like the
error number stuff.

So lets make this a call for submitting changes for mdadm that are
needed for the next release.

Thanks,
Jes


