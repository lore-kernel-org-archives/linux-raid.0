From: David Brown <david@westcontrol.com>
Subject: Re: Raid 6--best practices
Date: Fri, 20 Jan 2012 11:24:18 +0100
Message-ID: <jfbfk6$gqk$1@dough.gmane.org>
References: <4F173D3D.6070902@npr.org>,<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org> <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/01/2012 03:54, Shain Miley wrote:
> Hello all,
> I have been doing some research into possible alternatives to our
> OpenSolaris/ZFS/Gluster file server.  The main reason behind this is,
> due to RedHat's recent purchase of Gluster, our current configuration
> will no longer be supported and even before the acquisition, the upgrade
> path for the OpenSolaris/ZFS stack was murky at best.
>
> The current servers in question consist of a total of 48, 2TB drives.
> My thought was that I would setup a total of 6 RAID-6 arrays (each
> containing 7 drives + a spare or a flat 8 drive RAID-6 config) and place
> LVM + XFS on top of that.
>

I wouldn't bother dedicating a spare to each RAID-6 - I would rather 
have the spares in a pool that can be used by any of the low-level raids.

Before it is possible to give concrete suggestions, it is vital to know 
the usage of the system.  Are you storing mostly big files, mostly small 
ones, or a mixture?  What are the read/write ratios?  Do you have lots 
of concurrent users, or only a few - and are they accessing wildly 
different files or the same ones?  How important is uptime?  How 
important are fast rebuilds/resyncs?  How important is array speed 
during rebuilds?  What sort of space efficiencies do you need?  What 
redundancies do you really need?  What topologies do you have that 
influence speed, failure risks, and redundancies (such as multiple 
controllers/backplanes/disk racks)?  Are you using hardware raid 
controllers in this mix, or just software raid?  Are you planning to be 
able to expand the system in the future with more disks or bigger disks?

There are lots of questions here, and no immediate answers.  I certainly 
wouldn't fixate on a concatenation of RAID-6 arrays before knowing a bit 
more - it's not the only way to tie together 48 disks, and it may not be 
the best balance.

mvh.,

David




> My questions really are:
>
> a)    What is the maximum number of drives typically seen in a RAID-6
> setup like this?  I noticed when looking at the Backblaze blog, that
> they are using RAID-6 with 15 disks (13 + 2 for parity).  That number seemed
> kind of high to me....but I was wondering what others on the list thought.
>
> b)    Would you recommend using any specific Linux distro over any other?
> Right now I am trying to decide between Debian and Ubuntu....but I would be open to
> any others...if there was a legitimate reason to do so (performance, stability, etc) in terms of the Raid codebase.
>
> Thanks in advance,
>
> Shain
>


