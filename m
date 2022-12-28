Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE05C4167B
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 14:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiL1Otj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 09:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiL1Oti (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 09:49:38 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FA6B41
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 06:49:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672238970; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=i+kvHAvUIHde1puR4Xi8mVRWsg/okUOWI5EciBCgNGF7lQ7T5u7ikomQ6ZNss9+n4SxaiNDjhCvKZ22bPF/+ei0ouo+jo7hxE7drvN/eARqck/ZrsVG+Fg/QbyDvO/KomAwDr2nBVIRMSLBu9KTueSV/nwdfVcKXKeCw/9KnNAA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672238970; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tCC0GhwuuJbPU8KBaW80uZPHl8IFm5DwxearA/g/yWs=; 
        b=KJocFRJl3DJ8MdkOe+HzsvAHZ5Z9dzO+c3747faDNxksk9a0NzcmlUrdyAKRTVsuhkuGNa/S9BgKR5OBnTnthJfjsJ+/pWl6T7sQ6RnV/MEEQ4mPLSWIEYpGogAgG65tnQCz33ysKZGfAimSR5fTMDQ+sza0GOAjs5jEwuYwYhU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672238968028747.6826384611986; Wed, 28 Dec 2022 15:49:28 +0100 (CET)
Message-ID: <6e8c91f1-28f1-c594-4881-0d1546fcb1a2@trained-monkey.org>
Date:   Wed, 28 Dec 2022 09:49:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 2/9] Mdmonitor: Make alert_info global
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-3-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220907125657.12192-3-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 08:56, Mateusz Grzonka wrote:
> Move information about --test flag and hostname into alert_info.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Hi Mateusz,

This one no longer applies, any chance you can do an update?

Thanks,
Jes


