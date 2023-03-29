Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16466C77B60
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjC2Xga (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjC2Xg2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:36:28 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB285257
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680132987; x=1711668987;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OTfJOB5+rMhAgZTM4ONfC4vlfxhMaFKo471fkAaO7qM=;
  b=St8PzksH1ZEMAMvMW1CvbZLbPTeJ+Sim9cGfHlRTUzL4Sit9XRhx9KDd
   lC6n3AFi1t0uTWOYMAjZ7C6kmS/Ce1il8eSV1n653bvQbSzvN4LQJwMUD
   UVZSeBormSGRSL9UhZcpxoIq8OBt/o3Fc8RIK848h54gRZuImoZ7FvDrH
   OfJet5UpcWdTHlz5IEOndDVWginMZgFvBOrEKwgIGgDQMOqOyqze7kOhO
   H1RY+LBEwKgHTPxxeDf9JfYYrMdSuSltY5TkhEXnSBlw5rvBynYQ9HFi1
   MclBULdUgwVah693xdeE1tGqguh32Y/FDeZOVMahm62bod7ErB8wT+o62
   g==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="226828699"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:36:26 +0800
IronPort-SDR: EwmS4v/3D7kudWvisGBa4rI/RAJUj5L9JFiwiYtZDxUjENI/lVo11+xpk+O9SClVKRPrt8AADr
 U4m9JENAf3AipKkJGoCA6NDQKOok3Ks0L2AS2HGBhVEHBa4SlPZ5ag/C8Bpccops3iq7mhiMI5
 Gcm+bHa/LqvO9kONXRvweF0RLcSHkEM6c9MG9lAJBSOqo86bIFgkAYXnhfW0tsnV23N6vU1qa5
 tDyRzw8qiDFF8eVvb3X65SENJYV90w8ks/3pY7O7+X1U+4U3lC45ZSiYQKw3qoVZKR0fQ6JIAa
 vmY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:46:54 -0700
IronPort-SDR: j2XQvtOZqQoh8PNj/coLke4+461teybovX9ODXMHaAXIfkPEJWTdhijZ8CgvfoavgBMfjUL2Xx
 dhkqeF09fDvrytCQCVvOUaRodak6rc9ztrTt21sXpEnjeJfpzeoxfvVbjKmLl9qfZjjQ3eUOwv
 cwlK2XESsNgz0VcSq++Lj1zSNlL9zSappUcPXgRZBwuz6HhFQnbO8ZzPHg9ruGJfT+tuvyofO0
 RJE1fzj+FeOTexFnWjc5+8ATOqQ+BFBGK9foPh7HHuPQ0goDU+WYH2TUBPXJNiqpg3+9ggKsek
 kGw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:36:26 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2xk0JP6z1RtVq
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:36:26 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680132985; x=1682724986; bh=OTfJOB5+rMhAgZTM4ONfC4vlfxhMaFKo471
        fkAaO7qM=; b=J/CqCvxG/yXtDAZ6Z8y4FVSD6FKO6mFuHtMgkMtbXZxLWpJrTxX
        jzg15N0WLrB2LHfcj6uWsnuBSOqd2Si1ya5K/ZVO4lPVREU5qrfDG+ZAzfgRnoQN
        6rTg8PEzntdT9htvQjOn9TvzpU6OYJJgLWQ/pOb8gEu1BYuaoKfWtpLNY23geZVK
        6XrmgWL58pocgNIQNG19ktzATxEb3JKU9zAv3b/nXM1vRtO4uAFqDJjYfFQEyseM
        iU8x0uoQU56YGx7/+3oBbeIPU54IguMOX09Hyyg2ge7+zCFE4LD1HSan1+JAk979
        zgqp41S3evORpTcblSQASnh1TLRx0LFMuaQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rw-iignjNWsq for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:36:25 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2xd5qYJz1RtVm;
        Wed, 29 Mar 2023 16:36:21 -0700 (PDT)
Message-ID: <329c915b-b49d-491f-80ef-f4c9cdf80600@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:36:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 13/19] zram: use __bio_add_page for adding single page to
 bio
Content-Language: en-US
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
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
 <339841b3b7ce6b2faf56bcaf9d92e298d878ef64.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <339841b3b7ce6b2faf56bcaf9d92e298d878ef64.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The zram writeback code uses bio_add_page() to add a page to a newly
> created bio. bio_add_page() can fail, but the return value is never
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

