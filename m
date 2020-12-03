Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4BEC83012
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 06:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FF0206F9
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 06:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgLCGlf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:41:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgLCGle (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 01:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606977608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4a+ZpQmjLgoV6jCwYnyDxtAMBa2ORCm8AqUKIqPXkLU=;
        b=TNOg+tW5w6bLytas0nSPWClyY/6LwEw+YxX6eGXqK1YNB/lYtTWxP8JyD6ekoEQNi4WdG1
        Ie0gvSaUGR/xLwQ1zAKeam+ud4/vOm20eDNF69VymJP2qPtWxdAKufh3FIgjPmmwFuRjND
        VDM37lko99uPbQRKRHXAMYdAKh7QprQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-jcc9ZzulNrKGkc15zcOW0Q-1; Thu, 03 Dec 2020 01:40:06 -0500
X-MC-Unique: jcc9ZzulNrKGkc15zcOW0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB5018030D5;
        Thu,  3 Dec 2020 06:40:04 +0000 (UTC)
Received: from T590 (ovpn-13-173.pek2.redhat.com [10.72.13.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C920C1A890;
        Thu,  3 Dec 2020 06:39:51 +0000 (UTC)
Date:   Thu, 3 Dec 2020 14:39:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/9] block: store a block_device pointer in struct bio
Message-ID: <20201203063941.GA629758@T590>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> Replace the gendisk pointer in struct bio with a pointer to the newly
> improved struct block device.  From that the gendisk can be trivially
> accessed with an extra indirection, but it also allows to directly
> look up all information related to partition remapping.

The extra indirection is often done in fast path, so just wondering why
you don't consider to embed gendisk into block_device? Then the extra
indirection can be avoided.


Thanks,
Ming

