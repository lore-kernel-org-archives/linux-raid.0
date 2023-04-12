Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A58C77B6E
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 13:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDLNwo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjDLNwo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Apr 2023 09:52:44 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EB349C2
        for <linux-raid@vger.kernel.org>; Wed, 12 Apr 2023 06:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681307563; x=1712843563;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5XUyitWJ84noJH22oCqtK8cqDhIF+hBj5ucycdhrxdY=;
  b=S1nFjhfWjwATHGzbdctzgLDN0oGTiYanrda7lrwsQ18VUglzbo7B7KdT
   296umKMieCCulXf7qOB4HFGSDA9B6csq1fNCY7IIX3vBL1EydkZjlfkPY
   IJmhEvrH1EsFTY5/as3EaRgtJhqL/lbAJ46WHuq2gr5fGofDLwTPfivQl
   tPaI/qCbKYhj2bJZa8/pBD8IGCeZYEMEdzm5vnWhQSbioOVXF7epP19nO
   giKIMZLBb3QmrR6iWZypFW0StRlknDp7b0v6pVfvdXf6N+Uv7uKgNZJ7+
   LZr+CKu6vmGkPbkR+2gE6PkoY+u34EwCKpNU6BnW2+jb+1Rr3bXZN5rvS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406728819"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="406728819"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:52:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="1018749114"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="1018749114"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.133.110])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:52:41 -0700
Date:   Wed, 12 Apr 2023 15:52:36 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "NeilBrown" <neilb@suse.de>
Cc:     "Jes Sorensen" <jes@trained-monkey.org>,
        "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Subject: Re: mdadm minimum kernel version requirements?
Message-ID: <20230412155236.00002f37@linux.intel.com>
In-Reply-To: <168116364433.24821.9557577764628245206@noble.neil.brown.name>
References: <e8ed86bb-4162-7d8e-ece9-eb75e045bcc5@trained-monkey.org>
        <168116364433.24821.9557577764628245206@noble.neil.brown.name>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 11 Apr 2023 07:54:04 +1000
"NeilBrown" <neilb@suse.de> wrote:

> On Tue, 11 Apr 2023, Jes Sorensen wrote:
> > Hi,
> > 
> > I bumped the minimum kernel version required for mdadm to 2.6.32.
> > 
> > Should we drop support for anything prior to 3.10 at this point, since
> > RHEL7 is 3.10 based and SLES12 seems to be 3.12 based.
> > 
> > Thoughts?  
> 
> When you talk about changing the required kernel version, I would find
> it helpful if you at least mention what actual kernel features you now
> want to depend on - at least the more significant ones.
> 
> Aside from features, I'd rather think about how old the kernel is.
> 2.6.32 is over 13 years old.
> 3.10 is very nearly 10 years old.
> If there is something significant that landed in 3.10 that we want to
> depend on, then requiring that seems perfectly reasonable.
> 
> I think the oldest SLE kernel that you might care about would be 4.12
> (SLE12-SP5 - nearly 6 years old).  Anyone using an older SLE release
> values stability over new functionality and is not going to be trialling
> a new mdadm.
> 
> Thanks,
> NeilBrown

Agree with Neil. I have no strong recommendation. I'm not aware significant
feature that landed recently. I think that any kernel released around 5 ago
will be applicable.

Thanks,
Marusz
