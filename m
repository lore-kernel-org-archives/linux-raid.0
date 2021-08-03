Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C18C4338F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 14:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5064A601FD
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 14:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhHCOX7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Aug 2021 10:23:59 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17010 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbhHCOX7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Aug 2021 10:23:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1628000616; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bt0COOgZpeDk9g93LtEp483FBeO17r4rrmm+ZaWf7ZTUpWzsVQWBTjXeobcWf8QXuKWsqmDuSfPKhNHhBp05t9CvvBfFNHIN5hxmdYGLXGa4eHVNpWF2QksTdXODxc2NHwGsfQIKN5t3UtK5Wwr6V9sVFvO/epid/i4iCX1sqU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1628000616; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LwxKGs1pJU9D2LnjIx/LkzIfcGdbhG0CWsnstdT6cZ0=; 
        b=YPt32sC7R5QqX57O60EQoNHJem360adGb0eg3cEENVHlFXNI3HXqMPqndtqvp+0lqYmjT2zDdGkDUX+SuLOaxRqCSnPXAZkorOjWTfo1gPwnciDmyU5pxpzW54rw66fDBFhid4McOfouAZM6BxYUN9wXs8NBb66nYBe7BU0Nu7M=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1628000615811985.1582916031455; Tue, 3 Aug 2021 16:23:35 +0200 (CEST)
Subject: Re: ANNOUNCE: mdadm 4.2-rc2 - A tool for managing md Soft RAID under
 Linux
To:     Felix Lechner <lechner@debian.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <23ff060b-0958-ffc5-7da6-64948ec3179c@trained-monkey.org>
 <CAFHYt56dQ6NHL+q8vbFvF4+Dq0c7ui+p64fi0uUo=game-hRMw@mail.gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <736a794b-26c5-4ea2-0464-3b2964684a45@trained-monkey.org>
Date:   Tue, 3 Aug 2021 10:23:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAFHYt56dQ6NHL+q8vbFvF4+Dq0c7ui+p64fi0uUo=game-hRMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/3/21 8:07 AM, Felix Lechner wrote:
> Hi Jes,
> 
> On Mon, Aug 2, 2021 at 10:14 AM Jes Sorensen <jes@trained-monkey.org> wrote:
>>
>> I am pleased to announce the availability of the second rc release of
>> mdadm-4.2
> 
> Thanks for this! I package mdadm in Debian. Did you push your most
> recent changes?
> 
> Could you furthermore tag the RC commits, please? For the previous
> release candidate 4.2-rc1 I found commit c11b1c3c, but it was
> untagged. In Debian, we replace the tilde with an underscore as
> described here [1] to get around Git's tag name restrictions. It would
> be great if you tag both commits in Git, please.

It's been pushed now, I forgot to push it after I tagged it and did the
release build. My bad, sorry. Thanks for pointing this out.

> Finally, a question about procedure: Do you folks copy people
> explicitly when replying even though they are on the list? Thank you
> for all your hard work!

I generally reply all, I like to have the thread directly in my inbox if
I am on the CC list.

Cheers,
Jes


> Kind regards
> Felix Lechner
> 
> [1] https://dep-team.pages.debian.net/deps/dep14/
> 

