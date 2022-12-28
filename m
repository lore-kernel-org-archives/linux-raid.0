Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA33C3DA7A
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 14:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiL1O5V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 09:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiL1O5T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 09:57:19 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4331004D
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 06:57:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672239431; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=eUlQyYSqjm1cqtFUvfiKTQ5V+TYEWowRCv5tSzAkewIt9kmSNDcnLOtyPzaDSYpUO9IufD2WzUNR+Iq4vY3H1LutEAlR50GMor/j4IubK3MI712SuxAZ3BMY06coXBCrMzkU7+M+rdbRmn5PbbccbjqRqHlEfbrqOffZBLrCfTI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672239431; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=t9SSX1dwg5cRSdjclekFNRXT+3OfpG1SPdL0YNnvufY=; 
        b=A7rSW/u2WT885PL1YdQA1dsQAhtPIYcMfR/xyNmh2JsDTnaGotjStTagUEM4ouskibWHpnin+Ju76dYzQZSdCwGlCJD6/YwsmgOP9r8cjnQIqhBGGWN62se5812s2ZqatwvvQ9aEwPMzeXdQ3JIGsUt7wWuEO3L/F86od6vE5B0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672239429200606.7440004225775; Wed, 28 Dec 2022 15:57:09 +0100 (CET)
Message-ID: <82eec9cb-d897-090c-63ad-e91d7de48ee0@trained-monkey.org>
Date:   Wed, 28 Dec 2022 09:57:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH V2 0/2] Changes in Monitor
Content-Language: en-US
To:     Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20221219102158.10180-1-blazej.kucman@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221219102158.10180-1-blazej.kucman@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/19/22 05:21, Blazej Kucman wrote:
> Hi, Jes, Coly
> In first patch blocked is starting monitor when
> --scan mode and MD devices list are combiened,
> to prevent undefined behaviors.
> Second patch containst monitor manual update.
> 
> Changes in V2:
> - remove unnecessary line from commit message
> 
> Blazej Kucman (2):
>   Monitor: block if monitor modes are combined.
>   Update mdadm Monitor manual.
> 
>  Monitor.c  |  7 +++++-
>  mdadm.8.in | 71 ++++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 56 insertions(+), 22 deletions(-)
> 

Applied,

Thanks,
Jes

