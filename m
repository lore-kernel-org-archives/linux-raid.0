Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C349CC6FD18
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjC2X6n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjC2X6n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:58:43 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8049759E7
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680134322; x=1711670322;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l3K4Kt/FO4iBIKq8VgAcGfFNIvXYccX/xQem9blms08=;
  b=iN0/9zeAznYhbUZXkkd5ZwXC51rfovnITWRz+bWxbNSb2sbSOSV9Nnu1
   RYpRsLsotdDxFPkUFGgnq06TIlHvUvzB0u3jjV0ljmrP39jJa/TCPukb+
   jtfIfMygyzY9Ws2dmcvn3iU3hxZe3bRIZf4HIve+9KO/b7z6xZz7oZMtj
   KxdfYIsfqK/BS/UsXPf/xpnJcmQecrGpm9tZyER6HQGHo8eb208SUEfdi
   WgdKqtOavQMJ22WPcbaPluttjUtp96muWXIgZw9JgDyxeO+vDRXnvHvX9
   sHMhNWTZjlV1hQ3THym0RSFAqwqrLrHZERPTKnmUsKt0FfLWDnwKaKpxH
   A==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="338905088"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:58:40 +0800
IronPort-SDR: c5/XjCdv6OGi/jw5Ym165Ewiaho195qgSxT8yQPJkIo0/vpcVHYbcTEo1uF9IzXmx4A8sjSwvy
 Umw1gYLp9KqaQgDwKVtVwmq8u+yVYXpz2an+J0uzb/LP4oLEsvMBgNPZJo/PCqPzTM2CstKHGX
 AKwLSUzlx/mKz/ouRKaZm8Zt2JUvHGG3k7DanmXMePt2e4wNrZ/x3hviATskAvATLpIFV/hkH2
 re31vGh2n1PU+09F99/Zq3SPMEfp/4uPEYJAGxPRxJTa0cV3tjzZu3hj8NxjAhAdhI00h7Jhss
 Lf0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:14:49 -0700
IronPort-SDR: 9Sgk0a3t/mF800LtGJapz0Wczdh5hGcXYy+o2O27DoLU7stVIKHNPvqXQZ7mk/ve9JpHoUKMLD
 qorzqWUT1VQEEu4+Hq3erG9LJwRFs7GJFniDdMWTlOyyd7R/RnyywOISiyNMcUkuybhGgx/EoP
 uuaAkUncMDW7/H7k43m1jxpXVya2DnTQyQSPjqGmr8ssnsdfDt/VIDar/lmDB+FBXFEl7TxwaS
 WRZLCtP526BWSUrERDw0gDX7wWIZSByctvmBSV/j/vaZWFEf2sXz0Ma7o2a0dKlkIVNyhnT+2X
 Yd0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:58:41 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn3RN22RCz1RtW5
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:58:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680134319; x=1682726320; bh=l3K4Kt/FO4iBIKq8VgAcGfFNIvXYccX/xQe
        m9blms08=; b=Z/xEynILGjmaBwHeY3zVoiULWBo3e30fvx6iPr3Zx6Wj7JD/AeL
        AlMf5sdtT16U+2fy8eU1VAKFPpBudi6kurLPAGIzKE9drC6EeQeqgjCFT9E4ojVy
        TQQB5cTsm8u17203jJLawINrINsD7UcNkKFsfaNP554pst6fe7CQNFLH/4gnZpHW
        cIc0ZPn8qBqY/PUa8EZzINk2DyDa38pZrA2IHJhRPZg8wTakQ8CRn+WKb8IUyz/t
        SBylBZXjhtrWwGcmAPksFGN22jMLMsZOAJeZ+IGqQ1Xj5XyaZ0SgGrhmF2I15zcu
        VVtWA4JMjP+QyIuov+vQWELqF/Tx0+aFYxg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rbWKEU4AeiWM for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:58:39 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn3RJ0pDLz1RtVm;
        Wed, 29 Mar 2023 16:58:35 -0700 (PDT)
Message-ID: <e088f7f1-827e-f0e5-4fc0-df0dcefbb873@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:58:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 19/19] block: mark bio_add_page as __must_check
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
 <350bd9c62ce575267a2b38625ab767c332429bc1.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <350bd9c62ce575267a2b38625ab767c332429bc1.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:06, Johannes Thumshirn wrote:
> Now that all users of bio_add_page check for the return value, mark
> bio_add_page as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

