Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3AAC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 20:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353298AbiCUU0b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346176AbiCUU0b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 16:26:31 -0400
X-Greylist: delayed 2998 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Mar 2022 13:25:04 PDT
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BCB165A83
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 13:25:04 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 22LJZ0FA016566
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 21 Mar 2022 19:35:01 GMT
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Marc MERLIN <marc@merlins.org>, Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>,
        linux-raid@vger.kernel.org
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
References: <20220319041020.GW3131742@merlins.org>
        <01d2c8c5-46ea-f69e-e285-da0abe6cd594@youngman.org.uk>
Emacs:  why choose between a word processor and a Lisp interpreter when you
 could have neither instead?
Date:   Mon, 21 Mar 2022 19:35:00 +0000
In-Reply-To: <01d2c8c5-46ea-f69e-e285-da0abe6cd594@youngman.org.uk> (Wols
        Lists's message of "Sat, 19 Mar 2022 10:14:16 +0000")
Message-ID: <87zgljcd5n.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=5 Fuz1=5 Fuz2=5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19 Mar 2022, Wols Lists uttered the following:

> On 19/03/2022 04:10, Marc MERLIN wrote:
>>> If you find it needs more than the size of sdk1, as an emergency measure you
>>> could wipe off the partition table and add the entire sdk as the array member.
>
>> Yeah, I thought of that, just don't really like it, and not sure if
>> mdadm -can looks for raw drives in addition to partitions
>> 
> mdadm has absolutely no trouble with that at all. All it cares about is if something is a block device - if it finds an mdadm
> signature at the start of a block device it will use it.
>
> The problem is the eejits out there who assume that all physical
> drives must be partitioned. And we know from experience that there are
> eejits out there who assume that any drive without an MBR or GPT just
> *must* be unused and it's *perfectly* *okay* to write said MBR or GPT
> *without* *asking*. Just trashing your mdadm (or lvm, or whatever yada
> ydad) signature in the process.

... and we know that some of the eejits out there write EFI firmware :(
and some of them blow away things like this on boot, on resume from
suspend, 

> It's not common

... thank goodness.

-- 
NULL && (void)
