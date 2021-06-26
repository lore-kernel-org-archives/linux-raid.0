Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C67FC49EA6
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 14:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF6D61C2D
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 14:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFZOak (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Jun 2021 10:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhFZOak (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Jun 2021 10:30:40 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B6C061574
        for <linux-raid@vger.kernel.org>; Sat, 26 Jun 2021 07:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eE5hrhGyvRkpwxtRc8yJNBJGE/hT5OCKdPtmr+63Cac=; b=nbH+BjFZb8fEJpFBAgMTONqsiG
        pTR4IsZs2eDwsndSZF9dWdN1GgHSqCgs/YBBFxrFmxsG/dQZbkuG/dxqH+RoN6Y8p0rddQEVxLM2u
        Gy5ZNBHowWUr4hdlzrSGE5TkCo/NozT8F/c+bnKfqNNUYAbFPNeF8F8I+/dUr+E1mrRrcgxh6E7Yb
        3w4ji4tNu+CQW/kL1e4q/5ecsFNYi1QgwdrQ/h/tJ3Asg0f1dQavdR6mUyATYEr0xZ0ivS24gKzxP
        rmxIQVley5RDL+6C1faWfWlhM2zjfe2Q6PVIW9NLx7/y7UYn13G44HdlYtqRuLijr8WtJEkePC+n9
        ZHS+iZqw==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lx9I5-0000ma-Of; Sat, 26 Jun 2021 14:28:13 +0000
Subject: Re: 4-disk RAID6 (non-standard layout) normalise hung, now all disks
 spare
To:     antlists <antlists@youngman.org.uk>,
        Jason Flood <3mu5555@gmail.com>, linux-raid@vger.kernel.org
References: <007601d769ba$ced0e870$6c72b950$@gmail.com>
 <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org>
 <00f101d76a7b$bdb3fc50$391bf4f0$@gmail.com>
 <df60eb5f-b1c0-b3f8-4985-3cb8d9dcc531@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <011e281f-7ea3-9491-29fd-5e1574aa5819@turmel.org>
Date:   Sat, 26 Jun 2021 10:28:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <df60eb5f-b1c0-b3f8-4985-3cb8d9dcc531@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning Jason, Wol,

On 6/26/21 9:13 AM, antlists wrote:
> On 26/06/2021 12:09, Jason Flood wrote:
>>      Reshape Status : 99% complete
>>       Delta Devices : -1, (5->4)
>>          New Layout : left-symmetric
>>
>>                Name : Universe:0
>>                UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
>>              Events : 184255
>>
>>      Number   Major   Minor   RaidDevice State
>>         6       8       16        0      active sync   /dev/sdb
>>         7       8       32        1      active sync   /dev/sdc
>>         5       8       48        2      active sync   /dev/sdd
>>         4       8       64        3      active sync   /dev/sde
> 
> Phil will know much more about this than me, but I did notice that the 
> system thinks there should be FIVE raid drives. Is that an mdadm bug?

Not a bug, but a reshape from a degraded array with a reduction in space.

> That would explain the failure to assemble - it thinks there's a drive 
> missing. And while I don't think we've had data-eating trouble, 
> reshaping a parity raid has caused quite a lot of grief for people over 
> the years ...

I've never tried it starting from a degraded array.  Might be a corner 
case bug not yet exposed.

> However, you're running a recent Ubuntu and mdadm - that should all have 
> been fixed by now.

Indeed.

> Cheers,
> Wol

On 6/26/21 7:09 AM, Jason Flood wrote:
 > Thanks for that, Phil - I think I'm starting to piece it all together 
now. I was going from a 4-disk RAID5 to 4-disk RAID6, so from my reading 
the backup file was recommended. The non-standard layout meant that the 
array had over 20TB usable, but standardising the layout reduced that to 
16TB. In that case the reshape starts at the end so the critical section 
(and so the backup file) may have been in progress at the 99% complete 
point when it failed, hence the need to specify the backup file for the 
assemble command.
 >
 > I ran "sudo mdadm --assemble --verbose --force /dev/md0 /dev/sd[bcde] 
--backup-file=/root/raid5backup":
 >
 > mdadm: looking for devices for /dev/md0
 > mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
 > mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
 > mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
 > mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
 > mdadm: Marking array /dev/md0 as 'clean'
 > mdadm: /dev/md0 has an active reshape - checking if critical section 
needs to be restored
 > mdadm: No backup metadata on /root/raid5backup
 > mdadm: added /dev/sdc to /dev/md0 as 1
 > mdadm: added /dev/sdd to /dev/md0 as 2
 > mdadm: added /dev/sde to /dev/md0 as 3
 > mdadm: no uptodate device for slot 4 of /dev/md0
 > mdadm: added /dev/sdb to /dev/md0 as 0
 > mdadm: Need to backup 3072K of critical section..
 > mdadm: /dev/md0 has been started with 4 drives (out of 5).
 >

So force was sufficient to assemble.  But you are still stuck at 99%.

Look at the output of ps to see if mdmon is still running (that is the 
background process that actually reshapes stripe by stripe).  If not, 
look in your logs for clues as to why it died.

If you can't find anything significant, the next step would be to backup 
the currently functioning array to another system/drive collection and 
start from scratch.  I wouldn't trust anything else with the information 
available.

Phil

ps.  Convention on kernel.org mailing lists is to NOT top-post, and to 
trim unnecessary context.
