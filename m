Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBD9C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 07:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiF0HN4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiF0HNz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 03:13:55 -0400
Received: from pott.psjt.org (pott.psjt.org [46.38.234.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F6326F2
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 00:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=psjt.org;
        s=psjt01; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
        In-Reply-To:Date:References:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5d7sTNs3B+sahFK4V6ihRcgkNb3DqWSD6+SIAKxQYuQ=; b=W38CNs6X+WCrhGqAK7PfwZ4ZPn
        uWEJHcb+M1c6wt7zWfoE5S9bpcLtTjopJbEYEv9aQGVRS+jRhLkn9iDDXMdXpPLitwuskboDjLl9j
        7QwJ3MQC2PPATXuIWTsz5wrF6HXjQRC1ge+sThxvlhyutWlvrIWB3pUWEo+ESyO9ruwkTDy1bXiHU
        NuAT5YPV2s2986GYKbc5jCisKLJj8sp+zRsMrjouB+L75BcL4SgUCZiJ7Czkiv89SfJDNot9gJZzj
        xbH/sm87y4EVpLH22SWjF/fHKJpZFhNeQcDn1/P4RN6Yv7lPxNsQ+YQGlLXBbaRUYDxV3ecz1ubWg
        5oFTaIqw==;
Received: from [10.1.1.3] (helo=malachite.psjt.org)
        by pott.psjt.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <stephan@psjt.org>)
        id 1o5iwO-0005sw-Hz; Mon, 27 Jun 2022 09:13:49 +0200
Received: from blaulicht.dmz.brux ([10.1.1.10])
        by malachite.psjt.org with esmtp (Exim 4.95)
        (envelope-from <stephan@psjt.org>)
        id 1o5iwP-0007FC-CY;
        Mon, 27 Jun 2022 09:13:49 +0200
Received: from stephan by blaulicht.dmz.brux with local (Exim 4.95)
        (envelope-from <stephan@psjt.org>)
        id 1o5iwP-0004WM-Bv;
        Mon, 27 Jun 2022 09:13:49 +0200
From:   Stephan <linux@psjt.org>
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc:     Wols Lists <antlists@youngman.org.uk>, Stephan <linux@psjt.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
        <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
        <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
        <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
        <20220624232049.502a541e@nvm>
        <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
        <20220624234453.43cf4c74@nvm>
        <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
        <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
        <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
        <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
        <20220625030833.3398d8a4@nvm>
        <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
        <s6nh748amrs.fsf@blaulicht.dmz.brux>
        <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
        <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
Date:   Mon, 27 Jun 2022 09:13:49 +0200
In-Reply-To: <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org> (Pascal
        Hambourg's message of "Sun, 26 Jun 2022 23:46:03 +0200")
Message-ID: <s6n7d52poia.fsf@blaulicht.dmz.brux>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Pascal Hambourg <pascal@plouf.fr.eu.org> writes:

> Le 25/06/2022 =C3=A0 19:10, Wols Lists wrote=C2=A0:
>> On 25/06/2022 14:35, Stephan wrote:
>>>
>>> Does mdraid with metadata 1 work on the root filesystem w/o initramfs?
>
> No. Why would one not use an initramfs ?

An initramfs adds unnecessary intransparency to the system.=20=20

>> If you're using v1.0, then you could boot off of one of the mirror
>> members no problem.
>>
>> You would point the kernel boot line at sda1 say (if that's part of
>> your mirror). IFF that is mounted read-only for boot, then that's
>> not a problem.
>
> Mounting read-only does not guarantee that there won't be any
> write. See man mount(8) :
>
> -r, --read-only
>     Mount the filesystem read-only. A synonym is -o ro.
>
> Note that, depending on the filesystem type, state and kernel
> behavior, the system may still write to the device. For example, ext3
> and ext4 will replay the journal if the filesystem is dirty. To
> prevent this kind of write access, you may want to mount an ext3 or
> ext4 filesystem with the ro,noload mount options or set the block
> device itself to read-only mode, see the blockdev(8) command.

Good point.  Thus, there is no alternative to superblock 0.90 for root on
mdraid w/o initramfs.  This is the answer to the question why somebody
(like me) may need to use superblock 0.90.

>> Your fstab would then mount /dev/md0 as root read-write
>
> I don't think so. IME the root device in fstab is ignored, only the
> options are used.

This is some of the intransparency.  Will the / entry in the /etc/fstab
be copied to the initramfs to use it for mounting the real root
filesystem?  You imply that this is the case but the device will be
ignored.  Why?=20=20

Gru=C3=9F,
--=20
Stephan
