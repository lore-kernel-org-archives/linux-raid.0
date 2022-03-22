Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A613C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 22 Mar 2022 07:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiCVHqN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Mar 2022 03:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiCVHqH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Mar 2022 03:46:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A4A7B556
        for <linux-raid@vger.kernel.org>; Tue, 22 Mar 2022 00:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647934778; x=1679470778;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4rlOaCCmMY32uwz8G+H+R6aJpWupW4cFlic1YW0B7Js=;
  b=O9bcy1YmwmPY5A6FohJtYPZbr3orcZQaQW15Lx+8QTC4Wj9jG7/Avwmy
   VCetuO5VpD/MrlrmPjxXuanbErW+Y2xYiNp3pEIR+q0TOm4+Zf8lCiwM7
   cidAMc3zFpNTzas5AYUNT9JsA1gsXhXLH5JBvpfGMZ/LDcXpJOKfvuNh/
   X0XuinATuNAAG3ohIV7lsUy6wRDIiGvDuX0Lx1RvuqOPg5SBNwkh6at9+
   qybiXqe2Wnk6NCWSMeUetk0dP2o2TZKNl1tEcMRwcLlO5AWzIR6+YhwLx
   GFlwpVZ+6TlNPu4zd7wv5AtueWoUlBnxFVCJDFCenqnqJ2ytg7A0+eUW3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="257469674"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="257469674"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 00:39:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="518777058"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.10.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 00:39:31 -0700
Date:   Tue, 22 Mar 2022 08:39:26 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/4] mdadm: Respect config file location in man
Message-ID: <20220322083926.00001f04@linux.intel.com>
In-Reply-To: <084cd90c-fada-072e-aade-079b577cf107@suse.de>
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
        <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
        <51ee6419-9ae4-04a5-1a69-e3fd1b9f0d04@suse.de>
        <20220321091458.00007c0c@linux.intel.com>
        <084cd90c-fada-072e-aade-079b577cf107@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 21 Mar 2022 22:54:41 +0800
Coly Li <colyli@suse.de> wrote:

> On 3/21/22 4:14 PM, Mariusz Tkaczyk wrote:
> > On Sun, 20 Mar 2022 17:54:56 +0800
> > Coly Li <colyli@suse.de> wrote:
> >  
> >> On 3/18/22 4:26 PM, Lukasz Florczak wrote:  
> >>> Default config file location could differ depending on OS (e.g.
> >>> Debian family). This patch takes default config file into
> >>> consideration when creating mdadm.man file as well as
> >>> mdadm.conf.man.
> >>>
> >>> Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is
> >>> generated automatically.
> >>>
> >>> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>  
> >>
> >> I test and verify the change under openSUSE.
> >>
> >>
> >> Acked-by: Coly Li <colyli@suse.de>
> >>
> >>  
> > Hi Coly,
> > Could you please merge it to your master/for-jes branch then?  
> 
> Sure, I will do it.
> 
> Just to confirm, for this situation, do you want me to add the patch 
> directly to for-jes branch with my Acked-by: tag, or you will post 
> another version with the Acked-by: tag?
> 
Please do. Asking author to post another version will bring unnecessary
harm. Just take it and add your tag.

> 
> > We have additional CI at Intel, based on our internal IMSM scope.
> > I would like to switch it to your master/for-jes branch. Also I
> > want to base future development on your tree.  
> 
> 
> Copied.

I can see that you named the branch with the date. Do you plan to
create more for-jes branches?
https://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git/log/?h=for-jes/20220321

> 
> 
> > Could you also elaborate more, what kind of testing are you doing?  
> 
> 
> Currently I only compile the patches, and create simple md raid1 
> with/without container, and show them with mdadm -D and -E.
> 
> For the manual modification, it is checked by myself. I compile the
> man page, and check the CONFFILE and CONFFILE2 replacement in man
> page is correct on openSUSE. Then I run checkpatch.pl from Linux
> kernel with --codespell to check the patch style and basic spelling.
> And finally read the changed content of the man page.
> 
> 
> > I think that is a good moment to give new life to mdadm test suite,
> > if you are using it.  
> 
> 
> I am thinking of create another separate git repo, to store all the 
> testing scripts, and run them on the mdadm-CI tree.

Make sense.

Thanks,
Mariusz

