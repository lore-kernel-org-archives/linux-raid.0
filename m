From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: mdadm + raid1 of 2 disks and now need to add more
Date: Tue, 11 Apr 2006 18:13:02 -0400
Message-ID: <1144793582.26235.196.camel@localhost.localdomain>
References: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com>
	 <20060411145142.GR29446@strugglers.net>
	 <443BE6A6.5000202@unix-scripts.info>
	 <20060411203216.GV29446@strugglers.net>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060411203216.GV29446@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2006-04-11 at 20:32 +0000, Andy Smith wrote:
> On Tue, Apr 11, 2006 at 07:25:58PM +0200, Laurent CARON wrote:
> > Andy Smith wrote:
> > >On Tue, Apr 11, 2006 at 04:41:30PM +0200, Shai wrote:
> > >>I have two SCSI disks on raid1.
> > >>Since I have lots of reads from that raid, I want to add two more
> > >>disks to this raid so that read will be faster.
> > >>
> > >>How should I add the new disks?
> > >
> > >Is this possible with md currently:
> > >
> > >Create a RAID-10 on the two new disks specifying one disk missing
> > >from each mirror.
> > >
> > >Then copy data over and add the two existing disks letting it
> > >resync?
> > 
> > Why not growing the array with 2 more disks?
> 
> Well I guess a RAID-1 of 4 disks would be slightly more redundant
> than a 4 disk RAID-10, but it would have half the capacity, and the
> read performance would be very similar, no?

raid1 of 4 will give u read performance like 1 disk;
raid10 of 4 can give u read performance like aggregated 2 disks.


> 

