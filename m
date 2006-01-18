From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 22:43:04 +1100
Message-ID: <17358.10696.538733.693819@cse.unsw.edu.au>
References: <dqkie5$mf2$3@sea.gmane.org>
	<Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca>
	<dqksi3$mf2$5@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Max Waterman on Wednesday January 18
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 18, davidmaxwaterman+gmane@fastmail.co.uk wrote:
> Mark Hahn wrote:
> >> They seem to suggest RAID 0 is faster for reading than RAID 1, and I 
> >> can't figure out why.
> > 
> > with R0, streaming from two disks involves no seeks;
> > with R1, a single stream will have to read, say 0-64K from the first disk,
> > and 64-128K from the second.  these could happen at the same time, and 
> > would indeed match R0 bandwidth.  but with R1, each disk has to seek past
> > the blocks being read from the other disk.  seeking tends to be slow...
> 
> Ah, a good way of putting it...I think I was pretty much there with my 
> followup message.
> 
> Still, it seems like it should be a solvable problem...if you order the 
> data differently on each disk; for example, in the two disk case, 
> putting odd and even numbered 'stripes' on different platters [or sides 
> of platters].

raid10 'far' mode is exactly designed to address this issue.
If you create a raid10 with 2 drives and a layout of 'f2':

  mdadm -C /dev/mdX --level=10 --layout=f2 --raid-disks=2 /dev/XX /dev/YY

then reads should be comparable to a raid0 of 2 drives, but you still
get raid1 protections.
Writes may be substantially slower though I haven't measured to be
sure.

It doesn't do "different sides of platters" as that is not possible
with modern drives (you have no knowledge and no control).  It does
different 'ends' of the drive.

NeilBrown

