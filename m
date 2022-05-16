Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE3DC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 14:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiEPO2P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 10:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiEPO2N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 10:28:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895013B2A7
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 07:28:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3A0A61F383;
        Mon, 16 May 2022 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652711291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oaKnbx/xu9eMRGlPWJxmHREQg55kifW5Ek7rL7s2h4U=;
        b=nFhgxKpbQVgsKxTykZbs6vx9wbChFMMeRF4QUvnVgcuLlxnfbvJORnqTqlurPwpTRJdSIi
        x0XV+cYFy9wyzdXqCThyyqova2BaTUCE9u6O8NgxX69gm2K6ftuD6+jM0iGChb+lyKHLey
        vcp6A4v740MuDFoVUh9qeKCSz5sAp/Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652711291;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oaKnbx/xu9eMRGlPWJxmHREQg55kifW5Ek7rL7s2h4U=;
        b=KD0IJvzVhe/2y6VYZSBcox2g50MJCiUKJeQnfyyyEwbdkiTDJAObdqVS8xtNqLGcgAmaK5
        yOhGZO4BVFA6SUAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AAA8D13AAB;
        Mon, 16 May 2022 14:28:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id njksHHlfgmLvGAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 16 May 2022 14:28:09 +0000
Message-ID: <8da1af28-5ecf-6781-7428-826f630fac42@suse.de>
Date:   Mon, 16 May 2022 22:28:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: mdadm test suite improvements
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20220516160941.00004e83@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>,
        Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220516160941.00004e83@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/16/22 10:09 PM, Mariusz Tkaczyk wrote:
> Hello All,
> I'm working on names handling in mdadm and I need to add some new test to
> the mdadm scope - to verify that it is working as desired.
> Bash is not best choice for testing and in current form, our tests are not
> friendly for developers. I would like to introduce another python based test
> scope and add it to repository. I will integrate it with current framework.
>
> I can see that currently test are not well used and they aren't often updated.
> I want to bring new life to them. Adopting more modern approach seems to be good
> start point.
> Any thoughts?


Hi Mariusz,

Yes IMHO python is more ideal than bash. Personally I am supportive to 
this idea.

Thanks.

Coly Li


