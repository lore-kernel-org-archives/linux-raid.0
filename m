From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Thu, 6 Jan 2005 20:42:40 +0100
Message-ID: <200501062042.40165.maarten@ultratux.net>
References: <200501061731.j06HVi932064@www.watkins-home.com> <200501061918.16088.maarten@ultratux.net> <41DD83DA.9040609@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DD83DA.9040609@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 06 January 2005 19:30, Mike Hardy wrote:
> maarten wrote:
> > I was planning to do this quickly tonight, but I've overlooked one
> > essential thing ;-|  The old server has already 220 GB of data built of 4
> > 80GB disks in raid-5.  But I cannot connect all 8 disks at the same time,
> > so I'll have to 'free up' another system to define the arrays and copy
> > the data over Gbit LAN.  I definitely don't want to lose the data!
> > What complicates this a bit is that I wanted to copy the OS verbatim (it
> > is not part of that raid-5 set, just raid-1). But I suppose booting a
> > rescue CD would enable me to somehow netcat the OS over to the new
> > disks... We'll see.
>
> You could degrade the current raid5 set by plugging one of the new
> drives in and copying the 220GB to it directly, then you could build the
> new raid5 sets with one drive "missing" and then finally dump the data
> on the new raid5's and then hotadd the missing drive

Hey.  I knew that trick of course, but only now that you mention it I realize 
that indeed one single new disk is big enough to hold all of the old data.
Stupid :)  I never though of that.  Go figure.  Those disks get BIG indeed...!
:-))

Right now I took my main(*) fileserver offline, unplugged all the disks from 
it and connected the new disks.  Using a RIP CDrom I partitioned them and 
'mkraid'ed (mdadm not yet being on RIP) the first md device which will hold 
the OS.  As we speak the netcat session is running, so if I didn't make any 
typos or thinkos soon I will hopefully reboot to a full-fledged system.

(*) These new disks are not for my _fileserver_, but for my MythTV PVR, the 
machine they will eventually end up in, which holds the 220 GB TV & movies.

So far, so good...

Maarten

-- 

