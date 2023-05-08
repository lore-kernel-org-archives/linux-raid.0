Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D616C77B75
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 20:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjEHUWi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 16:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbjEHUWh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 16:22:37 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C3640D3
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 13:22:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1683577340; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=CzH/Irgk6nhJXgDEC3lC3AIPnF2ANAc0H3qB4MzPs6XKFHQgi1/cJKlcFJ72U6goUX0wKwf3koNvdiPIdGa9jiaba1nmO9u7VJ/5iaNL1dvlIyhnG2tIH5um39ZpzdtIZbUiRrk3SrslRpADCElMpoPkDrhcnvxLuI8mh+llHLM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1683577339; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=YRxZz+vZlc8/hOmYNy6j0y5gEtL8oZNB04rytzHKk1U=; 
        b=HcpSO2Fwdp8TSC0hd6gAQDm9po6aUSpZ6ej3QI7X/PzbabYPYRxQpX9Eh1E1gsIMnLogZ6s+tWeephn6pWPs8lPO+HDoSmjTDm1T0vdvXd+FW20B7J/jEdz8BZPDKLIHkF/sFzbx3sUqYbk7xZHHtzgFzV/pSr3s1gs0tc1YtRU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1683577336853386.29912467551117; Mon, 8 May 2023 22:22:16 +0200 (CEST)
Message-ID: <9bfd76c4-3775-4ba6-10c3-ac32b5389f63@trained-monkey.org>
Date:   Mon, 8 May 2023 16:22:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: mdadm minimum kernel version requirements?
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <e8ed86bb-4162-7d8e-ece9-eb75e045bcc5@trained-monkey.org>
 <168116364433.24821.9557577764628245206@noble.neil.brown.name>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <168116364433.24821.9557577764628245206@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/10/23 17:54, NeilBrown wrote:
> On Tue, 11 Apr 2023, Jes Sorensen wrote:
>> Hi,
>>
>> I bumped the minimum kernel version required for mdadm to 2.6.32.
>>
>> Should we drop support for anything prior to 3.10 at this point, since
>> RHEL7 is 3.10 based and SLES12 seems to be 3.12 based.
>>
>> Thoughts?
> 
> When you talk about changing the required kernel version, I would find
> it helpful if you at least mention what actual kernel features you now
> want to depend on - at least the more significant ones.
> 
> Aside from features, I'd rather think about how old the kernel is.
> 2.6.32 is over 13 years old.
> 3.10 is very nearly 10 years old.
> If there is something significant that landed in 3.10 that we want to
> depend on, then requiring that seems perfectly reasonable.
> 
> I think the oldest SLE kernel that you might care about would be 4.12
> (SLE12-SP5 - nearly 6 years old).  Anyone using an older SLE release
> values stability over new functionality and is not going to be trialling
> a new mdadm.

Hi Neil,

I guess my mindset is more that I don't expect RHEL/SLES grade distros
to fully upgrade mdadm, but I do see them backporting changes occasionally.

I was mostly basing my question on what I see us testing for in the
actual code. Dropping support for anything prior to SLES 12 (4.12) and
RHEL 8 (kernel 4.18) seems fair.

Cheers,
Jes


