Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA43C6FA82
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiIHXI5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIHXI4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 19:08:56 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1958AE227
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 16:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=prpMoEm6d0IhcYyofnqdMLDsWQ0uTmI8wD1Tp6gFvE4=; b=N464WoCQPABXJyDQVGtn3ZvEt8
        0L9cTvE7F9Nvf8Xfx0azXWplHEp/ab2zGgRtrcY/ybOtLgF96mAQeOxEN5/aJPsImPe+/7DIoGMlr
        EvDAZVRdcZtWyB4GvhSj2WWpyKP3fSTeHS6UrsxRiX2d6lRvZ2JdeP5Em4XIOh4/lWwIN07FgDl7j
        Qk7mttX7HNFYyP4+74Ejr8irztuXBTkOIXm8hUNgRGC8cmPCDQrLruc+jGh3iqS3lhb2aySnVd7fZ
        Q4lH81acxvKOTaYNWhhURPnZDS8yKXquQHRX8+epUECKrW4XdUhk1dQxO5VibN3ZPebgJT8U4J5Yc
        zww4SlFg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oWQde-001qIT-Rt; Thu, 08 Sep 2022 17:08:53 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oWQdc-0001VY-RU; Thu, 08 Sep 2022 17:08:48 -0600
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
Date:   Thu,  8 Sep 2022 17:08:45 -0600
Message-Id: <20220908230847.5749-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 0/2] Discard Option for Creating Arrays
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

Changes since v1:

   * Discard the data in the devices later in the create process
     while they are already open. This requires treating the
     s.discard option the same as the s.assume_clean option.
     Per Mariusz.
   * A couple other minor cleanup changes from Mariusz.

--

Logan Gunthorpe (2):
  mdadm: Add --discard option for Create
  manpage: Add --discard option to manpage

 Create.c   | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 ReadMe.c   |  1 +
 mdadm.8.in | 15 +++++++++++++++
 mdadm.c    |  4 ++++
 mdadm.h    |  2 ++
 5 files changed, 73 insertions(+), 4 deletions(-)


base-commit: 171e9743881edf2dfb163ddff483566fbf913ccd
--
2.30.2
