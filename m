From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Wed, 19 Apr 2006 14:16:10 -0400
Message-ID: <1145470570.8608.100.camel@localhost.localdomain>
References: <200604191631.04305.Dexter.Filmore@gmx.de>
	 <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
	 <1145466223.8608.84.camel@localhost.localdomain>
	 <44467654.2060903@swcp.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44467654.2060903@swcp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Conoboy <synk@swcp.com>
Cc: Shai <shaibn@gmail.com>, Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2006-04-19 at 10:41 -0700, Brendan Conoboy wrote:
> Ming Zhang wrote:
> >> Why can't you just mark that drive as failed, remove it and hotadd a
> >> new drive to replace the failed drive?
> > 
> > because background rebuild is slower than disk to disk copy, since his
> > disk is still fully functional.
> 
> Wouldn't it be great if every disk in a RAID volume were in its own way 
> a degraded RAID1 device without a mirror?  Then when any drive started 
> generating recoverable errors and warnings a mirror could be allocated 
> without any downtime.  You can certainly generate a layout like this 
> manually, but it would be nice to have that sort of feature out of the 
> box (and without the performance hit!).  This would help a great deal in 
> a situation such as Dexter's.

is this possible? 
* stop RAID5
* set a mirror between current disk X and a new added disk Y, and X as
primary one (which means copy X to Y to full sync, and before this ends,
only read from X); also this mirror will not have any metadata or mark
on existing disk;
* add this mirror to RAID5
* start RAID5;

... mirror will continue copy data from X to Y, once end

* stop RAID5
* split mirror
* put DISK Y back to RAID5
* restart RAID5.

since this is a mirror, all metadata are same. it will be even greater
if no need to stop raid5 to do this.

may MD already can do this, but I do not know.

> 
> -Brendan (synk@swcp.com)

