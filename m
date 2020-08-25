Return-Path: <SRS0=YcZW=CD=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCB2C433E1
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 18:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55DC72071E
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 18:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgHYSap (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Aug 2020 14:30:45 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44554 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHYSam (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Aug 2020 14:30:42 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 07PITvrQ021367;
        Tue, 25 Aug 2020 19:29:57 +0100
From:   Nix <nix@esperi.org.uk>
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes.sorensen@gmail.com
Subject: Re: [PATCH] Make target to install binaries only
References: <20200819090312.16994-1-kinga.tanska@intel.com>
Emacs:  impress your (remaining) friends and neighbors.
Date:   Tue, 25 Aug 2020 19:29:57 +0100
In-Reply-To: <20200819090312.16994-1-kinga.tanska@intel.com> (Kinga Tanska's
        message of "Wed, 19 Aug 2020 11:03:12 +0200")
Message-ID: <87bliyshne.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-x.dcc-servers-Metrics: loom 104; Body=3 Fuz1=3 Fuz2=3
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19 Aug 2020, Kinga Tanska spake thusly:

> Make install causes installation of binaries, udev and man.
> This commit contains new target make install-bin, which
> results in installation of binaries only.

That would be the conventional name for the target, but...

> +install : install-binaries install-man install-udev
[...]
> +install-binaries: mdadm mdmon

... that's not what you actually called the target.
