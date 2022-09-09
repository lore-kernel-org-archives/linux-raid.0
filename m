Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986ECECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 13:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiIINvL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 09:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiIINvH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 09:51:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BAA85ABB
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 06:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662731447; x=1694267447;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8kY6ab2ZtAtmMzgwCYfENi2VtmbpFFDL4sDfSOxWmY8=;
  b=Ry/UONzXLmp9Sm70m3s+kJ1bHrjvrsSsuQ/RQ+Wncv8FqGiMd17n4fmN
   qdSaZVdlVUKeEycNjsedlRbh0qtSsRXWdKYFurwi6XZXf5WKX9KNyphC0
   aR3d/wYp9g1ATVHcDKkD+J+3HfXDlGRYY2Uc2kijnjbCcJqOqIzlH3MHO
   2lR0a1aavJY8cveyLHJo8OTPo55JdOm4yNJkBqqMBerRS5LwEbjKGS6Ej
   6px1H5sX6mwi64tWL/6HD2p+/moDUrpsXkcRRB/MYARuvagsiNhCpuCDD
   TtBe4f4/Z9PafkAGsErvYpY8gb3r5ZN7DHqyRj9MuR6K7vrbRvBYP6K+t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298815236"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="298815236"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:50:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="592612665"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:50:45 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     felix.lechner@lease-up.com, linux-raid@vger.kernel.org
Subject: [PATCH v2 0/2] Small fixes from Debian
Date:   Fri,  9 Sep 2022 15:50:32 +0200
Message-Id: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes and Coly,
Here we have small Debian customizations worth to be integrated.

Changes:
- Commit title updated, suggested by Paul.

Mariusz Tkaczyk (2):
  mdadm: Add Documentation entries to systemd services
  ReadMe: fix command-line help

 ReadMe.c                             | 2 +-
 systemd/mdadm-grow-continue@.service | 1 +
 systemd/mdadm-last-resort@.service   | 1 +
 systemd/mdcheck_continue.service     | 3 ++-
 systemd/mdcheck_start.service        | 1 +
 systemd/mdmon@.service               | 1 +
 systemd/mdmonitor-oneshot.service    | 1 +
 systemd/mdmonitor.service            | 1 +
 8 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.26.2

