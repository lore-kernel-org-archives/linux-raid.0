From: Phil Turmel <philip@turmel.org>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 22:33:53 -0400
Message-ID: <e75dcc05-f0c2-2152-9d24-5ff42ea02657@turmel.org>
References: <20160823050947.GL32250@subspacefield.org>
 <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org>
 <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/25/2016 06:32 PM, Chris Murphy wrote:

>> It's possible, but why would you ever end up with a GPT in a partition?
> 
> In every case I've seen, it was user error. I haven't heard of things
> putting GPTs in partitions, and in a sense I'd say it's a bug if any
> utility lets a user do that. Nesting GPT's in partitions, bad idea,
> although it *should* be innocuous because it shouldn't be seen/honored
> by anything that doesn't go looking for it because it doesn't belong
> there.

It is possible to run gdisk or parted on /dev/sdX1 accidentally instead
of /dev/sdX.  Pretty simple user error.

It is also possible and appropriate if using v0.90 or v1.0 metadata on
an array and you partition the array itself.  Then it'll show up on
member 0, any mirror of member 0, and possibly on a parity disk (if
intervening blocks are zero).

Phil
