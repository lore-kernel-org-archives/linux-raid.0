Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFC0C433E7
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6873E2222C
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgJNPf0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:35:26 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17350 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbgJNPf0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:35:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602689721; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=VmJivxU/JiAZMN75tGAm0WjP/ICEzGVrzbmL8YkgZ/yh2tPhUMDpDpiX8rFUTSrghFbizBGasQzwzrtxuFFVOSexN+uiyA6Gvv3ep4INe1XmhZmky+1YpmWSYXqI9wpCKA30+ZQkXtMgTB6n2TN8LqLe0dkj+UhCTYIVmqTZYN8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602689721; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6YhBMzFEPg1PqSNy/+3yvFue/ZaOht3PAxmqA6U5WUI=; 
        b=WiwLEb/5iJuv71BoRzJ4KGp4SaPyJwGHOMelB5fa2rzmhv8TN7SnzO1H+hzKXkLDKfHmJvXZnX9G1GH3C77VO/GfF73eF+PBCm8jT0it9yFsLeshLAsyl88sXVpm1KsSp+KeqnMtqBCPzYUe5bQ/9v86EgsEcF8B++6mVT0xt6o=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602689718688584.0998078531869; Wed, 14 Oct 2020 17:35:18 +0200 (CEST)
Subject: Re: [PATCH 3/4] mdmonitor: set small delay once
To:     Nix <nix@esperi.org.uk>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
 <20200909083120.10396-4-mariusz.tkaczyk@intel.com>
 <87lfhbz33e.fsf@esperi.org.uk>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <7b4a43b2-a922-e145-104d-00b930362bf4@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:35:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87lfhbz33e.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/15/20 7:33 AM, Nix wrote:
> On 9 Sep 2020, Mariusz Tkaczyk uttered the following:
> 
>> +				/*
>> +				 * If mdmonitor is awaken by event, set small delay once
>> +				 * to deal with udev and mdadm.
>> +				 */
>> +				if (wait_result != 0) {
>> +					if (c->delay > 5)
>> +						delay_for_event = 5;
>> +				} else
>> +					delay_for_event = c->delay;
> 
> This is racy: if any delay is needed, any finite delay value will
> now and then be too short.
> 
> I think this should be fixed by arranging for mdmonitor to be signalled
> when udev or whatever has finished whatever it's doing. (udev has lots
> of ways it could be asked to do that.)
> 

Hi

I have applied this patch for now, since it is better than what we had.
However, I agree it would be better to do this using udev or other
signalling, so please have a look at that.

Cheers,
Jes
