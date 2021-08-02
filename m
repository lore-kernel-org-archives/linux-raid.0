Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEB9C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 17:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F87261103
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 17:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhHBROg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 13:14:36 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17080 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhHBROd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 13:14:33 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627924457; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ip6pSARnCP9nESo72J4lE2gMFndQ9qfZSVNrHWjLefSPcFYbi51ryzXjtntWvDYaCNNilvgvsJ9G/v5Fg5Gvdp2aQ5E+Kqy2nLcl+uVcwxJa5/qsl0svNL9Bdr1BqZy29ErOjXqtCwkNf54yzaODiN/WNDt81nXX6elHZed/tlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627924457; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=LgFXabLhXNX2nLy4jFKaNBYeghg5LR5ALeyMfV6WWi4=; 
        b=YJZkyS5IK2rPGj1IA4N5tybqiZQoc3tqel5cX2Ulse2+sLaOn0vYRfn2BnbXzziawWe9zPlZAn7QZSHUemRszyR+LgDW5JKlfFTb3mYDkbTqXh96DnUyNgBRQhJ0Qhfg90YQywFKaZratMPhvnxzFv3W1U7HaG8tq2HwC0LGN3E=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627924455776901.511722002686; Mon, 2 Aug 2021 19:14:15 +0200 (CEST)
To:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Subject: ANNOUNCE: mdadm 4.2-rc2 - A tool for managing md Soft RAID under
 Linux
Message-ID: <23ff060b-0958-ffc5-7da6-64948ec3179c@trained-monkey.org>
Date:   Mon, 2 Aug 2021 13:14:14 -0400
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

I am pleased to announce the availability of the second rc release of
mdadm-4.2, hopefully the last before we cut final.

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
   http://git.kernel.org/cgit/utils/mdadm/

The update constitutes more than one year of enhancements and bug fixes
including for IMSM RAID, Partial Parity Log, clustered RAID support,
improved testing, and gcc-8 support.
