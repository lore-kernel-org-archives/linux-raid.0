From: Thomas Arthur Oehser <tom@toms.net>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 6 Nov 2009 10:26:23 -0500
Message-ID: <20091106152623.GA13412@Toms.NET>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com> <17563.17224.85968.572754@cse.unsw.edu.au> <bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com> <17567.36792.303403.35943@cse.unsw.edu.au> <bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com> <4564B5C3.9050501@idgmail.se> <20091106131740.GA30506@Toms.NET> <4AF43B14.60804@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AF43B14.60804@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> Putting swap in a raid-0 will hang your computer as soon as sda, sdb or  
> sdc fails.
> Are you OK with that?

I'll move the swap to the partitions then, though it is a moot point as
the machine has 4G physical RAM and runs with a load such that usually
about 2G is cache... I assume that if it never swaps, it never matters.

But what I care about is the raid-5 shrinking issue... does anyone know
if there is a reasonably safe way to shrink a raid-5 device (size, not
number of drives) that is superblock format 0.90?  I assume the --grow
just forces the superblock based on the _device_, but if I shrank the
_device_ before I shrank the raid, it wouldn't find the superblock in
the first place...

-Tom

