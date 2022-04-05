Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AEDC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 02:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiDECOV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiDECOU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 22:14:20 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F37E1E8CF0
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 18:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649121358; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PQ3HApZROdOjatRnh5PuOPRXhVivAJaxGcjcSNkhl8fKCRipHSfAAATefEbYexfTYF8sxWDyWhjxT4Z6Tl3al7nbY0Mg9y6rCD+sYtZ5TOt0p5MmjBVeN/gQRJ3C6dwMs8vZnDmbUb7GLX0WPRh0Kf8Ce7BZcVISc5od6iijRJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649121358; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hxqyGfks0aUxx27gqqxFAFcSv9UStKPxTYPA2D8vlyM=; 
        b=Fh6G2j+OvL0lsB1Pm4TZ1yLndh1o/BnCdZiZnDoGgJPPJwbYojhyaqwMK17nzVQEZKPO/wexnG7XnBxUukh+s/yj6aBY8lflFwGD3ocS5u1vQ2XfFIx9IQCWASCGTbGGZNJcE6PdUE2qr8JgOPTzwaTLwq7wCuY5q/vFYQIr+hM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649121357775670.7332946541178; Tue, 5 Apr 2022 03:15:57 +0200 (CEST)
Message-ID: <3e6e1268-5457-faa0-735c-7f24fc0fb5b8@trained-monkey.org>
Date:   Mon, 4 Apr 2022 21:15:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/4] mdadm: Update config manual
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-5-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220318082607.675665-5-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 04:26, Lukasz Florczak wrote:
> Add missing HOMECLUSTER keyword description.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>  mdadm.conf.5.in | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

Applied!

Thanks,
Jes

