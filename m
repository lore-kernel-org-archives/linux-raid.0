From: Karl Newman <siliconfiend@gmail.com>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Fri, 4 May 2012 06:54:18 -0700
Message-ID: <CAOOwNtJwEDZ2rYZ3-6sPzfjHkiRhJcfpyD-keyN=zBkFuGPgEg@mail.gmail.com>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
	<20120503155850.2900067d@notabene.brown>
	<CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
	<20120503165030.7e45c25b@notabene.brown>
	<CAOOwNtKko_db_wtqYOiGScq0ZOMbMK1L9DhDnm1geWhsQmLWNQ@mail.gmail.com>
	<20120504164738.3ddf4073@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120504164738.3ddf4073@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 3, 2012 at 11:47 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 3 May 2012 23:37:38 -0700 Karl Newman <siliconfiend@gmail.com> wrote:
>
>
>> Somehow gmail marked this email as read, too, so I missed it. Anyway,
>> that did it! With this patch applied I can successfully boot! I tested
>> the offending commit by itself first with the all-zeros uuid patch
>> applied and confirmed the bug was still present, then applied this
>> patch and the bug was gone. I also applied this patch to 3.4-rc5 and
>> confirmed that it was still good.
>
> Thanks - and good news.
>
> I'd still like to know how this bug manages to cause a crash (I create an
> array that have identical "mdadm -E" and "mdadm -X" output on an x86_64
> machine, and couldn't make it crash).
>
> I'll add a Reported-by: and Tested-by: for you and submit to Linus shortly.
>
>
>>
>> Thank you for your help on this issue, and thank you for your work as
>> a kernel developer and supporting this crucial component.
>
> A pleasure - specially when I get to work with helpful and responsive
> people :-)
>
> NeilBrown
>

Well, if it helps any, here's some history: This array dates back to
early 2006 and was created with the Gentoo mdadm tools available at
that time. I had one hard drive fail about 2 years ago and replaced it
with an identical model. During this recent testing I noticed that one
of the array devices had a metadata of versions of 0.90.02 where the
others were 0.90.00 so possibly that was a side effect of the
replacement. A few weeks ago I had the motherboard or CPU or something
fail on the machine, so I bought replacement hardware and am trying to
bring it up on the old array (which is why I'm using rc kernels--I
need the driver support introduced in 3.4). It was during this rebuild
that I discovered about bitmaps and thought it would be a good idea to
add it to the array, so I did. So, the array has had its metadata
written by at least 3 different versions of mdadm scattered over 6-1/2
years. Thus, it may be impossible (or at least extremely difficult)
for you to exactly re-create my situation unless you can scrounge the
old versions and simulate it. I'm suspecting my condition is an
oddball one, which is probably why nobody else has experienced it (or
at least google didn't find anyone talking about it).

Sincerely,

Karl
