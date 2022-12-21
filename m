Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157D1C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 11:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiLULuf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiLULuc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 06:50:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EC71DA46
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 03:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671623431; x=1703159431;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7e51McNv0L1zxBxg2/cV6dyq4Jw+zre08/Cjn6U26dc=;
  b=iOynC1cVZJkJHwB0HfTJOPJb9J2BPx5xUYFst3SN04Pvl8cjBkPnyo14
   yZzQxGW039sjLAWdbE41jR6lBZKrHj/T2lnuk7zjFNtijdF6ALObquPMS
   qnH3ihut78KWnDhGUVLW/WYRQZpClDpfWY8yB+Wls2g//T16x+/NnnPd6
   8pe2YX/gtS0ocEgHPnknY7NEmJFYToMq7D4z6UGD4yPxtcOslVww8xF+E
   02MWZC0M4k07oedZysGl02z2KiiYhF1Zb/c9iH4h3/wgsgXthedU2jLLv
   1bgW76zQHCZWNMaUFJiqaGpLPRW1O0L6iH3X4Zn8kR4IfZnjhGXU4kSZc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321765615"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321765615"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714799019"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="714799019"
Received: from mtkaczyk-devel.elements.local ([10.102.105.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:29 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/3] Validation for names during creation
Date:   Wed, 21 Dec 2022 12:50:16 +0100
Message-Id: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes, Coly
Mdadm has to weak names policy and it is inconsistency with udev.
From IMSM side it also causes problem with VROC UEFI driver.

There is a small risk of regression because print_escape() is removed.
I think that these cases are incidental and can be fixed by updating
array name. All test passed.

Mariusz Tkaczyk (3):
  mdadm: create ident_init()
  mdadm: refactor ident->name handling
  Limit length and set of characters allowed of devname

 Detail.c        |  8 ++---
 config.c        | 81 ++++++++++++++++++++++++++++++++++---------------
 lib.c           | 80 +++++++++++++++++++++++++++++++++++++++---------
 mdadm.8.in      | 57 +++++++++++++++++-----------------
 mdadm.c         | 32 ++++---------------
 mdadm.conf.5.in |  4 ---
 mdadm.h         | 32 +++++++++++++------
 super-intel.c   | 25 +++++----------
 super1.c        |  3 +-
 util.c          | 24 +++++++++++++++
 10 files changed, 212 insertions(+), 134 deletions(-)

-- 
2.26.2

