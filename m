From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Wed, 08 Jun 2011 10:16:54 +0200
Message-ID: <4DEF2FF6.5060300@xunil.at>
References: <4DEE6A11.1030205@xunil.at> <4DEECD61.4030909@anonymous.org.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEECD61.4030909@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 08.06.2011 03:16, schrieb John Robinson:

> There may be a clever alternative, retaining single redundancy, if
> you don't mind buying one more disc, which I'm guessing you might do
> soon anyway as you're already 85% full. Or if not, it won't do too
> much harm to have a spare drive sitting on a shelf.

In fact I already have one ... but I can't use it as the 8 bays of that
server are already fully used. I could only attach that drive
temporarily with USB or so ...

> You can convert a 2-drive RAID1 to a 2-drive RAID5, then add the new 
> drive to double the size of the array, resize the PV, then move the
> PEs over from the other RAID1, then tear down that PV and RAID1, add
> one or both of those drives into the RAID5 and grow it to a RAID6.
> The only step at which you have a little less redundancy is while
> you're running the 3-drive RAID5 (well, it's still 1 drive but
> against 2 drives, instead of 1:1).

Clever idea, yes ... but a rather long way somehow ...

> On the other hand it might be easier to take a backup, which you 
> probably ought to do anyway!

Yep, I assume it will be that way: mv data aside, new array, data back
in ...

Thanks anyway, Stefan
