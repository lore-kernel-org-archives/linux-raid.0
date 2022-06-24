Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C22EC43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 01:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiFXBgM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiFXBgM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 21:36:12 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91FC5677D;
        Thu, 23 Jun 2022 18:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656034555;
        bh=ehaST28egKY42mdYfYoGyBZzbvG6StutgcG1sOUryjs=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=b8oobUos5me8IyxE8MRHvtXkTj2KEhAzabk9baPfEMmtpa9WzdSuzjO3Pc6obEjiZ
         OADaad0CneLjhMU8DF+KUHD77/QrVjpGJ9WYt/NLboicmPhrOz/KXxqFWQJbh5GO0w
         Cn5RktO71FzoIpHxI6823eEaTkWtcnlYx7ZiA/1w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MfpSb-1nT0YV20JF-00gKRy; Fri, 24
 Jun 2022 03:35:55 +0200
Message-ID: <33b6c180-2252-a444-3204-18cdbd02ff6b@gmx.com>
Date:   Fri, 24 Jun 2022 09:35:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Jani Partanen <jiipee@sotapeli.fi>, Song Liu <song@kernel.org>
Cc:     NeilBrown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
 <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
 <165593717589.4786.11549155199368866575@noble.neil.brown.name>
 <a09d6a24-6e1a-0243-ea4c-ac6d6127b69d@gmx.com>
 <CAPhsuW5iYWPkSyjqU0VUM-y+aQyFW6SkQXdjinu9ayz3DigcxA@mail.gmail.com>
 <6a2d3909-edb1-96e8-4a29-d954a2ebdaef@gmx.com>
 <8e682742-60b0-1820-7887-952b0963c783@sotapeli.fi>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: About the md-bitmap behavior
In-Reply-To: <8e682742-60b0-1820-7887-952b0963c783@sotapeli.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fB0GbCvrQGphSimARve8eBwFk9Bv6udz1bvRs2AoUgLOExcufXp
 kLlLjsoXIlWy+CXXPWTLMLoorSRVixWfTCvAeXuT9WiZlO8YpeivDsG1+ziQmunOY4KKyR9
 obSZMRLiW0mKx4wBWbdWV2UfLIKsCbabFBcpT/ZY4fHzDpSfYedyaDqLtnYpjyIOM/rPo1e
 fNzg4g0iZ2FRrUR4vjUvg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:L0TzWAc3WkQ=:iq+VUffVGMuqgKVH1n5hic
 DBaCVsyQDdMvE8d7VpUnCfNsWer+46MaHp/ekaNDAu8AxGXfxb59OxvtSOUkryTMAMG7GJA93
 EZsOsEFTX/88DOFPi8Flz6vn9lDPVVjWrTpTrfL18g/yRMKwUDznuIcIbrUaUx9Hd7xJiV4H+
 ecfmfdlJGGj3a1mXs5c8DqLSf/RLNXp/JUuKYPuRK2cU85kWGUesUnwgsKlfDyO0QWILn8MaI
 mN2ScHc0mITY7RFStjolGqLEWb51rpjd6pd3ANNJR+tB7duID8tPSL3uLu31fRUMAqUecSjrO
 973UNLvynTKlRiRIKtvYsjHMBGPZ1DJ832wLLp7p7Hzb3vwRD7LkmyovxNfR+jJ69FJ9/jQ15
 uYF7n8547B8jf+0/hr2uucO49JmhYDOKcwda4UoFu5oZV4tA+qEFMo1fk9QFRT3NmTZhHyYEy
 3agukW6GN8au4AFoxXt7M04pNeU9uGI8GqdcRL6W2jJI1T7clg8YmLiK/aGcBE2OXpdn+3Qv0
 e5ABM6jrK0UXyMlf6SgOH7asTPe9td686oOSyR4AKdq93hVc1yOOGReSfEOsBLDTnCuMJcia6
 rxFyeagxYXVFU5SKC6YShlCFpLSS0xkEnwkYoqYfvXAyq7QBiTblrixQwR1oL8+HUgC9Dj60H
 sAGUeAaHiSnSF28fDwcb5N8MpK3IK1/Lvnws53RpWzwZeyaW+n6zE33Oczd7O3Ef54YSCqLiW
 ClYRCpF7NglAuXBY43QGIzF4MbkDrNU+kksuUbze3s4QELeB0z0bFx58d3XcWHVhKndLVj7Xe
 BTHSdPgybO4AhfO13GjjGXRblvzDRl7hihsIj/tgNOb8ORSq7Z+aK6HPUyJUWRJj/UlzyYadH
 XnHS6WzZGXWZjkb3PHbFhCpuqvVzcC1XeUlb3j+TouwgNQBr6JBS1fnD/rn1v1mwRICRxonk2
 YpleIwTMXfRclWFlII0b5nLWp+0n+3Y5XsXsuSNTKoepush+PSpey2blmG7rk51i5INqAx3Pi
 wnKzRYiB9RAQjYffaGOLURYyqEoMvTUMu1E4JWLccHuT0qFdAX/fJC+N0uSkMtiJcMWZ93Tv3
 cmWtx/LpRFc7N13vr32esM+q2whp+Ud3KRMg3XEmQZ4q7+PTdnAQN+gPw==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/6/24 08:55, Jani Partanen wrote:
>
>
> Qu Wenruo kirjoitti 23/06/2022 klo 7.52:
>> That makes sense, but that also means the extent allocator needs extra
>> info, not just which space is available.
>>
>> And there would make ENOSPC handling even more challenging, what if we
>> have no space left but only partially written stripes?
>>
>> There are some ideas, like extra layer for RAID56 to do extra mapping
>> between logical address to physical address, but I'm not yet confident
>> if we will see new (and even more complex) challenges going that path.
>
> Isn't there already in btrfs system in place for ENOSPC situation?

It's not perfect, we still have some of reports of ENOSPC in the most
inconvenient timing from time to time.

> You
> just add some space temporaly?

That is not a valid solution, not even a valid workaround.

> Thats what I remember when I was playing
> around with different situations with btrfs.

The situation is improving a lot recently, but it's still far from
write-in-place fs level.

> For me bigger issue with btrfs raid56 is the fact that scrub is very
> very slow. That should be one of the top priority to solve.

In fact, that's caused by the way how we do scrub.
We start a scrub for each device, this is mostly fine for regular
profiles, but a big no no to RAID56.

Since scrub a full stripe will read all data/P/Q from disk, it makes no
sense to scrub a full stripe multiple times.

That would be a target during the write-intent bitmap, as we will rely
on scrub to re-sync the data at recovery time.


After that, I'll try to create a better, RAID56 friendly interface for
scrub ioctl.

Thanks,
Qu

>
> // JiiPee
