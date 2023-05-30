Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A05EC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 06:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjE3GR1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 02:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjE3GR0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 02:17:26 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD84BF
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 23:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685427445; x=1716963445;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1YVHLzFolUZQ+Oe+H1XD6s8g5+vJh17dZXlf9wuJhFo=;
  b=Py/9VDBInuh6RqDxCX9IyF8lBXN5a1SiSr9psagyceOxgNUnKAlWxZih
   CoWJBTvhcs10rqVn9Y3z2M3SGuUtm6lRGi00uULJqI2WikQU2VdBx0e5y
   xvvSk5DJQA9nXZKg4r3xoeEqxGrporSUX5c9s7naQ2qRYTjn2Bhhw9Ld6
   aeOHdnjmykJ2c3IU0KYZe3dPrhwu3b+guTEoG6PignY/Da8a9Kk/a4qvW
   P128Z1qGCxJNWDZv8VgRQTFMqcpfNmDbqYeHajOc62ayg7fqLL7MggrF5
   ShQFH6O5T0pRfRkrqO6Yih61xeNNjMblQAhJv5NNo9CtcX/nA1YqJpM+o
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="420585827"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="420585827"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 23:17:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="818652142"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="818652142"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.155.14])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 23:17:23 -0700
Date:   Tue, 30 May 2023 08:17:18 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v3] Incremental: remove obsoleted calls to udisks
Message-ID: <20230530081718.00003cb7@linux.intel.com>
In-Reply-To: <20230529160754.26849-1-colyli@suse.de>
References: <20230529160754.26849-1-colyli@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 30 May 2023 00:07:54 +0800
Coly Li <colyli@suse.de> wrote:

> Utilility udisks is removed from udev upstream, calling this obsoleted
> command in run_udisks() doesn't make any sense now.
> 
> This patch removes the calls chain of udisks, which includes routines
> run_udisk(), force_remove(), and 2 locations where force_remove() are
> called. Considering force_remove() is removed with udisks util, it is
> fair to remove Manage_stop() inside force_remove() as well.
> 
> In the two modifications where calling force_remove() are removed,
> the failure from Manage_subdevs() can be safely ignored, because,
> 1) udisks doesn't exist, no need to check the return value to umount
>    the file system by udisks and remove the component disk again.
> 2) After the 'I' inremental remove, there is another 'r' hot remove
>    following up. The first incremental remove is a best-try effort.
Hi Coly,

I'm not sure what you meant here. I know that on "remove" event udev will call
mdadm -If <devname>. And that is all I'm familiar with. I don't see another
branch executed in code to handle "remove" event, no second attempt for clean
up is made. Could you clarify? How is it executed?
Perhaps, I understand it incorrectly as second action that is always executed
automatically. I know that there is an action "--remove" which can be manually
triggered. Is that what you meant?

> Therefore in this patch, where force_remove() is removed, the return
> value of calling Manage_subdevs() is not checked too.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> ---
> Changelog,
> v3: remove the almost-useless warning message, and make the change
>     more simplified.
> v2: improve based on code review comments from Mariusz.
> v1: initial version.

For the code:
Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Mariusz
