Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE81C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 20:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbhLSUPt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 15:15:49 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:19343 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhLSUPs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 19 Dec 2021 15:15:48 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mz0Lq-0005st-Cw; Sun, 19 Dec 2021 17:52:02 +0000
Message-ID: <af7e8f4e-d770-5fde-f007-1894d62c15e6@youngman.org.uk>
Date:   Sun, 19 Dec 2021 17:52:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Debugging system hangs
Content-Language: en-US
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
 <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
 <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/12/2021 22:05, Roger Heflin wrote:
> There would be various messages.
>   grep -E 'ATA| sd |ata[0-9]' /var/log/messages
> might get you details.  It will also show when the disks are first
> showing up and being reported.

thewolery /home/anthony # tail /var/log/messages
tail: cannot open '/var/log/messages' for reading: No such file or directory

Cheers,
Wol
