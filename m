From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 16:08:05 -0700 (PDT)
Message-ID: <719154.37165.qm@web38805.mail.mud.yahoo.com>
References: <20090923200257.GA19027@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923200257.GA19027@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 9/23/09, Robin Hill <robin@robinhill.me.uk> wrote:
> Obviously, but in the case of a RAID1 mirror, then this is
> immaterial
> (as either side of the mirror is identical), and in the
> RAID10 case it
> is controlled by the position of the drives in the array
> (which is
> controlled by the order they're given in the create
> statement).
> 
> > When I set up my NAS it's likely those remote drives
> will be sdc and
> > sdd (HTPC drives would be sda and sdb), so the RAID10
> create order
> > wouldn't help.
> > 
> Of course the create order helps - it's the _only_ way to
> control what
> chunks of the data go on which drive.  If your HTPC
> ends up with local
> drives sda and sdb, and remote drives sdc and sdd, then
> do:
> 
>     mdadm -C /dev/md0 -l 10 -p n2 -n 4 /dev/sda
> /dev/sdc /dev/sdb /dev/sdd
> 
> Then you'll end up with a RAID10 with all data held on both
> the sda/sdb
> and sdc/sdd pairs (so either pair can drop out of the array
> without
> losing any data).  The data layout will be:
> 
>     sda  sdb  sdc  sdd
>    
> A1   A2   A1   A2
>    
> A3   A4   A3   A4
>     ...
> 
> The equivalent happens for f2 or o2 arrays - though they're
> not strictly
> mirrored in those cases (they contain the same data but
> with a differing
> layout).
> 
> As I say though, this setup will still result in poor
> performance as you
> have the database and recordings on the same drives. 
> And to make them
> bootable you'd want to partition the drives first and
> create a separate
> 4-way RAID1 mirror for /boot.

YIKES, I'd better read this when I'm -not- drunk...

I take away that my main performance problem is in not separating by drive, the Myth database from the affected video.  Given these listserv transactions, I guess I have to resort to a 2.5" drive with the root filesystem and the Myth database, and the space-divided array for video storage.  I guess I can't RAID10 the root drive with the garage, as it might not be bootable, and you probably can't boot to a NAS drive anyway.   But this doesn't stop me from backing up the root drive onto the array.

It seems that I -can- control the role of the drives using your command above.  This is good news.

I will reexamine this tomorrow... 


      
