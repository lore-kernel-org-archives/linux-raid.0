Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E8AC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 01:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7555D60EBC
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 01:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhKDCAi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:00:38 -0400
Received: from sender12-1.zoho.eu ([185.20.211.225]:17202 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhKDCAi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Nov 2021 22:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635991074; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=fqGOZPU61agWhMOnjy8qMsryR2HKW9WvtlAaHT0qC34vkE1y+iLAc/+/NW5/UPEGIpkjSOTvc8dlrGz6lFXiCtx83jIvaozt7zfUj8H97Res6mkT1aZ+WE0NApdaIHrTz8fkbqj7prsJ94sypHIRCDB1+f1gKNpVzRdZ3We8Zbo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635991074; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=EVCNEsvJi3BmbgoIULC4t8IYXt9RKx3yu8mgfqZAxrg=; 
        b=bPCrSCB8P39v+ymFycF5JZ4bbQ7JS715tr0xOpZAqgo3WqtzrmmVWZ0esUO3Q6eWyeTd8RxIecHNN1rhT5c1vUQaOc1W6ZvBkBDKyIf5G1CAW/zFu2Yy7bR/fzLjwLGLeL1qZsqJrHHx9cp9zgROWWgv+RLvgKTHjDgxnclcE/o=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635991072598836.0209039297382; Thu, 4 Nov 2021 02:57:52 +0100 (CET)
To:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Subject: ANNOUNCE: mdadm 4.2-rc3 - A tool for managing md Soft RAID under
 Linux
Message-ID: <0d276f26-cd56-5917-2422-0f1075491fb3@trained-monkey.org>
Date:   Wed, 3 Nov 2021 21:57:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I am pleased to announce the availability of the third rc release of
mdadm-4.2. This took much longer than anticipated, but hopefully we can
get 4.2 out the door soon.

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
   http://git.kernel.org/cgit/utils/mdadm/

The update constitutes more than one year of enhancements and bug fixes
including for IMSM RAID, Partial Parity Log, clustered RAID support,
improved testing, and gcc-8 support.

Jes Sorensen, 2021-11-03
