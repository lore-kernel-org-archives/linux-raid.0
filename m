Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD23C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 01:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbhLIBV4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 20:21:56 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47276 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhLIBVz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Dec 2021 20:21:55 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9DF53212C3;
        Thu,  9 Dec 2021 01:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639012701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/M3hGUlN6jU/CGhnH3QquTIFR1JAJpFQV7veANVKsI=;
        b=ecwILejSWXYt1AGKJl8ZVgp3sEZajwOuYr62Bwxny6Cy5U5CUnAhfmnqLg+h+Mh76FY2tb
        5BbS4Av5MvLvJNEDlEa+yycy3tDjoxGQS8ordA+ZTwdcW37l2soNa373gw9YoRnTdOu6/5
        JHJ/C8b4bZ2Wx8K3ot1BsxD65P2ajkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639012701;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/M3hGUlN6jU/CGhnH3QquTIFR1JAJpFQV7veANVKsI=;
        b=CVD6T5GwKSyf6KL/9ZzS8wFGR+4OxqfW+h2frM1YWkUeszvC2/dIx4W8GEXxGFpuhQyFQw
        da1e4gsW+KjzwQBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C241913C73;
        Thu,  9 Dec 2021 01:18:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LEA9JVxZsWFGOgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 09 Dec 2021 01:18:20 +0000
Message-ID: <0cb02d8d-e74a-19e7-09df-09553397f4d5@suse.de>
Date:   Thu, 9 Dec 2021 09:18:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3] Monitor: print message before quit for no array to
 monitor
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     George Gkioulis <ggkioulis@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20210902073220.19177-1-colyli@suse.de>
 <c9e5b8af-1a1d-82c0-1ca0-af4bd1182d75@suse.de>
 <46d238f5-0757-b876-4a41-6f89605b7d8a@trained-monkey.org>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <46d238f5-0757-b876-4a41-6f89605b7d8a@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/8/21 10:45 PM, Jes Sorensen wrote:

Hi Jes,

> Hi Coly,
>
> Didn't see this one as it was only copied to my work email. Sorry.

It should be my fault, I didn't notice that jes@trained-monkey.org was 
the proper email address :-)

> Applied!
>

Thanks. I will post patches to the trained-monkey.org address in future.

Coly Li
