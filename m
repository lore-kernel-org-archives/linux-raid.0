Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E62C77B61
	for <linux-raid@archiver.kernel.org>; Tue, 25 Apr 2023 08:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjDYIvc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Apr 2023 04:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbjDYIvb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Apr 2023 04:51:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133C57AB1
        for <linux-raid@vger.kernel.org>; Tue, 25 Apr 2023 01:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682412671; x=1713948671;
  h=date:from:to:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=jGqHG0yuM52/wd5LD93ZHkiWmaLVm0UrqfF6z0BR3hw=;
  b=lAK6d9Ljr5D64zUiIVjIBj3NRId+VEFY9EC0jHklkUsJ0pGbXpd7An/R
   41KrLbc8q9cr5FLrujaVa2yx3Mz7RbrCtMpAJUh+AIM8bgUR67nnvnXif
   VDHlU1Cv0CRl1LzNfuSGF+WrqECYyfIevtS/Weq147MU2ZKqyIwWmoXbG
   C0aYmEEYIErhVy6omu/RYP+JgqYG2QRVWLdLB5D2sXSJ8zTHPHnAWS/kA
   sjsfUW1xl7iEluioDVjlQx2B5e7WPWqnqLyE8ITz/h0guMEuYogHEI6RF
   OQuRBvravVyo87baWyBaPRNPaILCJVaDK+CTyUwt1wS4M0MPkCHX8yOG2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="411992574"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="411992574"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 01:51:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="837348527"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="837348527"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.145.92])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 01:51:07 -0700
Date:   Tue, 25 Apr 2023 10:51:02 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>, colyli@suse.de,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>
Subject: [RFC] Allow spare's movement only for one metadata type
Message-ID: <20230425105102.00006f3c@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,
We are seeing issues related to spares movement managed by mdmonitor in
configurations with IMSM and native arrays because IMSM has some drive specific
checks inside add_to_super_imsm. The spare will be lost if add fails in the
middle of the movement.

For example, IMSM allows to use only one namespace from the nvme drive. If spare
in native array is a second namespace ( by-path link is same for every
namespace, or simply path=* is used) then issue occurs.

I would like to not make mdmonitor more complicated and I don't see the
case when we are configuring spare to be used across many metadata types as
good requirement. For that reason, I would like to propose limiting
mdmonitor spares reassignment functionality to work only across one metadata
type arrays or containers. It means that mdmonitor will be able to move spare
if metadata type is the same for both donor and target.

It deprecates "metadata=" property in POLICY line because there will be no
need to specify metadata if spare can be moved only across one metadata type
arrays/containers.

Thoughts?

Thanks,
Mariusz
