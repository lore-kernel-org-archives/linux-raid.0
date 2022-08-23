Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82781C32772
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 17:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbiHWRPB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245330AbiHWROm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 13:14:42 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E329F696D0
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 06:53:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661262777; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=TEinTiQCdiPlVoV44s/KVabtklx34jbSvM3awifYD5c4+KS0UJUJV1ExJ9PSzKImiccGX5ZCDtn7C5FdO3hk3evggZrHBB1Q4KMtHzGWTZvzwLhIn+rZhWZ0cPDSQ41WC2B5FF6L4c2eiyDSK2IitMOFHYK7b1A3Vsftb8iJiO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661262777; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OkkCY3XIc4Y4KKL1rLpcBqApsGaFshs1bfckP4UQVbs=; 
        b=eMZvFs9OyPew2skzv62hwhTm0VniQIvztmYW/os96bns4tgNjipZN5yiuHNZPSug7iR8uvfA2AytxgrZajSFRa9mMMS1usF6mBbk8rMdtJgAZHbEmbo2oRsgFEoLUtSBVZzg3oPrdRYy74T6y0gx9f7CEsfAtzOeVcCoydDN98M=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661262775810660.672578758015; Tue, 23 Aug 2022 15:52:55 +0200 (CEST)
Message-ID: <0f084f21-ef9a-c377-1a3a-240fb412f25a@trained-monkey.org>
Date:   Tue, 23 Aug 2022 09:52:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/3] Add test for names.
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
References: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 08:48, Mariusz Tkaczyk wrote:
> Hi Jes,
> In first patch test for MD device names is added. This is entry for
> future create_mddev() updates - we need test to avoid regression.
> Beside that, small code improvements are done.

Hi Mariusz,

All applied!

Thanks,
Jes

