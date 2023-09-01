Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A23CA0FE5
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 16:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbjIAQKY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344829AbjIAQKW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 12:10:22 -0400
Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB0610FB
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 09:10:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693584604; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XqwDKNhqQPai1nL3dzhF/Gl9GwPlLb7QVs0OBYS+K6v56iFaRbKoqHhyryyWwl93Ysw+R/tAR2i7lVo4IAkA0lpSErHFkPg5pL1bpijmiGqhXCW07zYDREPlRmR+MDbTXfFxjNf0OhR8oO16Xj+dpajng7PSsJVBh7Yh757wGXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693584604; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=5gUviwoVpG5FKV4novdIuCYOD5yBFX/E/83liooFT30=; 
        b=UNXd6c/78GMlbj3ZjbBMuEKJP4a4/o6FV66HnS/PfvsiiTshbRrZg7SdOdKMbGsDNvHx6Cmb6AWzMn8l74ggK9lPcTCmrTzeFlLJByC11ndSuWCHkkHSHPs+V1hw4N3PozAAsZvI7ZSNBuyl4C1JGkNMYuA3RtciD2OkNjn2UmM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 169358460336514.72593914003096; Fri, 1 Sep 2023 18:10:03 +0200 (CEST)
Message-ID: <f2992bbd-da4e-3844-6b99-5682c197f2f4@trained-monkey.org>
Date:   Fri, 1 Sep 2023 12:10:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/2] Fix unsafe string functions
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20230511025513.13783-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230511025513.13783-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/10/23 22:55, Kinga Tanska wrote:
> This series of patches contains fixes for unsafe string
> functions usings. Unsafe functions were replaced with
> new ones that limites the input length.
> 
> Kinga Tanska (2):
>   Fix unsafe string functions
>   platform-intel: limit guid length
> 
>  mdmon.c          | 6 +++---
>  mdopen.c         | 4 ++--
>  platform-intel.c | 5 +----
>  platform-intel.h | 5 ++++-
>  super-intel.c    | 6 +++---
>  5 files changed, 13 insertions(+), 13 deletions(-)
> 

Applied!

Thanks,
Jes

