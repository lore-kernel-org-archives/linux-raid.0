Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFCEC48BE5
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 09:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98B146109E
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 09:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFUJRx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 05:17:53 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:12375 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230161AbhFUJRx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 21 Jun 2021 05:17:53 -0400
Received: from host86-157-72-169.range86-157.btcentralplus.com ([86.157.72.169] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lvG1p-000BX7-Et; Mon, 21 Jun 2021 10:15:37 +0100
Subject: Re: How does one enable SCTERC on an NVMe drive (and other install
 questions)
To:     Edward Kuns <eddie.kuns@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <60D06BF5.50000@youngman.org.uk>
Date:   Mon, 21 Jun 2021 11:37:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/06/21 06:00, Edward Kuns wrote:
> While this page is clear about the difference between Red, Red Pro,
> and Red Plus:
> 
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
> 
> this page is not:
> 
> https://raid.wiki.kernel.org/index.php/Drive_Data_Sheets
> 
> I would be happy to propose some text changes if that would help.

Whoops. Thanks for pointing that out.

I'll get that page fixed.

Cheers,
Wol
