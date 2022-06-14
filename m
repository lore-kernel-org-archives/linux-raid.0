Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC69C43334
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiFNOoT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355711AbiFNOne (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:43:34 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13DC1AF2E
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655217799; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=T6mOUwt1zD22AkBdHjhb0EL76ZB8wlz3Av/qP0whwlbOhoerOIP8U84MrYJgVTjwP2wAJPd+6OuHFEUYfdUU8wzteEVUBACq0HSKWOn/BhRmzS3Hk3qhlbegBMXfqMQR5KQCOU1RQZUX2Ujwa2zQj/wXvStZKXRZrfn+j4veFi8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655217799; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qxGQAXHqp+hMlILwA4VPtpnJVCeWJxFZkgoOq7rbFac=; 
        b=c3H7uYmqlh2vUd9ucXk5ch4so4rN1NcXmC1rzJ533HWaf0TOapbsG2NyESXJZS1M7jbHiTAkWKaIxgDWcroN0R6wtallHeH+TZmac7knGzKwyRRlL2IXgrSJQ5/dMmTN+U6IrjOul7gzzDb+6w+8+5r2uCMHj+brT7gRzGqrTns=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1655217798335672.0832187567006; Tue, 14 Jun 2022 16:43:18 +0200 (CEST)
Message-ID: <4381011f-141e-b054-74cd-d491e92f43ca@trained-monkey.org>
Date:   Tue, 14 Jun 2022 10:43:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH resend] Fix possible NULL ptr dereferences and memory
 leaks
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20220613095934.19042-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220613095934.19042-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/13/22 05:59, Mateusz Grzonka wrote:
> In Assemble there was a NULL check for sra variable,
> which effectively didn't stop the execution in every case.
> That might have resulted in a NULL pointer dereference.
> 
> Also in super-ddf, mu variable was set to NULL for some condition,
> and then immidiately dereferenced.
> Additionally some memory wasn't freed as well.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Assemble.c  | 7 ++++++-
>  super-ddf.c | 9 +++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 

Applied!

Thanks,
Jes


