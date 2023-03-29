Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF84C74A5B
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjC2XhS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjC2XhD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:37:03 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4075257
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680133022; x=1711669022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D+aEMixN3+lt/Ao/5W/66ZnjrxKALm8DtG5/s/spqgo=;
  b=k/FQyrwkhBg9+B+grtGXItx2jC4/rss+hE4m21YtoKiGZ6X0V5uDdHKa
   NL0iXrfuQtOs2bmZfYKlHXHYetyPkIrDGVFeisCBU1k8aLAg9uBYkNrQV
   U4KphdXs6N0BvC48sCXNLLeyzKdukmIWmygpdjZi9AgFugKIbDZc/F6yh
   2PjrnQHLZGZWNoi655Ogtsh8v2BqYcKAlghPKYH2gmdA/LZU2jfAeUWOS
   TEMkgZUOj79V+3gFcGm0bRNThXUgrtaizdbLZAdwNI6ZFmi3krgRWVmch
   1yaqRqg0fpoSpOqVujG/ZR7vmPMzWegzriPWZmc3TrkgN7mk+f6sqQkCt
   A==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="225113835"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:37:01 +0800
IronPort-SDR: uU6YZylZlT76qnW45st5JbOlzydnfyOvOWxiCGjqEJ3J2zeLObT/u7uy918X0ZW2C7oHXfk3JJ
 YL8exIWCLPWxgnDTu1zr1agrZbpGCk72rFD1zuH60kNqSn5qfgxrwRXsbH+cdH2FXFqzK/jLQS
 zeuzYKiHwE+3Oj+6eWriNXyahHUWuiHCFxRZSs9jzMyCmk7Bbj0idr257CKSBb6W2B2sByM4rG
 gv9NsfZ2cTuITR++wxRtsh24pDDuCpVXDc0G/mYbt8w9jjP9TtGc1+p/u3DNXo82JXQRQ0Lozr
 BI0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 15:47:29 -0700
IronPort-SDR: 9JkZUJmSeXqPOuBFcovq6nu7e5XDe2rrpbUELcYmT/CnfAa4Ik53igiIp/j3xIfsdBgLNGoAmi
 joBgyEMUtjM9dw4abo0w98oOd/qEd2tMpdBiFw+0FYcqzZ9Vlce53mvnsX/2Pxkb+dixfKFbGn
 qLQLyh5htDK5SOqRHIelShiZ7AdFyXsVaktPgsnsl/zS1nbqQfjSOAN2hCcfRhRo+uxc7GqE6z
 rqJ3fvqaZ+HblObxyzjLMiqK6phTxdjKacj2/D46fRETuie3DCW/U1asU/J2jM2JW2j6PdvZlz
 jxk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:37:02 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2yP3LbGz1RtW2
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:37:01 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680133020; x=1682725021; bh=D+aEMixN3+lt/Ao/5W/66ZnjrxKALm8DtG5
        /s/spqgo=; b=BEfOkYGGZfGNwIpK9BEJ0FcFAcVLpJnvJCRHtqvX1ZSykJX+oaz
        TiKbQqo/rlFcgsGqwufvYk8MIKGTrAb9+RSsrJd3SZRo35htZKTw14P+p/eD7q/J
        ceqYnoioxpQ1yuPl8XxWYNWTguv/974yBA9klFhcKgFSo99Ul+ebGjc2RjgypZF9
        Edw+QnL+wy8s1G7+GYq/bnFol1i1bpAhLPRysri8L0LJfnjE4aU2+znrrOFBtHLe
        kPJoBqaYr+hUOYgCZHb6OjFE3dVfncY3OnznL/HrXrJLgp+49NV58WitEWdLbK+H
        SGYLaXAVc//3j4H7s6ktsYfZi2PJTJuLWOw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EWJ661DOLM1z for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:37:00 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2yK4J91z1RtVm;
        Wed, 29 Mar 2023 16:36:57 -0700 (PDT)
Message-ID: <1027d62b-d09f-e9fb-b8fb-9876fda97f82@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:36:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 14/19] floppy: use __bio_add_page for adding single page
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
 <aeff063d2f56092df8cae0a6e9c1a8e771994407.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <aeff063d2f56092df8cae0a6e9c1a8e771994407.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:06, Johannes Thumshirn wrote:
> The floppy code uses bio_add_page() to add a page to a newly created bio.
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

