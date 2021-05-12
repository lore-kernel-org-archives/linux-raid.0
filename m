Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42C7C43470
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74549611C9
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 18:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346317AbhELSsY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 14:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243093AbhELSWq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 14:22:46 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD3AC061349
        for <linux-raid@vger.kernel.org>; Wed, 12 May 2021 11:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OCivOL51UhMk7AZF74gVDFSOLNaxpo+hM6D+rdqPT3w=; b=NRuekcAuRtVdQDCqlrzm4J1VJO
        NqcUOPj54tQe6whS3TsCcsrkRqKye4SpCtcOyuTfWkNu4fi4xpHTMZlFW5Q8yeCx/t5Ocs0kzx+rz
        eUIffY9lFOyWugi/CV+0gGoZvHNkgKz8TKMRFpXCn4y12CHaOAw26BU+Vno32A0Ww2cb0DppwqV3N
        /OaB21Wul/eD+zmRfZTENuaYfWESgXoGg5xq4oV+cVhF3NPpoCposUKCXARVpPz+b7hJqKYq2rgPx
        kXGtEi+YP3wm0/vC2VpQOjGIlw/Gw1VVraXbDjpte9IAiNf4tkDtAsQD+4MFRXTEzUVM+1iIwIkeb
        Dcet6RKQ==;
Received: from [12.35.44.237] (helo=[172.30.2.77])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lgtT9-0007CB-Iw; Wed, 12 May 2021 18:20:27 +0000
Subject: Re: raid10 redundancy
To:     David T-G <davidtg-robot@justpickone.org>,
        list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <AD8C004B-FE83-4ABD-B58A-1F7F8683CD1F@websitemanagers.com.au>
 <CAC6SzHKH62XwudewxtOUyNQYi9QSFar=dZ64fz9HiEW1eZh47g@mail.gmail.com>
 <60950C7B.5040706@youngman.org.uk>
 <8333ded7-8805-18df-13d8-166ba021ac02@turmel.org>
 <20210512172720.GY1415@justpickone.org>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <9790cd4b-8d19-49f4-d442-f900bfb37c7b@turmel.org>
Date:   Wed, 12 May 2021 14:20:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512172720.GY1415@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/12/21 1:27 PM, David T-G wrote:
> Phil, et al --
> 
> ...and then Phil Turmel said...
> %
> % I do this for my medium-speed read-mostly tasks.  Raid10,n3 across 4
> % or 5 disks gives me redundancy comparable to raid6 (lose any two)
> % without the CPU load of parity and syndrome calculations.
> 
> I've been reading and I still need to catch up on the notation, but how
> much space do you get in the end?

One third of the total, since I'm using n3.

> I'm hoping to grow our disk farm and end up with 8+ disks.  I'm more than
> a bit nervous about RAID5 across a bunch of 6T (or bigger) disks, so I've
> been thinking of RAID6.  That would give me 6x6 = 36T plus two parity.
> 
> Putting 8 disks in RAID10 should give me 6x4 = 24T with mirroring.
> That's a pretty hefty space penalty :-(  But ...

I wouldn't use only two copies, as you cannot lose any two.  With three 
copies, 8x6T/3 = 16T usable space.  Heftier space penalty, but necessary 
to have confidence surviving a rebuild after a disk replacement.

> How does RAID10 across 5 disks as above 1) work and 2) work out? 

1)  Linux raid 10 does not layer raid 1 on top of raid 0, but implements 
"n" copies of each chunk striped across all devices.  Which is why the 
number of devices doesn't have to be a multiple of "n".

>  If you
> had 8 disks with a huge need for space, how would y'all lay out everything?

raid6.  I pretty much always layer LVM on top of mdraid.

> Thanks in advance :-)
> 
> :-D
> 

Phil
