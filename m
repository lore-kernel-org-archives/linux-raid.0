Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE69C433DF
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD682222A
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgJNPeK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:34:10 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17333 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbgJNPeK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602689647; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=lVUoODqONTtIRt5uFTibSd3XsggAx/RibmEl7KgXISH8knRG8+TiR9lPT5iA5FJbodqWwUYb4UsTA474OKVtCDuhLvFYQt5u8iUxwIh/hykVSLQDLegGyOTaiL9+byzsHQHx9d7tx6NrY6Rk83KqIryiDOacNvPx1COOxbrl3Pg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602689647; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=5JKNiOUb2o1l5Hbdbq+odKLqNPE5De5DcaGO2THSi8U=; 
        b=j6COMo7SF7xPQvm83d6/qdBuTktpQu/UOliusKoe1+FIDia3UMbE2V8fhCZGgP5+CE3WIOtJ02M2RUFqCpbUeY1O39XV/BLpyHGY8BPobz+K8mn1fVX2p0a1PAsv2exMuOohXgYVGfiyndKCOAMFNbTVvdpsbKE1TroSCARxZxQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602689645403354.83626991784763; Wed, 14 Oct 2020 17:34:05 +0200 (CEST)
Subject: Re: [PATCH 1/4] Monitor: refresh mdstat fd after select
To:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
 <20200909083120.10396-2-mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <b9cef77d-7069-89b5-225a-d1f8b5a91a3b@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:34:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909083120.10396-2-mariusz.tkaczyk@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/9/20 4:31 AM, Mariusz Tkaczyk wrote:
> After 52209d6ee118 ("Monitor: release /proc/mdstat fd when no arrays
> present") mdstat fd is closed if mdstat is empty or cannot be opened.
> It causes that monitor is not able to select on mdstat. Select
> doesn't fail because it gets valid descriptor to a different resource.
> As a result any new event will be unnoticed until timeout (delay).
> 
> Refresh mdstat after wake up, don't poll on wrong resource.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  Monitor.c | 6 +++---
>  mdstat.c  | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)

Applied!

Thanks,
Jes

