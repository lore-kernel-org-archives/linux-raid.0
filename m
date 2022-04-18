Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E467DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Apr 2022 08:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiDRIFG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Apr 2022 04:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiDRIE6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Apr 2022 04:04:58 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA4A1929F
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 01:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650268939; x=1681804939;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OmPuKz2YWA8zfnI8UisdXu/UB5gIbMI/eeJtu4mrOgE=;
  b=p0xY5S0T0JgjOSfJ6zjDadK8ztzKLMBXPaLjkv7NnFCp9B1V0JXOfKKL
   +uhhmfC1W+shZPp9Yd58Bfx2NiPVhiHu/TPnkXRW5VwY8XRMBThf19dcu
   muR3BkMhS7lWScBe3yNRzmMhjybeERQ2Tsh/x6/v0St/n5QHXMaAkbIAL
   SQAXncI5AYOdOBh16CpjzZN8AI/TOQTqwrcT3cgd8kbWgAYAIhok+jcfn
   emQvF0QTEy8jlJI0tPmOnmb7JEq/6vpRbzjy/8xXiwji/0rHx+UsYNkKy
   FyFHeMzzkAqFxxT5f8xJ67/QPouCzx2Qo1ZWrnhddzRXIYnwTut9qSXaX
   A==;
X-IronPort-AV: E=Sophos;i="5.90,269,1643644800"; 
   d="scan'208";a="310120098"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 16:02:18 +0800
IronPort-SDR: v11N4nmTH+aj4jQbV217mK4LHRwYMbJUiHWQKfAhem5bvISM1mFoRB34r+JwVyaGnp7JRkm7Xy
 /u8u7TDkQ23ccLP4LsmDI7khDoY2tmeOWpIZOuP6hkT/wXykAX2AmumAHFkGtmBKYuFI6MVnVF
 jrI9XfLDbt8APmoHSfhJPNE5wk3yk86LImeewnpPa7F3JGhCaTtnCDM0iKuuFiEbSIJ5j7XyKQ
 7+r3X0oqgkqb0A24KP+85ak+aAk9GTNZkEYVS2BWzA1wHd4CWuT+91z5DDPGXNeaRXbMe8vcmJ
 WvxSBDisnI+IpPnN4dku1qxX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 00:33:27 -0700
IronPort-SDR: ko8EK+SmJs17oTzWmewIRc8oRJbjFVcu2BHJdPVvX/HDE+rI2/X/kEIz4tDp/mACuoiR21SjF9
 XkOQ/pWiF2nQw+/NWMIQ/S6ss5uAOCw4ihKZmyVi/EyTNxIddOXn4UuGnRGICk3KB5Y10ZlVVK
 69FuOh66HHfcUl3ClMKW6G2IufIhAHk1kFevU88BXzMaK84gYgRTgf1XHIYnuXpqeUIuwQrCm0
 ZLP2a16wCJFmiJ2OHlme3wFb6gxS78eSvlJ+Z1fmpnxXtyuej4SO73q2ut+mmcaqg8e4YvT7t0
 lSQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 01:02:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhfY72SLxz1Rwrw
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 01:02:18 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650268937; x=1652860938; bh=OmPuKz2YWA8zfnI8UisdXu/UB5gIbMI/eeJ
        tu4mrOgE=; b=iq/DZtxIsH78J5+wxR20C/juR8srBcWxSV3ywtDv3tYOwTkL3uf
        A4HxBcRKotnvWTD1KOdCakjP9CBAMXOHFJQO+gW4W6NrXUdaQZyeATpC3vgDmC2/
        b6aR8MWIxQbBtWd1k4bmN29Kj9j2x8zQll9Nsvat1LryPuatUaKeqt6IZHWw7oia
        bqBLagLvqtOUd2viud2b+TaA8azo8Z+FIKRDbpTaA5wl7IVqak3jDSz781qRatoX
        CTPLw/8uTXPPOE41sDbbehCUr8tIW9Z/uhgJpZu1tDB8tDKbjkbWp6PdcoxYla18
        GMXcdKSGpAk9WAmZJwmUHgxuVE+HqnZ5TbA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dUA0lSYa26yy for <linux-raid@vger.kernel.org>;
        Mon, 18 Apr 2022 01:02:17 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhfY24GYPz1Rvlx;
        Mon, 18 Apr 2022 01:02:14 -0700 (PDT)
Message-ID: <cd77bfd9-e133-1929-2d61-73822ad95366@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 17:02:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [dm-devel] [PATCH 09/11] nvme: remove a spurious clear of
 discard_alignment
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        linux-nvme@lists.infradead.org,
        virtualization@lists.linux-foundation.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, linux-s390@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        xen-devel@lists.xenproject.org, linux-um@lists.infradead.org,
        Mike Snitzer <snitzer@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
        linux-block@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        linux-raid@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-10-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220418045314.360785-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/18/22 13:53, Christoph Hellwig wrote:
> The nvme driver never sets a discard_alignment, so it also doens't need
> to clear it to zero.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index b9b0fbde97c80..76a9ccd5d064a 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -1628,7 +1628,6 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
>  	BUILD_BUG_ON(PAGE_SIZE / sizeof(struct nvme_dsm_range) <
>  			NVME_DSM_MAX_RANGES);
>  
> -	queue->limits.discard_alignment = 0;
>  	queue->limits.discard_granularity = size;
>  
>  	/* If discard is already enabled, don't reset queue limits */

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
