Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C202C19F2A
	for <linux-raid@archiver.kernel.org>; Sun,  7 Aug 2022 20:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiHGUlb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 Aug 2022 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHGUla (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 Aug 2022 16:41:30 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A39562E6
        for <linux-raid@vger.kernel.org>; Sun,  7 Aug 2022 13:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659904882; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ApAXEeuhh5boFUFeKggjJJVxCngdM5jAfkYJdCrJ7Z99A/n6p9RV/5RB2QKhakZYFYl6JOmCt2Q+IFrUAHMo+E+AKsNjt3SBF7PGxnuKa3FaGVTIc8NIxDXRfqy3eAl2PhftVf+ye2OEW9fbw/fg5zENcYalOlT/QyhllQQUDdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1659904882; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Q8YQLSW2kGgNhj2zyTW1h7/zm/WQZqN3zKRBstgh/CQ=; 
        b=I0x6OqtkjzWLOXEKzrdeqDYZpTp0Ycz7Q3J+CFCGfT5bLMU3PU1X8YTZ7Lv9YH/58pHs1TcY73Pz1gbCCSX1XM8eEHqK72p0hf34tFH15E9+nFSiYJ2uK35r+SLiRa2OJ6i2Dxa+ZlRulDFNY/AKN23WGYNF4rbr/mTfgJ2tHy8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.20.4.58] (207.253.54.47 [207.253.54.47]) by mx.zoho.eu
        with SMTPS id 1659904879667446.9684691903062; Sun, 7 Aug 2022 22:41:19 +0200 (CEST)
Message-ID: <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
Date:   Sun, 7 Aug 2022 16:41:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220609074101.14132-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/9/22 03:41, Mateusz Kusiak wrote:
> Grow_reshape should be split into helper functions given its size.
> - Add helper function for preparing reshape on external metadata.
> - Close cfd file descriptor.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> 
> Changes since v2:
> - removed dot from commit message
> - formatted commit description as a list
> - got rid of returning -1 in prepare_external_reshape()
> - changed "return" section in prepare_external_reshape() description

Hi Mateusz,

Changes look good to me, but it no longer applies. Mind sending an 
updated version?

Thanks,
Jes

