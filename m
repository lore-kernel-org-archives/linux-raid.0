Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E117C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 09:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B0B961405
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 09:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhD2JaR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Apr 2021 05:30:17 -0400
Received: from ns1.ant.gliwice.pl ([195.66.73.63]:47712 "EHLO
        mail.ant.gliwice.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhD2JaR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Apr 2021 05:30:17 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 05:30:17 EDT
Received: from matkor-hp.localnet (unknown [93.179.197.152])
        by mail.ant.gliwice.pl (Postfix) with ESMTPSA id 301AE61292;
        Thu, 29 Apr 2021 11:21:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ant.gliwice.pl;
        s=default; t=1619688103;
        bh=owkcJVMrnPu+w/7GQbh7otmNGJsDrgxnuiUm0NENk4E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gaIMotZ0Og2Pl2YOdIyQXmm7h94msRlWD6oXtr55pdyEY5qvr9nnfdTn2uEh5Oij0
         npJvRPCXKkzx6TGnb9Zh2PhHutwg1iDH23VNveE4VOEz0QURIoRIwVMZ0y2zo1TZbW
         LLMwPKwMBy85v3yVwXPia21MK9WQq0In3WJ0ZM38bvGbmHR7xCWVvtzHmvOxVjXXIb
         c+7k+NUJGjrHj8CV4nIwz0O1gNPmcw6T7SfSSmF2AErGgZl2T71yLjdNMkcYfqGt/C
         KJeww73qBud10a+eRRal2UUPmZy6Sm5EDqIb4phTRkRKyXcnbj5hx689cbIA7RRYWT
         hMWcjkH2N0mWw==
From:   Mateusz <mateusz-lists@ant.gliwice.pl>
To:     list Linux RAID <linux-raid@vger.kernel.org>,
        d tbsky <tbskyd@gmail.com>
Subject: Re: add new disk with dd
Date:   Thu, 29 Apr 2021 11:21:40 +0200
Message-ID: <7903054.T7Z3S40VBb@matkor-hp>
In-Reply-To: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
References: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On czwartek, 29 kwietnia 2021 10:52:21 CEST d tbsky wrote:
> however dd may also copy the mdadm superblock which include internal
> bitmap(since I don't caculate correct size). I don't know if there is
> risk that mdadm will be confused with the bitmap in new disk. although
> I have tried and it seems work fine.
> should I disable internal bitmap before add new disk?=20

No.

> or mdadm will
> understand the superblock/bitmap at new disk is invalid and just
> overwrite everything?

Should in most cases [1], but IMHO it's good idea to
mdadm --zero-superblock /dev/YOU_ARE_SURE_IS_ONE_YOU_WANT_TO_ADD
before adding disk already used somewhere else.

BTW,  IMHO it's better to clone partition layout, and than install bootload=
ers=20
instead of dding disk.

[1] If disk/part was already used / cloned in same array it's bitmap may be=
=20
recognized, not synced, resulting likely broken array.

=2D-=20
Mateusz=20
(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=BCn=
i=C5=9B,
	kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
		Nikos Kazantzakis - "Grek Zorba"



