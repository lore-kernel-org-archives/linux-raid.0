Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C880EC7EE23
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 13:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjE3NGA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 09:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjE3NF7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 09:05:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF7292
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 06:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685451958; x=1716987958;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TiC2tlKDNJ5395Wyrpwwao6ad/PBe87I334aUcKDLmY=;
  b=AQYZwpdaSpETWqGnj2oo6nQyZJs8dd4Fc2zccRRnLNrPCpJG6eNeRbI8
   hI0d5B0THwnN2sHAuAXuSGF90aYpaufM62aqjeXi5RyAST+GNjNL6DLp3
   4885Lljcp4bjYRbOj4keHHs6gJDG20k10dPHi/XUCkIX8K9WMcc71/NOZ
   p0Xc/QHCY5NPUX/KXbq1YRqT9tbD23s516iMllUrs84XgBEmw6wgDqX92
   vzboqcgdTodG/3PsE/aWMLoMTUU8V7nGnsaKfjT1oYzhyIUjCpDxnSYGu
   i9XdS3ow6Vu9Osf1qMgD83+6yGEzICGZTiYEozi7o1pTPCScIERWaXZI4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="420668190"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="420668190"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 06:05:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="818803337"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="818803337"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.155.14])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 06:05:20 -0700
Date:   Tue, 30 May 2023 15:05:15 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v3] Incremental: remove obsoleted calls to udisks
Message-ID: <20230530150515.00005980@linux.intel.com>
In-Reply-To: <c6jr4jmfkesjfxon7wsaxcw2qj52dvgrtjsxuuddoxhpftaly4@3vqllxix4otq>
References: <20230529160754.26849-1-colyli@suse.de>
        <20230530081718.00003cb7@linux.intel.com>
        <c6jr4jmfkesjfxon7wsaxcw2qj52dvgrtjsxuuddoxhpftaly4@3vqllxix4otq>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 30 May 2023 18:59:46 +0800
Coly Li <colyli@suse.de> wrote:

> On Tue, May 30, 2023 at 08:17:18AM +0200, Mariusz Tkaczyk wrote:
> > On Tue, 30 May 2023 00:07:54 +0800
> > Coly Li <colyli@suse.de> wrote:
> >   
> > > Utilility udisks is removed from udev upstream, calling this obsoleted
> > > command in run_udisks() doesn't make any sense now.
> > > 
> > > This patch removes the calls chain of udisks, which includes routines
> > > run_udisk(), force_remove(), and 2 locations where force_remove() are
> > > called. Considering force_remove() is removed with udisks util, it is
> > > fair to remove Manage_stop() inside force_remove() as well.
> > > 
> > > In the two modifications where calling force_remove() are removed,
> > > the failure from Manage_subdevs() can be safely ignored, because,
> > > 1) udisks doesn't exist, no need to check the return value to umount
> > >    the file system by udisks and remove the component disk again.
> > > 2) After the 'I' inremental remove, there is another 'r' hot remove
> > >    following up. The first incremental remove is a best-try effort.  
> > Hi Coly,
> > 
> > I'm not sure what you meant here. I know that on "remove" event udev will
> > call mdadm -If <devname>. And that is all I'm familiar with. I don't see
> > another branch executed in code to handle "remove" event, no second attempt
> > for clean up is made. Could you clarify? How is it executed?
> > Perhaps, I understand it incorrectly as second action that is always
> > executed automatically. I know that there is an action "--remove" which can
> > be manually triggered. Is that what you meant?
> >   
> 
> What I mentioned was only related to the source code.
> 
> Before force_remove() is removed, it was called on 2 locations, one was from
> remove_from_member_array(), another was from IncrementalRemove().
> 
> But remove_from_member_array() was called from IncrementalRemove() too. The
> code flow is,
> 
> 	if (container) {
> 		call remove_from_member_array()
> 	} else {
> 		call Manage_subdevs() with 'I' operation.
> 		if (return 2)
> 			call force_remove()
> 	}
> 		
> 	call Manage_subdevs() with 'r' operation
> 
> From the above bogus code, the first call to Manage_subdevs() was an
> Incremental remove, and the second call to Manage_subdevs() was a hot remove.
> No matter it succeed or failed on the first call, the second call for hot
> remove will always happen.
> 
> Therefore, after removing force_remove(), it is unnecessary to check the
> return value of the first call to IncrementalRemove(). Because always the
> second call to Manage_subdevs() with 'r' operation will follow up.
> 
> This was what I meant, it was only related to the code I modified.
> 

Ok, now I get this. Thanks! It make sense now. And I know who made it this way:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=cb8f5371352f6c16af5aab8a40861e13aa50fc2b

This second independent Manage_subdevs call is needed for external metadata
because at the end we need to remove the device from the container. It seems
that I made a mistake here and doubled call for native (nobody have been
noticed for years LOL). The goto end; should be independent from if (rv & 2).

Feel free to clear this up. I think that else branch is not needed now.
In incremental remove we should stay with 'I' disposition because in this mode
kernel should not be blocked from setting broken state as it is with 'f'
disposition.
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=461fae7e7809670d286cc19aac5bfa861c29f93a
> 
> e > Therefore in this patch, where foorce_remove() is removed, the return
> > > value of calling Manage_subdevs() is not checked too.
> > > 
> > > Signed-off-by: Coly Li <colyli@suse.de>
> > > Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> > > Cc: Jes Sorensen <jes@trained-monkey.org>
> > > ---
> > > Changelog,
> > > v3: remove the almost-useless warning message, and make the change
> > >     more simplified.
> > > v2: improve based on code review comments from Mariusz.
> > > v1: initial version.  
> > 
> > For the code:
> > Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>  
> 
> Thanks.
> 
> BTW, do you have any suggestion for the commit log? It seems current commit
> message is not that clear, and I want to listen to your input :-)

It is fine, I read that at the morning so it seems that my brain was not
working yet. This is another example why I should not write mail before coffee
:)

Thanks,
Mariusz
