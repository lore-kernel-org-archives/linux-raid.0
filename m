Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE52EC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Jan 2023 15:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbjADP0q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Jan 2023 10:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjADP0o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Jan 2023 10:26:44 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8180C8FED
        for <linux-raid@vger.kernel.org>; Wed,  4 Jan 2023 07:26:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672845997; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=NrCcmWsyUy2ogCQhECWj9Q//QYSsO6pOx2Dz2lyhUpGVGRvsgjCdUit/fjLO5b3+N7xSbe8uowQRMCqYR4BCTj2S+xKlSmci5cjnFNiM5REganlYeSvuyJwdvuPHm2z71njh6CRa9UsQtro6r7pDxcX/MlpehDYjGTKfzWmI/zw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672845997; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ECg5wnnPNBKmsy34ia2SV7fKTEHyoaRioaTIN0+ZJT4=; 
        b=RHRFN7DXvaA4tF2Uw18Os7O/d+m11+fhXmEQcNP7rt13qp6ZI1lfPpuP4wHH8A315v9UXlI7ppaYeYeR/7lDLkYxX3j8kAk89lrkdEFkvClFTlxTRerg2LaHkQM+QVicuH9SMCZo80nK/aYGhIOw98nVf88leANdtyxt0w/QNGg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 167284599533950.53238672024031; Wed, 4 Jan 2023 16:26:35 +0100 (CET)
Message-ID: <a8bf9623-154c-59c4-e8f0-a4d38d2ffec4@trained-monkey.org>
Date:   Wed, 4 Jan 2023 10:26:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 2/2] util: remove obsolete code from get_md_name
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20230102084622.29154-1-mateusz.kusiak@intel.com>
 <20230102084622.29154-2-mateusz.kusiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230102084622.29154-2-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/2/23 03:46, Mateusz Kusiak wrote:
> get_md_name() is used only with mdstat entries.
> Remove dead code and simplyfy function.
> 
> Remove redundadnt checks from mdmon.c
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
>  mdmon.c |  8 +++-----
>  util.c  | 51 +++++++++++++++++----------------------------------
>  2 files changed, 20 insertions(+), 39 deletions(-)

Applied!

Thanks,
Jes


