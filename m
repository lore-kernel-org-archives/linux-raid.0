Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7282C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348579AbiFNOkr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347945AbiFNOkn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:40:43 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E728D2DD44
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:40:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655217635; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=IsYfPewX7Fvz4BJFVQjLDiPxi74SdlgVltKus+5+kMLV8wByGc38C+OAsc+iF7TimSNSlWAx5caodS6pckN5gMloORVDaBbpIOdWG7smM7i7GsUfcrlB5jib6kM5vxsHaIrkeaBMgm1OAhoCk9WIuVikEMCLiL/3LpxmH8yNmXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655217635; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=pWiw579hBLTB8wLs/kYP+HhejUrLMv8pi2+39RMwaQE=; 
        b=WzKRv+5i8fEB37h7+kY+52aKuJyODxLLwy8O1TKV3RtbOMSQOYOsh3NaWjJio6lOG9J5BxnmynLQu2DBbcQb54QaOrX0yogqp8yzgMfIOnFs6CK0iT2F54KieeTH3mY33QY/4BqjyJ1VK+OtWr3Gex6S0Q75Fy5WgZgGDmzg3+E=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1655217635514874.7059708229489; Tue, 14 Jun 2022 16:40:35 +0200 (CEST)
Message-ID: <672b7bf8-46d7-83c6-ac2e-6b570381f997@trained-monkey.org>
Date:   Tue, 14 Jun 2022 10:40:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] Monitor: use devname as char array instead of pointer
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220606103420.13135-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220606103420.13135-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/6/22 06:34, Kinga Tanska wrote:
> Device name wasn't filled properly due to incorrect use of strcpy.
> Strcpy was used twice. Firstly to fill devname with "/dev/md/"
> and then to add chosen name. First strcpy result was overwritten by
> second one (as a result <device_name> instead of "/dev/md/<device_name>"
> was assigned). This commit changes this implementation to use snprintf
> and devname with fixed size. Also safer string functions are propagated.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Monitor.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)

This doesn't seem to apply cleanly. Mind sending an updated version?

Thanks,
Jes


