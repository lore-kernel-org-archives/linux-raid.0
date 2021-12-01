Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2039C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Dec 2021 16:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351419AbhLAQNi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Dec 2021 11:13:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:3993 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351410AbhLAQNh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 1 Dec 2021 11:13:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="233989555"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="233989555"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 08:08:51 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="460078184"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.14.163])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 08:08:48 -0800
Date:   Wed, 1 Dec 2021 17:08:43 +0100
From:   mtkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Neil Brown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
Message-ID: <20211201170843.00005f69@linux.intel.com>
In-Reply-To: <20211201062245.6636-1-colyli@suse.de>
References: <20211201062245.6636-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,

> This patch changes KillMode in above listed service files from "none"
> to "mixed", to follow systemd recommendation and avoid potential
> unnecessary issue.
What about mdmonitor.service? Should we add it there too? Now it is not
defined.

> Cc: Jes Sorensen <jsorensen@fb.com>
Not sure if it a problem but Jes uses: jes@trained-monkey.org for
communication with linux-raid.

Thanks,
Mariusz
