Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639DCC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 17:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbiEaRxM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 13:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346715AbiEaRxK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 13:53:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C5064BFD
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 10:53:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9D1721FAB6;
        Tue, 31 May 2022 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654019584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8moKIIZpjaOuII1lmyaoPzCmdkQKBaafxzPnVdD4yM=;
        b=TtwC8cqzP8naNTCKmOcz33qx/kPNrR5i/2L1W7w1CS7hZviEYFx4ZxIIxI0XLZC2up4knn
        qCY+BwGROOFrLZfql0Q9bNq4o430LuhMmTbV9G36mh+YxHhibOd1HYyqLTegqW7ZxRQR9j
        m4h9r+GFs3orISf0PvQyTluc/g03KSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654019584;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8moKIIZpjaOuII1lmyaoPzCmdkQKBaafxzPnVdD4yM=;
        b=XlDM4oCJDK51zZQpqqIGfCLCtTaw3rfXhxxl7InIBeIR0U9nI085IdY/HH62DK5D0mHXAJ
        RrBwBEvebE0BRJAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BFFE013AA2;
        Tue, 31 May 2022 17:53:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Pt6xIv9VlmIpGAAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 31 May 2022 17:53:03 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 0/3 v2] IMSM autolayout improvements
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
Date:   Wed, 1 Jun 2022 01:53:00 +0800
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <56C1729A-1C59-47C9-9C2E-D09986A64615@suse.de>
References: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B45=E6=9C=8831=E6=97=A5 18:27=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Following patchset modifies some parts of IMSM creation to ensure that
> member's order is always same. It is ISM metadata requirement.
>=20
> Additionally, as discussed with Jes I've started to implement more =
modern error
> handling, by adding special enum for IMSM. Will be great to hear any =
comments
> and opinion.
>=20
> V2 improvements:
> - typedef added in first patch
> - changed order in enum
>=20
> Mariusz Tkaczyk (3):
>  imsm: introduce get_disk_slot_in_dev()
>  imsm: use same slot across container
>  imsm: block changing slots during creation

These patches look fine to me and I ack them all. Next step I will apply =
them into mdadm-CI 20220406-testing branch (not yet now) for further =
testing.

Thanks for the update.

Coly Li

