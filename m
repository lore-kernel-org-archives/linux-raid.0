Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA1AC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 22:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhLUWCq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 17:02:46 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:34670 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhLUWCp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 17:02:45 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 1B37227E09;
        Tue, 21 Dec 2021 17:02:45 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 92A94A770E; Tue, 21 Dec 2021 17:02:44 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25026.20228.532067.989158@quad.stoffel.home>
Date:   Tue, 21 Dec 2021 17:02:44 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        rgoldwyn@suse.de
Subject: Re: [PATCH v6 4/4] md: raid456 add nowait support
In-Reply-To: <20211221200622.29795-4-vverma@digitalocean.com>
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
        <20211221200622.29795-1-vverma@digitalocean.com>
        <20211221200622.29795-4-vverma@digitalocean.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Vishal" == Vishal Verma <vverma@digitalocean.com> writes:

Vishal> Returns EAGAIN in case the raid456 driver would block
Vishal> waiting for situations like:

Vishal>   - Reshape operation,
Vishal>   - Discard operation.

Vishal> Signed-off-by: Vishal Verma <vverma@digitalocean.com>

Are there any performance implications with this patch set?  I didn't
see any discussion in the patch set (v6) and I was just wondering what
this buys us?  Your patch 1/4 talks about using fio as a test, but
there's no mention of whether it's now faster or slower.

John
