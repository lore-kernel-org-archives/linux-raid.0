Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01B6C3E8C5
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 02:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764D721D46
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 02:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgK1C0a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:26:30 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:48806 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbgK1CZQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 27 Nov 2020 21:25:16 -0500
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 0AS1pHn2016401;
        Sat, 28 Nov 2020 01:51:17 GMT
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Mukund Sivaraman <muks@mukund.org>, linux-raid@vger.kernel.org
Subject: Re: RAID-6 and write hole with write-intent bitmap
References: <20201124072039.GA381531@jurassic.vpn.mukund.org>
        <5FBCDC18.9050809@youngman.org.uk>
Emacs:  don't try this at home, kids!
Date:   Sat, 28 Nov 2020 01:51:17 +0000
In-Reply-To: <5FBCDC18.9050809@youngman.org.uk> (Wols Lists's message of "Tue,
        24 Nov 2020 10:10:32 +0000")
Message-ID: <87ft4uckq2.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=3 Fuz1=3 Fuz2=3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24 Nov 2020, Wols Lists told this:

> On 24/11/20 07:20, Mukund Sivaraman wrote:
>> * With RAID-6 with write-intent bitmap in use, ext4 in ordered mode, no
>>   disk failures, and abrupt power loss, is there any chance of data loss
>>   in files other than those being written to just before the power loss?
>
> Probably. Sod's law, you will have other files on the same stripe and
> things could go wrong ... Plus I believe some file systems (including
> ext4?) store small files in the directory, not as their own i-node, so

ext4 can store small files in the *inode*, not in the containing
directory: that's impossible, since an inode can appear in many
directories at the same time.

... but, of course, inodes on many filesystems are packed into big
tables of inodes, and if you have a write hole hitting an inode write,
you've probably buggered up a bunch of other inodes too. And inodes are
more or less unordered, so that's just smashed a random spray of things
on the disk... it is quite posible that a lot of them are in directories
close in space or in time-of-write to the one you were updating, but not
necessarily. Reach for backups time.

> RULE 0: RAID IS NO SUBSTITUTE FOR BACKUPS.

But backups are a substitute for lack of sleep (for me anyway, because
if I don't have good backups, I can't sodding sleep).
