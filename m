Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE3DC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 19:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74EFE610E8
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 19:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhJ1TNr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhJ1TNq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Oct 2021 15:13:46 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AF9C061570
        for <linux-raid@vger.kernel.org>; Thu, 28 Oct 2021 12:11:18 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id b17so1296056qvl.9
        for <linux-raid@vger.kernel.org>; Thu, 28 Oct 2021 12:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4jLsBZH0HY2UzeTqFssM7TYJIeWBCX0sJXGbKQbs1Y=;
        b=Cz6PyL0Apib24ms/4/0xSSUwmev1vxNoPE0aJ6keEP7n7pKhkQSgIb4JTqXRt6Qszf
         iQJAD9OqmTHUnGZb3TjoMveEubCMORJt4L8Gp9KW5WQpAQjZv9EJv0jMsoO4jptiDYV5
         noOC5GbyruofYLdi8okGZzgabB+ScGoTYDyBNYHUo2xQc3lAcd2AdlrJAWdvCmakMkRU
         1k1qZqWpbzJvRgzXso/T1hp2u8YQil1vF5+w0P+OLe6XXwteFGc34ioJ93SYdSVzefXo
         TV0hA9lAi/okNE4Sb/Kbjtut98p6OUzgWYt3i64Qwhm4Y3hJ6w1xhOjo09caAkB+tb+p
         4c3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4jLsBZH0HY2UzeTqFssM7TYJIeWBCX0sJXGbKQbs1Y=;
        b=EY6NwkDTbFicS3YRwXfuox+HzBgkGhXoebZjcpqmiENfFsO5ZO6imzpezXL2j3cj/C
         AQcqKgVP9QCoZcy+pfFhMUw2Z/yp5d6axC48NrskULP8cC/d9g8bwlL1hxPG1T+NwWwR
         EEMGgvKRX5DOt1YG4aSO4nbXUbqwUqvJgvCavtoeWz5PmIHYnOZUfe4oSTiRRDtV83ks
         yokCKsWFOeRQjlLRpOdDh/wjIMMNZwSqhqCgbDZsagu+fhJU3IBASI3w7g6Ff49D+3v9
         wwSJi17KNKT7lcsI5mVnLPGPcKQffIxRXC70lKS487a/x+FNhGd2L412kmjz1ytQaT1a
         oStQ==
X-Gm-Message-State: AOAM531/7tVRLXOPEb70iYPwNehpICrhzd7APt+ln33yVsXdCo+3sgtj
        TQltPXCyj4nhq1lIeRaHeO8+Zz+X6nPc2hOywB1DU6Ja8bs=
X-Google-Smtp-Source: ABdhPJxTwFrQ8G9A7KcEb3tlksgOF9GXHuVUt08gyB6TXJaBvN7/piYPwM+/fT+xOxY6431UfcJRVxfCNy1yLaHHH98=
X-Received: by 2002:a05:6214:e84:: with SMTP id hf4mr6376386qvb.38.1635448277905;
 Thu, 28 Oct 2021 12:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211028133626.GX6557@justpickone.org> <752f98f7-1a2c-b29c-472a-5322fd37127d@youngman.org.uk>
In-Reply-To: <752f98f7-1a2c-b29c-472a-5322fd37127d@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 28 Oct 2021 14:11:06 -0500
Message-ID: <CAAMCDefsOFmMUHvi7H4bSEqLq=-tSRSL+CGKgt5Rh5KvXTAGTg@mail.gmail.com>
Subject: Re: growing a RAID5 array by adding disks later
To:     Wol <antlists@youngman.org.uk>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On mine I would partition the 8tb into 4tb partitions.

Then replace one of the 4tb partitions with an 4tb partition on an 8tb.

Then create a new 2 disk raid5 array with the old 4tb and the #2 8tb partition

Next add looks similar and you then have 3 disk raid5.

I have my array build of partitions of several disks such that when I
get a bad block on one of the partitions typically only one partition
gets thrown out of its array and when doing ops on the smaller
partitions I don't ever have any operation that takes anywhere close
to a full day.

I am using gpt so I also number the partitions such that they match
the last number of the md device like this:
md13 : active raid6 sde3[12] sdd3[1] sdb3[7] sdh3[8] sdg3[10] sdi3[11] sdf3[9]
      3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 0/6 pages [0KB], 65536KB chunk

that way I always know 13 gets a *3 device.

The above array was all 3tb disks originally, now 3 of them are
partitions on 6tb disks and I have a 4 disk raid6 added into a
separate fs using the one "good" 3tb disk I removed, and the 3 2nd
partitions on the 6tb disks (the other 2 3tb were having sector read
issues).

This lets me get a bit of extra space without doing an immediate buy
of all 7 new 6TB disks at once.

On Thu, Oct 28, 2021 at 11:44 AM Wol <antlists@youngman.org.uk> wrote:
>
> On 28/10/2021 14:36, David T-G wrote:
> > Hi, all --
> >
> > It's time to replace a few 4T disks in our little server.  I don't
> > particularly want to go back with more 4T disks (although the same
> > model sure are cheap these days! :-) and figure I should put in larger
> > drives as I go.  I am then left with weighing simple $/G vs total price;
> > bigger drives can be cheaper per volume but of course more overall.
> > My first approach is to put newer, larger drives in place and expect to
> > grow into the empty space when all of the old ones have been swapped out.
> >
> > But ...  If I were to splurge and buy 3ea big drives to replace all of
>
> Does that mean you have three drives currently?
>
> > the space that I have now, how practical is it to grow that RAID5 array
> > by adding additional drives later?
>
> Very. mdadm --add ...
>
> > My eventual goal would be to get
> > to 8-10 devices in a RAID6 layout (two "extras"), but of course I can't
> > afford that today.  Do I have an easy path to get there in the long run?
> >
> > [BTW, can I convert an array from RAID5 to RAID6, too?]
> >
> > On the other hand, I do have the empty slots (currently filled with
> > scratch drives here and there), so I could both replace my aging drives
> > and add more and just grow this array 1) if the growth idea is practical
> > and 2) if I don't get to splurge.
> >
> Okay, buy your new 8TB drives in pairs (unless you've got a bunch of
> scratch 4TB drives).
>
> Assuming you've got a 3x4TB array this will get you to a 3x8TB in one hit...
>
> mdadm --replace 4TB with 8TB
> Twice.
>
> mdadm --create --level=striped 4TB 4TB (to give you an 8TB raid0)
>
> mdadm --replace 4TB with 8TB raid0 mirror
>
> You may then be able move the data off your scratch drives onto the
> array, create another 8TB raid0, and add that for a raid6. You can then
> just add 8TB drives bit by bit.
>
> Read the website - there#s a lot of info there...
> https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> Cheers,
> Wol
