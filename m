Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7E3C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 21 Jan 2022 20:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiAUUZD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Jan 2022 15:25:03 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:40338 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiAUUZD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Jan 2022 15:25:03 -0500
X-Greylist: delayed 3400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2022 15:25:02 EST
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 20LJSH8T026191
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 21 Jan 2022 19:28:18 GMT
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     NeilBrown <neilb@suse.de>, anthony <antmbox@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>
Subject: Re: PANIC OVER! Re: The mysterious case of the disappearing
 superblock ...
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
        <164254680952.24166.7553126422166310408@noble.neil.brown.name>
        <cfea15f4-228e-4a38-5567-9b710b6dc5c2@youngman.org.uk>
Emacs:  The Awakening
Date:   Fri, 21 Jan 2022 19:28:17 +0000
In-Reply-To: <cfea15f4-228e-4a38-5567-9b710b6dc5c2@youngman.org.uk> (Wols
        Lists's message of "Wed, 19 Jan 2022 08:52:56 +0000")
Message-ID: <87o84428j2.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=5 Fuz1=5 Fuz2=5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19 Jan 2022, Wols Lists said:
> Oh well, the good thing is that backup drive is on its way. I'm planning to put plain lvm on it, and write a bunch of services that
> create backup volumes then do a overwrite-in-place rsync. So as I keep advising 
> people, it does an incremental backup, but the COW volumes mean I have full backups.

rsync works by rename-then-rewrite on a whole-file basis (it doesn't
just modify changed bits of files), so I'm afraid it's going to be
terribly inefficient for large slightly-changed files, with many
unchanging blocks CoWed nonetheless.

The right way to do a deduplicating backup is to use a deduplicating
backup system (borg, restic, bup, bupstash -- I swear by bup myself).
There's a really good list here: <https://github.com/restic/others>.

-- 
NULL && (void)
