Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12D2C77B7C
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 06:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjDXGpu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 02:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjDXGps (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 02:45:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05BB3C00
        for <linux-raid@vger.kernel.org>; Sun, 23 Apr 2023 23:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fMWclc9W7sJg8DTNDvVm040iimkCeaxPZxiAYSxfuf0=; b=Jfjp4/DyB4hq9tPAjmjdGgzP+u
        t62UXImjXvYz4zDM7+8Fo0BpXfsU2hruAl009WG1c8cBbhfY6C9HmxyG0FMqCQNh8NhqAKAqqpUwH
        pg6d6BkVzpETi3k9uBp/LlNQD2H9p7XF5+9LhTm7U++iWDJHfZGOMM5f4omQ+mmGWd/3ZOC1vVkdf
        zxI/3yXNZVvVboJLlEKaBzf0dA8rTApNksC9NHWG7m7wsbSLCKsI7YzLm3BUOe1IpkTq5WaEbXjuH
        HiP28PV3e8ht6+4/M0/SBhP7SvRgQD6QW6+cvoBV9c4vTkHLggZJq3NSDHrPe6zrse8pHqQhG1aPq
        gysfnPMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pqpxF-00FV3N-0C;
        Mon, 24 Apr 2023 06:45:41 +0000
Date:   Sun, 23 Apr 2023 23:45:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Song Liu <song@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-raid@vger.kernel.org, David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
Message-ID: <ZEYllY6ZHZX+q9ZC@infradead.org>
References: <20230417171537.17899-1-jack@suse.cz>
 <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
 <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
 <20230420112613.l5wyzi7ran556pum@quack3>
 <c5830dd8-57c5-0d94-a48d-d85f154607e0@deltatee.com>
 <CAPhsuW5aaaTL1Ed-wKb82DKSSqg+ckC0MboaOLSUuaiGmTYTuA@mail.gmail.com>
 <e6343cab-01e3-77da-8380-137703344768@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6343cab-01e3-77da-8380-137703344768@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 20, 2023 at 02:10:02PM -0600, Logan Gunthorpe wrote:
> > I am hoping to make raid5_make_request() a little faster for non-rotational
> > devices. We may not easily observe a difference in performance, but things
> > add up. Does this make sense?
> 
> I guess. But without a performance test that shows that it makes an
> improvement, I'm hesitant about that. It could also be that it helps a
> tiny bit for non-rotational disks, but we just don't know.
> 
> Unfortunately, I don't have the time right now to do these performance
> tests.

FYI, SSDs in general do prefer sequential write streams.  For most you
won't see a different in write performance itself, but it will help with
reducing GC overhead later on.
