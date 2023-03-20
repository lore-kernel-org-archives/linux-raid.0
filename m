Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1787AC7618A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 08:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjCTIf6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 04:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCTIf5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 04:35:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74C41B329
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 01:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679301356; x=1710837356;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8kbJc/X1H1OJjDYeci2Zcl7mwTIhHI47bAZrvz2cizQ=;
  b=DUyeZPsTHnfHRTP67+4Nc1E87AG/XlMzoXPvskXdlD99xyyHLNy4NwvJ
   3b4s8U552BMDa4f/+Cem5wHJF3Le/mePxh3hF3xKqdmUCuxqCGvEjb0ZU
   ur+W53PyRBRVd6obOPyQZ/51nzf/EAKhZi2M1wkI0fxqJnaJT0NwOSIDF
   kkr6BQ1ywQ/kAQBw9ZQcqg4agK+NIAO9QqQcm7b6ocn6h4HnxcxQQPio3
   63q7Q3tItGI9M98kMxKILqOTYagFzHZ5hnCrrmhgSSLYj+gVoruoMg8z7
   DZPAVw5aJbRJym1cz/xFKxYeupSWK6Z0GtTaA4+ZU4xdPuZ7w2ijez9SR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="337321967"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="337321967"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 01:35:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="674275204"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="674275204"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.82])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 01:35:55 -0700
Date:   Mon, 20 Mar 2023 09:35:45 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kevin Friedberg <kev.friedberg@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] enable RAID for SATA under VMD
Message-ID: <20230320093545.000016cc@linux.intel.com>
In-Reply-To: <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
References: <20230216044134.30581-1-kev.friedberg@gmail.com>
        <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 20 Mar 2023 02:26:31 -0400
Kevin Friedberg <kev.friedberg@gmail.com> wrote:

> Hi Mariusz,
> 
> You mentioned on the previous version of this patch that it might be a
> while before it could be tested.  Have you had a chance to try this
> revision?

Hi Kevin,
Sorry for that... I totally lost it. That for reminder. We will test the change
soon.

Thanks,
Mariusz
