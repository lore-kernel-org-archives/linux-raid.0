Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1228FCA0FE4
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 15:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjIAPh7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjIAPh7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 11:37:59 -0400
X-Greylist: delayed 91 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Sep 2023 08:37:53 PDT
Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9295C10E0
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 08:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693582664; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=f7/ALbknmBxRBm2Gvv37zmziNFDyNrTwAAdRIEag6B8dULlEkiiDqSlMbiMxNgomC7am4cobhHO0WXEE83zd5iCRECroQA2HOQMoQA4hUxUC0IkLN+bVM5wyPWzSP9lxJC6OUAzGj8nFEFJXrt2wSzWX7UG/uq+ZPDtIWbdI5QU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693582664; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=kQ4GzyQXTB8kHoyCy7369h9pJbNmo0A02U48EAUBLKY=; 
        b=j4bwdsZLk+6szYkBWKiUw9r8kSMPOYqLg7+1pk1oYHCNkKC3uf9kOSEdRq6/yFrKmlWDm6Cs5cLzUkUuDqt4m5qmd4E4Quogs6VBb+zluKL2a6H1IghN8rDCunmng1XQUfgcw+WikkO0yQNuVeNKbcFZqyZpohHs88igVMfTnBU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693582662547427.8575204303369; Fri, 1 Sep 2023 17:37:42 +0200 (CEST)
Message-ID: <ccbb3b88-1a4d-262d-6d0d-6622afb798bf@trained-monkey.org>
Date:   Fri, 1 Sep 2023 11:37:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/6] imsm: expand improvements
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
References: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/29/23 09:52, Mariusz Tkaczyk wrote:
> merge_extents() was initially designed to support creation only. Expand
> feature was added later and the current code was not updated properly.
> Now, we can see two issues:
> 1. --size=max used with expand and create result in different array size.
> 2. In scenarios, where volume were deleted an recreated it may not be
> possible to expand the volume.
> 
> The patchset addresses listed issues and removes limitation to the last
> volume for expand.
> 
> Mariusz Tkaczyk (6):
>   imsm: move sum_extents calculations to merge_extents()
>   imsm: imsm_get_free_size() refactor.
>   imsm: introduce round_member_size_to_mb()
>   imsm: move expand verification code into new function
>   imsm: return free space after volume for expand
>   imsm: fix free space calculations
> 
>  super-intel.c | 363 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 202 insertions(+), 161 deletions(-)

Applied!

Thanks,
Jes


