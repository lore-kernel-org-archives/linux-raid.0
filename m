From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: libata hotplug and md raid?
Date: Wed, 10 Jan 2007 17:55:42 -0500
Message-ID: <10375.1168469742@mdt.dhcp.pit.laurelnetworks.com>
References: <17716.14507.187306.941214@cse.unsw.edu.au>
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: Your message of "Tue, 17 Oct 2006 11:58:03 +1000."
             <17716.14507.187306.941214@cse.unsw.edu.au>
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids


I am currently looking at using md RAID1 and libata hotplug under 2.6.19.
This relevant thread from Oct 2006

http://thread.gmane.org/gmane.linux.raid/13321/focus=13321

tailed off after this proposal from Neil Brown:

> On Monday October 16, mlord@pobox.com wrote:
> > > So the question remains: How will hotplug and md work together?
> > > 
> > > How does md and hotplug work together for current hotplug devices?
> > 
> > I have the same questions.
> > 
> > How does this work in a pure SCSI environment? (has it been tested?)
> > If something should change, should those changes be in the MD layer?
> > Or can this *really* all be done nicely from userspace?  How?
> 
> I would imagine that device removal would work like this:
>  1/  you unplug the device
>  2/ kernel notices and generates an unplug event to udev.
>  3/ Udev does all the work to try to disconnect the device:
>      force unmount (though that doesn't work for most filesystems)
>      remove from dm
>      remove from md (mdadm /dev/mdwhatever --fail /dev/dead --remove /dev/dead)
>  4/ Udev removes the node from /dev.
> 
> udev can find out what needs to be done by looking at
> /sys/block/whatever/holders. 
> 
> I don't know exactly how to get udev to do this, or whether there
> would be 'issues' in getting it to work reliably.  However if anyone
> wants to try I'm happy to help out where I can.
> 
> NeilBrown

Not seeing any subsequent reports on the list, I decided to try
implementing the proposed approach.  The immdiate problem I ran into
was that /sys appears to have been cleaned up before udev sees the
remove event and the /sys/block/whatever/holders file is no longer
even around to consult at that point.  As a secondary problem, the
/dev/dead file is also apparently removed by udev before any programs
mentioned in removal rules get a chance to run so there is no longer any
device to provide to mdadm to remove at the time the program does run,
even if it had been possible to find out what md files were holders of
the removed block device to begin with.  Do I have the details right?
Any new thoughts in the last few months about how it would be best to
solve this problem?
--
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
