Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54303C25B08
	for <linux-raid@archiver.kernel.org>; Mon, 15 Aug 2022 21:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbiHOVKL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Aug 2022 17:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiHOVIp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Aug 2022 17:08:45 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66A054666
        for <linux-raid@vger.kernel.org>; Mon, 15 Aug 2022 12:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660591115; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=eWtcNeyxeHWpsRBB9+gQevQf/6Bss8W0Fd3vhzK+eRCzNxIch5SZuo9f2K6xnivetxpNPbcxbJ2ANTZodiZ890WNfbykmRLCqSRrsm42UHzKCa64Nel8VMN0GhydDLiw21J+rHqL2M5VHUOCvmYqOiGuhR54B80++O6Px4MegJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1660591115; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=7oEiqUOrIAGzqkg8WILI6IYp0cxnD3Z5IbrlDZLrm6I=; 
        b=LBSCRAWhHc58fyr6TSCwVQ30kQzWJnvEZhhFn6prkwswNhCepXGVWfI9QyNZAimcFFG5CSgAsVSo3WDSor03F4xZK9JWcM3p9ngX/l/BKV1fGcpZ3qXFzIIvkaxW5tR4L6XuU7UHcNhSdWtVUg9DElTbajAX1gOzS6Wg1xXYinA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1660591112960658.7185499937525; Mon, 15 Aug 2022 21:18:32 +0200 (CEST)
Date:   Mon, 15 Aug 2022 15:18:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
 <2622AABD-75DC-41D4-9F1E-E958463E9FD0@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <fab92bc5-b9c1-22a0-4ea0-41cd1d952b65@trained-monkey.org>
In-Reply-To: <2622AABD-75DC-41D4-9F1E-E958463E9FD0@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/8/22 06:03, Coly Li wrote:
> 
> 
>> 2022年8月8日 04:41，Jes Sorensen <jes@trained-monkey.org> 写道：
>>
>> On 6/9/22 03:41, Mateusz Kusiak wrote:
>>> Grow_reshape should be split into helper functions given its size.
>>> - Add helper function for preparing reshape on external metadata.
>>> - Close cfd file descriptor.
>>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>>> ---
>>> Changes since v2:
>>> - removed dot from commit message
>>> - formatted commit description as a list
>>> - got rid of returning -1 in prepare_external_reshape()
>>> - changed "return" section in prepare_external_reshape() description
>>
>> Hi Mateusz,
>>
>> Changes look good to me, but it no longer applies. Mind sending an updated version?
> 
> Hi Jes,
> 
> Please check the version I post to you in series “mdadm-CI for-jes/20220728: patches for merge” (Message-Id: <20220728122101.28744-1-colyli@suse.de>), the patch in this series is rebased and confirmed with Mateusz, it could be applied to upstream mdadm.

Hi Coly,

It is really painful for me to pull individual patches out of a large
set like that. It is much easier to deal with acks and updated patches
and being able to pull in smaller sets via patchworks.

Thanks,
Jes


