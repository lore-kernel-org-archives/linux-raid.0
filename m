Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F79AC6FA86
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 14:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiIGO7C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 10:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiIGO67 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 10:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5AFA0258
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 07:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662562737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wAgFYn04JWkSi5U/2as7gYF5HiZ1Ev8Ucg8sfjGskc4=;
        b=fn2yOrzPe1nwHVsg+DPChi681oJGuoXNBT3fbRzR0Ic/XDRRNSF8WdqLlO0d+9sfdzBmAM
        RUUUcM9hFsN1ex7GkRAl7Qyo4TOX1d77zBjgP1NYEf8TOyEimxvj3QS98Ln/KLVxpdw65I
        7xX1Q2PmRkDxKQmb8qSym1svA/4Ug8c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-XaJFF-k5O8G3Wajxg5ExDQ-1; Wed, 07 Sep 2022 10:58:54 -0400
X-MC-Unique: XaJFF-k5O8G3Wajxg5ExDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7799E185A7BA;
        Wed,  7 Sep 2022 14:58:53 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0597340CF916;
        Wed,  7 Sep 2022 14:58:46 +0000 (UTC)
Date:   Wed, 7 Sep 2022 22:58:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dusty Mabe <dusty@dustymabe.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>
Subject: Re: regression caused by block: freeze the queue earlier in
 del_gendisk
Message-ID: <YxixoYNB0VTc8Zd+@T590>
References: <017845ae-fbae-70f6-5f9e-29aff2742b8c@dustymabe.com>
 <YxBZ4BBjxvAkvI2A@T590>
 <20220907073324.GB23826@lst.de>
 <YxhYjaA3CrMz5njZ@T590>
 <44ab9f7d-8f00-5f80-210e-f65f02f6fd82@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44ab9f7d-8f00-5f80-210e-f65f02f6fd82@nvidia.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 07, 2022 at 02:40:57PM +0000, Chaitanya Kulkarni wrote:
> Hi all,
> 
> On 9/7/22 01:38, Ming Lei wrote:
> > On Wed, Sep 07, 2022 at 09:33:24AM +0200, Christoph Hellwig wrote:
> >> On Thu, Sep 01, 2022 at 03:06:08PM +0800, Ming Lei wrote:
> >>> It is a bit hard to associate the above commit with reported issue.
> >>
> >> So the messages clearly are about something trying to open a device
> >> that went away at the block layer, but somehow does not get removed
> >> in time by udev (which seems to be a userspace bug in CoreOS).  But
> >> even with that we really should not hang.
> > 
> > The new device should be allocated from md_probe() via blk_request_module(),
> > and the underlying devices are virtio-blk from the fedora BZ2121791.
> > 
> > [1] https://bugzilla.redhat.com/show_bug.cgi?id=2121791
> > 
> > Thanks,
> > Ming
> > 
> 
> It would be really helpful if mdraid experts can write blktests so it
> will get tested in the nightly builds along with other tests with
> different distros.

Can't agree more, and Cc linux-raid and our raid guys.

And looks this one is more related with imsm.


Thanks,
Ming

