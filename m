Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473F3C74A5B
	for <linux-raid@archiver.kernel.org>; Tue, 21 Mar 2023 09:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCUJV4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Mar 2023 05:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUJVz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Mar 2023 05:21:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928F583F3
        for <linux-raid@vger.kernel.org>; Tue, 21 Mar 2023 02:21:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4A7071FD6C;
        Tue, 21 Mar 2023 09:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679390512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V+naUt3pY0QEC8rW+scDPoCxDa38Z6I/uVdE85sIZLA=;
        b=uQH4GNbMbj+vshvRcCYhHqa6CLUqbdaBqRKtBa6oB1F5Wx55xTq9K26o6k2szQCnZMbQ3S
        k4MViXlLRTUlT3yQFpcUjjQpgdDeCo+8j4ERbkdhkWS9X+tlNu+2oR1pLC6/D51N7ej2Rd
        QJ9BEjiK163y7zEzVFWE4UnFRJ1msiA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 03F4213451;
        Tue, 21 Mar 2023 09:21:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /TzLOi93GWTNAgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 21 Mar 2023 09:21:51 +0000
Message-ID: <9115e7943113fc01cc4c197b2b2641617fdd4919.camel@suse.com>
Subject: Re: [PATCH] Fix race of "mdadm --add" and "mdadm --incremental"
From:   Martin Wilck <mwilck@suse.com>
To:     Li Xiaokeng <lixiaokeng@huawei.com>, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, colyli@suse.de, linux-raid@vger.kernel.org
Cc:     miaoguanqin@huawei.com, louhongxiang@huawei.com
Date:   Tue, 21 Mar 2023 10:21:51 +0100
In-Reply-To: <20230321085500.867948-1-lixiaokeng@huawei.com>
References: <20230321085500.867948-1-lixiaokeng@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 2023-03-21 at 16:55 +0800, Li Xiaokeng wrote:
> From: lixiaokeng <lixiaokeng@huawei.com>
>=20
> When we add a new disk to a raid, it may return -EBUSY.
>=20
> The main process of --add:
> 1. dev_open
> 2. store_super1(st, di->fd) in write_init_super1
> 3. fsync(di->fd) in write_init_super1
> 4. close(di->fd)
> 5. ioctl(ADD_NEW_DISK)
>=20
> However, there will be some udev(change) event after step4. Then
> "/usr/sbin/mdadm --incremental ..." will be run, and the new disk
> will be add to md device. After that, ioctl will return -EBUSY.
>=20
> Here we add map_lock before write_init_super in "mdadm --add"
> to fix this race.
>=20
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>

As noted in the previous thread about the topic, this will only help
if "mdadm -I" quits when it can't lock the device. Or am I overlooking
something?

Martin

