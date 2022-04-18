Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A60C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Apr 2022 08:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiDRIDb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Apr 2022 04:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiDRIDa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Apr 2022 04:03:30 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978F5BCB4
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 01:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650268851; x=1681804851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N3pAk4FME4FfpMn1iEoaJawKiDbUT/rSC5t+NXLtpDE=;
  b=EmFD4zOrBedJiKEIfmfQ1sq2WhbOhAyWhx4jqdRtaP7zFeAzX4YP2Wdu
   LV3Xc25w8LgpiONToQ44T9/hcrsVYpaS/nzeKobUWOCFThI+aKpwmAH/p
   7mdS9Lp0hH+U6glnkqDI+7P5kp194PqON6sPoR1MDYK5Lfa1M5oxVVWuh
   2hM19TZuoI5F/l/5yok95L71CSDk553x3NOzGvkGRAtnJxbuj9BZa4Zrd
   GeCPnnW74k2sVmF5/l+ctbA4xvouZKNPh1rn5dVyKP9qqro6m1nYMdqOi
   kHZtAwguknVXBUJ4gTQwvqA3QEC4ZtVoPJ3d4KmGZ+lLef8CCnYbNqLlq
   A==;
X-IronPort-AV: E=Sophos;i="5.90,269,1643644800"; 
   d="scan'208";a="197010064"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 16:00:20 +0800
IronPort-SDR: SPL9S34HkIfidEnFbgslK+I+UJ0LmV5u9Nm4JsX155daJey/Ecn74mhJKllJ4u0X6W0+dgV601
 LPxoF97ifdQJS0F4pc0K7/Iu2wcbwUVVCvQb2aHlP6tZlFM4L7o2yzRxiHFxjZ4iwruREX56b+
 4l+1BTK7IXCYP5a5B8KtZHhfYV4Uv4W1xIim1Y2d5qicYbvC9CAZx/I7Umm9fDYY1F8S7kMae+
 SfL/yzOTPSACPzkI4hrenyyzNZwAbspNgI1gErPLP5121RVV5OGY63YV4GdCUE+jvxIi7XlxWg
 uC2EepExskfMlG46o/dXpNvk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 00:31:27 -0700
IronPort-SDR: F4dWZwNZy680BY4lIgkTXR612pN/i9JNts3VbkC5rjZ07oFd3uSzIQYmOe3Fa2fKS91lxY5ftI
 9ayDx1RJhc7b+GSKSbKNSxvnnHN+BKw5mRVE+aZVJG3s3Rbjh8XtfAaLPxDtm1TX9vO7bHUyUg
 sys1mRwOT27dyXAlhhRE4Hz78agcrxWvDkg74xKP3zc040KeEZHSDr4wmFCjawlhbWdAQUNduB
 JxgTDzQDoDTrc7ZwZbg642pIiXia+ZYGLdTSsD0uv1UaZ9NzQffApO8V5ucNh5a4klOwTyTJJx
 ZUM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 01:00:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhfVp5NHmz1SVp7
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 01:00:18 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650268817; x=1652860818; bh=N3pAk4FME4FfpMn1iEoaJawKiDbUT/rSC5t
        +NXLtpDE=; b=Hv31bX7Jya9kAcbobcM2DbhnrpTGs/GTwAAtUv8vySpoFKQgxRG
        0PYJGfA2dAECZHN+A7jojXX4TPCln72oMy6HJclm/I/vdkiE/jo8YTTeRoyYZsgm
        /8g2jq0kSlmAlmdBaXgVhQugmIYoKJc6VSVmS3/vKZFuOGWdIx3J42PRXZRhj4vT
        4OURB/Cn0/RePkSCzRD3y1jplJh4/R5mHZHD9LVCry/+O2GN9qeH5cwnhqL23+sn
        do6qojLT8/p84Nyj8izFB9vEJu3PN59Q67c1vVF9yFO0YZerzJcoLMqR+oWldmNt
        RJ+7CYGXRuTQNYYhpyJfVv2zpFqW2SwbGxA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3fAWbR2_n6HH for <linux-raid@vger.kernel.org>;
        Mon, 18 Apr 2022 01:00:17 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhfVj0QSXz1Rvlx;
        Mon, 18 Apr 2022 01:00:12 -0700 (PDT)
Message-ID: <fd915a51-035f-d5c6-42a1-c517e3d1f1b1@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 17:00:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [dm-devel] [PATCH 05/11] dm-zoned: don't set the
 discard_alignment queue limit
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
 <20220418045314.360785-6-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220418045314.360785-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/18/22 13:53, Christoph Hellwig wrote:
> The discard_alignment queue limit is named a bit misleading means the
> offset into the block device at which the discard granularity starts.
> Setting it to the discard granularity as done by dm-zoned is mostly
> harmless but also useless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-zoned-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index cac295cc8840e..0ec5d8b9b1a4e 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -1001,7 +1001,7 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	blk_limits_io_min(limits, DMZ_BLOCK_SIZE);
>  	blk_limits_io_opt(limits, DMZ_BLOCK_SIZE);
>  
> -	limits->discard_alignment = DMZ_BLOCK_SIZE;
> +	limits->discard_alignment = 0;
>  	limits->discard_granularity = DMZ_BLOCK_SIZE;
>  	limits->max_discard_sectors = chunk_sectors;
>  	limits->max_hw_discard_sectors = chunk_sectors
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
