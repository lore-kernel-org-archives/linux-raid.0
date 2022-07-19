Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B2BC43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiGSJZ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbiGSJZz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:25:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B931FCD4;
        Tue, 19 Jul 2022 02:25:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B61341F85D;
        Tue, 19 Jul 2022 09:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658222752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VU8dkFU1OzYVcfW3pXpFFMpVYPltwXeHkZyxcEd7h4s=;
        b=wgyxw2u14vXkA7ntBGytGUBBQhpoJ9uIAMy0LaldM2VN0pZ+0yhSmCkXVn0lLDX5wcm71S
        rwWkxzVfBcRyOAVWLyT1gZ0HXvMzWcvO95u4CATEn3kvOMLS1l9tG4fwbVoD39I9NHjuE6
        xSUQje68u23t8S50qoKRxSHlN+Wfn1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658222752;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VU8dkFU1OzYVcfW3pXpFFMpVYPltwXeHkZyxcEd7h4s=;
        b=CkjoUT+libkSrInzYulRL+ZmuHhJQ/vgbn4GNNxCk6eeB4jIXYrI/kDHTh17y8vOhZLUyu
        QRQmFYyOwBHkAXDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 91DE513A72;
        Tue, 19 Jul 2022 09:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D3a5IqB41mLXZQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 19 Jul 2022 09:25:52 +0000
Message-ID: <03094545-a926-076c-481c-7de5fee5eb8b@suse.de>
Date:   Tue, 19 Jul 2022 11:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 09/10] md: only delete entries from all_mddevs when the
 disk is freed
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220719091824.1064989-1-hch@lst.de>
 <20220719091824.1064989-10-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220719091824.1064989-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 11:18, Christoph Hellwig wrote:
> This ensures device names don't get prematurely reused.  Instead add a
> deleted flag to skip already deleted devices in mddev_get and other
> places that only want to see live mddevs.
> 
> Reported-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++----------------
>   drivers/md/md.h |  2 ++
>   2 files changed, 40 insertions(+), 18 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

