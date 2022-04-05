Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60DCC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 02:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiDECio (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiDECii (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 22:38:38 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDA02661ED
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 18:38:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649121668; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ZBGEiffNh9p3A2mxnYtFKxii+MHg2SemSJia4QgEfMGggLQQBhsCo6Oq/LDvLwGeDC1jsHc5yqD3C10kfFECYmHjvxiGgR+8YB4r51wo8hTwtmy3NX3F6ZFEtKaYqh+Xeuyu54nRLLkUuF2BVOLD2czKc/SxDzySWgaeUb/jr4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649121668; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=7guxjgZKymkCyxbdfaVkqHLIp4bWEG0NyfeIRPn4Ehs=; 
        b=lKIRPwmcCj4t82f2tvDKI7tYqYI17mSkKht2HvLqjVbjMSEKM/xCXBaGkssHYNF1rs2qLIdhlLi8+UuBV9ZiVH7mI/F3eLMncO+X43FTFtcbOglwFb2lmHE84T8WAhdT2wOsBs5zEzUIuFvo36W/VR9l0DPeT4OtaEfchvgqtec=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649121667688454.9125670769056; Tue, 5 Apr 2022 03:21:07 +0200 (CEST)
Message-ID: <93089351-2e02-e647-f2ff-d9cfa1a2d85b@trained-monkey.org>
Date:   Mon, 4 Apr 2022 21:21:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] Create, Build: use default_layout()
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
 <20220120121833.16055-2-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220120121833.16055-2-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/20/22 07:18, Mariusz Tkaczyk wrote:
> This code is duplicated for Build mode so make default_layout() extern
> and use it. Simplify the function structure.
> 
> It introduced change for Build mode, now for raid0 RAID0_ORIG_LAYOUT
> will be returned same as for Create.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Build.c  | 23 +------------------
>  Create.c | 67 ++++++++++++++++++++++++++++++++++----------------------
>  mdadm.h  |  1 +
>  3 files changed, 43 insertions(+), 48 deletions(-)

Looks good, applied!

Thanks,
Jes


