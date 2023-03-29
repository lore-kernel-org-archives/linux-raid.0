Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD983C77B60
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjC2XfD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjC2XfB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:35:01 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69484C13
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680132900; x=1711668900;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eeHaifFAhmRPPQjhcQgNdDiqHkPhvUoOQEh9qZdcZBI=;
  b=Q40vDSNTGIi54F12judAEoCbV5Cpu8JPgsOBSmHmhC2pijeDxgjtZ1NA
   Jk5X5N2iUO5XXoVdV7BGTyS7DU43uQrh6FRivE4z6MZCYG0RWdV4PUGqK
   wNXJz6tpaLFdH1uswxOf6YrzJdnY3n9J/rTRHmNcGvw29VXVNmstqFtDU
   81LBvCGxbgTdYKX4OddF2n/fwhUgd51NuKsL1i7VxoiW/jS+lENVTMZQQ
   Ljfo9vEdzQV5sRIjto7vD0ZtVwRzTZpJ7pREJuQcvEOrdCPywctt+WV3l
   FFenvCRmjW7ufzqpKAJDzZfzIZju+zL5b2lQl1rS1Z36Ojrn73/gIXDPB
   A==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="225113721"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:34:58 +0800
IronPort-SDR: sw7vUX8wlRggVDdPs+tx5S9W6xpFBPp/DFA5fR+Q+Aj3W7hi2DkDKQcOn2+5dGAGG+j7vFODOI
 X/V+BVY5Cg+XcG6jz+6x4bIy3Tq6nOVUcBP45a1dUQ6mDTyN/nshPATM/zKkCHa5yT4AHf0nPm
 A5he+Ey7821O7ylXSM5Fw8wEDM1+Q4lVM4wEUqwww3X0Fmp0YVD6eF1+iauWPDHOvN6BSkNCZ0
 Cpb4RVvp8vYbwZFmAiJ+nKaeQUSTduPs4hLQkAvXmJSTl/eDsjKDpADAjUzv7UZBdL/4v15TtE
 GQ8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:51:07 -0700
IronPort-SDR: JNB4Mck137w4/kbG4WjLDnEtnOKT4AQZBx3QNd1jdlQH8gA3Hu4Q3ZT/oOlSoX3s3VzYZdPI7Q
 0VtO+wkRNx4HFmQwoF6/93xTfwAFzwyNdlbVdIhefRoWpggSDewv7JHAy4++HRfq6O/20Isa1x
 3oAlVYGnVKATmk5kzoQ0X8sRprfTro32EOXKapp9AAoLXHlnMRFE3YIFbyWE3lz6goHW5gNS+q
 H/ZmDMEOQEnNE/R1AP3LjqIuBdTFYWiuM/1l3j9WDYLh00ihCMTx4S74fp/UmYOkaUD2m98Q5H
 ffY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:34:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2w241Pbz1RtVp
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:34:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680132897; x=1682724898; bh=eeHaifFAhmRPPQjhcQgNdDiqHkPhvUoOQEh
        9qZdcZBI=; b=BXNDcLcmPPrVqL0uFQjErIzucxTlO2TIjyuUMny2mRGUWmQis2+
        Kp33jWSJF1g147Opo3rTneP3H7gwmNnEY+Up30cZQPxCibvRicdthlRAp7HwfA3s
        yZ2CR0pSt1DWieL+O+5noiTVyC18th0YJN7NxnEc9WA69UT3Aek5Gf1Ykc8KUD/E
        fCMhYTIDSrIhJoUmE5A9NvofEQI3CB/096YNkJxWerVVLA5+j1USgnk3t3REY1DB
        4txAUQ8raXYpQ2EQFHL2FPvKU/3Tn62ZAbsAG7vjHNq3VUhum4TuE7DV08/TeyBl
        eQW/1XF2djdTME7GQEAjbOj7c59rU1TGj7Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YtkEAlxR5HUf for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:34:57 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2vy4wThz1RtVm;
        Wed, 29 Mar 2023 16:34:54 -0700 (PDT)
Message-ID: <14a2f204-32a4-5108-560b-98c3dac2abfb@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:34:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 11/19] gfs: use __bio_add_page for adding single page to
 bio
Content-Language: en-US
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        dm-devel@redhat.com, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <51e47d746d16221473851e06f86b5d90a904f41d.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <51e47d746d16221473851e06f86b5d90a904f41d.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The GFS superblock reading code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

