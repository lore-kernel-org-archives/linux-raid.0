Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6372C43334
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 06:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiGVGmR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 02:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiGVGmR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 02:42:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B85823BA
        for <linux-raid@vger.kernel.org>; Thu, 21 Jul 2022 23:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658472136; x=1690008136;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bNwCwjRX2b6QTfd5oBrij6L2UnXO/UqJVXDfRZ9+Oi8=;
  b=hcFEH1sl64z15RN3nNu3qGXXxrIM+OzY5U6QG/2q4K/7yJJt++GGmBUZ
   jYK5/oPagGHTYVL0JqejXjtNA0WTzRCqLR5vk0nIiR/24iA/2OvX+/tS5
   nag0EvZ6MnjiYOH8ivWsdT30cRxy8oF9dbsBCW/vWfwR1A8fD+QMQjBpo
   fb/lD4ts4aXN5o5Z0FFF+ZPJXy7izPzHdmwPjesk+iJfOIl301geliA5K
   lAaMvyPI+Aah60c51vVk4Fxbj4/RWqCPNiU5DQO7653u8qMniundCrCy3
   8SdEeCxmD6oThW/WTxIgAsK9wCOJSr7ksthdpGt2bwpp1IDRS3RyP7i9T
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="287254959"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="287254959"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:42:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="657096191"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2022 23:42:14 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2 0/2 RESEND] mdadm: Fix array size mismatch after grow
Date:   Fri, 22 Jul 2022 08:43:46 +0200
Message-Id: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Changes in v2:
- split commit into two,
- explain dead code part,
- reformat commit body to wrap text after 72 characters.

Lukasz Florczak (2):
  mdadm: Fix array size mismatch after grow
  mdadm: Remove dead code in imsm_fix_size_mismatch

 super-intel.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

-- 
2.27.0

