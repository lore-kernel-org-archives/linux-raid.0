Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B8CC74A44
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 08:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCNIRZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 04:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCNIQz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 04:16:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D161D303E0
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 01:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678781708; x=1710317708;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tl2brNxoC3JUGIErtUwPri+whs42jLM1x74sHvcRs/M=;
  b=A7d39l8BsxkTIc1RI3DyjTMeQ0qK1wD1KRHMbgfScuBadNPI4cqKksXs
   RJ+c7qbbX/lBzrzE/wmEmT9a8hYXAKmSpLaRILvmHe/ARyD2MC+Z/WwJk
   pkRORAtoP/ASedQd1QPRpYVKMFNJXTC6KHVGqC9JoYHQrYO9OV+BcepaY
   W5Aq16I4PkD07+llK4EThcImXPU1tqFXA3nTIMWDVX1usrFCJMR5P1Pv0
   BsyRk4BiR7wolb9JtTXShIjc9oscdOSovR2Fj85Yv36+VMM6Giah7egv3
   h7CfuEQI+B4PqByivAB/xezCxVTX2OK+lisjgS1jqemw8AsgmZkksCoDw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337386467"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="337386467"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:15:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="628958986"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="628958986"
Received: from roschers-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.139])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:15:03 -0700
Date:   Tue, 14 Mar 2023 09:14:58 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] Limit length and set of characters allowed of
 devname
Message-ID: <20230314091458.00005c53@linux.intel.com>
In-Reply-To: <6ee775b9-291a-a2e7-1b30-3fc8e103e60d@trained-monkey.org>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
        <20221221115019.26276-4-mariusz.tkaczyk@linux.intel.com>
        <6ee775b9-291a-a2e7-1b30-3fc8e103e60d@trained-monkey.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 13 Mar 2023 10:22:47 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 12/21/22 06:50, Mariusz Tkaczyk wrote:
> > When the user creates a device with a name that contains whitespace,
> > mdadm timeouts and throws an error. This issue is caused by udev, which
> > truncates /dev/md link until the first whitespace.
> > 
> > This patch introduces prohibition of characters other than A-Za-z0-9.-_
> > in the device name. Also, it prohibits using leading "-" in device name,
> > so name won't be confused with cli parameter.
> > Set of allowed characters is taken from POSIX 3.280 Portable Character
> > Set. Also, device name length now is limited to NAME_MAX.
> > 
> > In some places there are other requirements for string length (e.g. size
> > up to MD_NAME_MAX for device name). This routine is made to follow POSIX
> > and other, more strict limitations should be checked separately.
> > We are aware of the risk of regression in exceptional cases (as
> > escape_devname function is removed) that should be fixed by updating
> > the array name.
> > 
> > The posix validation is added for:
> > - 'name' parameter in every mode.
> > - secondary device name (first devlist entry), only for create and
> > assembly.
> > 
> > To limit regression risk, config entries are excluded from POSIX
> > validation.
> > 
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>  
> 
> Hi Mariusz,
> 
> This no longer applies cleanly. Any chance you can post an updated version?
> 

Hi Jes,
Working on next version. I think that I omitted one place, need to dig into
again. I should make a test for that too.

Thanks,
Mariusz

