Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BF0C77B7D
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBXQGX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjBXQGU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:06:20 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF24C584A8
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:06:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7F25560A30;
        Fri, 24 Feb 2023 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0X2+PVIUMAf5rhezb30SERddXfmf2j82i4XpyArmYhk=;
        b=fn1lX+1z7NDtjsMFZMzytKpes/goRZVQ7Eqm8g9ToX+wJVQat79mMt16ebHTWKdaPJcowB
        kc/XMc7m4oWNKgag/LWkhou2pWehovDiTE2rFEnRdNtBOIMMyGYine7UjcjnTXZaa9q1mo
        LewnUV1eS0NZ3FROssdGcYEivfN8GIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254778;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0X2+PVIUMAf5rhezb30SERddXfmf2j82i4XpyArmYhk=;
        b=v7c45l3Zt5LjErI0zs2JZvybw6t0uN0uHKNouC9LQEEApidus7/DCdxZpi/ltMjTZ+FT2o
        eR9RPqTkp6kIHKAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E104C13A3A;
        Fri, 24 Feb 2023 16:06:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sJdQK3fg+GPhJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:06:15 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 6/7] tests/00raid5-zero: Introduce test to
 exercise --write-zeros.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-7-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:06:05 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <22300B92-714E-4CA8-8E33-C6A37E3466E0@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-7-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:53PM -0700, Logan Gunthorpe wrote:
> Attempt to create a raid5 array with --write-zeros. If it is successful
> check the array to ensure it is in sync.
> 
> If it is unsuccessful and an unsupported error is printed, skip the
> test.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
> tests/00raid5-zero | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
> create mode 100644 tests/00raid5-zero
> 
> diff --git a/tests/00raid5-zero b/tests/00raid5-zero
> new file mode 100644
> index 000000000000..7d0f05a12539
> --- /dev/null
> +++ b/tests/00raid5-zero
> @@ -0,0 +1,12 @@
> +
> +if mdadm -CfR $md0 -l 5 -n3 $dev0 $dev1 $dev2 --write-zeroes ; then
> +  check nosync
> +  echo check > /sys/block/md0/md/sync_action;
> +  check wait
> +elif grep "zeroing [^ ]* failed: Operation not supported" \
> +     $targetdir/stderr; then
> +  echo "write-zeros not supported, skipping"
> +else
> +  echo >&2 "ERROR: mdadm return failure without not supported message"
> +  exit 1
> +fi
> -- 
> 2.30.2
> 

-- 
Coly Li
