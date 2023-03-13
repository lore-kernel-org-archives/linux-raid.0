Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBDDC6FD19
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 14:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCMOJc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 10:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjCMOJa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 10:09:30 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12C56BC20
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 07:09:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678716537; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Kowmg1MNbI1S1/z1jBsbp4VjTFfXuhIQrw5PhyrHNW+4S3YFw+N7EDCCO8NLZW1C3XmiAqU4xaXQgb4rAh2glkDHN32fuA5P9bazS9F6LuF73XurfDFg5eUeET/oYac30FsfJjKM/gEzRDPlm+UHq8JX8bKrRyn83ywPY9s0Rso=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678716537; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Pv3e7OApv63z5RB0d1ZE9ZUgsQ9vEBlgvhybrd23OHU=; 
        b=KGuYh0MZ5kzOCUwUXh7mt23kbsKGnI1X7v+FRHegs2/wjNSzPdSzvq9D/xm+gvljZshiRnOWfN4kWXSvJ+kznteR7Ic/46im7JeLGBGJgJYMJmxXmoPwTxF45RkpB5txkTGrZW6qXI7l9sG3m2N8oyUh5WfRwMndqCXs75VIvAY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1678716535444203.19240447084724; Mon, 13 Mar 2023 15:08:55 +0100 (CET)
Message-ID: <8957a1bb-5add-3fd3-8c9e-f25ba9a8e895@trained-monkey.org>
Date:   Mon, 13 Mar 2023 10:08:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH mdadm v7 0/7] Write Zeroes option for Creating Arrays
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20230301204135.39230-1-logang@deltatee.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230301204135.39230-1-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/1/23 15:41, Logan Gunthorpe wrote:
> Hi,
> 
> This is the next iteration of the patchset to add a zeroing option
> which bypasses the inital sync for arrays. This version of the patch
> has some minor cleanup and collected a number of review and ack tags.
> 
> This patch set adds the --write-zeroes option which will imply
> --assume-clean and write zeros to the data region in each disk before
> starting the array. This can take some time so each disk is done in
> parallel in its own fork. To make the forking code easier to
> understand this patch set also starts with some cleanup of the
> existing Create code.
> 
> We tested write-zeroes requests on a number of modern nvme drives of
> various manufacturers and found most are not as optimized as the
> discard path. A couple drives that were tested did not support
> write-zeroes at all but still performed similarly with the kernel
> falling back to writing zero pages. Typically we see it take on the
> order of one minute per 100GB of data zeroed.
> 
> One reason write-zeroes is slower than discard is that today's NVMe
> devices only allow about 2MB to be zeroed in one command where as
> the entire drive can typically be discarded in one command. Partly,
> this is a limitation of the spec as there are only 16 bits avalaible
> in the write-zeros command size but drives still don't max this out.
> Hopefully, in the future this will all be optimized a bit more
> and this work will be able to take advantage of that.
> 
> Logan
> 
> --
> 
> Changes since v6:
>    * Collected review and ack tags from Xiao, Chaitanya and Coly
>    * Adjust the error reporting to us strerror() instead of the
>      glibc %m extension. (per Coly)
>    * Fix a typo in the man page ("despit" should have been "despite")
>      (as noticed by Coly)
> 
> Changes since v5:
>    * Ensure 'interrupted' is initialized in wait_for_zero_forks().
>      (as noticed by Xiao)
>    * Print a message indicating that the zeroing was interrupted.
> 
> Changes since v4:
>    * Handle SIGINT better. Previous versions would leave the zeroing
>      processes behind after the main thread exitted which would
>      continue zeroing in the background (possibly for some time).
>      This version splits the zero fallocate commands up so they can be
>      interrupted quicker, and intercepts SIGINT in the main thread
>      to print an appropriate message and wait for the threads
>      to finish up. (as noticed by Xiao)
> 
> Changes since v3:
>    * Store the pid in a local variable instead of the mdinfo struct
>     (per Mariusz and Xiao)
> 
> Changes since v2:
> 
>    * Use write-zeroes instead of discard to zero the disks (per
>      Martin)
>    * Due to the time required to zero the disks, each disk is
>      now done in parallel with separate forks of the process.
>    * In order to add the forking some refactoring was done on the
>      Create() function to make it easier to understand
>    * Added a pr_info() call so that some prints can be done
>      to stdout instead of stdour (per Mariusz)
>    * Added KIB_TO_BYTES and SEC_TO_BYTES helpers (per Mariusz)
>    * Added a test to the mdadm test suite to test the option
>      works.
>    * Fixed up how the size and offset are calculated with some
>      great information from Xiao.
> 
> Changes since v1:
> 
>    * Discard the data in the devices later in the create process
>      while they are already open. This requires treating the
>      s.discard option the same as the s.assume_clean option.
>      Per Mariusz.
>    * A couple other minor cleanup changes from Mariusz.
> 
> --
> 
> Logan Gunthorpe (7):
>   Create: goto abort_locked instead of return 1 in error path
>   Create: remove safe_mode_delay local variable
>   Create: Factor out add_disks() helpers
>   mdadm: Introduce pr_info()
>   mdadm: Add --write-zeros option for Create
>   tests/00raid5-zero: Introduce test to exercise --write-zeros.
>   manpage: Add --write-zeroes option to manpage
> 
>  Create.c           | 565 +++++++++++++++++++++++++++++++--------------
>  ReadMe.c           |   2 +
>  mdadm.8.in         |  18 +-
>  mdadm.c            |   9 +
>  mdadm.h            |   7 +
>  tests/00raid5-zero |  12 +
>  6 files changed, 437 insertions(+), 176 deletions(-)
>  create mode 100644 tests/00raid5-zero
> 
> 
> base-commit: f1f3ef7d2de5e3a726c27b9f9bb20e270a100dab

All applied!

Thanks,
Jes


