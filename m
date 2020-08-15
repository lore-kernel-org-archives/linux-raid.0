Return-Path: <SRS0=Kmql=BZ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32457C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 15 Aug 2020 22:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18DF5205CB
	for <linux-raid@archiver.kernel.org>; Sat, 15 Aug 2020 22:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgHOWHk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgHOVun (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 15 Aug 2020 17:50:43 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1413C09B040
        for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2020 08:03:50 -0700 (PDT)
Received: from [172.58.171.202] (helo=[192.168.42.102])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1k6xif-0008Ij-9s; Sat, 15 Aug 2020 15:03:41 +0000
Subject: Re: Confusing output of --examine-badblocks1 message
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net>
 <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net>
 <303847410.22535373.1597344622629.JavaMail.zimbra@karlsbakk.net>
 <573421659.22903312.1597428439621.JavaMail.zimbra@karlsbakk.net>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <de6e9dd1-7447-54ab-1818-ceabf422c8a0@turmel.org>
Date:   Sat, 15 Aug 2020 11:03:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <573421659.22903312.1597428439621.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/14/20 2:07 PM, Roy Sigurd Karlsbakk wrote:
>> I just tried another approach, mdadm --remove on the spares, mdadm --examine on
>> the removed spares, no superblock. Then madm --fail for one of the drives and
>> mdadm --add for another, now spare for a few milliseconds until recovery
>> started. This runs as it should, slower than --replace, but I don't care. After
>> 12% or so, I checked with --examine-badblocks, and the same sectors are popping
>> up again. This was just a small test to see i --replace was the "bad guy" here
>> or if a full recovery would do the same. It does.
> 
> For the record, I just tested mdadm --replace again on a disk in the raid. The source disk had no badblocks. The destination disk is new-ish (that is, a few years old, but hardly written to and without an md superblock). It seems the badblocks present on other drives in the raid6 are also replicated to the "new" disk. This is not really how it should be IMO.
> 
> There must be a major bug in here somewhere. If there's a bad sector somewhere, well, ok, I can handle some corruption. The filesystem will probably be able to handle it as well. But if this is all blocked because of flakey "bad" sectors not really being bad, then something is bad indeed.

In my not-so-humble opinion, the bug is the existence of the BadBlocks 
feature.  Once a badblock is recorded for a sector, redundancy is 
permanently lost at that location.  There is no tool to undo this.

I strongly recommend that you remove badblock logs on all arrays before 
the "feature" screws you.

Phil
