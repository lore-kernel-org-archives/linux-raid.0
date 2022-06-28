Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89239C43334
	for <linux-raid@archiver.kernel.org>; Tue, 28 Jun 2022 07:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244919AbiF1HAk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 03:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiF1HAi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 03:00:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC474B86
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 00:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656399637; x=1687935637;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i74Co+OGWCyDvdm9khgPo552FK1jhQ/uIlnlvjNTPes=;
  b=P8rj74G/K+GqOff8Tps+FVZY61qpoKpn5mXdvKoPCVLbo4nYSevr9SQq
   jAx5K7U35JJeoQN/PLXJOsEZQh4gP3PrnSJXb2QCjXWNi0dAoYCA5frVP
   5xxfT5+oAPytvHom+jW+yaPSaDtCYEXnNDwAO6IIyDM2L8KLw+2TD58Js
   vesBCaINqIBg/bbh2L4XJRQxiCr18dUxW7rNpzt4NyivBWUYm9LfKJqbX
   d/wqUT+4DojaI8STwspdeP+MOwqjbTSvG2wP1lfINexCVpMnnKigpO+lD
   YrRT4Aq/9iuSQHcT5FPa6H67HNKNby6QGmztiuGdPS+HU+tlTjXh5ej6x
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282746780"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282746780"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 00:00:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="646782376"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.142])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 00:00:33 -0700
Date:   Tue, 28 Jun 2022 09:00:28 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 01/14] Makefile: Don't build static build with
 everything and everything-test
Message-ID: <20220628090028.00003c95@linux.intel.com>
In-Reply-To: <20220622202519.35905-2-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
        <20220622202519.35905-2-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 22 Jun 2022 14:25:06 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Running the test suite requires building everything, but it seems to be
> difficult to build the static version of mdadm now seeing there
> is no readily available static udev library.
> 
> The test suite doesn't need the static binary so just don't build it
> with the everything or everything-test targets.
> 
> Leave the mdadm.static and install-static targets in place in case
> someone still has a use case for the static binary.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
