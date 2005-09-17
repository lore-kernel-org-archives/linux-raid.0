From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Re: Failed RAID-5 with 4 disks
Date: Sat, 17 Sep 2005 18:46:42 +0200
Message-ID: <20050917164642.GK21856@intoxicatedmind.net>
References: <20050726170329.GA30354@intoxicatedmind.net> <432AFA95.3040709@h3c.com> <20050916190928.GJ21856@intoxicatedmind.net> <200509171131.12643.suse-ml@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200509171131.12643.suse-ml@onlinehome.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 17, 2005 at 11:31:12AM +0200, Burkhard Carstens wrote:
> Am Freitag, 16. September 2005 21:09 schrieb Frank Blendinger:
> > On Fri, Sep 16, 2005 at 10:02:13AM -0700, Mike Hardy wrote:
> > > Frank Blendinger wrote:
> > > > This is what I did so far: I got one of the two bad drives (the
> > > > one that failed first) replaced with a new one. I copied the
> > > > other bad drive to the new one with dd. I guess that not
> > > > everything could be copied alright, I got 10 "Buffer I/O error on
> > > > device hdg, logical sector ..." and about 35 "end_request: I/O
> > > > error, hdg, sector ..." error messages in my syslog.
> > > >
> I am unable to find the beginning of this thread, so please excuse me if 
> this has already been said, but:
> 
> You did use ddrescue, didn't you? Because dd, when it fails to read a 
> block, it won't write that block. That's why your superblock might have 
> "moved" about 45 sectors towards the beginning of the drive.
> ddrescue writes a block with zeros when reading that block fails, so 
> every readable sector get copdied to its corresponding sector on the 
> new drive..

OK, thanks for the note, I am going to do a bad block scan with smart
and then try again with ddrescue. I hope this will restore the
superblock.


Greets,
Frank
