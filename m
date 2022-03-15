Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E5CC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 16:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349052AbiCOQVy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 12:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347846AbiCOQVw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 12:21:52 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D0656C27
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 09:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1647361223; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ImW6COpbh023LOAkQxdPV5eC78QMvB+oQ79vkWxLJbInIbuvTVvjETO4AyH/FET1Qh6Anxrob67YcPeUDIoXixUqIA28yL3+o9NO1gxpLylgX4AZCNmoMFBgWA3W7ZJjTD+bynNsmTKvs9R+6Q3UEidon2fHbJ+kBOHXVjjzZQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1647361223; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=olPkQJUM0oJwngNjp7rJD72UCKZTVKM/DrNNsZr81Wo=; 
        b=WMXhiBp6N0MPJZLlUhafL55+0N6gjn6VU51HpBITRRKvybxoMbwEDFaiOeoCB/fvriuFwh6QlFgjeO4a6VlcMVchlJM7BVE3wC7G1DdkRDUHYf45gD/fPDIEgQ2qZdRelAMXFuOK4P6jwyCu1Sf63aBg8KYDA/hA6o7j/zjhb04=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1647361220330843.0322169649013; Tue, 15 Mar 2022 17:20:20 +0100 (CET)
Message-ID: <14629f89-741e-61d3-b410-bfee0292174b@trained-monkey.org>
Date:   Tue, 15 Mar 2022 12:20:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Unify error message.
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220315083030.58992-1-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220315083030.58992-1-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/15/22 04:30, Lukasz Florczak wrote:
> Provide the same error message for the same error that can occur in Grow.c and super-intel.c.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>

Applied, thanks

Jes

