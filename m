Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0936AC636CD
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 13:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjBANhT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 08:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBANhS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 08:37:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EC61BFE
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 05:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675258637; x=1706794637;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/fX9RN8wKIjs5YOlPSnu5gurBPYSXAaefH0lNds4jMc=;
  b=kXbrc20ZlB8jOG8v+BwEQGS/p4AlQOuGNkbvsTj/JHTKjmzt1/1EfcW6
   WruRtpXDXLFkVWogvWzlaA19OUkJi2Q/7xlxYPjbK0GZ/l3366U10AXNX
   iMLnVg7plp7bgFJqzW9M+6rvqn9InMThui53QdCbxMiAYEROXi70jAkno
   VPxih7JfmTfyUFznvhTJgJNrDjirVww2FtEaqQCEiOQcCJyhR3hzwdORX
   tXILWsmI4/8Vc/T67UtneSw63fz0X40cdIgTGscxW8CCPQKB6VyyNhGze
   E66EmSoy1QIujhLw5LU8digFG1/fxU0NgxRYs3l6grmMWYsMlQALLXsvU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="316137676"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="316137676"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 05:37:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="695358714"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="695358714"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.103])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 05:37:14 -0800
Date:   Wed, 1 Feb 2023 14:37:09 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org, mariusz.tkaczyk@intel.com,
        kinga.tanska@intel.com
Subject: Re: [PATCH] mdadm reshape hangs on external grow chunk
Message-ID: <20230201143709.00001086@linux.intel.com>
In-Reply-To: <20221117150525.00002743@linux.intel.com>
References: <20220923142635.470305-1-ncroxon@redhat.com>
        <20220929113521.000012af@intel.linux.com>
        <20221117150525.00002743@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Nigel,
Ping?

Thanks,
Mariusz

On Thu, 17 Nov 2022 15:07:41 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> On Thu, 29 Sep 2022 11:35:21 +0200
> Kinga Tanska <kinga.tanska@linux.intel.com> wrote:
> 
> > On Fri, 23 Sep 2022 10:26:35 -0400
> > Nigel Croxon <ncroxon@redhat.com> wrote:
> >   
> > > After creating a raid array on top of a imsm container. Try to
> > > grow the chunk size and the reshape will hang with zero progress.
> > > The reason is the computation of sync_max_to_set value:
> > 
> > Hi Nigel,
> > 
> > I was trying to retest with your patch but still have the defect. I
> > analyzed it and found another reason, which causes this defect. In
> > validate_geometry_imsm function freesize and super is being checked and
> > return 1 if any of those is NULL. In my opinion 0 shall be returned
> > here, because it is an error and reshape should be stopped here. I will
> > prepare proper patch and send to review immediately.
> >   
> Hi Nigel,
> I agree with Kinga.
> https://patchwork.kernel.org/project/linux-raid/patch/20221028025117.27048-1-kinga.tanska@intel.com/
> Could you please retest the proposed patch on your side and provide feedback?
> 
> Thanks,
> Mariusz

