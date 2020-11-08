Return-Path: <SRS0=e7iu=EO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F62C4742C
	for <linux-raid@archiver.kernel.org>; Sun,  8 Nov 2020 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDAD1206F9
	for <linux-raid@archiver.kernel.org>; Sun,  8 Nov 2020 15:15:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="REGghAwv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgKHPPM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Nov 2020 10:15:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728311AbgKHPPM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 Nov 2020 10:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604848510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCiEM7AQz5QZ2RvY5C0nr85g19BsqN3bEHGGJWjun8g=;
        b=REGghAwvDG700XxvFoEua2gT/PxE7PR+OMgmuToJtos0TbUsFc02pLoUFyg5u9TQ6GTd0A
        n2qVLz8dMOc4QT5AipGmGCRZLazwmkyyRNOI5YOh3w3XFNLLFv4FhPz+BkhcnUxXhI8aJz
        0KdtWMnG4Kk3tZ5ava30mnW7p3HOdPk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-ebpWZvdLOs-mpNinJlw1mA-1; Sun, 08 Nov 2020 10:15:09 -0500
X-MC-Unique: ebpWZvdLOs-mpNinJlw1mA-1
Received: by mail-wr1-f71.google.com with SMTP id j15so3066594wrd.16
        for <linux-raid@vger.kernel.org>; Sun, 08 Nov 2020 07:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xCiEM7AQz5QZ2RvY5C0nr85g19BsqN3bEHGGJWjun8g=;
        b=RXtUMquGl0L8PXOzQc6xiUVcxKLtafWePPBL+pS8CA6UK/GGRsNDry0ZH9ii8iJw4l
         nRCrRtnD+UtE+3URaz8UIqvPNPlhxMdYrTvmNrYf2DnHWsKvNOmfsz6BQyww5GtQmuoL
         wJWPQQsIuJu5Hp1F33/fu9/YZfC8HE7FBriyPsmF9IGFE7sEpWOQMWdiZ5trks6PzQP+
         uc1Q6traZT7oJ9Pn1EWkiK1W0sV9XoC7ZviphhzmqP95jEL0bMIKgJz3yjgvh5EeLHx1
         Zl8QsiVb8UYZ5cQWk00mhjkzWe1ENa9KnaocZYXePpIf/wWa1oyFugxi8UJoXTvCP+jD
         lzow==
X-Gm-Message-State: AOAM530/04DrmmwwsSl0xX+kucOQH2KxZH0XZvnHTJM7X4VvwuzrfYhw
        LnxYXTCFyOmvI6hSp1LjNL5UPujyV2HhDiggZ/Gav2wk0t5ymn5nKz2ojAfN4FlxVP7DuPWtpsg
        Q0qkz72kv+gokoECHQFYSUQ==
X-Received: by 2002:a1c:80d3:: with SMTP id b202mr10142618wmd.139.1604848507886;
        Sun, 08 Nov 2020 07:15:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBz6wtcRAgwxrEGiAL8ElHcOzDdD7qQjz/7QuIFGOGrDkKJazoMrCqH8844xWODBZg8NNGyg==
X-Received: by 2002:a1c:80d3:: with SMTP id b202mr10142589wmd.139.1604848507695;
        Sun, 08 Nov 2020 07:15:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l3sm11508325wmg.32.2020.11.08.07.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 07:15:06 -0800 (PST)
Subject: Re: [PATCH 23/24] virtio-blk: remove a spurious call to
 revalidate_disk_size
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20201106190337.1973127-1-hch@lst.de>
 <20201106190337.1973127-24-hch@lst.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d23bd50a-7555-438b-9e3b-131414b2d1a5@redhat.com>
Date:   Sun, 8 Nov 2020 16:15:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106190337.1973127-24-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06/11/20 20:03, Christoph Hellwig wrote:
> revalidate_disk_size just updates the block device size from the disk 
> size. Thus calling it from revalidate_disk_size doesn't actually do 

s/revalidate_disk_size/virtblk_update_cache_mode/

> anything.

