Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261BDC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 21 Apr 2022 08:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386804AbiDUIrg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Apr 2022 04:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386834AbiDUIr0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Apr 2022 04:47:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94012183BF
        for <linux-raid@vger.kernel.org>; Thu, 21 Apr 2022 01:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650530676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BjQSABeMSCNqX6QeqXkLKcmoGWtgGGp59tDCHP5J+Ac=;
        b=U9fts13R7ndn+mM5WltAWP9vGtX8uPqwzN4qe28XhLpKToe0z9S2RxHcIYoggIIadZUceo
        sXDFpsohsexiQPZ+C7G1NQEFNa3uNjUzhTSg1N8FH3rVBiUoCb03sK/iy8ku/4hT9Kt9od
        4zAoOAwL2cfmpOjO0mDp42WXCgy/uhw=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-F0Mi4aQrOlmi_9yQNEoVxg-1; Thu, 21 Apr 2022 04:44:35 -0400
X-MC-Unique: F0Mi4aQrOlmi_9yQNEoVxg-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-e2f30da92fso1820230fac.16
        for <linux-raid@vger.kernel.org>; Thu, 21 Apr 2022 01:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjQSABeMSCNqX6QeqXkLKcmoGWtgGGp59tDCHP5J+Ac=;
        b=LIAGYvD3dxD+F9qs9z/1f6Bww2H3IAhPF21rvX/0nF9i2BtzoFrq6OuF7fEQ1qPqK0
         iOtaLe4u0NXMxjilpn4LOYdGI729rcRb5WnrKwbHNXVizcQ+QfI5IYO0Nbev0LGG6Hba
         4yBWW6PluqOmJRuT89qYQSS886tj90eh7DCu0gcbSytaWriHwAYyKPHxjuukezJFURF2
         T+Zk7kW/MzUR/EcNiZ4nSyjHfGG7R4qx8jbd17U+CGNOZNVWhxISWDyeCAQy1XuaEKHE
         qGrXNC5AKm2j9cl87c1EYA52+UdH029YSkUnLD3WsR0ozAwcHH/g4Y2qJymKUvzXk9C3
         e5Gw==
X-Gm-Message-State: AOAM533bTjktNU25dIhARg3ihLfXQyrti5TGnpcgBZfm2W3o7B8yBVub
        vaqgCW7UyZuE5eiH2LF0/BpOdpOoD1dVK/7bOeCHGIVtrZFehxVDhBTA1zGL2qa1Irbr34mdNtw
        82cO6lLRbBl/eYxekR/Q/kGsJ3fqeL7ohnKyLBg==
X-Received: by 2002:a05:6870:2425:b0:de:2fb0:1caa with SMTP id n37-20020a056870242500b000de2fb01caamr3414756oap.115.1650530674560;
        Thu, 21 Apr 2022 01:44:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdqtMEDqqtdXHubsX3CoXNlFqsCvKkohk+MVa9R3FD88YtrXojSCIPXizce5GQSkfV5YslLb64htiFdppcjRU=
X-Received: by 2002:a05:6870:2425:b0:de:2fb0:1caa with SMTP id
 n37-20020a056870242500b000de2fb01caamr3414749oap.115.1650530674370; Thu, 21
 Apr 2022 01:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220420195425.34911-1-logang@deltatee.com>
In-Reply-To: <20220420195425.34911-1-logang@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 21 Apr 2022 16:45:20 +0800
Message-ID: <CALTww28fwNpm0O_jc7-2Xr0JSX9i6F1kgoUQ8m_k6ZgPa1XxXw@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Improve Raid5 Lock Contention
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 21, 2022 at 3:55 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Hi,
>
> This is v2 of this series which addresses Christoph's feedback and
> fixes some bugs. The first posting is at [1]. A git branch is
> available at [2].
>
> --
>
> I've been doing some work trying to improve the bulk write performance
> of raid5 on large systems with fast NVMe drives. The bottleneck appears
> largely to be lock contention on the hash_lock and device_lock. This
> series improves the situation slightly by addressing a couple of low
> hanging fruit ways to take the lock fewer times in the request path.
>
> Patch 9 adjusts how batching works by keeping a reference to the
> previous stripe_head in raid5_make_request(). Under most situtations,
> this removes the need to take the hash_lock in stripe_add_to_batch_list()
> which should reduce the number of times the lock is taken by a factor of
> about 2.
>
> Patch 12 pivots the way raid5_make_request() works. Before the patch, the
> code must find the stripe_head for every 4KB page in the request, so each
> stripe head must be found once for every data disk. The patch changes this
> so that all the data disks can be added to a stripe_head at once and the
> number of times the stripe_head must be found (and thus the number of
> times the hash_lock is taken) should be reduced by a factor roughly equal
> to the number of data disks.
>
> The remaining patches are just cleanup and prep patches for those two
> patches.
>
> Doing apples to apples testing this series on a small VM with 5 ram
> disks, I saw a bandwidth increase of roughly 14% and lock contentions
> on the hash_lock (as reported by lock stat) reduced by more than a factor
> of 5 (though it is still significantly contended).
>
> Testing on larger systems with NVMe drives saw similar small bandwidth
> increases from 3% to 20% depending on the parameters. Oddly small arrays
> had larger gains, likely due to them having lower starting bandwidths; I
> would have expected larger gains with larger arrays (seeing there
> should have been even fewer locks taken in raid5_make_request()).


Hi Logan

Could you share the commands to get the test result (lock contention
and performance)?

Regards
Xiao

