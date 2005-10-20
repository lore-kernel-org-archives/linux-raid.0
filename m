From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Thu, 20 Oct 2005 11:23:30 +0100
Message-ID: <43577022.5010306@robinbowes.com>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com> <43420091.9060601@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43420091.9060601@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>, Robin Bowes <robin-lists@robinbowes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith said the following on 04/10/2005 05:09:
> Yep, that's pretty much bang on.  The only thing you've missed is using 
> pvmove to physically move the data off the soon-to-be-decomissioned 
> PVs(/RAID arrays).
> 
> Be warned, for those who haven't used it before, pvmove is _very_ slow.

I've just been re-reading this thread.

I'd like to just check if I understand how this will work.

Assume the following setup (hypothetical).

VG:
big_vg - contains /dev/md1, /dev/md2; 240GB

PV:
/dev/md1 - 4 x 40GB drives (RAID5 - 120GB total)
/dev/md2 - 4 x 40GB drives (RAID5 - 120GB total)

LV:
big_lv - in big_vg - 240GB

Filesystems:
/home - xfs filesystem in big_lv - 240GB

Suppose I then add a new PV:
/dev/md3 - 4 x 300GB drives (RAID5 - 900GB total)

I want to replace /dev/md1 with /dev/md3

I use pvmove something like this:

# pvmove /dev/md1 /dev/md3

When this finishes, big_vg will contain /dev/md2 + /dev/md3 (1020GB 
total). /dev/md1 will be unused.

big_lv will still be using just 240GB of big_vg.

I then use lvextend to increase the size of big_lv

big_lv will now use all 1020GB of big_vg.

However, the /home filesystem will still just use 240GB of big_lv

I can then use xfs_growfs to expand the /home filesystem to use all 
1020GB of big_lv.

Have I missed anything?

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?
