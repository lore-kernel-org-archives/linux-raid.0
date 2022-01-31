Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACECAC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 15:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379757AbiAaPkC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 10:40:02 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:40340 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379765AbiAaPkB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jan 2022 10:40:01 -0500
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 20VFdwEq028943
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 31 Jan 2022 15:39:58 GMT
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Phil Turmel <philip@turmel.org>,
        Roger Heflin <rogerheflin@gmail.com>,
        David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: hardware recovery and RAID5 services
In-Reply-To: <c3b7a580-952f-7c7a-fddc-88ca0b5fde84@youngman.org.uk> (Wols
        Lists's message of "Sat, 29 Jan 2022 15:36:21 +0000")
References: <20220121164804.GE14596@justpickone.org>
        <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
        <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk>
        <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
        <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
        <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
        <c3b7a580-952f-7c7a-fddc-88ca0b5fde84@youngman.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
Emacs:  it's like swatting a fly with a supernova.
Date:   Mon, 31 Jan 2022 15:39:58 +0000
Message-ID: <87leyvvrqp.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=5 Fuz1=5 Fuz2=5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 29 Jan 2022, Wols Lists told this:

> I believe there is also a way of injecting a hardware error onto a
> drive. Unless you can take a backup of the backup :-) I wouldn't
> recommend it at the moment, but there's some ATA command or whatever
> that tells the drive to flag a sector as bad, and return a read error
> until it's over-written.

See hdparm --make-bad-sector. The manpage says "EXCEPTIONALLY DANGEROUS.
DO NOT USE THIS OPTION!!". It is not lying. :)

(This is also --write-sector, which is merely VERY DANGEROUS, but can be
used to force rewrites of bad sectors. Make sure you get the sector
number right! Needless to say, if you don't, it's too late, and there's
no real way to test in advance...)
