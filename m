Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4E6C04A68
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jul 2022 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiG0Vwy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiG0Vwx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Jul 2022 17:52:53 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D704930568
        for <linux-raid@vger.kernel.org>; Wed, 27 Jul 2022 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=5aSOaHvwsU9+QH0cHH5S987K7ykyc5BL+UM4js2PJGQ=; b=r3Yop10sJjeICWokytwlL+Am+g
        ID5sajfTbRcR/Uopp1lEqZA25l7t0Ot/r0/MD9d5zMPDKFbYheUjWyu/m3RY67tTh4E1ix2T+JQDd
        vusPPizTd9G/xHxmzMdVi1PzsQx17sbejMuDTGD3H1DRii56eJyG3wSek/etitZXNah4J9hIcEc2c
        3Q5nxgnDs1TC3sqpdA8zbVrhrWsNVD7axj+emvoffaJHYR7qwz35U6Lpvs5MyQSYxlZ1CWvseZtBW
        eK6P2kCM1oUYVMe199pGehf9zmZsPMUpWUS1J25XB5rIViLRLM0o2C2mA98qPOEkZiKeoqseNMMBq
        ccPhWeHg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoxX-001qTe-2b; Wed, 27 Jul 2022 15:52:52 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoxT-000VaK-7F; Wed, 27 Jul 2022 15:52:47 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 27 Jul 2022 15:52:44 -0600
Message-Id: <20220727215246.121365-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v3 0/2] Couple more testing fixes
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey,

The first commit is a new race condition seen with more recent
md/md-next kernels. udevadm settle needs to be called in a test
to avoid the race.

The second patch I have already sent a couple times[1], but have
reworked it based on feedback from Mariusz. The new version of the
patch keeps the checks on the device if it already exists but
changes them so it doesn't require openning the device (which has
annoying side effects).

Logan

[1] https://lkml.kernel.org/r/20220714223749.17250-1-logang@deltatee.com

--


Logan Gunthorpe (2):
  tests/00readonly: Run udevadm settle before setting ro
  mdadm: Don't open md device for CREATE and ASSEMBLE

 lib.c            | 12 ++++++++++++
 mdadm.c          | 40 ++++++++++++++++++++--------------------
 mdadm.h          |  1 +
 tests/00readonly |  1 +
 4 files changed, 34 insertions(+), 20 deletions(-)

--
2.30.2
