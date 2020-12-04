Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA89C433FE
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 10:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219BD22519
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 10:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgLDKec (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbgLDKec (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Dec 2020 05:34:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D3BC0613D1;
        Fri,  4 Dec 2020 02:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z4RxJ3lOSf3eG4bi7IMzxDt9+2ZdQf43ibMQAm5S5Cs=; b=NfDRc7jAkWAZV7HxvQycJbxxwU
        MwxwTmRFOXnQ/I7U03uMlUr1gihelQ0GWLdiUp63iF+2zEHep2wIxxgpaJOAbS8VSlWXWfsFQAb3u
        ng7ZJVP6LTB01hxBMvfG5ABRMrvBqL+Zp16RiGXEP6QL3/RwyTpIf7b5qqIQ14SA7NBqCK+2EaXgr
        MPy3NUVs/UpL8esdYQ9ZpYT2aMWF5lt7kerOtdy1BUU+4Ki8ewX+YX1MtoqOqEkO/Y5KJnkYMuZ9l
        Sa7irtV0l9SkW2YwCW7fy6OtFTO8x6ECH1hez8fi49JV4+zuDVR2gdx6TzJv/7WjVr8EUOXFMSX35
        VUstmX5w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl8PA-000230-Ol; Fri, 04 Dec 2020 10:33:36 +0000
Date:   Fri, 4 Dec 2020 10:33:36 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com,
        corbet@lwn.net, song@kernel.org,
        Palmer Dabbelt <palmerdabbelt@google.com>, shuah@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v1 0/5] dm: dm-user: New target that proxies BIOs to
 userspace
Message-ID: <20201204103336.GA7374@infradead.org>
References: <20201203215859.2719888-1-palmer@dabbelt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203215859.2719888-1-palmer@dabbelt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

What is the advantage over simply using nbd?
