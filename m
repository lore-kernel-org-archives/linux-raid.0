Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EE1C77B73
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 08:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbjEXIfe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 04:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240458AbjEXIen (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 04:34:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AF91725
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 01:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684917206; x=1716453206;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PMOn6MkH9KpEs1p3SHWTIRF2C7d5rxAf3vuU5WT2yes=;
  b=V/ptE6AjbkPFBNYQi9fzCCKLU1XJ3m/1WBZOwykm2fTrQEr+YDQJ+seZ
   mY8mMwnAopHWQd2Y2oU4I2hFRmLfDnldJBZnXk05VXMPyAG/sxN5X6cK/
   ZqDb+JxnTuiN9qtEDhkGs+uvhm4MZhA/3dmJBO1/EflucHxSoit4yWwjt
   EXmPQmIsDy+xY4uB1OwdsDsrJhNYJ9F+xz/CUM4eCJ2zrcC0SNtzWkBAt
   +AUIcr/IviHrow90JdhJLsuXJYQuaGOxWUBEd1nlJe4skqnmlpbuoKREN
   E+j8Dkxsj6lTuaVPo8CxBmyXTFrdulmA5YYB6PEHOkrJPDyQ8bX8mhgTV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="338078277"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="338078277"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:33:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="774169234"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="774169234"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:33:06 -0700
Date:   Wed, 24 May 2023 10:33:01 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH tests 2/5] tests: add a new test for rdev lifetime
Message-ID: <20230524103301.00007195@linux.intel.com>
In-Reply-To: <20230523133900.3149123-3-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-3-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 23 May 2023 21:38:57 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> This test add and remove a underlying disk to raid concurretly, verify
> that the following problem is fixed:

As in previous patch, feel free to move it into separate directory.

This test is limited only to this particular problem you resolved because you
are verifying error message in dmesg. It has no additional value because
probability that this issue will ever more occur in the same shape is
minimal.

IMO you should check how "remove" and "add" are handled, if errors are
returned, if there is no trace in dmesg or if processes are not blocked in
kernel.
You can check for this error message as a additional step at the end of test
but not as a mandatory test pass criteria.

In current form it gives as a knowledge that particular kernel doesn't have your
fix, that is all. Because it is race, probably it is not impacting real life
scenarios, so that gives a weak motivation to backport the fix (only security
reasons matters).

I don't see that this particular scenario requires test. You need to make it
more valuable for the future.
 
Thanks,
Mariusz
