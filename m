Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC99C4320E
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 17:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DC160F6F
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 17:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243158AbhHZRBj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243147AbhHZRBj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Aug 2021 13:01:39 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE539C061757
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 10:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+a6FjJXxRh18RTOAJNwyUbcYDofVv8NZqZIrwzGq2Rs=; b=eiRGgKxmVL8krCfQ1duorLx5dm
        j0ni9cueLJ1Yvgw31rMPPZbwwIyXwQ3wOFrQXAQn1biJxvZw2LKHez3tnFXg46DqkPWU+oGSsuJxD
        fwbgeJ2RwVkc27MNlo/juT8/J5MiQ4ewjjmGCUrq59mzsMO6mMBfBY7mdkaOEgDQ9Pv9l/1qjbvhw
        T7yGuv3LMM3D2fD4JTBRObvm6e+LJAY09KkbQzS6JiZU9vRR19jBVY2apN71KUX53QvkRcaIkoKt7
        tk2Al0CWPLe96m6O9vqmMnRo6ts8GjoIZI7Cx2OXdjAaHHWNquvhd8wq5TlYs3RAzQsmrD13X/ICt
        mEHP4miQ==;
Received: from [12.35.44.237] (helo=[172.30.0.251])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1mJIkC-00072J-US; Thu, 26 Aug 2021 17:00:48 +0000
Subject: Re: Raid 5 where 2 disks out of 4 were unplugged
To:     Gennaro Oliva <gennaro.oliva@gmail.com>, linux-raid@vger.kernel.org
References: <YSdcUa6ZYsdPEtFB@ischia>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <11fe0c66-c128-2217-83fc-583d1a6c2b6e@turmel.org>
Date:   Thu, 26 Aug 2021 13:00:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YSdcUa6ZYsdPEtFB@ischia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Gennaro,

Good report.

On 8/26/21 5:18 AM, Gennaro Oliva wrote:
> Hello,
> I have a QNAP with Linux 3.4.6 and mdadm 3.3. I have 4 drives assembled
> in raid 5, two of those drives where accidentally removed and now they
> are out of sync. This is a partial output of mdadm --examine

[trim /]

> mdadm --verbose --assemble --force /dev/md1 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3
> mdadm: looking for devices for /dev/md1
> mdadm: failed to get exclusive lock on mapfile - continue anyway...
> mdadm: /dev/sda3 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdb3 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdc3 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdd3 is identified as a member of /dev/md1, slot 3.
> mdadm: added /dev/sdb3 to /dev/md1 as 1
> mdadm: added /dev/sdc3 to /dev/md1 as 2 (possibly out of date)
> mdadm: added /dev/sdd3 to /dev/md1 as 3 (possibly out of date)
> mdadm: added /dev/sda3 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 2 drives - not enough to start the array.
> 

This should have worked.  I suspect your mdadm is one of the buggy ones 
for forced assembly.

Download and compile latest mdadm and do this again.  (Newer mdadm works 
on older kernels.)

Regards,

Phil
