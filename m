Return-Path: <SRS0=aYZJ=CS=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCE2C433E2
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 08:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54983218AC
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 08:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIIIbl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:31:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:56773 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgIIIbk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Sep 2020 04:31:40 -0400
IronPort-SDR: 5S0tNnkn4fxB0Jol/ag5HwaZxauzPc/Lury13ibmPVYcoy+ahjvrW9PlI9OiskboqI3+JdMa28
 wXBdQwlgss4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="155692134"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="155692134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 01:31:39 -0700
IronPort-SDR: Xo8R9yIhwQ85Xj5P/yqimhdx8vkWWmQ6BfWQhXl1A99jz7DsZ9aP9jRw3S7ZdEn/zm50Y1yPo7
 /tHzeUXPjTLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="449119020"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga004.jf.intel.com with ESMTP; 09 Sep 2020 01:31:38 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/4] mdmonitor improvements
Date:   Wed,  9 Sep 2020 10:31:16 +0200
Message-Id: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patchset is targeting issues observed across distributions:
- polling on a wrong resource when mdstat is empty
- eventing for external containers
- dealing with udev and mdadm
- quiet fail if other instance is running

Mdmonitor is started automitically if needed by udev. This patchset
introduces mdmonitor stoping if no redundant array presents.

Blazej Kucman (2):
  mdmonitor: set small delay once
  Check if other Monitor instance running before fork.

Mariusz Tkaczyk (2):
  Monitor: refresh mdstat fd after select
  Monitor: stop notifing about containers.

 Monitor.c | 83 ++++++++++++++++++++++++++++++++++++++++---------------
 mdadm.h   |  2 +-
 mdstat.c  | 20 +++++++++++---
 3 files changed, 77 insertions(+), 28 deletions(-)

-- 
2.25.0

