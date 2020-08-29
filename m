Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076F4C433E6
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 15:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC49A20707
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 15:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgH2P5u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 11:57:50 -0400
Received: from rin.romanrm.net ([51.158.148.128]:56286 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgH2P5j (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 29 Aug 2020 11:57:39 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id CB932410;
        Sat, 29 Aug 2020 15:57:35 +0000 (UTC)
Date:   Sat, 29 Aug 2020 20:57:35 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     antlists <antlists@youngman.org.uk>
Cc:     Ram Ramesh <rramesh2400@gmail.com>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
Message-ID: <20200829205735.58dfcda1@natsu>
In-Reply-To: <6a9fc5ae-1cae-a3d6-6dc3-d1a93dc1e38e@youngman.org.uk>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
        <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
        <20200828224616.58a1ad6c@natsu>
        <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
        <6a9fc5ae-1cae-a3d6-6dc3-d1a93dc1e38e@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 29 Aug 2020 16:34:56 +0100
antlists <antlists@youngman.org.uk> wrote:

> On 28/08/2020 21:39, Ram Ramesh wrote:
> > One thing about LVM that I am not clear. Given the choice between 
> > creating /mirror LV /on a VG over simple PVs and /simple LV/ over raid1 
> > PVs, which is preferred method? Why?
> 
> Simplicity says have ONE raid, with ONE PV on top of it.
> 
> The other way round is you need TWO SEPARATE (at least) PV/VG/LVs, which 
> you then stick a raid on top.

I believe the question was not about the order of layers, but whether to
create a RAID with mdadm and then LVM on top, vs. abandoning mdadm and using
LVM's built-in RAID support instead:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/mirror_create

Personally I hugely prefer mdadm, due to the familiar and convenient interface
of the program itself, as well as of /proc/mdstat.

-- 
With respect,
Roman
