Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FCEC6FD18
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjC2XbT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjC2XbS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:31:18 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DAA1A8
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680132676; x=1711668676;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UNlm9Cgnb69c4/O/u7KM3nCJu6vgziKIZ4YaTqHtuUE=;
  b=PRhzTjzy5ld5FXaMZ9yPIVkw2B5RK/qAc+4v6jzUggRsLWTmB0C3Pluz
   3oc2S4Zuu29w9IfeSCz/vS9BBHcAuDaHsCZIW17iQnA5Bp3a8J6mvzq5t
   LO7y3c7kzkYyipke6mXbXo1GkN3UZPPArzodx7O2I3TS9xj6mH1F3rINO
   ASt18fL+lPbhYmwaYO/ahstI76Z/bRBYjRQGjZWZhSY1whm8kPHVKt30s
   mtZRSxoctk75BEYHecXj63hPqowS1vQDDyTIErL/c9TnZTizP51nl6T3k
   6Du+VBnz9wCok/iPNfnIGYhqgjoDk3HbYjDiLK8KWO7GDSh/4AAZID1O3
   w==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="226828443"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:31:15 +0800
IronPort-SDR: dCAEeCxkBRTCbetj4BQ6KeNmkaz1qACO9Eyp9QuF1MfmoohuSh9QurTebaWmkVDBiGmtMs9GGJ
 jSWWOliauKRvD3Du6r34IzcR17h0hnb48sD8/jlpVFOYWEdgtjt9xPUB0fLc4XMPka3MuqHp1r
 BGcKOiFzI2SUX5nWmbqtXSRK+pijaDq+mg/SIDMbPXqF1nu3cEywIhU+e3ptfZbKsnkNS6kcou
 xZ9Xh071BhcluAC3jpNE1Rhh96PWmJ9mUM09e+Lynf2M+QFVLyYDGDWtnXRj4oEVSuEsGciE/u
 ZvY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:41:44 -0700
IronPort-SDR: jg7iLE/2FUqcJOFqLh2zERKWooDjJ+cgaBNiRY64BZqFSKCW8HiqlrwITdcExx6PzUI+eHKYae
 OVujyKKkGL5+iLGmGnu3Bm33Ta1S9Z1WtgCCoPM56SIlODdR78dw6tLAgltbRLTkS7K2RH9fK9
 haRZX5FlJDONz+i5H1XP3+UWELRIZU3XYz5DxksP01xzsZmDjqJiWB0otdoMwViKLtN/XjQcNg
 hDVD+/XgmOqPZH9sXGfek4OtIyrpkCyeMpMFd20hXPrKK4y5N5dv3uOu6oFwHaMFCD0TZRmvDB
 C4Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:31:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2ql6Rcfz1RtVn
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:31:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680132675; x=1682724676; bh=UNlm9Cgnb69c4/O/u7KM3nCJu6vgziKIZ4Y
        aTqHtuUE=; b=Ca2fO6rcxglppHNXYxRAHziKkRlfWQdPRtKcotDpyHFiP/dqL1l
        +eRINX7r2eICbC4KQtNpc23E7B6cTVrRj9Ksclu4Jqd/OhE7FGf0WFts4RSkNvRZ
        vyDh64QjNua4rA3LG9nobAs9hY5rxbY67Vr2/TNnOHh89mZ8LeAkwGHM4RGHVU7Q
        G2zLU+l3brOhyc7kjdil5v6zpK4QdjwQTJ4zW86BPD9Cb/sL1GpTuVvrOGcehbqI
        6BtW6hfXgSgZ2432WxO3xb5C7AONp6W2nDb+sKaqwGk9QuSWfywQR32EdxP4QOPx
        RFADdkCfux4rv8H/ZisxP0MjM4uYkF1VzgA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fCBZnpNixJet for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:31:15 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2qh3MbGz1RtVm;
        Wed, 29 Mar 2023 16:31:12 -0700 (PDT)
Message-ID: <3ba0a4e1-7b75-9d0c-d6d3-dfc3d4bbbef0@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:31:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 04/19] fs: buffer: use __bio_add_page to add single page
 to bio
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
 <56321f8ef1e70e9e541074593575b74d3e25ade2.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <56321f8ef1e70e9e541074593575b74d3e25ade2.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The buffer_head submission code uses bio_add_page() to add a page to a
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

