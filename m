Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BABC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Dec 2022 12:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiL0Ms7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Dec 2022 07:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiL0Ms4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Dec 2022 07:48:56 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15129F12
        for <linux-raid@vger.kernel.org>; Tue, 27 Dec 2022 04:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672145336; x=1703681336;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pbQ0shZDLCa4VWGVnqu+YZK1W4DfQpExad4Vr8czi9Q=;
  b=CNspuF0JJ0583CqOY7Rb7FSinYgU5sdNQifiyM999NKVdmMfC/zui156
   wypqXIRws7ZbRYsaM3BsdIZQjqvGtpGl3bkumAAhWZ1/SSw7dOwARnnj4
   WnrDt+r6/6HMkzN/xU73Q92Ey8GkoAy8KpdKEsHvTea/wKbz+oiD2oyUd
   pK3Zd24T62U7TTC9x50MxBtz7EW0Q1V4Hj97bvPuOu5cNw4nK+tZLdAOy
   ceZKYsdVElC2Vp5qxIWTuGjNLdGkxoCXUxoGhZyuqUe7K/OcaXCbdvVAQ
   5GNMEBUR7L1x05tRooyAK1aE/HGQPRlBpOF4vORAyPiY/wdJu9Hu7wPC+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="385117680"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="385117680"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 04:48:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="646415734"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="646415734"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga007.jf.intel.com with ESMTP; 27 Dec 2022 04:48:54 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v3 0/3] Incremental mode: remove safety verification
Date:   Tue, 27 Dec 2022 06:50:41 +0100
Message-Id: <20221227055044.18168-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Changes in incremental mode. Removing verification
if remove is safe, when this mode is triggered. Also
moving commit description to obey kernel coding style.

Kinga Tanska (3):
  Manage: do not check array state when drive is removed
  incremental, manage: do not verify if remove is safe
  manage: move comment with function description

 Incremental.c |  2 +-
 Manage.c      | 82 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 50 insertions(+), 34 deletions(-)

-- 
2.26.2

