Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08D5C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 09:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbiFHJLU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbiFHJK0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 05:10:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1175616FEE1
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 01:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654677137; x=1686213137;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nyiecMv4iI3AQ+BjoF1H+Z948VnXndrJgDjVo5S1ffc=;
  b=PlIgnXula/mAdyZIJU53NemA08yrWS3k2mibA70MsewtdQhunPtaODdy
   jCkjWhRxTYFd0DquvWTLYFRex8mpKkR3a36y71p+2UAJSu2l3nRof9k8V
   Ym0x72gC2Yu4B09HcoJB0JSePYpQFHxUuN3r0CG3bPy9LB8rl4xsP2uyW
   rBQtpQJUIc9pjJZu3mRgzxrmkU+BHUk5Cx78tzSWBczIh7W8lCci7Zw5Q
   JBNGV332Om7KC2FsVxDzg/f5VkvQcwZQ6GHFgP9Wpt8fVyeRA7lpTkyeD
   jUN9WJZ3oFyAAtyYLNwm9X0SYv/1ihrGF43rT7Yq4pzPK91cD+Vyqk50C
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="338612921"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="338612921"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 01:32:15 -0700
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="636675667"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.150])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 01:32:13 -0700
Date:   Wed, 8 Jun 2022 10:32:09 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Pavel <pavel2000@ngs.ru>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Misbehavior of md-raid RAID on failed NVMe.
Message-ID: <20220608103209.00001d6a@linux.intel.com>
In-Reply-To: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
References: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 8 Jun 2022 10:48:09 +0700
Pavel <pavel2000@ngs.ru> wrote:

> Hi, linux-raid community.
>=20
> Today we found a strange and even scaring behavior of md-raid RAID based=
=20
> on NVMe devices.
>=20
> We ordered new server, and started data transfer (using dd, filesystems=20
> was unmounted on source, etc - no errors here).
>=20
> While data in transfer, kernel started IO errors reporting on one of=20
> NVMe devices. (dmesg output below)
> But md-raid not reacted on them in any way. RAID array not went into any=
=20
> failed state, and "clean" state reported all the time.
>=20
> Based on earlier practice, we trusted md-raid and thought things goes ok.
> After data transfer finished, server was turned off and cables was=20
> replaced on suspicion.
>=20
> After OS started on this new server, we found MySQL crashes.
> Thorough checksum check showed us mismatches on files content.
> (Of course, we did checksumming of untouched files, not MySQL database=20
> files)
>=20
> So, there is data-loss possible when NVMe device behaves wrong.
> We think, md-raid has to remove failed device from raid in a such case.
> That it didn't happen is wrong behaviour, so want to inform community=20
> about finding.
>=20
> Hope, this will help to make kernel ever better.
> Thanks for your work.
>=20

Hi Pavel,
IMO it is not a RAID problem. In this case some part of requests hangs
inside nvme driver and raid1d hanged too. It is rather nvme problem not a r=
aid.
RAID should handle it well if IO errors are continuously reported.

Thanks,
Mariusz

> ---
> [Tue Jun=A0 7 09:58:45 2022] Call Trace:
> [Tue Jun=A0 7 09:58:45 2022]=A0 <IRQ>
> [Tue Jun=A0 7 09:58:45 2022]=A0 nvme_pci_complete_rq+0x5b/0x67 [nvme]
> [Tue Jun=A0 7 09:58:45 2022]=A0 nvme_poll_cq+0x1e4/0x265 [nvme]
> [Tue Jun=A0 7 09:58:45 2022]=A0 nvme_irq+0x36/0x6e [nvme]
> [Tue Jun=A0 7 09:58:45 2022]=A0 __handle_irq_event_percpu+0x73/0x13e
> [Tue Jun=A0 7 09:58:45 2022]=A0 handle_irq_event_percpu+0x31/0x77
> [Tue Jun=A0 7 09:58:45 2022]=A0 handle_irq_event+0x2e/0x51
> [Tue Jun=A0 7 09:58:45 2022]=A0 handle_edge_irq+0xc9/0xee
> [Tue Jun=A0 7 09:58:45 2022]=A0 __common_interrupt+0x41/0x9e
> [Tue Jun=A0 7 09:58:45 2022]=A0 common_interrupt+0x6e/0x8b
> [Tue Jun=A0 7 09:58:45 2022]=A0 </IRQ>
> [Tue Jun=A0 7 09:58:45 2022]=A0 <TASK>
> [Tue Jun=A0 7 09:58:45 2022]=A0 asm_common_interrupt+0x1e/0x40
> [Tue Jun=A0 7 09:58:45 2022] RIP: 0010:__blk_mq_try_issue_directly+0x12/0=
x136
> [Tue Jun=A0 7 09:58:45 2022] Code: fe ff ff 48 8b 97 78 01 00 00 48 8b 92=
=20
> 80 00 00 00 48 89 34 c2 b0 01 c3 0f 1f 44 00 00 41 57 41 56 41 55 41 54=20
> 55 48 89 f5 53 <89> d3 48 83 ec 18 65 48 8b 04 25 28 00 00 00 48 89 44=20
> 24 10 31 c0
> [Tue Jun=A0 7 09:58:45 2022] RSP: 0018:ffff88810bbf7ad8 EFLAGS: 00000246
> [Tue Jun=A0 7 09:58:45 2022] RAX: 0000000000000000 RBX: 0000000000000001=
=20
> RCX: 0000000000000001
> [Tue Jun=A0 7 09:58:45 2022] RDX: 0000000000000001 RSI: ffff8881137e6e40=
=20
> RDI: ffff88810dfdf400
> [Tue Jun=A0 7 09:58:45 2022] RBP: ffff8881137e6e40 R08: 0000000000000001=
=20
> R09: 0000000000000a20
> [Tue Jun=A0 7 09:58:45 2022] R10: 0000000000000000 R11: 0000000000000000=
=20
> R12: 0000000000000000
> [Tue Jun=A0 7 09:58:45 2022] R13: ffff88810dfdf400 R14: ffff8881137e6e40=
=20
> R15: ffff88810bbf7df0
> [Tue Jun=A0 7 09:58:45 2022] blk_mq_request_issue_directly+0x46/0x78
> [Tue Jun=A0 7 09:58:45 2022] blk_mq_try_issue_list_directly+0x41/0xba
> [Tue Jun=A0 7 09:58:45 2022]=A0 blk_mq_sched_insert_requests+0x86/0xd0
> [Tue Jun=A0 7 09:58:45 2022]=A0 blk_mq_flush_plug_list+0x1b5/0x214
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? __blk_mq_alloc_requests+0x1c7/0x21d
> [Tue Jun=A0 7 09:58:45 2022]=A0 blk_mq_submit_bio+0x437/0x518
> [Tue Jun=A0 7 09:58:45 2022]=A0 submit_bio_noacct+0x93/0x1e6
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? bio_associate_blkg_from_css+0x137/0x15c
> [Tue Jun=A0 7 09:58:45 2022]=A0 flush_bio_list+0x96/0xa5
> [Tue Jun=A0 7 09:58:45 2022]=A0 flush_pending_writes+0x7a/0xbf
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? md_check_recovery+0x8a/0x4bd
> [Tue Jun=A0 7 09:58:45 2022]=A0 raid1d+0x194/0x10e8
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? common_interrupt+0xf/0x8b
> [Tue Jun=A0 7 09:58:45 2022]=A0 md_thread+0x12c/0x155
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? init_wait_entry+0x29/0x29
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? signal_pending+0x19/0x19
> [Tue Jun=A0 7 09:58:45 2022]=A0 kthread+0x104/0x10c
> [Tue Jun=A0 7 09:58:45 2022]=A0 ? set_kthread_struct+0x32/0x32
> [Tue Jun=A0 7 09:58:45 2022]=A0 ret_from_fork+0x22/0x30
> [Tue Jun=A0 7 09:58:45 2022]=A0 </TASK>
> [Tue Jun=A0 7 09:58:45 2022] ---[ end trace 15dc74ae2e04f737 ]---
> [Tue Jun=A0 7 09:58:45 2022] ------------[ cut here ]------------
> [Tue Jun=A0 7 09:58:45 2022] refcount_t: underflow; use-after-free.



