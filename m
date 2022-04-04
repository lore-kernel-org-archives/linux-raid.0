Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2F3C433FE
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 15:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352482AbiDDPPw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237512AbiDDPPv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 11:15:51 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E59BF6C
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 08:13:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649085217; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=c4O/I3L6BAX+T/DRWvFIIy128kG1SWpGm2LkoDfFNd+/3CUfFeIXp3pPzQ11xg6axm7PY9k+l6BiIEOhyJZTJ6cXtEWkqqnUadLTXgjcTbjAxQcXreBGKznpS7Jz3cO5IW63iqhYV1QrlkmaKUH3QCo/H0obxv7WQQg2q4IluwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649085217; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=66rusqf2VQs+qA/+Dr+bTbvmEHd4p8/OtBS2oNrKT7k=; 
        b=UDtZ5NMjsmPrKwMiB1LXIXfuVySz0ty8tTD8Z2IVx8jVUeqcyUKGQxlqKC4pcHleFOkrElwdka8pdWN5903npZBHCoDIpKvmjiaufXSohC5yTlNm5IZeP0NsQNeadg2oRX7LmseEWGdDX37hb3HhRlVaiqXYx9wepyCd4+TlGXM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649085214520575.8919623557027; Mon, 4 Apr 2022 17:13:34 +0200 (CEST)
Message-ID: <5a089f94-b97b-adcc-7f73-7931e6e3dac0@trained-monkey.org>
Date:   Mon, 4 Apr 2022 11:13:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] Replace error prone signal() with sigaction()
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     pmenzel@molgen.mpg.de
References: <20220221120521.16846-1-lukasz.florczak@linux.intel.com>
 <20220221120521.16846-2-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220221120521.16846-2-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/21/22 07:05, Lukasz Florczak wrote:
> Up to this date signal() was used which implementation could vary [1].
> Sigaction() call is preferred. This commit introduces replacement
> from signal() to sigaction() by the use of signal_s() wrapper.
> Also remove redundant signal.h header includes.
> 
> [1] https://man7.org/linux/man-pages/man2/signal.2.html
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>


Applied!

Thanks,
Jes


