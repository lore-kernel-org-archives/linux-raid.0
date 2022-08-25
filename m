Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97561C28D13
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 13:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiHYNnh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242287AbiHYNng (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 09:43:36 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9B3B5E48
        for <linux-raid@vger.kernel.org>; Thu, 25 Aug 2022 06:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661434965; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=LamnY0eTEizROlhvZZo8lWGZMeT4DIat9dtIE5GIJW3ZqJxVjilR/uDY4xQtYCiFbKh9n95mjoW9UUmcmWX/Dc1VigkN+rrNgTEVgdi/tRF88Xz7pnF4SZHom2lm59gKRG/y5kOtwInyTVVZBPy5yZ6c85UN/sZKSSwA1APNKjE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661434965; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sDrgXCAXHqQphAHXZQgTcNSfDkqTf77mIKfVUi6HJQo=; 
        b=NqJDOiGZ6tkq6ECVwyd4lKwI4UVNMCCQDBAFraH5sFrZckoemUPJksAuMFLAPvo6zCyedo8cEKqy3/b2fbCd6OiVxTaxWbIckNJv4ciUOu03TmuNWIn/KG3td4qi28KniGB/VZS+TYJdlIyLOsEmi871/EcHmOpFC2LS7dPNc/Y=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661434962365723.0696742190177; Thu, 25 Aug 2022 15:42:42 +0200 (CEST)
Message-ID: <571bde96-e70d-9c87-1544-49790844d160@trained-monkey.org>
Date:   Thu, 25 Aug 2022 09:42:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH mdadm v2] super1: report truncated device
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        NeilBrown <neilb@suse.de>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>
 <20220721101907.00002fee@linux.intel.com>
 <165855103166.25184.12700264207415054726@noble.neil.brown.name>
 <20220725094238.000014f0@linux.intel.com>
 <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>
 <166138706173.27490.18440987438153337183@noble.neil.brown.name>
 <20220825095917.00002549@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220825095917.00002549@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/22 03:59, Mariusz Tkaczyk wrote:
> On Thu, 25 Aug 2022 10:24:21 +1000
> "NeilBrown" <neilb@suse.de> wrote:
>>> What is the consensus on this discussion? I see Coly pulled this into
>>> his tree, but I don't see Mariusz's last concern being addressed.  
>>
>> I don't think we reached a consensus.  I probably got distracted.
>> I don't like that suggestion from Mariusz as it makes assumptions that I
>> didn't want to make.  I think it is safest to always test dsize against
>> bother ->size and ->data_size without baking in assumptions about when
>> either is meaningful.

No worries, distraction is my middle name these days :)

> Hi Neil,
> It seems that I failed to understand it again. You are right, you approach is
> safer. Please fix stylistic issues then and I'm fine with the change.

Thanks Mariusz

Jes

