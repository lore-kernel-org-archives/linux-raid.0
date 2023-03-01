Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0004C64EC4
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 02:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCACKv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Feb 2023 21:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCACKv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Feb 2023 21:10:51 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE4B36098
        for <linux-raid@vger.kernel.org>; Tue, 28 Feb 2023 18:10:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677636633; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=T6OjTZCsbLZxIZYwko6vZtljq/4I4u6N6F3ad7uLZiMLOyFMsmq9dTl04ignaF8L5DlmXAjGi2KfNGHlcFTGeKae/goT5oJDNroxBCT7OSELrvPqCtgXHjzhqAAVNveihL/4YNhh/aEZtfnsa+w0ERSq7v9Y0GLDjYqOVr7A97E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1677636633; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3QgasSaw0lpkNjDM89AN91sE8KhZU7V+ELRyzrYzD1U=; 
        b=eRTprACvpShVwDzrKikKF7O+v390SFw/8HZR74zs5sOuqIr5fF3V0KwoR8usfRbK7TeP2tGmf89klBimBq7MSLRzgw4k2ev/xZJDRo2zzbh2D8FHOt3LYOXFLvfbgZgR1KZAs/mHz5+d4oG0/UeBVfwwaXTxZBtqkwz2v66Qq+Q=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 167763663189674.83993661198724; Wed, 1 Mar 2023 03:10:31 +0100 (CET)
Message-ID: <7aed97cf-6044-02d1-2404-16af4415002a@trained-monkey.org>
Date:   Tue, 28 Feb 2023 21:10:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Grow: fix can't change bitmap type from none to
 clustered.
Content-Language: en-US
To:     Heming Zhao <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        ncroxon@redhat.com
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20230223143939.3817-1-heming.zhao@suse.com>
 <dc887716-1b95-709d-07b1-fe0c6ddbcfe0@trained-monkey.org>
 <5e5b885a-b77c-0d5a-d41f-0cb3cd0d33d9@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <5e5b885a-b77c-0d5a-d41f-0cb3cd0d33d9@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/23/23 18:50, Heming Zhao wrote:
> Hello Jes,
> 
> On 2/24/23 2:23 AM, Jes Sorensen wrote:
>> On 2/23/23 09:39, Heming Zhao wrote:
>>> Commit a042210648ed ("disallow create or grow clustered bitmap with
>>> writemostly set") introduced this bug. We should use 'true' logic not
>>> '== 0' to deny setting up clustered array under WRITEMOSTLY condition.
>>>
>>> How to trigger
>>>
>>> ```
>>> ~/mdadm # ./mdadm -Ss && ./mdadm --zero-superblock /dev/sd{a,b}
>>> ~/mdadm # ./mdadm -C /dev/md0 -l mirror -b clustered -e 1.2 -n 2 \
>>> /dev/sda /dev/sdb --assume-clean
>>> mdadm: array /dev/md0 started.
>>> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=none
>>> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=clustered
>>> mdadm: /dev/md0 disks marked write-mostly are not supported with
>>> clustered bitmap
>>> ```
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>
>> Applied!
>>
>> Thanks,
>> Jes
>>
> 
> With Paul Menzel comment, I will remove the dot/period in patch subject
> then
> send a v2.

I already applied it. I don't think the dot is worth respinning the
patch for.

Thanks,
Jes

