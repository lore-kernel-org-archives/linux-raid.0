Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0061AC12002
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE68A613F8
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbhGPOg4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 10:36:56 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17086 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbhGPOgz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jul 2021 10:36:55 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626446034; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DhWnZPijQGrZnWp11RVgtS25kLvpAfiK7Q9m1/rUN2z2FBPZn1mwh5eU5eWHZJsZ/mRnL0Jx8SbUGZzugaaYktpIvvW5pHn5sXZmvkDWPj798uG2cUB45tHLU4kchwF1Q6ut1OPWHvRuckgItVW7jMdZQBTWg0eKWHQXudSra3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626446034; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=PMA4gd1yqKP1cv+a7diB/sAlaVSKQeYWUw9+SR94ZWc=; 
        b=JnTlaRIsfuBXUX/AXuVvHUw4jBOYC85eFVSGFhFBWixpWMRZd/HgOEJIjE8wYtUhSwZG1AUvgaIeNVj4OElCHfipADAQKTYcXPUZgSOagU1B1yf6EeJzNq04XKlxBF8Tfv4GNok+/x4y43Q4WvEQj8mciMxXNIWOmkM2TWo31Vw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1626446033300595.7905171979668; Fri, 16 Jul 2021 16:33:53 +0200 (CEST)
Subject: Re: mdadm 4.2-rc2
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     Xiao Ni <xni@redhat.com>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>,
        blazej.kucman@intel.com, linux-raid <linux-raid@vger.kernel.org>
References: <614b0f39-0a1d-5c86-be88-42f65a72911b@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <1efd204f-917f-d812-2089-c651f492f8f9@trained-monkey.org>
Date:   Fri, 16 Jul 2021 10:33:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <614b0f39-0a1d-5c86-be88-42f65a72911b@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/28/21 9:48 AM, Tkaczyk, Mariusz wrote:
> Hello Jes,
> A lot of mdadm patches are waiting, could you look into them?
> 
> IMO it is good time to mark rc2. Do you agree?

Hi Mariusz,

I finally had time to go through the pending changes, I think I got
everything. Sorry it's been chaotic as usual here.

Unless I missed something urgent, then I think rc2 is appropriate.
Please speak up loudly if I missed anything.

Thanks,
Jes
