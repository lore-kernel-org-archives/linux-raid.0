Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC2EC77B62
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjC2XcW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjC2XcU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:32:20 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FBE1FFF
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680132739; x=1711668739;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2oOVyR5FAdaST7S/q6ZiTs6JWIlaWidrp4+z9soxNLY=;
  b=IVIrVEB3ZddWUsYs7aRERbqhJI5n9AxCDyq4c2f3uGyp8yfHNap2lEbh
   mZyhQeXnhQlqP6ISxOPRHo13jc2UoGwEPb859uZy02SnscVrYi629S3eu
   Kdx3I8wIB9ATpYIWLq7TPwN6ChW8R3FTVis7obMjLOGoKLIk7wK5bfCM5
   Ss+is6mKE+5NxIs4x3IuSxSTRpYH+M4Y+t4yetFafX7rfTYYI0xceWlQs
   ZLEITi1wSgHWObnhS1KfJLc1sGqVjUkt4ljOkXHkcZm4tP8bbPygezXRB
   Xtl1sZFtbBF8Y4eM6pil1lPTNwYWrlEg7+WAvBuqIzstW9vrD/1m5GWYK
   A==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="225113562"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:32:18 +0800
IronPort-SDR: udLAxsC/SmsStI5bQZekj0FoIOKiqlB23rs9j80RXXO2CePuXjCALa7eVhxMb02ipIzI17nLHJ
 8dkm3pm/qWz+X0gcEMcBw4k1XLgrt8Nkf/ww4mogRB/vCMrhA3yCjpYHWbvyarh8vT8d2Qvzup
 iNKVF3v+C8rHGIcyj/T2jgJeKCCg3zEbErcrbZKtFuQj5FQzlIFGK3qSigsoFQjkd7+gkJ6vOg
 TduYRp2RnCkEOUYOnD0qHlWkWBDaw5u4rjLau/K9LcRpIIdQcLCJ6Qfvwlu1xm0+LdyjxHXc/5
 yO4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:42:46 -0700
IronPort-SDR: Zk8jc6yG0nr4/o9BTFkkCCBl4jz91164IICBNe8Hu1gfZy29OGoBLSo1EkJfPSn+tBASl+QO8J
 mOq5sw4yvoOHBzsySi20humLUemmgo/QBWV+x8AKzY2z6SzUfmn1vAeeSf5CEytmlOGHyzo4Ng
 A3QBukElNQuRRtiU6kgTbpeHAFj0e8Koh42DYadNBzKTF8RFSgCMlIlSnAb+TzNy87/vDBAgMd
 tA4aMGC8mXmaSg+tHyy7TE+R7V9XuWmwEXgmQUEMgSReQ6hT+WM6CmD8rCJt3N/sVbPiTZ3svs
 R30=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:32:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2ry17jLz1RtW3
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:32:18 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680132737; x=1682724738; bh=2oOVyR5FAdaST7S/q6ZiTs6JWIlaWidrp4+
        z9soxNLY=; b=CzTI5dmKz+cz+ra1W91v/vvm1q+lz4VpZaKNJ+ur2JgwvsLgkyz
        Ag9i1RXpGZQVCWt/gCi8lYEB9yivIbPnlXG6Hkz4MlXf5GZofs5pel3W7YhmzADn
        y+IYY/j6Lu2Sr8JsZyfjakqTUdNpz293fh+kzLI/QY1JbVuKx8S2nxmI8RNRgCP9
        5hP2QzGdEOFg9faNtfShxavTwxvhGcZzFc0K7rJLpJN7Iw5Q9BWad4Y+EX6dqTJt
        4igFqUNZin9rq2K2OW32dMdvOFsCycds3Ts6xqe6P+GtL3mkBpHqjGNtHRe59whO
        D7Vet14/ORgEglG520efiA8j4/Y3c2z2ESg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id p6dBRcBDN5xz for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:32:17 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2rt2gL4z1RtVm;
        Wed, 29 Mar 2023 16:32:14 -0700 (PDT)
Message-ID: <a18998ed-49e2-739c-1f1a-c3d2375f4438@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:32:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 06/19] md: raid5-log: use __bio_add_page to add single
 page
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
 <492cbaf4225065838d25e04f8488528e50a52e3e.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <492cbaf4225065838d25e04f8488528e50a52e3e.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The raid5 log metadata submission code uses bio_add_page() to add a page
> to a newly created bio. bio_add_page() can fail, but the return value is
> never checked.
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

