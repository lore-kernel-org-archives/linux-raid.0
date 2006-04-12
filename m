From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: mdadm + raid1 of 2 disks and now need to add more
Date: Wed, 12 Apr 2006 09:22:39 -0400
Message-ID: <1144848159.25488.8.camel@localhost.localdomain>
References: <200604120207.k3C27N228357@www.watkins-home.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200604120207.k3C27N228357@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Andy Smith' <andy@lug.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2006-04-11 at 22:07 -0400, Guy wrote:
> 
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Ming Zhang
> } Sent: Tuesday, April 11, 2006 6:13 PM
> } To: Andy Smith
> } Cc: linux-raid@vger.kernel.org
> } Subject: Re: mdadm + raid1 of 2 disks and now need to add more
> } 
> } On Tue, 2006-04-11 at 20:32 +0000, Andy Smith wrote:
> } > On Tue, Apr 11, 2006 at 07:25:58PM +0200, Laurent CARON wrote:
> } > > Andy Smith wrote:
> } > > >On Tue, Apr 11, 2006 at 04:41:30PM +0200, Shai wrote:
> } > > >>I have two SCSI disks on raid1.
> } > > >>Since I have lots of reads from that raid, I want to add two more
> } > > >>disks to this raid so that read will be faster.
> } > > >>
> } > > >>How should I add the new disks?
> } > > >
> } > > >Is this possible with md currently:
> } > > >
> } > > >Create a RAID-10 on the two new disks specifying one disk missing
> } > > >from each mirror.
> } > > >
> } > > >Then copy data over and add the two existing disks letting it
> } > > >resync?
> } > >
> } > > Why not growing the array with 2 more disks?
> } >
> } > Well I guess a RAID-1 of 4 disks would be slightly more redundant
> } > than a 4 disk RAID-10, but it would have half the capacity, and the
> } > read performance would be very similar, no?
> } 
> } raid1 of 4 will give u read performance like 1 disk;
> } raid10 of 4 can give u read performance like aggregated 2 disks.
> 
> I know RAID1 of 4 disks will give you read performance like 4 disks.
> Unless your test or application is single threaded!  Not likely I hope!
> At least with the 2.4.31 kernel.

for random read, u can make use of 4 disk in parallel. but for
sequential workload, it has not much gain.

> 
> A RAID1 of 4 disks will still function with any 3 failed disks.
> Real good idea for remote systems.

unless u data is that critical, u only get 25% disk utilization here.

> 
> Also I think raid10 of 4 can give u read performance like 2 to 4 disks.
> This depends more on the application.  IMO.
> You would have twice the space, but maybe not needed.


> 
> 
> } 
> } 
> } >
> } 
> } -
> } To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> } the body of a message to majordomo@vger.kernel.org
> } More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

