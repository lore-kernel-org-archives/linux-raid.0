Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E095C54EE9
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 20:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiIGUEK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIGUEI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 16:04:08 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA02FC0B78
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 13:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=r+hHw7J5rRP3FKqOHDjaHw9VzFjA/FosjwkNeUhDHoo=; b=k7xnegMcZKkO6q7JMhC0npwTEE
        QfD/+IMIKtEoYjfnQcxudnyHlYg0fdJIC9u1o0luQMK1ebCgdZtvrkVjaygCUUZeRT3Rv9Cm7KzQm
        xak5132pHo5JvIUB0rLll851X+JCVj/B47XgfvPoax5AGtyt+SuFV/84yUSzUv9mTz6G5dmIiMHal
        P2OtFbwHjP+j2+s43sTH+vciM8WJGwlWoXcR3qoTLH8NfTBbE6b8PXHklunwFVDlcV9gibnEzJUYB
        9oOJNGcRGe5hGZblhLanKQdxRbFyNvoQ0g8Tlf7p3gq/jjGvUURfhggSzHBrExyGKNkR7PBDkLZs2
        rskhIeIA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oW1HH-000vwk-EK; Wed, 07 Sep 2022 14:04:05 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oW1HF-000rM0-4n; Wed, 07 Sep 2022 14:04:01 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed,  7 Sep 2022 14:03:53 -0600
Message-Id: <20220907200355.205045-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm 0/2] Discard Option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

This patchset adds the --discard option for creating new arrays in mdadm.

When specified, mdadm will send block discard (aka. trim or deallocate)
requests to all of the specified block devices. It will then read back
parts of the device to double check that the disks are now all zeros. If
they are all zero, the array is in a known state and does not need to
generate the parity seeing everything is zero and correct. If the devices
do not support discard, or do not result in zero data on each disk, an
error will be returned and the array will not be created.

If all disks get successfully discarded and appear zeroed, then the new
array will not need to be synchronized. The create operation will then
proceed as if --assume-clean was specified.

This provides a safe way and fast way to create an array that does not
need to be synchronized with devices that support discard requests.

Another option for this work is to use a write zero request. This can
be done in linux currently with fallocate and the FALLOC_FL_PUNCH_HOLE
| FALLOC_FL_KEEP_SIZE flags. This will send optimized write-zero requests
to the devices, without falling back to regular writes to zero the disk.
The benefit of this is that the disk will explicitly read back as zeros,
so a zero check is not necessary. The down side is that not all devices
implement this in as optimal a way as the discard request does and on
some of these devices zeroing can take multiple seconds per GB.

Because write-zero requests may be slow and most (but not all) discard
requests read back as zeros, this work uses only discard requests.

Logan

--

Logan Gunthorpe (2):
  mdadm: Add --discard option for Create
  manpage: Add --discard option to manpage

 Create.c   | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ReadMe.c   |  1 +
 mdadm.8.in | 15 +++++++++++
 mdadm.c    |  4 +++
 mdadm.h    |  2 ++
 5 files changed, 97 insertions(+)


base-commit: 171e9743881edf2dfb163ddff483566fbf913ccd
--
2.30.2
