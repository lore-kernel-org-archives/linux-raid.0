Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5346AC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 23 Jul 2022 06:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiGWGVZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Jul 2022 02:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiGWGVX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Jul 2022 02:21:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8723848E85
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 23:21:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8FFAE37C1D;
        Sat, 23 Jul 2022 06:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658557280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHiuYhnWcVCf7K1U4GtDmqPiyieO4KXxPC0XDQ+JrKo=;
        b=leAnnHf6ZRoFa5E2QBO5PH4O9pnT0/tHYMH1V99zLJNMEnD+Qyu5dGWCCG+zSZat1QIvlz
        WyK2ZtW7UVqW8FsNiaMWn1ocJPckQ6BtVebcFGBbQRSu6w6O3cBUlAW0MO0WcsIDJfxC87
        A9ewdSuzZ8G8zBD3+IPOn6WzwAR477o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658557280;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHiuYhnWcVCf7K1U4GtDmqPiyieO4KXxPC0XDQ+JrKo=;
        b=c/DzX/l0pX7v2v4IHEUo5F7X5a3z60HrIyZYUzip8XB5C2NvZZ3GsEyzHYGclcXq1TaqP7
        koFaHNrn8su9sWBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B8AF13A92;
        Sat, 23 Jul 2022 06:21:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id z+11GFyT22JGdAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 23 Jul 2022 06:21:16 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
From:   Coly Li <colyli@suse.de>
In-Reply-To: <1561DA98-8681-483F-A14C-FE6877B9DC05@oracle.com>
Date:   Sat, 23 Jul 2022 14:21:13 +0800
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Jes Sorensen <jsorensen@fb.com>, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7F1A75AE-2F25-4D77-8BA5-2826E108E85B@suse.de>
References: <20220622202519.35905-1-logang@deltatee.com>
 <1561DA98-8681-483F-A14C-FE6877B9DC05@oracle.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8823=E6=97=A5 01:00=EF=BC=8CHimanshu Madhani =
<himanshu.madhani@oracle.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Jes,
>=20
>> On Jun 22, 2022, at 1:25 PM, Logan Gunthorpe <logang@deltatee.com> =
wrote:
>>=20
>> Hi,
>>=20
>> This series tries to clean up the testing infrastructure to be a bit
>> more reliable. It doesn't fix all the broken tests but annotates =
those
>> that I see as broken so testing can continue. V2 includes changes
>> requested in the feedback so far.
>>=20
>> As such, I've fixed all the kernel panics (in md-next now) and =
segfaults
>> that caused testing to halt regardless of whether --keep-going was
>> passed. I've also included some patches posted to the list from =
Sudhakar
>> and Himanshu which fix some more broken tests.
>>=20
>> I've also included a patch which adds the --loop option to ./test =
which
>> runs tests for a specified number of iterations (or indefinitely if =
zero
>> is specified). This was very useful for ferreting out tests that =
failed
>> randomly.
>>=20
>> The last two patches adds some infrastructure and annotation for =
known
>> broken tests so that they don't stop the processing (even if
>> --keep-going is not passed). Tests that are known to be broken  can
>> optionally be skipped with the --skip-broken or --skip-always-broken
>> flags.
>>=20
>> With these changes it's possible to run './test --loop=3D0' for =
several
>> days without stopping.
>>=20
>> There are still a number of broken tests which need more work, and =
there
>> may be other issues on other people's systems (kernel configurations,
>> etc) but that will have to be left to other developers.
>>=20
>> The tests that are still broken for me in one way or another are:
>> 01r5integ, 01raid6integ, 04r5swap.broken, 04update-metadata,
>> 07autoassemble, 07autodetect, 07changelevelintr, 07changelevels,
>> 07reshape5intr, 07revert-grow, 07revert-shrink, 07testreshape5,
>> 09imsm-assemble, 09imsm-create-fail-rebuild, 09imsm-overlap,
>> 10ddf-assemble-missing, 10ddf-fail-create-race,
>> 10ddf-fail-two-spares, 10ddf-incremental-wrong-order,
>> 14imsm-r1_2d-grow-r1_3d, 14imsm-r1_2d-takeover-r0_2d,
>> 18imsm-r10_4d-takeover-r0_2d, 18imsm-r1_2d-takeover-r0_1d,
>> 19raid6auto-repair, 19raid6repair.broken
>>=20
>> Details on how they are broken can be found in the last patch.
>>=20
>> This series is based on the current kernel.org master (190dc029) and
>> a git repo can be found here:
>>=20
>> https://github.com/lsgunth/mdadm bugfixes_v2
>>=20
>>=20
>> Thanks,
>>=20
>> Logan
>>=20
>> --
>>=20
>> Changes since v1:
>> * Rebase onto latest master (190dc029b141c423e), which means
>>   reworking patch 6 seeing the original patch was already
>>   reverted
>> * Drop mdadm.static from the make target everything-test as well
>>   as everything (as pointed out by Mariusz)
>> * Switch to using close_fd() helper in patch 4 (per Mariusz)
>> * Fixed a couple minor typos and whitespace issues from Guoqing
>>   and Paul
>> * Collected Acks from Mariusz
>>=20
>> --
>>=20
>> Logan Gunthorpe (10):
>> Makefile: Don't build static build with everything and =
everything-test
>> DDF: Cleanup validate_geometry_ddf_container()
>> DDF: Fix NULL pointer dereference in validate_geometry_ddf()
>> mdadm/Grow: Fix use after close bug by closing after fork
>> monitor: Avoid segfault when calling NULL get_bad_blocks
>> mdadm: Fix mdadm -r remove option regression
>> mdadm: Fix optional --write-behind parameter
>> mdadm/test: Add a mode to repeat specified tests
>> mdadm/test: Mark and ignore broken test failures
>> tests: Add broken files for all broken tests
>>=20
>> Sudhakar Panneerselvam (4):
>> tests/00raid0: add a test that validates raid0 with layout fails for
>>   0.9
>> tests: fix raid0 tests for 0.90 metadata
>> tests/04update-metadata: avoid passing chunk size to raid1
>> tests/02lineargrow: clear the superblock at every iteration
>>=20
>> Grow.c                                     |  4 +-
>> Makefile                                   |  4 +-
>> ReadMe.c                                   |  1 +
>> mdadm.c                                    |  6 +-
>> mdadm.h                                    |  1 +
>> monitor.c                                  |  3 +
>> super-ddf.c                                | 94 =
++++++++++------------
>> test                                       | 71 +++++++++++++---
>> tests/00raid0                              | 10 +--
>> tests/00readonly                           |  4 +
>> tests/01r5integ.broken                     |  7 ++
>> tests/01raid6integ.broken                  |  7 ++
>> tests/02lineargrow                         |  2 +
>> tests/03r0assem                            |  6 +-
>> tests/04r0update                           |  4 +-
>> tests/04r5swap.broken                      |  7 ++
>> tests/04update-metadata                    |  8 +-
>> tests/07autoassemble.broken                |  8 ++
>> tests/07autodetect.broken                  |  5 ++
>> tests/07changelevelintr.broken             |  9 +++
>> tests/07changelevels.broken                |  9 +++
>> tests/07reshape5intr.broken                | 45 +++++++++++
>> tests/07revert-grow.broken                 | 31 +++++++
>> tests/07revert-shrink.broken               |  9 +++
>> tests/07testreshape5.broken                | 12 +++
>> tests/09imsm-assemble.broken               |  6 ++
>> tests/09imsm-create-fail-rebuild.broken    |  5 ++
>> tests/09imsm-overlap.broken                |  7 ++
>> tests/10ddf-assemble-missing.broken        |  6 ++
>> tests/10ddf-fail-create-race.broken        |  7 ++
>> tests/10ddf-fail-two-spares.broken         |  5 ++
>> tests/10ddf-incremental-wrong-order.broken |  9 +++
>> tests/14imsm-r1_2d-grow-r1_3d.broken       |  5 ++
>> tests/14imsm-r1_2d-takeover-r0_2d.broken   |  6 ++
>> tests/18imsm-r10_4d-takeover-r0_2d.broken  |  5 ++
>> tests/18imsm-r1_2d-takeover-r0_1d.broken   |  6 ++
>> tests/19raid6auto-repair.broken            |  5 ++
>> tests/19raid6repair.broken                 |  5 ++
>> 38 files changed, 361 insertions(+), 83 deletions(-)
>> create mode 100644 tests/01r5integ.broken
>> create mode 100644 tests/01raid6integ.broken
>> create mode 100644 tests/04r5swap.broken
>> create mode 100644 tests/07autoassemble.broken
>> create mode 100644 tests/07autodetect.broken
>> create mode 100644 tests/07changelevelintr.broken
>> create mode 100644 tests/07changelevels.broken
>> create mode 100644 tests/07reshape5intr.broken
>> create mode 100644 tests/07revert-grow.broken
>> create mode 100644 tests/07revert-shrink.broken
>> create mode 100644 tests/07testreshape5.broken
>> create mode 100644 tests/09imsm-assemble.broken
>> create mode 100644 tests/09imsm-create-fail-rebuild.broken
>> create mode 100644 tests/09imsm-overlap.broken
>> create mode 100644 tests/10ddf-assemble-missing.broken
>> create mode 100644 tests/10ddf-fail-create-race.broken
>> create mode 100644 tests/10ddf-fail-two-spares.broken
>> create mode 100644 tests/10ddf-incremental-wrong-order.broken
>> create mode 100644 tests/14imsm-r1_2d-grow-r1_3d.broken
>> create mode 100644 tests/14imsm-r1_2d-takeover-r0_2d.broken
>> create mode 100644 tests/18imsm-r10_4d-takeover-r0_2d.broken
>> create mode 100644 tests/18imsm-r1_2d-takeover-r0_1d.broken
>> create mode 100644 tests/19raid6auto-repair.broken
>> create mode 100644 tests/19raid6repair.broken
>>=20
>>=20
>> base-commit: 190dc029b141c423e724566cbed5d5afbb10b05a
>> --
>> 2.30.2
>=20
> I have not seen any updates or review comments on this series. Any =
plan on merging this series?=20
>=20
> I have been using this test series for my developer testing and this =
has a very helpful
> testing framework update. This update improves baseline testing and =
predictive failure coverage.
> I find it very useful to work on improving the overall test =
infrastructure.=20
>=20
> You can add my R-B for the series while merging.
>=20
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

I just finished to go through all these fixes recently. After the rested =
patches (around 4~5) in my review-queue finished, I will submit them all =
to Jes for the next step to handle, with your Rviewed-by tag.

Coly Li

