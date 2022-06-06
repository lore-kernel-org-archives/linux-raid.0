Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26412C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 10:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiFFKO3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiFFKOS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 06:14:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686F817DDC9
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 03:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654510289; x=1686046289;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ROL2id/ueaA47TNtfABNiuFKzesdbuaq6EV5DZLQGH8=;
  b=j1syjx2wMnmx3yofSZ+ROPpjrtiSzoSfae7GRnbrIO21OSoyGVU9umvg
   x4OnH1Lo+hFdjfSQqmmLH8eHmvSOBROXZvnqsbwRRBEDqrW/Z+6VW/Acy
   ydQENBYLjl7sdrhIebrB08Imcyh34o+QKjclUvO1mZjEBLOkdBj2M7aAT
   dzh86yRQUuLdbvI8yOY9k8Sr0OQ1UnnEj0s48W2PgrlmHo+u41/WE8JHd
   KslkeXTlMvMo6L56IWqm0qpNaczUeCOR2jRYD1sEbAJFBdGQcPAoT4uFM
   XfrhGdfIkP+iWwHZY3y/RC7Wgma24pn4nxSfQOx1oiCHiBmnzmBQ/Dnn3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="274180199"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="274180199"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:11:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682189044"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 03:11:24 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v3 0/2] Mdmonitor improvements
Date:   Mon,  6 Jun 2022 12:17:13 +0200
Message-Id: <20220606101715.11433-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Changes in v3:
- fix place where is_mddev is calling
- no new changes in "Mdmonitor: Improve logging method" patch

Kinga Tanska (2):
  Mdmonitor: Fix segfault
  Mdmonitor: Improve logging method

 Monitor.c | 36 ++++++++++++++++++++++++------------
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 util.c    |  2 +-
 4 files changed, 43 insertions(+), 13 deletions(-)

-- 
2.26.2

