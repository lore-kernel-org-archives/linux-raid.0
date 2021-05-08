Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08417C433ED
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 14:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C392D610A0
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 14:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhEHOL6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 8 May 2021 10:11:58 -0400
Received: from open-std.org ([93.90.116.65]:33070 "EHLO www.open-std.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhEHOL5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 8 May 2021 10:11:57 -0400
X-Greylist: delayed 1407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 May 2021 10:11:56 EDT
Received: by www.open-std.org (Postfix, from userid 500)
        id 9F11A356EC5; Sat,  8 May 2021 15:47:26 +0200 (CEST)
Date:   Sat, 8 May 2021 15:47:26 +0200
From:   keld@keldix.com
To:     d tbsky <tbskyd@gmail.com>
Cc:     Reindl Harald <h.reindl@thelounge.net>,
        list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210508134726.GA11665@www5.open-std.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com> <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net> <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 07, 2021 at 09:28:35AM +0800, d tbsky wrote:
> Reindl Harald <h.reindl@thelounge.net>
> > Am 06.05.21 um 11:57 schrieb d tbsky:
> > > if losing two disks will madam find out the raid can be rebuilded safely or not?
> >
> > it's pretty simple
> >
> > * if you lose the wrong disks all is gone
> > * if you lsoe the right disks no problem
> 
>  that's seems reasonable. I will give it a try.


My understanding is that raid10 - all layouts - are really raid0 and then raid 1 on top.
If you loose two disks you loose the whole raid in 2 out of 3 cases in a 4 disk setup.
If it was raid0 over a raid1 you would only lose the whole raid in one out of 3.

               raid1
           raid0  raid0      
           d1 d2  d3 d4


gone d1+d2  survives d3+d4
gone d1+d3  dead
gone d1+d4  dead


should be.

            raid0
         raid1  raid1
         d1 d2  d3 d4

gone d1+d2  dead
gone d1+d3  survives
gone d1+d4  survives

keld
