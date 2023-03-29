Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFACC77B60
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjC2Xiz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjC2Xim (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:38:42 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0494944B4
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680133121; x=1711669121;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aODFcqxqHz5iuZ9R2+Bd+E8Nkx+iNXfbVHgy68x60n0=;
  b=gwZqchh0bB1gXkom4w9s4I/gVYw3ayfa4/18plUNfDEdfe2VnuH+N7pB
   IKz1qnkyjcal4x/JWMQ/7Kq9S4Kigb7sGcV84qilifQ8ulLVHeiyesWom
   6mOkkruYTwbgGcr7X1g0cvtKQl96QUbYuCizmYjfy2vmJrXnjT7p6ZKfh
   Pe/dIquZfUdJ08RztMb2JhgbiSFcs6sh4GYXG/7zbKu4J8QX1+laoWk3a
   rRQXaekpQ2DgDcuCXlBP2nibvzVU/GrObND9zhR61AAc/iUQZQvCPvHsn
   Awv/vMQkajW8yZWYXpb6cjI/rWzGDf/MZOSHOtj58dugCKsWZsU9HOmT9
   w==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="226828803"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:38:40 +0800
IronPort-SDR: pT+HeYiREggxgVniSpX/R+UNCtsUeD2ScT7jMIKV2lUCG2B+8i/ZGUjsnr4e7yKwEd+DbElGFf
 tt4lyUJzmDnNhgcyPErY672Gl64rf9EMAop+9+mVMUXaYxG6WmnJ2jFYccmduOhZJ+2LpXbSW+
 nn3H6ITZVgzAX2zKTZn2Ebx0KHrDKALfiCe8HaXq2F8aFCGRzMRF1hmMBzWYd74CB9o9wRKfdD
 gIsIcEWmn4QklBfvLkjaORBtMIditekvouc9KdIiGeDCqNZemI8XJeLqro6o42GPfxk7G1IGtm
 HeE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:54:49 -0700
IronPort-SDR: KWV+ikGBDpCCCAWw+OZGkbiEVYFM3GXttIrnivUzokdWdHVDJNccnJTFa6ncjY5rAwvM1z6zF3
 MnS4lK4xu9u3fAj8PfcegFgX8k3GEP2GSymRm0/aZKcV07J9WvyDT8VK+1sSSCqbTgYCw1xr9d
 buSSkgF8YFmptigrfzuFJUo0AMV/f6Ul9WW8TnXu+LfgKzsj050SSlg6Y7YY+cE4fI4ed3VT6D
 vkqkvAD2Zcm571McnfcZ0TYl3Cd/9qQeqzGF6JE1Dj0gx1Br1/rEkyTji0LTiH5A8iq9IYjasS
 vjo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:38:41 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn30J3WM0z1RtW0
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:38:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680133120; x=1682725121; bh=aODFcqxqHz5iuZ9R2+Bd+E8Nkx+iNXfbVHg
        y68x60n0=; b=R8Vxmqf2gzyvd60/G3fNrcajqgf2Hq3bqu+J9ygav1Qc5k6vp0A
        hZ5W9CUTNV9Nfuv5COhboO6StmWvtgIdaBZoQNEw9Bg3MZDcIoKR9hgFec5Bl6n2
        kJBhEqSEvP20eEETiOS4fmamOYJ5xRWqEd6n+TPYaDsGuoMZSma8OM91aKaYfC7l
        Ojm6whBt/NyWaPupvKTvFJoBea8kq7nXUMCxemBzVjBlj9lBAMznBFwiIzkeYZLd
        jTV2sE4UhfKhvgQuLa74BU6Zsuth7/1imIA+lakuiMnimyKawIkA7bL5yffxrqf+
        R+VZIUc0iLWil+zcsIzSew/QXpgT48BsWiQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ca6s09zAZj1e for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:38:40 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn30D5vG4z1RtVn;
        Wed, 29 Mar 2023 16:38:36 -0700 (PDT)
Message-ID: <84d3057f-58b3-b3da-a473-082806c4b5f2@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:38:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 16/19] md: raid1: use __bio_add_page for adding single
 page to bio
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
 <8758569c543389604d8a6a9460de086246fabe89.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <8758569c543389604d8a6a9460de086246fabe89.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:06, Johannes Thumshirn wrote:
> The sync request code uses bio_add_page() to add a page to a newly created bio.
> bio_add_page() can fail, but the return value is never checked.
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

