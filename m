Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA70CC6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 16:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCSQgJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 12:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjCSQfp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 12:35:45 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0848F10245
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 09:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679243660; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=IgopC2e0Emb/cqfCDTAtKAtg8dTAp+WU5D++kkVwPFKIeFmA3j69e5tfUXMLsLRqYzBUa4WPaIhxwIecxztUQ5Kyd/w3/Bf/83iOkYR2AjnUdqZdkCbLR91jIoMcpMZLQNti6hIg8mjieW9jRLGOEiKN6h9oxuaH2qt8pLaXSJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679243660; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=vdK/PRRjsqRq9RlUR275NOiw9ucZfs1kX2Nirdhvxy0=; 
        b=aW7OjtuQ031syioi16C8P15QmLERHLFmbY2m3Xme0CEgR+47Gua1YKRp7KXCz5p5ufOiefiC24vAoX+EqFMbvMK3HpGx8E78dZ8KZGcypyrAJXMSyX7/rKFqx8eXVGKg3o89mGkPaeTgaotzNsDaxENs29G6t27w32MSgRbAG9c=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1679243658361674.7468022301083; Sun, 19 Mar 2023 17:34:18 +0100 (CET)
Message-ID: <780b3df4-196a-e985-1b77-d4bed9a43c54@trained-monkey.org>
Date:   Sun, 19 Mar 2023 12:34:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/6 v2] Assorted patches relating to mdmon
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/12/23 23:42, NeilBrown wrote:
> This series is a minor revision of the previous series with the same
> name.
> It includes the important bugfix identified by Mariusz and a few minor
> improvements suggested by Paul.
> 
> Original comment:
> 
> mdmon is a root-storage daemon is the sense defined by systemd
> documentation, but it does not follow the practice that systemd
> recommends.  Specifically it is run from the root filesystem when
> possible.  The instance started in the initrd hands-over to a root-fs
> based instance, which then hands-over to an initrd-based instance
> started by dracut at shutdown.
> 
> Part of the reason that we ignore systemd advise is that mdmon needs
> access to the filesystem - specifically /dev and /sys - which is not
> available in the initrd context after switchroot.  We could possibly
> change mdmon to work in the systemd-preferred way by splitting mdmon
> into two processes instead of just having 2 threads.  The "monitor"
> process could running entirely in the initrd context, the "manager"
> process could safely run in the root-fs context, passing newly opened
> file descriptors to the monitor over a unix-domain socket.
> 
> But we aren't there yet and may never be.
> 
> For now, mdmon doesn't work correctly.  There is no mechanism to ensure
> a new instance starts after switchroot.  Until recently the initrd
> instance of the systemd mdmon unit would be stopped at switchroot time
> because udev would temporarily forget about md devices.  This would
> allow the "udevadm trigger" process to start a new instance.  udev was
> recently fixed:
> 
> Commit: 7ec624147a41 ("udevadm: cleanup-db: don't delete information for kept db entries")
> 
> so now the attempt to start mdmon via "udevadm trigger" does nothing as
> mdmon already has an active unit.
> 
> The net result is that mdmon continues running in the initrd mount
> namespace and so cannot access new devices.  Adding a device to a root
> md array that depends on mdmon will no longer work.
> 
> We want the initrd instance of mdmon to continue running until the
> root-fs based instance starts, and that really requires we have two
> different systemd units.  This series achieves this in the final patch by
> using a different instance name inside or initrd and outside.
> "initrd-mdfoo" and "mdfoo".
> 
> Other patches in the series are mostly clean-ups and minor improvements
> in related code.
> 
> NeilBrown

Applied, 1, 3-6. Skipping 2 per previous email.

Thanks,
Jes


