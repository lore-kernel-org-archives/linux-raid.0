Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6834C43219
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 19:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbiKWTKI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiKWTKE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 14:10:04 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1188FE47
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 11:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=BrvQ8NBSzQ4Rm/HPN86qTW3eeXaJulms19jNw5KLn+U=; b=J8KZ+1q/ykKEbd12BY43w9XG04
        WK2485+misrDapLCMiIfFcrVUlxSkt02PdSBiXDUTTqSEH5UUUdo+cpZsx17qeF2xWNNxjSd0mz8K
        ArwdyP+o+TVCEgtmQbiNHirmJ3v3JylqrHztnr+R8+R+ai8blMR6AwwUUE2+092ej1tj9HY5Nnk70
        gzDCVp6ZQ/Ik/l9nkDvD6mp6XTXWb0iFBKb5fUdK3O4EQ8oCYNkm+tP5yz6DHpDKp33zOfqD27nXR
        ANRNAI5apKa3cHYLSu9MdyvziZhp68JMMD5Y3tEnX/MQiHp/zLD9C7/OhBu15Jl4DjUHYEQWDz6NP
        JehR+htQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv8B-009Six-E8; Wed, 23 Nov 2022 12:10:00 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv88-000OpT-Jm; Wed, 23 Nov 2022 12:09:56 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 23 Nov 2022 12:09:47 -0700
Message-Id: <20221123190954.95391-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v6 0/7] Write Zeroes option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

This is the next iteration of the patchset to add a zeroing option
which bypasses the inital sync for arrays. This version of the patch
set fixes an unitialized variable bug in v5.

This patch set adds the --write-zeroes option which will imply
--assume-clean and write zeros to the data region in each disk before
starting the array. This can take some time so each disk is done in
parallel in its own fork. To make the forking code easier to
understand this patch set also starts with some cleanup of the
existing Create code.

We tested write-zeroes requests on a number of modern nvme drives of
various manufacturers and found most are not as optimized as the
discard path. A couple drives that were tested did not support
write-zeroes at all but still performed similarly with the kernel
falling back to writing zero pages. Typically we see it take on the
order of one minute per 100GB of data zeroed.

One reason write-zeroes is slower than discard is that today's NVMe
devices only allow about 2MB to be zeroed in one command where as
the entire drive can typically be discarded in one command. Partly,
this is a limitation of the spec as there are only 16 bits avalaible
in the write-zeros command size but drives still don't max this out.
Hopefully, in the future this will all be optimized a bit more
and this work will be able to take advantage of that.

Logan

--

Changes since v5:
   * Ensure 'interrupted' is initialized in wait_for_zero_forks().
     (as noticed by Xiao)
   * Print a message indicating that the zeroing was interrupted.

Changes since v4:
   * Handle SIGINT better. Previous versions would leave the zeroing
     processes behind after the main thread exitted which would
     continue zeroing in the background (possibly for some time).
     This version splits the zero fallocate commands up so they can be
     interrupted quicker, and intercepts SIGINT in the main thread
     to print an appropriate message and wait for the threads
     to finish up. (as noticed by Xiao)

Changes since v3:
   * Store the pid in a local variable instead of the mdinfo struct
    (per Mariusz and Xiao)

Changes since v2:

   * Use write-zeroes instead of discard to zero the disks (per
     Martin)
   * Due to the time required to zero the disks, each disk is
     now done in parallel with separate forks of the process.
   * In order to add the forking some refactoring was done on the
     Create() function to make it easier to understand
   * Added a pr_info() call so that some prints can be done
     to stdout instead of stdour (per Mariusz)
   * Added KIB_TO_BYTES and SEC_TO_BYTES helpers (per Mariusz)
   * Added a test to the mdadm test suite to test the option
     works.
   * Fixed up how the size and offset are calculated with some
     great information from Xiao.

Changes since v1:

   * Discard the data in the devices later in the create process
     while they are already open. This requires treating the
     s.discard option the same as the s.assume_clean option.
     Per Mariusz.
   * A couple other minor cleanup changes from Mariusz.

--

Logan Gunthorpe (7):
  Create: goto abort_locked instead of return 1 in error path
  Create: remove safe_mode_delay local variable
  Create: Factor out add_disks() helpers
  mdadm: Introduce pr_info()
  mdadm: Add --write-zeros option for Create
  tests/00raid5-zero: Introduce test to exercise --write-zeros.
  manpage: Add --write-zeroes option to manpage

 Create.c           | 564 +++++++++++++++++++++++++++++++--------------
 ReadMe.c           |   2 +
 mdadm.8.in         |  16 ++
 mdadm.c            |   9 +
 mdadm.h            |   7 +
 tests/00raid5-zero |  12 +
 6 files changed, 435 insertions(+), 175 deletions(-)
 create mode 100644 tests/00raid5-zero


base-commit: 8b668d4aa3305af5963162b7499b128bd71f8f29
--
2.30.2
