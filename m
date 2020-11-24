Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C89DC56201
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 10:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2627206E0
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 10:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgKXKKf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 05:10:35 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:53787 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728789AbgKXKKf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 05:10:35 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1khVHN-000ApP-DX; Tue, 24 Nov 2020 10:10:33 +0000
Subject: Re: RAID-6 and write hole with write-intent bitmap
To:     Mukund Sivaraman <muks@mukund.org>, linux-raid@vger.kernel.org
References: <20201124072039.GA381531@jurassic.vpn.mukund.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <5FBCDC18.9050809@youngman.org.uk>
Date:   Tue, 24 Nov 2020 10:10:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20201124072039.GA381531@jurassic.vpn.mukund.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/11/20 07:20, Mukund Sivaraman wrote:
> Hi all
> 
> I am trying to setup a MD RAID-6 array and use the ext4 filesystem in
> ordered mode (default) on it. The data gets backed up periodically. I
> want the array to be always available.
> 
> I prefer not using a write-journal if it is sufficient for my usage. I
> want to use the write-intent bitmap only. AIUI the write-hole problem
> occurs when there is a crash or abrupt power off *and* disk failures.

No, I don't think so. I'm not sure, but aiui, there is a critical point
where the data is partially saved to disk, and should a power failure
occur at that precise point you have a stripe incompletely saved, and
therefore corrupt. This is why you need a log to fix it ...
> 
> * After a crash or abrupt power off, the write-intent bitmap is used to
>   rewrite parity where necessary. If there is no disk failure during
>   this period, is the RAID-6 array guaranteed to recover without
>   corruption?
> 
>   With RAID-6, will recovery with write-intent bitmap succeed with 1
>   disk failure during the recovery period without a write-journal? i.e.,
>   is there a possibility of write hole with 1 disk failure in a RAID-6
>   array?
> 
> * With RAID-6 with write-intent bitmap in use, ext4 in ordered mode, no
>   disk failures, and abrupt power loss, is there any chance of data loss
>   in files other than those being written to just before the power loss?

Probably. Sod's law, you will have other files on the same stripe and
things could go wrong ... Plus I believe some file systems (including
ext4?) store small files in the directory, not as their own i-node, so
there's a whole bunch of other complications possible, plus if you
corrupt the directory ,,,
> 
> (Apologies if these are silly questions, but I request answers.)
> 
RULE 0: RAID IS NO SUBSTITUTE FOR BACKUPS.

And if you don't want to lose live data as it is being updated, you need
a journal. Run the correct horse for the course :-)

Cheers.
Wol

