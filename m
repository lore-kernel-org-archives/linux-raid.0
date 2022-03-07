Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7762C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  7 Mar 2022 16:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiCGQ5X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Mar 2022 11:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiCGQ5W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Mar 2022 11:57:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F83C7E097
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 08:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646672187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GKvX1sl7p58ECEtwztu/8ZgveUC73k+ES14SIrLarpQ=;
        b=eA8BHRsaBl1CBRisaXrIJOluFFLgl7mvVmqgUGwhUNZjdNSOT8paZzDxRW0m0gBKnnz8Fb
        M0jFlOHeCLX87qcxtLIex9QZgfsrpMMgemNkbUXbDrpMtW4dlClOq9wl1HZSVELdxwmyQT
        543dR55uEnhfuydgDkOfBMkloeW8RSY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-mx6IRnCEPFSGwgFUMfwp6g-1; Mon, 07 Mar 2022 11:56:26 -0500
X-MC-Unique: mx6IRnCEPFSGwgFUMfwp6g-1
Received: by mail-qv1-f72.google.com with SMTP id w7-20020a0ce107000000b0043512c55ecaso13424372qvk.11
        for <linux-raid@vger.kernel.org>; Mon, 07 Mar 2022 08:56:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GKvX1sl7p58ECEtwztu/8ZgveUC73k+ES14SIrLarpQ=;
        b=Cgn71qI6AG3dEkzz4lgY4QjeLOZt3GB+x03tyJ7bX6Zu6fZoDDKGKLt9JKwozvVJu5
         PgJYr8uk9nmumdW7EB6kqI7WmCE7C3lhZz1iGQkVFevf4vqO0NhzLfbuFbjdOGbBAHy5
         v+fQWowjfNiPAxQM5DlS9I3gdAjofbukJzIdS8FCecUyRJEw/2u8NaoU2PFJiVyd+YgZ
         e8mlAcK6KZdXXFx4yi1ic0boTXu84bb9Su7DpzOA1pHOoAB58sBsd+7rQGvlZ/zK6XXr
         ID1MOKH2/xJb0yZloIkmx/Z2/6PZU6vSdbaOi/STiW98yYK+k+N+qBnRVk9kLIFIQHTA
         zLJg==
X-Gm-Message-State: AOAM532MyaMJRFeMjvQgM05PgSF+TMvgLzq7w0wduWEdMZSs4kATcR28
        XkF/gZbJgZzW6MGodBxjunVKfZhcfrTB7VDqhMFiFsMxwekU1XYzUSFsAIajeq6o2REGVB3Jmwh
        jdiGIHY9zvHDmatkVg+Wj
X-Received: by 2002:a37:e303:0:b0:47b:b0e1:fc3f with SMTP id y3-20020a37e303000000b0047bb0e1fc3fmr7411354qki.108.1646672185821;
        Mon, 07 Mar 2022 08:56:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgimeaJmCviuje97Vzy/Bu8ddKoAbj4Lj2WFLdHhsuRx8YeCO+5ZEp3hBleQ9OYyyKUFJxWg==
X-Received: by 2002:a37:e303:0:b0:47b:b0e1:fc3f with SMTP id y3-20020a37e303000000b0047bb0e1fc3fmr7411341qki.108.1646672185573;
        Mon, 07 Mar 2022 08:56:25 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm9086902qtk.8.2022.03.07.08.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 08:56:25 -0800 (PST)
Date:   Mon, 7 Mar 2022 11:56:24 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Song Liu <song@kernel.org>
Subject: Re: remove bio_devname
Message-ID: <YiY5OLhi1WMFUgGH@redhat.com>
References: <20220304180105.409765-1-hch@lst.de>
 <164666057398.15541.7415780807920631127.b4-ty@kernel.dk>
 <YiY2wUVIz3NXIjlc@redhat.com>
 <20220307164814.GA12591@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307164814.GA12591@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Mar 07 2022 at 11:48P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Mar 07, 2022 at 11:45:53AM -0500, Mike Snitzer wrote:
> > Should those go through block too? Or is there no plan to remove
> > bdevname()?
> 
> My preference would be:  do the full bio_devname removal through Jens'
> tree and you keep the bvdevname removal.  I hope bdevname will go away
> as well, but certainly not in this merge window.

OK, sounds good. Thanks

