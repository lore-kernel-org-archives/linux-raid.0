Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F7AC433E0
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C916A64FA6
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242137AbhCCBP2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:15:28 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17201 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575637AbhCBWvB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Mar 2021 17:51:01 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614725412; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=aElqH0P6DxlueCCSFs4Q9fHVnh3qsK1/iEJKpI5tP9YAgocPQxSJlupwHefZfaEhkNfc4X+pNWqNMroUbc6nORBAUpB759fBOnCeMCfn3G8Gcc5gEQVPqYvGQsF2ATY++TfTw+LWWOKShnXdBCL6CgvFryo/2mgurHlaCtKeOls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1614725412; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=M6qFJX/EkUKNQIiYX7BVN2MD9A/TbsOZRheeBInJXA8=; 
        b=SZEqCDFZLLZoBSUFniLE8hrU/MUw9bH3+EOnAcmagO+uemkKn2CQnw76dH+/QUJpUk51QRoYJavGJrmc9FNiHrqfjdxwt7e5Lstu6AlLwR2O/kKrI67Q10oxgQJg6ATUQldgNkSYcs+BZKJ+fGedSMlPTXfTACdjJVfwkfB3dtc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 161472541107466.35150450998026; Tue, 2 Mar 2021 23:50:11 +0100 (CET)
Subject: Re: release plan for mdadm
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
Date:   Tue, 2 Mar 2021 17:50:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/27/21 6:39 AM, Tkaczyk, Mariusz wrote:
> Hi Jes,
> 
> It's been a while since last mdadm release. Mdadm-4.2 release that was
> mentioned back in July does not happened yet. It's getting messy to
> manage mdadm across multiple distributions.
> 
> Also, not all OSVs are willing to cherry-pick the patches, especially
> for stable project - like mdadm, so only critical bugfixes are landing
> in the distros.
> As a result - new OSes has various forks of mdadm-4.1 and the difference
> is growing with every backported patch. It leads us to situation where
> those forks may have own bugs, caused by many missing bugfixes or wrongly
> resolved merge conflicts.
> To be honest - it becomes more and more problematic for us to track all
> fixes in different supported distros.
> 
> We are searching for solutions for those problems and we are counting on
> your support:
> Short term - is there any way that we can help you to release next version
> of mdadm soon?
> 
> Long term - what do you think about smaller, more frequent releases of
> mdadm? Maybe twice a year is an option (similar to RedHat/Ubuntu
> schedule)? That would be better for us and for vendors. They will need
> to follow upstream instead resolving bugs reported by us or community.
> 
> The benefits will be gained by everyone. User will get up-to-date
> software much faster, with minimal vendor input and modifications.
> Mdadm bugs will be predictable across distros. We could help with
> testing IMSM and basic functionality of native metadata.

Hi Mariusz,

Sorry for the slow response. Our daughter was born in late December and
I was on paternity leave through Feb 5, so still catching up. I also
switched teams at work back in July so my focus was shifted.

I'd very much like to see a release, and we should do one quick. Doing
more regular releases will also make it easier to ship them, so I am not
against that at all.

I am not aware of anything major pending right now, so if we can get
focus on any pending patches and get them in over the next week or two,
then I can cut an -rc and we can do a release soon. Especially if you
can help out regression testing the -rc candidate(s).

Cheers,
Jes
