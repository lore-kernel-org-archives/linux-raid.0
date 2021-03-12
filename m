Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A98FC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 12 Mar 2021 10:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFAF64FE2
	for <linux-raid@archiver.kernel.org>; Fri, 12 Mar 2021 10:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhCLKOg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Mar 2021 05:14:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:31201 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233156AbhCLKOb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 12 Mar 2021 05:14:31 -0500
IronPort-SDR: V1VkNpR47gA61/s9PlyYmhCIKOnHONJPLBYHhnLihqo/sroHgAGEn01enOQIy7cANQKFZa6kzi
 2RxTRsrXFIhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="250176852"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="250176852"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 02:14:27 -0800
IronPort-SDR: p3pc/NLd+Xqm94VoyweNd+YFu5lrYU14/wYaFZZ7h4PAB0GuN2m5yV6wLm49FTclipmvMl+Xky
 1z3sUL3UQsnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="603884095"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga005.fm.intel.com with ESMTP; 12 Mar 2021 02:14:26 -0800
Received: from [10.213.16.227] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.16.227])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id E097D580514;
        Fri, 12 Mar 2021 02:14:25 -0800 (PST)
To:     Jes Sorensen <jes@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Subject: IMSM regresion
Cc:     linux-raid <linux-raid@vger.kernel.org>
Message-ID: <d7f430e5-fb47-a90a-60d0-e63ec85b4a3b@linux.intel.com>
Date:   Fri, 12 Mar 2021 11:14:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Jes,

We discovered IMSM regression after last push in following scenario:

#mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
#mdadm -CR volume -l0 --chunk 64 --raid-devices=1 /dev/nvme0n1 --force
#mdadm -G /dev/md/imsm0 -n2

At the end of reshape, level doesn't back to RAID0.

This is an information. We are working on fix. Please don't mark release 
candidate yet.

Mariusz
