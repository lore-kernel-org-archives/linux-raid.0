From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: paralellism of device use in md
Date: Wed, 18 Jan 2006 08:41:42 +0100
Message-ID: <dqkrfm$9k9$1@sea.gmane.org>
References: <20060117120927.GU7017@strugglers.net> <43CD8A73.90703@nsr500.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Moore <linux-raid@nsr500.net> wrote:
> Andy Smith wrote:
>> Are reads from a 2 device RAID-1 twice as fast as from a single
> md14 : active raid0 sdb13[1] sda13[0]
> md13 : active raid1 sdb12[1] sda12[0]
>
> /dev/md14:
>   Timing buffered disk reads:  272 MB in  3.01 seconds =  90.37 MB/sec
> /dev/md13:
>   Timing buffered disk reads:  164 MB in  3.00 seconds =  54.67 MB/sec

And this is exactly the strange thing which I'm also experiencing and
which was asked a lot of times on this list already, IIRC.

Why is the single-stream read-performance of a RAID1 so much worse than
the read-performance of a RAID0. A RAID1 should easily be able to gain
(or perhaps even advance, since it's not bound to chunk borders) the
read-performance of a RAID0.

As far as I can see, RAID1 only does that in case of lots of parallel
scheduled read-requests. Would it probably make sense to split one
single read over all mirrors that are currently idle?


regards
   Mario
-- 
I've never been certain whether the moral of the Icarus story should
only be, as is generally accepted, "Don't try to fly too high," or
whether it might also be thought of as, "Forget the wax and feathers
and do a better job on the wings."            -- Stanley Kubrick

