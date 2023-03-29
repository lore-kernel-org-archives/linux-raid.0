Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEA5C761A6
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjC2Xbz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjC2Xby (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:31:54 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705121FFF
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680132713; x=1711668713;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+kVHS+U6z9asf4h5hbfmudX0RZseimMtPqZrPjZ6sRo=;
  b=Lha5TSPlqbUKSg1crS6anFbITZi8WqCHs2HXL8xu9MzvDbE23dST8XXY
   H28BZOna78U3VNd10JU4A5QABvfV9RGVJPCAIcsFSVxnjTO2spcDDJlpn
   VuX4VMp1TF2xooqep54mkTkGO7qXMfYSaWMW1M9PCIXbKXJjPlLadAsyz
   0BnoWDHE/h9d1QygOWZOQ+QuZPcX/25PEUpl4nSrcDxo0nWH7CO+T7Pl0
   ttCOc48i0LaAFAGC+siqWWCRPt1QAtkwWy31qWwfzAOmUPlz5cDNEl8Ni
   q9Efvyad1PP8d9xTQmYyp9josu5zPIvwbz/0k9Jz/Nw69Wm8TCDlZSSsL
   A==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="226828494"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:31:52 +0800
IronPort-SDR: r41eeLYj5gggQffC9vQPXlAchAEuIH+N8vF9+XPoAQhuVMSQsFM2r8kL/OoLVL2WQJ9x6Qff2o
 byAOetl8pQ8ydfTAD7i9TJSVPRQPexyNdvM47jP4/e3UBvQvsTTY3PEDRRmEd9YXhxnYnDZAqJ
 8lXgvsNEEPivQQjT/UM6xeW87Rz2x8t0m+uVE+MZzV04tmcXqiUWPPaRCMxwe7p4rljUE1KuCQ
 1EvZGCd4zP0cHOo4azTtEIZMq8m6D7rYRrl3sgCQ+QSLvHkebHuGxRtdzV0YeTbdoE/IMlLM8P
 1kc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:48:01 -0700
IronPort-SDR: HZVjsrC5nuc62jFYa6FPmW6KLQPtW21esSwEGVR7VYksX7ihd3Invjd6qVt91sR4O78clxgfR9
 BLJgdk2ax1ZMjicjkA6Jrw2Pnteu6AlhpliIMO5YzxNfVFeEIS6SUDU0r+QYHBc9L3wQEciA/F
 Vz8YZa69DhMJhK6dociOR/TEOMjfkQxbXlQTkYLFAFx3jtGwNVn9Q+B2VhxgKzJoRQ2asjSnO9
 NYAhhGgBQm0nsQfGuRvRXxKYJ8RPkIxrvh2oH+2ITLaTFGPTYTWpnYIUFQ9Fa4dpP9z7RXHMLz
 /gk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:31:53 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2rS50qKz1RtVp
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:31:52 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680132711; x=1682724712; bh=+kVHS+U6z9asf4h5hbfmudX0RZseimMtPqZ
        rPjZ6sRo=; b=MSq/WJxnLgUdzNLdphZIxQyHpRfCEW6j0Wdm4bITDd3uXIJqQ4U
        6qdg8Jn+9J/5Vy15M0ezWVKJWT8F8K92ngiUMKiBHMjvNoXlsCiavKM2pCNvEVov
        vlK/ucLB7MVAxYZ5cHk1jabnY+TbwEwlTT9KgXLD0a9q8dyAASHunSVnEyJEYJ7P
        7iw/QMpUPkVls7zoUoEY/Arks/dS+UANaSD74pMDu1fcBTeFf/On+bqerWeu/wXb
        w18aQHkuSirM7cbXNck9eth9dOrIym0BiZLWxzFL+lQf5z8+AxH9izE6FsdvqzY0
        s4/hXeC/IEhI1jqvjLH2uTpMFvpk3PLBGwA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yOUwcXNtvHHq for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:31:51 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2rP0PPLz1RtVm;
        Wed, 29 Mar 2023 16:31:48 -0700 (PDT)
Message-ID: <c90afdff-55c6-a4f2-0ad9-a7bb30e6c214@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:31:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 05/19] md: use __bio_add_page to add single page
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
 <55ec6659d861fd13e8e4f46d3e5a7fbad07e3721.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <55ec6659d861fd13e8e4f46d3e5a7fbad07e3721.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The md-raid superblock writing code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-of_-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

