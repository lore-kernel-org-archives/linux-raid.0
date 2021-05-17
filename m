Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B069C433B4
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 02:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1974160725
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 02:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhEQC2T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 16 May 2021 22:28:19 -0400
Received: from ns3.fnarfbargle.com ([103.4.19.87]:56946 "EHLO
        ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhEQC2S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 16 May 2021 22:28:18 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2021 22:28:18 EDT
Received: from [10.8.0.1] (helo=srv.home)
        by ns3.fnarfbargle.com with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lists2009@fnarfbargle.com>)
        id 1liSdn-0004IJ-9A
        for linux-raid@vger.kernel.org; Mon, 17 May 2021 12:05:55 +1000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=fnarfbargle.com; s=mail; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DcPonSpClQfrbf5MYFHXFau0quEAirKpUrlioMP3kzg=; b=OrDMnBo0goQsqsVdkfgNe2UFnl
        zJGxgTDUXRbuIGMqaXo45rEBrwtTZVpuKClnyDqEHmwvq07a+Ppynm0hVItt8oLFdjim59VQHiUP8
        BOM1APwxzUz9GuIhy2NOcSndpbWO5eQcp/zR9X/HZ7ZuSOv8ug7d4rmDHaUSj3mz6BXE=;
Subject: Re: raid10 redundancy
To:     list Linux RAID <linux-raid@vger.kernel.org>
References: <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org> <87y2co1zun.fsf@vps.thesusis.net>
 <20210512172242.GX1415@justpickone.org> <877dk2r5s3.fsf@vps.thesusis.net>
 <20210513155956.6m6yek3t4ln464bw@bitfolk.com>
 <871ra95qxg.fsf@vps.thesusis.net>
 <20210514143725.qaezymawflfybjv3@bitfolk.com>
From:   Brad Campbell <lists2009@fnarfbargle.com>
Message-ID: <9d1ec4f1-63c8-5521-96d6-7fff69f2eca6@fnarfbargle.com>
Date:   Mon, 17 May 2021 10:07:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210514143725.qaezymawflfybjv3@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/5/21 10:37 pm, Andy Smith wrote:
> Hi Phillip,
> 
> On Fri, May 14, 2021 at 10:28:52AM -0400, Phillip Susi wrote:
>> Andy Smith writes:
>>> While the *layout* would be identical to RAID-1 in this case, there
>>> is the difference that a single threaded read will come from both
>>> devices with RAID-10, right?
>>
>> No, since the data is not striped, you would get *worse* performance if
>> you tried to do that.
> 
> Are you absolutely sure about this? Previous posts from Neil and
> others seem to contradict you:
> 

No they don't. If you read those posts closely you'll see that they are using RAID10 in a striped configuration (far). So not at all like a RAID1.

Picture it this way.
You have two disks. You partition each disk in half and create a RAID0 across the first partition on each disk.
You now have a RAID0 which has the same capacity as a single disk but twice the read performance.
You have no redundancy.
You now create another RAID0 across the second partition on each disk, but you do this such that the layout is alternated making sure there is a copy of every chunk on each disk.
You then RAID1 these 2 RAID0 partitions.

Ordinarily this wouldn't provide any redundancy because a dead disk would leave you with 2 dead RAID0, however the linux RAID10 implementation knows that all the chunks are available on a single drive, they're just spread across both halves.

So they are still striped and provide the performance of a striped array, moreso because when reading the drives are effectively "short-stroked" where all data is available on the first half of each disk.

The layout is *completely* different from a RAID-1 unless you use the "near" layout, in which case it'll be pretty much the same with the same performance limitations.

This gives a better explanation that my words :
http://www.ilsistemista.net/index.php/linux-a-unix/35-linux-software-raid-10-layouts-performance-near-far-and-offset-benchmark-analysis.html?start=1

Regards,
Brad
