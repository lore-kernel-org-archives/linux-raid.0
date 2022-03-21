Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D676EC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 08:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344427AbiCUIRI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 04:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345172AbiCUIQs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 04:16:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60884FC43
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 01:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647850505; x=1679386505;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CMq0ibLOu8t9jdgsSoDhCmBTbXejF8v7EGODzZAYNYI=;
  b=B4YU0PrU9XuHZqGnuZgJJJwqTsNjXjYyPU9TubA2BLt13OcE+EDjYo/7
   KrvSGdqezRV+avGBXqzQjQ8WMURnvlERbqMPdvE5ktE/40Lo/Oo07RAtd
   kAqC83WKcmfDCsedwwMpRs282mFYIfCP0u94tHS933mtXMlMFzissHuOg
   96tB03uBe7DtuPgIBdu9Jo0flv4BJmh0HHbzHtVXdJmXLoemwqsc4KjHp
   ZdxtrxOb+jk6H68JTfDINchDjvUnPAoKWLgjJdzdLSdEtg555FH21h0zc
   nhsgD2VGF6m4UlmM6J7uDdhRPlmUi+FeH2/RwijnQ8r4+3WUk7glYBhVA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="237440144"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="237440144"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 01:15:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="518340651"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.7.104])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 01:15:03 -0700
Date:   Mon, 21 Mar 2022 09:14:58 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/4] mdadm: Respect config file location in man
Message-ID: <20220321091458.00007c0c@linux.intel.com>
In-Reply-To: <51ee6419-9ae4-04a5-1a69-e3fd1b9f0d04@suse.de>
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
        <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
        <51ee6419-9ae4-04a5-1a69-e3fd1b9f0d04@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 20 Mar 2022 17:54:56 +0800
Coly Li <colyli@suse.de> wrote:

> On 3/18/22 4:26 PM, Lukasz Florczak wrote:
> > Default config file location could differ depending on OS (e.g.
> > Debian family). This patch takes default config file into
> > consideration when creating mdadm.man file as well as
> > mdadm.conf.man.
> >
> > Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is
> > generated automatically.
> >
> > Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>  
> 
> 
> I test and verify the change under openSUSE.
> 
> 
> Acked-by: Coly Li <colyli@suse.de>
> 
> 
Hi Coly,
Could you please merge it to your master/for-jes branch then?
We have additional CI at Intel, based on our internal IMSM scope.
I would like to switch it to your master/for-jes branch. Also I want to
base future development on your tree.

Could you also elaborate more, what kind of testing are you doing?
I think that is a good moment to give new life to mdadm test suite, if
you are using it.

Thanks,
Mariusz
