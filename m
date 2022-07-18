Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF07C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 12:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiGRMZH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 08:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiGRMZG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 08:25:06 -0400
X-Greylist: delayed 283 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 05:25:04 PDT
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64FD121
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 05:25:03 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26ICKGpw001870
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 13:20:17 +0100
From:   Nix <nix@esperi.org.uk>
To:     linux-raid@vger.kernel.org
Subject: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
Emacs:  resistance is futile; you will be assimilated and byte-compiled.
Date:   Mon, 18 Jul 2022 13:20:16 +0100
Message-ID: <87o7xmsjcv.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1102; Body=1 Fuz1=1 Fuz2=1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

So I have a pair of RAID-6 mdraid arrays on this machine (one of which
has a bcache layered on top of it, with an LVM VG stretched across
both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
simply didn't find anything to assemble, and after that nothing else was
going to work. But rebooting into 5.16 worked fine, so everything was
(thank goodness) actually still there.

Alas I can't say what the state of the blockdevs was (other than that
they all seemed to be in /dev, and I'm using DEVICE partitions so they
should all have been spotted) or anything else about the boot because
console scrollback is still a nonexistent thing (as far as I can tell),
it scrolls past too fast for me to video it, and I can't use netconsole
because this is the NFS and loghost server for the local network so all
the other machines are more or less frozen waiting for NFS to come back.

Any suggestions for getting more useful info out of this thing? I
suppose I could get a spare laptop and set it up to run as a netconsole
server for this one boot... but even that won't tell me what's going on
if the error (if any) is reported by some userspace process rather than
in the kernel message log.

I'll do some mdadm --examine's and look at /proc/partitions next time I
try booting (which won't be before this weekend), but I'd be fairly
surprised if mdadm itself was at fault, even though it's the failing
component and it's old, unless the kernel upgrade has tripped some bug
in 4.0 -- or perhaps 4.0 built against a fairly old musl: I haven't even
recompiled it since 2019. So this looks like something in the blockdev
layer, which at this stage in booting is purely libata-based. (There is
an SSD on the machine, but it's used as a bcache cache device and for
XFS journals, both of which are at layers below mdadm so can't possibly
be involved in this.)

-- 
NULL && (void)
