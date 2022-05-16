Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B2C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 14:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244335AbiEPOJy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 10:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244342AbiEPOJu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 10:09:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C133B00E
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 07:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652710187; x=1684246187;
  h=date:from:to:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=opQhnnJOz9YNx6ktToEyym+I/507a8YYp90nZ1ccfxY=;
  b=md8Jprj+7MdA66r1fr5YgFa9lGP9FLdbtFPdNJOxBYwv/cEsj+i5MEg+
   rDMus3s9byEQ7C8dEvQ6Ge0UY+NQyOII4cKQNHWd9J3ZhD7uphHRhRD6u
   x3WJkcI1TuLYZgXoLUiVAKT79KuOb2nMWL0yXV6/gGWtqAoNsjehOQa3o
   waZMza5t0ptuq8CLXT9yh9i/VeONsU5F/N3phzB7BCiDv6P7chz0L792I
   hQRXd9SKKMRwrXRxuDQaEeIQqz4pbeafbtJdxQqZ0XNGvonS6vHz035hu
   9/f/Prk+YP21vIGmw+u9qNCr0cxRIWN4AtnH5NVgBY21E6bit/Zz3NI++
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="252905722"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="252905722"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:09:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="544373559"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.113])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:09:45 -0700
Date:   Mon, 16 May 2022 16:09:41 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Nigel Croxon <ncroxon@redhat.com>, Coly Li <colyli@suse.de>,
        Xiao Ni <xni@redhat.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org
Subject: mdadm test suite improvements
Message-ID: <20220516160941.00004e83@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello All,
I'm working on names handling in mdadm and I need to add some new test to
the mdadm scope - to verify that it is working as desired.
Bash is not best choice for testing and in current form, our tests are not
friendly for developers. I would like to introduce another python based test
scope and add it to repository. I will integrate it with current framework.

I can see that currently test are not well used and they aren't often updated.
I want to bring new life to them. Adopting more modern approach seems to be good
start point.
Any thoughts?

Thanks in advance,
Mariusz
