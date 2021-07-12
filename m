Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9278C07E99
	for <linux-raid@archiver.kernel.org>; Mon, 12 Jul 2021 07:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BB2A61C5F
	for <linux-raid@archiver.kernel.org>; Mon, 12 Jul 2021 07:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345864AbhGLH5F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Jul 2021 03:57:05 -0400
Received: from mail-out-auth1.hosts.co.uk ([195.7.255.1]:12686 "EHLO
        mail-out-auth1.hosts.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348006AbhGLHzJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Jul 2021 03:55:09 -0400
X-Greylist: delayed 52977 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 03:55:09 EDT
Received: from host86-159-54-55.range86-159.btcentralplus.com ([86.159.54.55] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1m2qjf-0008I6-E0; Mon, 12 Jul 2021 08:52:16 +0100
Subject: Re: RAID5 now recognized as RAID1
To:     Nicolas Martin <nicolas.martin.3d@gmail.com>,
        linux-raid@vger.kernel.org
References: <C3C9F935-DD1C-409C-8C9D-56F97B13B676@gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <60EBF4AE.7080205@youngman.org.uk>
Date:   Mon, 12 Jul 2021 08:52:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <C3C9F935-DD1C-409C-8C9D-56F97B13B676@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08/07/21 11:07, Nicolas Martin wrote:
> So, I don’t know how this could happen ? I looked up on the FAQ, but I can’t seem to see what could explain this, nor how I can recover from this ?

https://raid.wiki.kernel.org/index.php/Asking_for_help

Cheers,
Wol
