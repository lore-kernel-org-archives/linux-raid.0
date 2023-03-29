Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F291C6FD18
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 23:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjC2Xtk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjC2Xti (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 19:49:38 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D917B59D0
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680133777; x=1711669777;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sWeg/sDXtlTL83A5IYwbAyKHpDQ9ojOEouG2K7X3x6k=;
  b=dbIZDTIeEj/t1MefBdT8PHsFN6Sshvo8m5hgfTN/Z917j0Wyf0Z50Zq9
   Kbu9Z3eAqsAGjys5xSOCib6kZtm4ckZXO6dl4zqGovANurD8CPMZPHAuB
   lpQAzAezBVpz8rnIeoZmAksPiWmN9nvXNPupu1HXz2Jv9bw3+NZVph7ON
   Al0QsVQBwYIVRm+cDC/G+DSK+eAndwonlp/IimyVAvYzytSj+OyqcWXtX
   tlCu40h6EixmDzCKnVYjj8A9RlflpI52uWCeT8l2zj4T8v3l1Za9jiDx5
   KmEXZdL5P6Pn9o00IRbHbzD+kczV0oy0+TDm+neIbKU/K433Adh64g+jM
   g==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="225114314"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:49:36 +0800
IronPort-SDR: NQ80C7+VNqmOO4PXh/AXMQ1syH8wbLKxtp1yJDDlR3NN8NYGbDregMcoDztmzkI/FtiRal6V17
 XHcvVotWLdwn9KVZxPfI/NItIWp0DjPXL5dGWbLEvXuhdgmv1B4HR47pX7/FiYgGu4Xgkkh1g+
 1V6dln9u11yYjOXB2LI5EIXHY5BXnSGxK4gtlW5ovyrr6kW0Y3iAXdMtOtSSUSjEX5rUnqbyz9
 3eccSiNgglsYCawWcSBE+JUeoLwf9Xzzax0Jx0F9K0jXkSE5mGCuZQGSlyKC7UosSTDbQHgvwi
 mmk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:05:45 -0700
IronPort-SDR: vbjirbRrwrmegEXaWXpCAqKcEso+e2sUhMyK2D+ToW0bEc3gnFf4kOXr92LA5InvFVZSCMPz0h
 mYD3WJKbLxDe9WHuC0vqJIbOek++1rRmE9ySXsrJ71hk7lZIYpKsk5/Ne1PKB9pTU0dK4/5++X
 An2yVtmMc4T+1sUlFWC30RrFCQrTygoeOGSyrIErn2jpg8Bth6SsDfcWDNtKG+Z53Vvn+Npgu2
 VKyKiwkARQxz051ADWdpYbLDvv4TB+wycYVN+2GzhvyNIhNJ7lLb4ox4E5XS7v3KJh0sBsnH1U
 IRM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:49:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn3Dv5J44z1RtW5
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 16:49:35 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680133774; x=1682725775; bh=sWeg/sDXtlTL83A5IYwbAyKHpDQ9ojOEouG
        2K7X3x6k=; b=eaHQO/5YdYiXFsYm/m2wbzwCkEugBw14d0oKzXplSjZHTHWaRMM
        Rk0oZrO1z2yUn1Hja/n7bNucPqxcM0Cs6MfA2oa5h6VvS/F+VwOLHewkiZbvidXq
        gDXx1HIvRbO67fIYxbiBlENDBGzrGfFDypIQ83l3S9bnFvOFbwL3JmPEG4sD2OTO
        76DtyQ7WNA/kwrwtHL3kwg8jBFayqspuA7w9tm1p7sbrrGBUG1jymW1uO8NTGsZw
        4ntmN9Q3t7uWNfK3ZSSPuOWo7F29Q7SKKF1YRQBAS+5Jpz6sJVj7x+cnUiM+9wnB
        fQ+/Rw2jrr+amC1EN1ET3pZO7+qaPVJ+Smg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ykh3fY2YpVEq for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 16:49:34 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn3Dq22DKz1RtVm;
        Wed, 29 Mar 2023 16:49:31 -0700 (PDT)
Message-ID: <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 08:49:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 18/19] dm-crypt: check if adding pages to clone bio fails
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
 <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 02:06, Johannes Thumshirn wrote:
> Check if adding pages to clone bio fails and if bail out.

Nope. The code retries with direct reclaim until it succeeds. Which is very
suspicious...

> 
> This way we can mark bio_add_pages as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

With the commit message fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

