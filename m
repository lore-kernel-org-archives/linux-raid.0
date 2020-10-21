Return-Path: <SRS0=jU3t=D4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8B4C4363D
	for <linux-raid@archiver.kernel.org>; Wed, 21 Oct 2020 00:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B2D22251
	for <linux-raid@archiver.kernel.org>; Wed, 21 Oct 2020 00:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439759AbgJUAo7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Oct 2020 20:44:59 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:42296 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439757AbgJUAo7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Oct 2020 20:44:59 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 09L0ilmM020617;
        Wed, 21 Oct 2020 01:44:47 +0100
From:   Nix <nix@esperi.org.uk>
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes.sorensen@gmail.com
Subject: Re: [PATCH] Make target to install binaries only
References: <20201016084932.7541-1-kinga.tanska@intel.com>
Emacs:  because you deserve a brk today.
Date:   Wed, 21 Oct 2020 01:44:47 +0100
In-Reply-To: <20201016084932.7541-1-kinga.tanska@intel.com> (Kinga Tanska's
        message of "Fri, 16 Oct 2020 10:49:32 +0200")
Message-ID: <87mu0gv24g.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=3 Fuz1=3 Fuz2=3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16 Oct 2020, Kinga Tanska verbalised:

> Make install causes installation of binaries, udev and man.
> This commit contains new target make install-bin, which
> results in installation of binaries only.

... but the code says:

> +install : install-binaries install-man install-udev
[...]
> +install-binaries: mdadm mdmon

... which is not the same name.

(FWIW, install-bin is definitely the common name for this target.)
