Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A865DC00A5A
	for <linux-raid@archiver.kernel.org>; Tue, 17 Jan 2023 23:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjAQX5T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Jan 2023 18:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjAQX5B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Jan 2023 18:57:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C417ED5D
        for <linux-raid@vger.kernel.org>; Tue, 17 Jan 2023 15:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673996932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hLUhE+N6wNGcOFfTldSYxDCBe/hAkHMsdAmNF17Xymc=;
        b=HXeyKLdve5pTWwYYydsS0ZZuA3CFKnb1jMHBGYNrWA1vvTkF3cVtx45f/oRxrl/pv0FhX1
        AvBlj9s1a1Qn3emjHQ7dnGCqZiM67esmF0Wx7pzxXDqM70k7SVGqCztKP2F06FaTbluzc9
        sZfz4kwt4tOEjWI84c57gqbsFU3YwGY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-503-lUQRsapDOyiYX3KV51OGDA-1; Tue, 17 Jan 2023 18:08:48 -0500
X-MC-Unique: lUQRsapDOyiYX3KV51OGDA-1
Received: by mail-qt1-f197.google.com with SMTP id bp43-20020a05622a1bab00b003b63be6827dso1543003qtb.23
        for <linux-raid@vger.kernel.org>; Tue, 17 Jan 2023 15:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLUhE+N6wNGcOFfTldSYxDCBe/hAkHMsdAmNF17Xymc=;
        b=o5IBIUCp1qKKCLeST735MstISyVB3Frkif0gmvxAaeCIFtgdtUBj59X71yJB4T+NNA
         Nb3+vZlyU3zoGj5/JpS18XctIGCLn2eWDsLc0LPB4tnvJKo+SY8TRdUSz52cFgKcHWze
         RfQKZLUFjMt2UurLY4G9Kjx8wXVBl17wioo+4B3sKNLHn2nyYAbrakBiyPsHoKPvCjIo
         g/DisU+4rWoW1S914IS44EZWpezlQD/dPLoj1clYSFEdkm28VwJj8xebFaAYRbEZaMRe
         uad/tZHZ2J0I+edpwFmzAHNVNEocugu51wFeGx1yIyepabNtezymxMbio5GYhaRRfqaS
         9PrQ==
X-Gm-Message-State: AFqh2kpbq69CWOst+shVhS9tKjZKra4B3DRQqX8YtLGOGqWs1v/mYYxc
        DjWVvQA3uQLtOrk0rqP0JmDP/qU/gD1yUNuom2ZOQOCgL9eBHlDSZybcW9SxNRY6LB43XkJhB6Z
        o1HBH9gtnrMAyGq6D2lZq
X-Received: by 2002:a05:622a:1dc4:b0:3b0:12fc:ff96 with SMTP id bn4-20020a05622a1dc400b003b012fcff96mr5892361qtb.23.1673996928004;
        Tue, 17 Jan 2023 15:08:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs0vPxyl1XT+dxMILItLl3+pLEGdNv9Sv+NcGT7bP7sh98JIs9rjlnuL0rLpT8TgvsCATdexQ==
X-Received: by 2002:a05:622a:1dc4:b0:3b0:12fc:ff96 with SMTP id bn4-20020a05622a1dc400b003b012fcff96mr5892349qtb.23.1673996927779;
        Tue, 17 Jan 2023 15:08:47 -0800 (PST)
Received: from localhost (pool-68-160-145-102.bstnma.fios.verizon.net. [68.160.145.102])
        by smtp.gmail.com with ESMTPSA id p15-20020ac8460f000000b003ae33f9260dsm4659239qtn.49.2023.01.17.15.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 15:08:47 -0800 (PST)
Date:   Tue, 17 Jan 2023 18:08:46 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH rcu v2 06/20] drivers/md: Remove "select SRCU"
Message-ID: <Y8cqfvrfd3pL9ToJ@redhat.com>
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
 <20230113001132.3375334-6-paulmck@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113001132.3375334-6-paulmck@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jan 12 2023 at  7:11P -0500,
Paul E. McKenney <paulmck@kernel.org> wrote:

> Now that the SRCU Kconfig option is unconditionally selected, there is
> no longer any point in selecting it.  Therefore, remove the "select SRCU"
> Kconfig statements.
> 
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: <dm-devel@redhat.com>
> Cc: <linux-raid@vger.kernel.org>
> Reviewed-by: John Ogness <john.ogness@linutronix.de>

Acked-by: Mike Snitzer <snitzer@kernel.org>

