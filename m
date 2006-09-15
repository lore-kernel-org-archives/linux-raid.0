From: Lem <l3mming@iinet.net.au>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Fri, 15 Sep 2006 17:51:12 +1000
Message-ID: <1158306672.6349.8.camel@localhost.localdomain>
References: <1155987607.7207.23.camel@localhost.localdomain>
	 <17641.25141.373827.77279@cse.unsw.edu.au>
	 <1156200453.19051.13.camel@fc6.xsintricity.com> <44FC68A8.4010002@tmr.com>
	 <1157867968.3920.4.camel@localhost.localdomain>  <4509DABC.7040205@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4509DABC.7040205@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2006-09-14 at 18:42 -0400, Bill Davidsen wrote:
> Lem wrote:
> 
> >On Mon, 2006-09-04 at 13:55 -0400, Bill Davidsen wrote:
> >
> >  
> >
> >>May I belatedly say that this is sort-of a kernel issue, since 
> >>/proc/partitions reflects invalid data? Perhaps a boot option like 
> >>nopart=sda,sdb or similar would be in order?
> >>    
> >>
> >
> >Is this an argument to be passed to the kernel at boot time? It didn't
> >work for me.
> >
> 
> My suggestion was to Neil or other kernel maintainers. If they agree 
> that this is worth fixing, the option could be added in the kernel. It 
> isn't there now, I was soliciting responses on whether this was desirable.

My mistake, sorry. It sounds like a nice idea, and would work well in
cases where the RAID devices are always assigned the same device names
(sda, sdb, sdc etc), which I'd expect to be the case quite frequently.

> Unfortunately I see no way to avoid data in the partition table 
> location, which looks like a partition table, from being used.

Perhaps an alternative would be to convert an array with
non-partition-based devices to partition-based devices, though I
remember Neil saying this would involve relocating all of the data on
the entire array (perhaps could be done through some funky resync
option?).

I'm not a developer, those are just my thoughts. Thanks for all the fine
work guys.

Cheers,
Lem

