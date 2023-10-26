Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C671C25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjJZVtv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZVtv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:49:51 -0400
Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFED8AB
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356979; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PZDHy98fgBEgvczYP1uF6vSwjWRJHTN1STYNK6NnalZjCNIfhaiI7+g6BYXX9ozC0Zkzp/QU/m2irlXiFRjWKPj/cP/trnyAXiwokuSOc5bCIxUowqnAqPVxHm8FaIwi/jwYYMGVC0hfKDYqngZS2fF+PExyj4AYttpPmv8dSGg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356979; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=W9pINFN4XvP/WpEEnoMdNSwXafOo8BMNFdLeRA1sctQ=; 
        b=YZ48INbZ0DkAoTyzoKbSW5DxP6jArmRnwhVXjN/4J00RnruSY6PpTReycIUkaRfOJ5EZCaHX8PdnLS+rOASZakhyOfgiEPen5sqAKKMsj7NLCC0D8qrUQmjuGfYgjmhTlsi+SDNMz+6u2OPhPbRALL72B4B9+TNPQHX+zK1Qbj8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356977830268.2343834063971; Thu, 26 Oct 2023 23:49:37 +0200 (CEST)
Message-ID: <3e80ccf1-9f72-326a-7d44-5088353e6bb7@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:49:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V3 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 kernel>=5.4
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Xiao Ni <xni@redhat.com>
Cc:     colyli@suse.de, neilb@suse.de, linux-raid@vger.kernel.org
References: <20231017123546.46292-1-xni@redhat.com>
 <20231017161216.0000565a@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20231017161216.0000565a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/17/23 10:12, Mariusz Tkaczyk wrote:
> On Tue, 17 Oct 2023 20:35:46 +0800
> Xiao Ni <xni@redhat.com> wrote:
> 
>> After and include kernel v5.4, it adds one feature bit
>> MD_FEATURE_RAID0_LAYOUT. It must need to specify a layout for raid0 with more
>> than one zone. But for raid0 with one zone, in fact it also has a defalut
>> layout.
>>
>> Now for raid0 with one zone, *unknown* layout can be seen when running mdadm
>> -D command. It's the reason that mdadm doesn't set MD_FEATURE_RAID0_LAYOUT for
>> raid0 with one zone. Then in kernel space, super_1_validate sets mddev->layout
>> to -1 because of no MD_FEATURE_RAID0_LAYOUT. In fact, in raid0 io path, it
>> uses the default layout. Set raid0_need_layout to true if
>> kernel_version<=v5.4.
>>
>> Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
> 
> LGTM.
> 
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Looks good!

Applied!

Thanks,
Jes


