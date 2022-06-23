Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A58C43334
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 05:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiFWFK5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 01:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiFWFKi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 01:10:38 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5708C1E;
        Wed, 22 Jun 2022 21:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655959970;
        bh=kh15OWUe5m+BBkNqFLd2cgLxUlZXYtqKFnXrKdPwN+I=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=FLMgj3piEnBhhPrg/z6tmsVnYRR3XN0jpxuV7OphzY0p3roRSSt+4AQNwQpxsYhZr
         ouddmGHMtxQ17I0+NMc7EYO+ffreFBbRvnhIEiHAa+pRKAMk5M4CfD6xSbMoCpN7un
         kSRWWEDk/fmECGZF12NjjtGRLWOTH/GOujzYw+iw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MrhQC-1nIkvl0yeK-00nhiG; Thu, 23
 Jun 2022 06:52:49 +0200
Message-ID: <6a2d3909-edb1-96e8-4a29-d954a2ebdaef@gmx.com>
Date:   Thu, 23 Jun 2022 12:52:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>
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
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: About the md-bitmap behavior
In-Reply-To: <CAPhsuW5iYWPkSyjqU0VUM-y+aQyFW6SkQXdjinu9ayz3DigcxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QYTMla+/oaBEINDchVM8SdPJ8GbUNvfOziGh03ZvEpWftEhQpf8
 rWjnTRkyYvdwNUDZkmgxOYZT1733CbrtgEqbfJqiLM2/l+PpHlHm4nIMa+769+jc62SoKfP
 rZ3zu37mZSK+aStqrE//BqqXdpJPbHicd35T7VInkt7xspvn57iF94nQp4J/eNd1QgSmAiX
 AE/hZxNwXwD9R529z8Qcg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JcLXe9nLmBY=:EhYkyPgX3uAwi3NLh6tOBw
 Rb7R5z7HorEY9Z/StlrX65DUj2V4rJvJQpxsNuMJDN+81pzgt/YUwVPj/RO3wVsMFku6XkDQ9
 3bKzxKBAC7u1KoSQeS+pgjkdNhuqnpbtW3oqZWr0SvxNTTvUdS98JwFSuqmqd7+S90sWuhfS4
 y/kcrQpfU1MBQFzw2U9YtwL+aWOI9KMLrZ0MO6+6uCzTlQg8w3NNcFtvuBoj+DzlKKBxu2mfr
 8Ele/JHyrzxxctCyzZf7y9eBQ24ROD387gbqyTwdCRQaylvNWRbqZqWZael5wkPH7dUkrG5ED
 rZVjWm1kV6/8s6nZIyFor4wcAQ64y4Z2UNKdXhuLyzpoLkxcjxAO5OzJX+g2QhqlyiUxpDIvi
 MhOdmjuVLPOzQxTbPNiA9JoMnNtSFLqzwK2hFMx0JAqk9q82ndXbU6Wmx8EK4Ir7Vvi9++HRU
 3fWdz/FJn+Dlo88AVU8NR0lqrhTuBQoVSWsWKarJGrmVMWwzjvStjqwEtxwJYr5iSEb7Ao1HY
 2EdGMK79zxTb0T4BiYaF+zq6b1Vl2TrjxFak6iWZXibBKvpROOXm/pYyLjQmwvN6pODOcxcqA
 RTh/uuW8yngDDiLL4YsXw6r5rxlX0wy5Z3l5b2HXweohBTmU/xt/Kg2RNHL7m2zcVWhHXwXhs
 erzo5tM9vBetgXv14KNLsIu33x5mIf5SNC4pNGUbEdOJRzwCcXCdX/nOdWcK8nuS9ChAnFtse
 z3OEK5rZljjcy5uLxToxLbA9KJD16hrxtnm8JkctEASpQaQRCvqpbrgroWRacedXPlBc9gVil
 r6RRNqgUZUgIrN/y+VB8gLVgfhiQ2b7WLsRZpAb0Gg4CxNKWhZ7IZ0UWUEqIDBMIZEi2JqmtJ
 b7OCreDLGEWzbfvbMJUiI+IGVzqt3IpnQ1wJl1/xAemwxuSBmixwjUaK2Lk7n1RVnQ3prf5GT
 Xu0lsIJTTQhx8gbmeoUUsKqiPoGuCaOpqWN87d+zxc19yfAXL5lFpr97mjQmk3k8gZNSLwxYI
 sniZcK/jE9sNKbPuAksmjXvWOPbIDJTf3jjEesND+cswEs7KmAJ8JRHd9TTq4ipde2zunbEtc
 hrMOU9OS+CgNGqXr3koDQg1mzrRFEeubNdZM7k0LOflw1pch9UKoBB6Qg==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/6/23 11:32, Song Liu wrote:
> On Wed, Jun 22, 2022 at 5:39 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>
> [...]
>> E.g.
>> btrfs uses 64KiB as stripe size.
>> O =3D Old data
>> N =3D New writes
>>
>>          0       32K     64K
>> D1      |OOOOOOO|NNNNNNN|
>> D2      |NNNNNNN|OOOOOOO|
>> P       |NNNNNNN|NNNNNNN|
>>
>> In above case, no matter if the new write reaches disks, as long as the
>> crash happens before we update all the metadata and superblock (which
>> implies a flush for all involved devices), the fs will only try to read
>> the old data.
>
> I guess we are using "write hole" for different scenarios. I use "write =
hole"
> for the case that we corrupt data that is not being written to. This hap=
pens
> with the combination of failed drive and power loss. For example, we hav=
e
> raid5 with 3 drives. Each stripe has two data and one parity. When D1
> failed, read to D1 is calculated based on D2 and P; and write to D1
> requires updating D2 and P at the same time. Now imagine we lost
> power (or crash) while writing to D2 (and P). When the system comes back
> after reboot, D2 and P are out of sync. Now we lost both D2 and D1. Note
> that D1 is not being written to before the power loss.

For that powerloss + device lose case, journal is the only way to go,
unless we do extra work to avoid partial write.

>
> For btrfs, maybe we can avoid write hole by NOT writing to D2 when D1
> contains valid data (and the drive is failed). Instead, we can write a n=
ew
> version of D1 and D2 to a different stripe. If we loss power during the =
write,
> the old data is not corrupted. Does this make sense? I am not sure
> whether it is practical in btrfs though.

That makes sense, but that also means the extent allocator needs extra
info, not just which space is available.

And there would make ENOSPC handling even more challenging, what if we
have no space left but only partially written stripes?

There are some ideas, like extra layer for RAID56 to do extra mapping
between logical address to physical address, but I'm not yet confident
if we will see new (and even more complex) challenges going that path.

>
>>
>> So at this point, our data read on old data is still correct.
>> But the parity no longer matches, thus degrading our ability to tolerat=
e
>> device lost.
>>
>> With write-intent bitmap, we know this full stripe has something out of
>> sync, so we can re-calculate the parity.
>>
>> Although, all above condition needs two things:
>>
>> - The new write is CoWed.
>>     It's mandatory for btrfs metadata, so no problem. But for btrfs dat=
a,
>>     we can have NODATACOW (also implies NDOATASUM), and in that case,
>>     corruption will be unavoidable.
>>
>> - The old data should never be changed
>>     This means, the device can not disappear during the recovery.
>>     If powerloss + device missing happens, this will not work at all.
>>
>>>
>>> You must either:
>>>    1/ have a safe duplicate of the blocks being written, so they can b=
e
>>>      recovered and re-written after a crash.  This is what journalling
>>>      does.  Or
>>
>> Yes, journal would be the next step to handle NODATACOW case and device
>> missing case.
>>
>>>    2/ Only write to location which don't contain valid data.  i.e.  al=
ways
>>>      write full stripes to locations which are unused on each device.
>>>      This way you cannot lose existing data.  Worst case: that whole
>>>      stripe is ignored.  This is how I would handle RAID5 in a
>>>      copy-on-write filesystem.
>>
>> That is something we considered in the past, but considering even now w=
e
>> still have space reservation problems sometimes, I doubt such change
>> would cause even more problems than it can solve.
>>
>>>
>>> However, I see you wrote:
>>>> Thus as long as no device is missing, a write-intent-bitmap is enough=
 to
>>>> address the write hole in btrfs (at least for COW protected data and =
all
>>>> metadata).
>>>
>>> That doesn't make sense.  If no device is missing, then there is no
>>> write hole.
>>> If no device is missing, all you need to do is recalculate the parity
>>> blocks on any stripe that was recently written.
>>
>> That's exactly what we need and want to do.
>
> I guess the goal is to find some files after crash/power loss. Can we
> achieve this with file mtime? (Sorry if this is a stupid question...)

There are two problems here:

1. After power loss, we won't see the mtime update at all.
    As the mtime update will be protected by metadata CoW, since the
    powerloss happens when the current transaction is not committed,
    we will only see the old metadata after recovery.

    Thus to btrfs, at next reboot, it can not see the new mtime at all.

    AKA everything CoWed is updated atomically, we can only see
    trnsaction last committed.

    Although there is something special like log tree for fsync(), it has
    its own limitation (can not happen across transaction boundary), thus
    still not suitable for things like random data write.

2. Will not work for metadata, unless we scrub the whole metadata at
    recovery time
    The core problem here is graduality.
    The target file can be in TiB size, or for the whole metadata.

    Scrubbing such large range before allowing user to do any write can
    lead to super unhappy end users.

So for now, as a (kinda) quick solution, I'd like to go write-intent
bitmap first, then journal, just like md-raid.

Thanks,
Qu


>
> Thanks,
> Song
