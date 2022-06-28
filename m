Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36B9C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 28 Jun 2022 07:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbiF1HEo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 03:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343746AbiF1HEk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 03:04:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9189027165
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 00:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656399852; x=1687935852;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3JyEBGvCrVZ9O2DLLxkBLdxBl9nm/8rvx6gN645AlDM=;
  b=QVhXGEeHnmIpCVWRQ1KxinUExDcv/Q5dZAdC3mhfZdIdwA6uVyDYDsbw
   sgJcjGroB+sZZfObr1T1tAHpdobnRw/L8v8bKCgceZEme2vqO4MKX70Dx
   TClnhnAeXBZHE8UEGPbO2S4WtyCjrw5N+c2amQqRQzvuNe2TqDNHuJuF7
   oq+wMYsNBAA4zlSO08CGuHl3F7gdFLxPMT16boyYSnXmo7k2BnpzLJ+0S
   WorsscRCtdqyk98yon2E7IzQD+xBvajJuhgZvVAosxvIFcy3KJsGnGyb8
   aRmMP3wywCaWEiwYxPMDxp5Bx5uf2bfz4DSEE+o5Dw/7kqeQf/4isVTfP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="307133966"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="307133966"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 00:04:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="646783522"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.142])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 00:03:55 -0700
Date:   Tue, 28 Jun 2022 09:03:52 +0200
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
        David Sloan <David.Sloan@eideticom.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
Subject: Re: [PATCH mdadm v2 06/14] mdadm: Fix mdadm -r remove option
 regression
Message-ID: <20220628090352.00007f85@linux.intel.com>
In-Reply-To: <20220622202519.35905-7-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
        <20220622202519.35905-7-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 22 Jun 2022 14:25:11 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> The commit noted below globally adds a parameter to the -r option but missed
> the fact that -r is used for another purpose: --remove.
> 
> After that commit, a command such as:
> 
>   mdadm /dev/md0 -r /dev/loop0
> 
> will do nothing seeing the device parameter will be consumed as a
> argument to the -r option; thus, there will only be one device
> seen one the command line, devs_found will only be 1 and nothing will
> happen.
> 
> This caused the 01r5integ and 01raid6integ tests to hang indefinitely
> as mdadm did not remove the failed device. With the device not removed,
> it would not be readded. Then the loop waiting for the array status to
> change would loop forever.
> 
> This commit was recently reverted, but the legitimate fix for the
> monitor operations was still not fixed. So add specific monitor
> short ops to re-fix the --monitor -r option.
> 
> Fixes: 546047688e1c ("mdadm: fix coredump of mdadm --monitor -r")
> Fixes: 190dc029b141 ("Revert "mdadm: fix coredump of mdadm --monitor -r"")
> Cc: Wu Guanghao <wuguanghao3@huawei.com>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
