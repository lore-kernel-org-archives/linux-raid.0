From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm udev rules change
Date: Fri, 10 Apr 2009 19:22:38 +1000
Message-ID: <18911.4062.64497.82446@notabene.brown>
References: <3B6F676A-5ADD-4741-8269-D7D655C4E21E@redhat.com>
	<18908.21182.706667.310243@notabene.brown>
	<A9A53B64-720E-48DF-8377-5FCFDA2D6A7A@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday April 9
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 9, dledford@redhat.com wrote:
> On Apr 8, 2009, at 3:31 AM, Neil Brown wrote:
> >
> > And you are saying that if we uncomment the "#ENV{...." line, then we
> > only want it to fire on add devices.  So something like:
> >
> > ....
> > ACTION!="add|change", GOTO="md_end"
> > +ACTION=="change", GOTO="no_incr"
> >
> > # import data from a raid member and activate it
> > #ENV{ID_FS_TYPE}=="linux_raid_member", IMPORT{program}="/sbin/mdadm  
> > --examine --export $tempnode", RUN+="/sbin/mdadm --incremental  
> > $env{DEVNAME}"
> > # import data from a raid set
> > +LABEL="no_incr"
> > KERNEL!="md*", GOTO="md_end"
> > ......
> >
> > Is that correct?
> >
> > Your explanation certainly seems reasonable.
> 
> As I was reading through this, I certainly thought the above  
> implementation was reasonable, and then I got this new bug report:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=495034

I'm guessing this bug is because the line

TEST!="md/array_state", GOTO="md_end"

is missing from the udev rules file??  It is a relatively recent
addition.

> 
> I would do some investigation on your own machines, but given udev  
> change semantics, I think the proper course of action is simply to not  
> watch changes.

We absolutely have to watch change events on md devices.
When the "new" event happens, the array doesn't exist yet.  We have
just started building it.  Once it is fully assembled and started a
change event happens and it is on that event that we create /dev
files, look for partitions, and mount filesystems.

NeilBrown
