Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852C1C63797
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 14:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbiL1Osh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 09:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiL1OsP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 09:48:15 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781FDBC3A
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 06:48:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672238888; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PvMPNJ8+qJwe4lPDd2LBAdm906nwfze9oejHTG/ic8qSPbSmKsfGhwjGoqKtOzc+CXVIRcAFCdEMNsxfhrnE7MufoDgHEiDT7isVXfPuqKt96ww47fo/nnonnlqO02YTwfLUWYhr37mQ/mpL9U7t9fg9DO7RlG5oLjr9bGsODg4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672238888; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=w19o8xgcR6EtAWi3CJGssyF315farr7lu/j9Vmua8gM=; 
        b=ZGXRdGFd0B1iXcpEASXW6ux2uLUNc2TcVJQzcAzeMUYNS4uMwV1ENl5bpoqwNR9gmyp6DI+qyFBtE8Ywo9ndioAhnUmoJHA65vgV7jioMhm6aTBKYQ24wIkMe4aFSVPDkFsb1BzMcAIQktBHZ9Zg/tCHJwuKqrQCGuLC2kOEu9o=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672238885077318.56646205194477; Wed, 28 Dec 2022 15:48:05 +0100 (CET)
Message-ID: <149ea2a4-0983-6122-b310-af440199f19c@trained-monkey.org>
Date:   Wed, 28 Dec 2022 09:48:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/9] Mdmonitor: Split alert() into separate functions
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-2-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220907125657.12192-2-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 08:56, Mateusz Grzonka wrote:
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Monitor.c | 186 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 95 insertions(+), 91 deletions(-)

Applied!

Thanks,
Jes


