Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A8CC43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 15:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243004AbiFIPLq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiFIPLp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 11:11:45 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA0528D68C
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 08:11:44 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B27A1320097C;
        Thu,  9 Jun 2022 11:11:41 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Thu, 09 Jun 2022 11:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=braithwaite.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1654787501; x=1654873901; bh=GM
        FMFQAgZAlWntoKFynYOAaMzu/etYvSctBNWU4W6iM=; b=KTSoW4vRmL0f5DyvLx
        2/61VpU7qR9MFqrDTWgeosv+G6h3MvI8njgp47x5xQ0ImlYheWmZIG2adp1gHA3K
        bnRKZ6Ra1eVNg1hmXvxzXO1Vb13wnsnMFcp9G/BlTyLTZatvE9XiaxaHMtyzj976
        NnwFXn1FJIzgT5IhA6GhQe/6lq94XxrKBWdXVxzmX0Fm5C1Ix5R7JNHMMOR6IZYK
        oIRNmFnHeC5FNh+pBeTaJDyEL1UwVmS6JztQXWg3APrwzk27/8LKvgIQa1semaaw
        0wqBlGr3HKgZDRNJ3Z5y3CX6o4drycuWsu6VTUTr8zbv9dDyyOpVM/7KUJOfxplw
        deOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1654787501; x=1654873901; bh=GMFMFQAgZAlWntoKFynYOAaMzu/e
        tYvSctBNWU4W6iM=; b=AsAMdrhL3jjyBYHHaB/EjxGvM91C0PCFmDkGbTNEij6E
        8UE5vTNFveLirA3J+PdK+bkFpyaSMbAwPKmqoEc7ZChxA6qgJo+Z7bfVKRHKiFP1
        bKUJNoKzalXwd/9UGDDVbY30q2HSP1NWjYUmMNFPFuVMuX6S7mh712Qbzyk1goKA
        g8mnhu7O0aPTSaUyfPAsuyhd2xkLt5H8kVtQuc+e05weXkjkdlX+eBUPJlBcHxIs
        YsiqKiJ7zKNY7BX9HrnCEvoEjSS+IENEGr9T4TdvMZGiLW3eu9MqUZbFaprNcrA5
        n3v8b0XRwFPJdupTAn7K4D/ksfGEGY8kp3Sz1zV4IA==
X-ME-Sender: <xms:rA2iYlI5whfike9yPVOqjtwzzR6UbHx88n_uJIhAPU_gjuLpNf259w>
    <xme:rA2iYhIwwNhTe0RmHeaxOWZEtvVSOGKH6B_vZ3gFGjlT8ryOtI22a7F5X8ThFmHT9
    IkZMlkRwu-0tmIX-gM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddtledgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehl
    rghnuceurhgrihhthhifrghithgvfdcuoegrlhgrnhessghrrghithhhfigrihhtvgdrug
    gvvheqnecuggftrfgrthhtvghrnhepueeujeffuddugffgieetteeijeekueevieekhfeu
    ffettdeuieevhedtvdeghfeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgrnhessghr
    rghithhhfigrihhtvgdruggvvh
X-ME-Proxy: <xmx:rQ2iYtv7_NhOB3zH0UdBjuQshPXyLxaAZucyFC1Reh1EU6zlYsaWkQ>
    <xmx:rQ2iYmZqxQq2M_rWu-Ob1XcqRH6S54kbCIS_w415ZLq6gaf8N4P5cw>
    <xmx:rQ2iYsa18bmG_ZGK7jnLtwpHeF-v-Q6X4IYtARQ14FuNOMqIlCbPVg>
    <xmx:rQ2iYlCZ_awtx4J_mH-82GzHHIYjhREDQ4QDSoSEjKXdVgYKjyyHMg>
Feedback-ID: i1a914699:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E552515A0080; Thu,  9 Jun 2022 11:11:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-692-gb287c361f5-fm-20220603.003-gb287c361
Mime-Version: 1.0
Message-Id: <88ffaeae-4f1e-4195-b927-182f21249cf5@www.fastmail.com>
In-Reply-To: <ba0d6708-1275-6fac-b387-40d5673d6002@youngman.org.uk>
References: <0fa973c1-2961-4f8f-99fa-b427a5c694fd@www.fastmail.com>
 <CAPpdf5-wEfpHnteLAG-EHD-we+b+0=KB7RcD=U9dw6K-_3f48w@mail.gmail.com>
 <b80c6d10-760e-40a2-b9ca-86aabf3267d0@www.fastmail.com>
 <ba0d6708-1275-6fac-b387-40d5673d6002@youngman.org.uk>
Date:   Thu, 09 Jun 2022 08:10:36 -0700
From:   "Alan Braithwaite" <alan@braithwaite.dev>
To:     "Wols Lists" <antlists@youngman.org.uk>,
        o1bigtenor <o1bigtenor@gmail.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: MD Array Unexpected Kernel Hang
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey all,

Thanks for the responses!

> A quick google also says these are old drives, which may or not be a 
> concern. That also possibly explains the lack of sct/erc.

These are old SAS drives, correct.  They're in an external JBOD chassis with an HBA expander to the host machine.  I acquired them used with the hopes of extending their life in a raid array.

> Given that you say three drives all failed in the first slot? My money 
> would actually be on nothing to do with raid, but a dodgy cable or 
> motherboard connector. I don't think they're rated at being swapped over 
> that many times ...

First position in the virtual array, not physical.  The actual drives are plugged into different drive bays and I'm swapping them into the VM by updating the disk's libvirt XML configuration.

> I don't know how much help this website will be for you, but take a look...
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid

Thanks!  I've spent a lot of time on that wiki, it's very helpful!  It's also why I've come to the mailing list for help, since I've been using md arrays since 2015 and haven't encountered an issue like this before.

> I would question why he is passing the disks in via virtio, rather than doing the raid outside the VM and passing in the raid6 block device.

I do it for the convenience of managing VMs.  It's for a homelab, so I won't always have remote hands to replace a disk and I like to have the spares free to use for other projects instead of tying them up as a hot-spare full-time.

> I don't believe that using MD-raid with devices virtualized and passed through via a virtio device is going to be valid/supportable.

I realize it's a bit wonky, but I'm surprised that this would be the case.  I wouldn't expect it to be that uncommon these days.  I guess I can always go back to zfs if you all feel like this is too crazy. :-P

If anybody has any other tips for debugging, it would be much appreciated.  I feel that ebpf might be helpful here, but haven't yet been able to quite figure out the right way to inspect the situation with BCC-tools.

Thanks everyone,
- Alan
