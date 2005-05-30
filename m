From: "David F. Bakker" <dbakker1@yahoo.com>
Subject: Re: Raid 1 disk scheduling
Date: Mon, 30 May 2005 07:01:30 -0700 (PDT)
Message-ID: <20050530140130.55617.qmail@web30511.mail.mud.yahoo.com>
Reply-To: dbakker1@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 6667
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- Molle Bestefich <molle.bestefich@gmail.com> wrote:
> David F. Bakker wrote:
> > I have a server with lots of available RAM (10GB)
> I
> > wanted to create an md raid 1 device that would
> mirror
> > a large ramdisk (2GB) to a scsi md device. The
> > thinking here is writes will be just as fast as
> always
> > since I/O is sync to both the RAM and hard disk.
> > However reads should be crazy fast since it should
> be
> > coming from the device with the lower latency or
> the
> > one that answers first (RAM). It looks like the
> I/O is
> > done in a round robin setup. I get amazing reads
> every
> > other test (cat'n a file) which seems it is a
> round
> > robin scheme. Can this be changed somehow to
> prefer a
> > device or use latency instead?
> 
> Linux should use any available RAM for disk cache.
> Are you sure that using MD as a disk cache like
> above is any faster than that?
> 

No Im not. I would assume it would be since if I start
a large service (1GB) and then stop it and restart it
it takes just as long. I was thinking since everything
would already be in ram that it would start much
faster. However after thinking about this somemore
it's probaly the apps internal init that is slow and
not the actual executable load time. I did make a
change to raid1.c to favor ram disks if present which
shows some great read speeds but I havent tested the
whole thing out yet.


		
__________________________________ 
Yahoo! Mail Mobile 
Take Yahoo! Mail with you! Check email on your mobile phone. 
http://mobile.yahoo.com/learn/mail 
