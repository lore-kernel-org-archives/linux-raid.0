From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: RFC: incremental container assembly when sequence numbers don't match
Date: Mon, 23 Sep 2013 09:30:10 +0200
Message-ID: <CAC9WiBgHFSX4oo2+N2wVL9EcbXFE-F9W9N+gYj1S6RHDUSZumA@mail.gmail.com>
References: <523CADFD.9050006@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523CADFD.9050006@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Martin

On Fri, Sep 20, 2013 at 10:20 PM, Martin Wilck <mwilck@arcor.de> wrote:
> Hi,
>
> I have spent a few days thinking about the problem of incremental
> container assembly when disk sequence numbers (aka event counters) don't
> match, and how mdadm/mdmon should behave in various situations.
> Before I start coding on this, I'd like to get your opinion - I may be
> overlooking something  important.

I was really suprised to see that this functionnality needs to be
implemented since in my understanding, it's the most important one, at
least for RAID1.

Isn't this already implemented for IMSM ? If so can't we use the same strategy ?

If not, isn't dmraid supporting it ? If so can't we use the same strategy ?

Thanks
-- 
Francis
