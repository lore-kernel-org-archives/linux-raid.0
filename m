Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A535C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 01:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiFXBBd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 21:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiFXBBb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 21:01:31 -0400
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 18:01:28 PDT
Received: from box.sotapeli.fi (sotapeli.fi [37.59.98.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB222515BE;
        Thu, 23 Jun 2022 18:01:28 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 834D483372;
        Fri, 24 Jun 2022 02:55:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1656032150; h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=7t9C+2pQUbBl1eXiPJLnxXEnRjMR6voVBZjRrkVy2j8=;
        b=Fq92yFHUy7V/vF3MOnusdXKyGmhVKNFnxhQJisqnKtQOOV1YH25rJxP/ZL9nCFPYOpKTda
        ggzDj6qFO5fnYizrHSUEUewC2kkN0zihKVKEm9KI4BA9jE+c2p/ce2XlzymVrQem8qyn02
        NhrxiY/QfsBFBjxMj2Rv7MB0AzKJ0iBVWc3FYkYKs5w0uE+aNVL9Q5zbWmtbCpbKYESwYS
        m63pXlNZs+ZtLc+GHg+pDHyWucRz601d/ZqNmBWB+9cVuixcLpkQA6HXFdERMblypTozvo
        fvf67r0LDHto3ddGK8w2/afd05HVWPTzfLwkKAmgbaAiGFsa26/B8C4RZH+Miw==
Message-ID: <8e682742-60b0-1820-7887-952b0963c783@sotapeli.fi>
Date:   Fri, 24 Jun 2022 03:55:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: About the md-bitmap behavior
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Song Liu <song@kernel.org>
Cc:     NeilBrown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
 <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
 <165593717589.4786.11549155199368866575@noble.neil.brown.name>
 <a09d6a24-6e1a-0243-ea4c-ac6d6127b69d@gmx.com>
 <CAPhsuW5iYWPkSyjqU0VUM-y+aQyFW6SkQXdjinu9ayz3DigcxA@mail.gmail.com>
 <6a2d3909-edb1-96e8-4a29-d954a2ebdaef@gmx.com>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <6a2d3909-edb1-96e8-4a29-d954a2ebdaef@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Qu Wenruo kirjoitti 23/06/2022 klo 7.52:
> That makes sense, but that also means the extent allocator needs extra
> info, not just which space is available.
>
> And there would make ENOSPC handling even more challenging, what if we
> have no space left but only partially written stripes?
>
> There are some ideas, like extra layer for RAID56 to do extra mapping
> between logical address to physical address, but I'm not yet confident
> if we will see new (and even more complex) challenges going that path.

Isn't there already in btrfs system in place for ENOSPC situation? You 
just add some space temporaly? Thats what I remember when I was playing 
around with different situations with btrfs.
For me bigger issue with btrfs raid56 is the fact that scrub is very 
very slow. That should be one of the top priority to solve.

// JiiPee
