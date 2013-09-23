From: Martin Wilck <mwilck@arcor.de>
Subject: Re: RFC: incremental container assembly when sequence numbers don't
 match
Date: Mon, 23 Sep 2013 22:30:04 +0200
Message-ID: <5240A4CC.7060908@arcor.de>
References: <523CADFD.9050006@arcor.de> <CAC9WiBgHFSX4oo2+N2wVL9EcbXFE-F9W9N+gYj1S6RHDUSZumA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgHFSX4oo2+N2wVL9EcbXFE-F9W9N+gYj1S6RHDUSZumA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 09/23/2013 09:30 AM, Francis Moreau wrote:
> Hello Martin
> 
> On Fri, Sep 20, 2013 at 10:20 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> Hi,
>>
>> I have spent a few days thinking about the problem of incremental
>> container assembly when disk sequence numbers (aka event counters) don't
>> match, and how mdadm/mdmon should behave in various situations.
>> Before I start coding on this, I'd like to get your opinion - I may be
>> overlooking something  important.
> 
> I was really suprised to see that this functionnality needs to be
> implemented since in my understanding, it's the most important one, at
> least for RAID1.

Please don't confuse this with the problem you are currently seeing,
which looks more like a bug we need to find yet.

I agree this is important, that's why I wrote this RFC, but it's not the
most important functionality. AFAICS, the cases that won't work
optimally with the current code are pretty rare corner cases. They
should be fixed but it isn't too urgent. The "normal" case is that after
a failure, you add a new disk (possibly the same one again, as you did
in your late testing), and auto-recovery is started.

> Isn't this already implemented for IMSM ? If so can't we use the same strategy ?

I don't know the IMSM code well enough to tell. I had a look at it and
didn't find code treating this situation, but it's a lot of code, so I
may be missing something. I will set up test cases soon.

> If not, isn't dmraid supporting it ? If so can't we use the same strategy ?

I think dmraid doesn't have this problem because it doesn't do
incremental assembly, as mdadm does. Rather, after udev has settled,
dmraid scans its devices; this is similar to running "mdadm -As" at that
stage. If you do this, you don't have the problem that possibly an
already running array needs to change state because a new disk with more
recent meta data is added. Rather, you choose the "best" meta data at
assembly time. It would be possible to change the scanning behavior for
mdadm by changing the udev rules such that normal assembly is done after
udev has settled, rather than incremental on-the-fly assembly.

Martin
