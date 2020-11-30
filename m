Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49ECEC63777
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 21:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E85A62076A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 21:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgK3VU6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:20:58 -0500
Received: from burlywood.elm.relay.mailchannels.net ([23.83.212.26]:52787 "EHLO
        burlywood.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387645AbgK3VU6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 16:20:58 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2020 16:20:51 EST
X-Sender-Id: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 822F05425B1;
        Mon, 30 Nov 2020 21:03:38 +0000 (UTC)
Received: from ams109.yourwebhoster.com (100-96-12-120.trex.outbound.svc.cluster.local [100.96.12.120])
        (Authenticated sender: xxlwebhosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id CAF45541AFA;
        Mon, 30 Nov 2020 21:03:36 +0000 (UTC)
X-Sender-Id: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Received: from ams109.yourwebhoster.com (ams109.yourwebhoster.com
 [109.71.54.20])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.10);
        Mon, 30 Nov 2020 21:03:38 +0000
X-MC-Relay: Junk
X-MailChannels-SenderId: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
X-MailChannels-Auth-Id: xxlwebhosting
X-Hysterical-Army: 7eb4ade20c10a8ff_1606770217708_613642596
X-MC-Loop-Signature: 1606770217708:343413921
X-MC-Ingress-Time: 1606770217707
Received: from [2001:470:7b31:0:80c0:6ee2:d9c:7cfc] (port=55941)
        by ams109.yourwebhoster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kjqKZ-00G5a8-Ls; Mon, 30 Nov 2020 22:03:31 +0100
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
To:     antlists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <b40ceac5-84a3-ed40-b501-63b3d0c134ce@grumpydevil.homelinux.org>
Date:   Mon, 30 Nov 2020 22:03:33 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AuthUser: rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Op 30-11-20 om 21:51 schreef antlists:
> On 30/11/2020 20:05, David T-G wrote:
>> You don't see any "filesystem" or, more correctly, partition in your
>>
>>    fdisk -l
>>
>> output because you have apparently created your filesystem on the entire
>> device (hey, I didn't know one could do that!). 
>
> That, actually, is the norm. It is NOT normal to partition a raid array.
>
> It's also not usual (which the OP has done) to create a raid array on
> top of raw devices rather than partitions - although this is down to
> the fact that various *other* utilities seem to assume that an
> unpartitioned device is free space that can be trampled on. Every now
> and then people seem to lose their arrays because an MBR or GPT has
> mysteriously appeared on the disk.

And as long as you take care that the mdadm.conf in the initrd is
correct and reflects the true status, all should be well.

If this is not the case, you almost certainly get initrd barfing at you,
if not at first boot in that condition, than once an error has occurred.

Cheers

Rudy

P.S. doing a raid as the OP has done is not what the debian installer
will do.

