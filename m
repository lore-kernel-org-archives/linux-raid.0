From: keld@keldix.com
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two disks, causing silent data corruption
Date: Sun, 30 Sep 2012 12:24:00 +0200
Message-ID: <20120930102400.GA17700@www5.open-std.org>
References: <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se> <152edbf7bdad33717477f174f94116b7@192.168.93.35> <20120925223227.130ef8e3@notabene.brown> <50628B39.90205@gooseman.cz> <20120926154107.1568a115@notabene.brown> <20120926082848.GA18616@www5.open-std.org> <5062C3FE.7090906@yuiop.co.uk> <20120926090803.GA21499@www5.open-std.org> <20120926092340.GA21935@www5.open-std.org> <5067F014.5020600@gooseman.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5067F014.5020600@gooseman.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jakub Hus?k <jakub@gooseman.cz>
Cc: John Robinson <john.robinson@yuiop.co.uk>, NeilBrown <neilb@suse.de>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Sep 30, 2012 at 09:09:08AM +0200, Jakub Hus?k wrote:
> Are you sure it's possible to design r10 f2 with the same performance 
> benefits of current implementation, which will be (in some cases) able 
> to survive 2-disk failure, when we talk about 4-disk array? IMHO it's 
> always a trade of between performance and redundancy. When you want to 
> survive with more failed drives, you can't spread the data and iops 
> among so many drives. But maybe it's just me trying to use the law of 
> conservation of energy in a wrong place :), I haven't studied raid 
> layouts so much.

Yes, I am sure we can design a better layout for raid10,far,
with the same performance characteristics..
The current layout can already survive 2 disk failures
for a 4 disk array, but the chances are only 33 % for surviving the 2 disk crash.
The new layout can survive in 66 % of the cases.
And the performance is completely the same.
That is why the new layout should be the default layout for raid10,far.
No performance difference but greatly improved survival chances.

> Just to make things clear: I have no problem with the redundancy level 
> of current r10f2, it was all just about the wrong handling of array failure.

Yes, that is understood. Anyway, my take is that both layouts need to be
supported by the kernel, for backwards compatibility. We need to have
kernel code that can handle all the existing raid10,far arrays already in production.

best regards
keld


> 
> Thanks
> Jakub Hus?k
> 
> On 26.9.2012 11:23, keld@keldix.com wrote:
> >On Wed, Sep 26, 2012 at 11:08:03AM +0200, keld@keldix.com wrote:
> >>On Wed, Sep 26, 2012 at 09:59:42AM +0100, John Robinson wrote:
> >>>On 26/09/2012 09:28, keld@keldix.com wrote:
> >>>[...]
> >>>>We have discussed earlier how to implement raid10,far that would mean
> >>>>better survival chances with more disks failing. This is not implemented
> >>>>yet.
> >>>No, but even if/when it is, there will still be some combinations of two
> >>>discs that you cannot afford to lose. The layout change to try to
> >>>improve redundancy will not be generic, as it doesn't work for an odd
> >>>number of discs, so the existing layout would have to be retained as an
> >>>option.
> >>Well, at least for backward compatibility we need an option for the 
> >>current layout.
> >>
> >>For odd number of disks, I do think we can improve the chances for more 
> >>failing disks, as
> >>discussed earlier.
> >To sum up: for raid10,f2 with odd numbers of disks, you can have a group 
> >of 3 disks and then
> >the rest of the disks ordered in pairs. Thus one disk in each of the pairs 
> >and one
> >disk in the 3-group all could fail and the raid would still be functional.
> >This is almost the same improvement as for the even numbered raid10,f2.
> >The scheme is easily generalised to raids with more than 2 copies.
> >
> >Best regards
> >Keld
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
