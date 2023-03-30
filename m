Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6992C77B6D
	for <linux-raid@archiver.kernel.org>; Thu, 30 Mar 2023 00:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjC3AYn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 20:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC3AYl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 20:24:41 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B744ED9
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 17:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680135880; x=1711671880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qt1x7YVxfqzn+HD4mjAgVT20c57AOdxOnsXsCs1FA/w=;
  b=Qn+RYKAZFTZ/InWanaFJ4smXCz1sROJG4KDq+et5xwwuK2lPRSoG2Y0l
   4I8eirbEFxSK9pBEPF72+q4Z/MnIuhczbLmjD5c06jGRFBbgMRxEoelSM
   8zR1Nvjy+ti7feH4fPpaDIIOxyrS+COEoZ+JImEdp6MX9uk5fL6J4k9Q2
   gUewaEG0V5GfYm5eIyw5bV+7nE/rsWvxIETDgUjiUJ0h4WqGsGvJsRwru
   Mby1Vtd2qInmYIaJLniVcXevqr4u+qqSg1Fujtk/EJb51bvSPnFakI/41
   jZsF9LvXqExMZkrJ33dVICkEgUqr6aTH7nTyNFCvUoMAN/5F3KGGkrPLU
   w==;
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; 
   d="scan'208";a="225116489"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 08:24:38 +0800
IronPort-SDR: yXnTYhE/14MFNpBCS/MNvY0J9qXVUy/erlYNiWGthan5XIiAJOkIQfbX31apF5jhb7Im3V8Y4s
 Y6VWUwOhIMy9n5+o0LVt9l+1sE1pCTb9/la3DftY9eqhlG9dwI8Q2XpaMbbVqYOgFygxYy4mQq
 5FsdkM7LrmZKui4ybxeWzU2R5Xrw7JLR3zriwAUwTjhmnb3eWJmN/MZ1pysv5acbbmKNP63Rm+
 q0IwLa63UYQdcjuGeZNbCeNdcRiOwz0j5IR3uoGhu7K7BiNQiD5QmrmyME3+gC+SS1qli2BVBj
 IMA=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 16:40:47 -0700
IronPort-SDR: 9wCLALwpCnWjcxZRF63cMlIakEdXcoQ3zdfsob4A3ilXsKooH/PSmXkmPqVeoPwenrulozJkG1
 Op0NC6EhhR+zYeT+fgNycx9lwzMu9wwO0at2mGxkqWKytzRQ+6M8J2PTZS8TJnF2SRkkKiTXW3
 KDLPVa0FPTzzyAlof7l0uHhMBHQot/zDOOdHXCf72OrzxCjnLlwUJkM4Y3ZNm3EZ2lxBWYXTR6
 5JZr9DXSUxWzTJSr+5qGIIkm8/LlS5EFiRmQuNlpT9qsWYlg96D2RAktoQTdSAkBAUe0iy3GeW
 14E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Mar 2023 17:24:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn41J48QJz1RtW8
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 17:24:36 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680135875; x=1682727876; bh=Qt1x7YVxfqzn+HD4mjAgVT20c57AOdxOnsX
        sCs1FA/w=; b=QYxDsIVMrmX6uf+9bVUxwnELpwLFtWbRMF/Nt94gTpOQqsLyuHo
        PXJiVZbl3870VsxXn8brpbI6uXwWHk7stsw+5gkioY211aQ4o7Uwst47JscjbQrE
        K99N0ESBwKRwcJ19lOavdNixjywODC+7YTyIWnQWpWiZ7LOJA65a1Dktc5vhkT82
        znVNQgKCEILTiX4ZJrtUa8z6RLlEDM8bBMpnfRTy9OPKQbfOM5lFjJG9REul1WDJ
        YusjXPCg9SHR5Djh+zW5IEAVq4UBPEDGxuvLD8JkqpT7PkTcGPvdn28OEWHZvMVg
        2Mi24TQl4Lz1GQlrFjxVXjdvpPxbmdednfA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Zl09Zle02i88 for <linux-raid@vger.kernel.org>;
        Wed, 29 Mar 2023 17:24:35 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn41C5RmQz1RtVm;
        Wed, 29 Mar 2023 17:24:31 -0700 (PDT)
Message-ID: <b19696d3-54bb-d997-5e56-aa5fd58b469f@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 09:24:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 18/19] dm-crypt: check if adding pages to clone bio fails
Content-Language: en-US
To:     Yang Shi <shy828301@gmail.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
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
 <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
 <CAHbLzkoRdTTbnfz3RyLQAeNJBOEVNGL2WLgRSE2eQ4nR8sRe2g@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAHbLzkoRdTTbnfz3RyLQAeNJBOEVNGL2WLgRSE2eQ4nR8sRe2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/23 09:17, Yang Shi wrote:
> On Wed, Mar 29, 2023 at 4:49=E2=80=AFPM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>>
>> On 3/30/23 02:06, Johannes Thumshirn wrote:
>>> Check if adding pages to clone bio fails and if bail out.
>>
>> Nope. The code retries with direct reclaim until it succeeds. Which is=
 very
>> suspicious...
>=20
> It is not related to bio_add_page() failure. It is used to avoid a
> race condition when two processes are depleting the mempool
> simultaneously.
>=20
> IIUC I don't think page merge may happen for dm-crypt, so is
> __bio_add_page() good enough? I'm working on this code too, using
> __bio_add_page() would make my patch easier.

If the BIO was allocated with enough bvecs, we could use that function. B=
ut page
merging reduces overhead, so if it can happen, let's use it.

>=20
>>
>>>
>>> This way we can mark bio_add_pages as __must_check.
>>>
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>
>> With the commit message fixed,
>>
>> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>>
>> --
>> Damien Le Moal
>> Western Digital Research
>>
>>

--=20
Damien Le Moal
Western Digital Research

