From: Harry Mangalam <hjm@moo.nac.uci.edu>
Subject: Re: How to free devices held captive by failed arrays
Date: Fri, 21 Oct 2011 16:08:24 -0700
Message-ID: <20111021230824.GA11647@moo.nac.uci.edu>
References: <20111021202736.GA10682@moo.nac.uci.edu>
 <20111022094156.1a2c42ae@notabene.brown>
 <20111021224556.GA11429@moo.nac.uci.edu>
 <20111022100457.0f5133f3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111022100457.0f5133f3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > > 
> > > > 
> > > > What do I have to do to free this device?
> > > 
> > > Doesn't
> > >  
> > >    mdadm --stop /dev/md_d0
> > > 
> > > release sdg1 ??
> > > 
> > > NeilBrown
> > 
> > No, it doesn't.
> > 
> > $ mdadm --stop /dev/md_d0
> > mdadm: error opening /dev/md_d0: No such file or directory
> > 
> > In fact, that's sort of odd:
> > 
> >  $ ls -l /dev/md*
> > brw-rw---- 1 root disk 9, 0 2011-10-20 17:18 /dev/md0
> > lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p1 -> md/d0p1
> > lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p2 -> md/d0p2
> > lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p3 -> md/d0p3
> > lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p4 -> md/d0p4
> > 
> > /dev/md:
> > total 0
> > brw------- 1 root root 254, 0 2011-10-20 17:05 d0
> > brw------- 1 root root 254, 1 2011-10-20 17:05 d0p1
> > brw------- 1 root root 254, 2 2011-10-20 17:05 d0p2
> > brw------- 1 root root 254, 3 2011-10-20 17:05 d0p3
> > brw------- 1 root root 254, 4 2011-10-20 17:05 d0p4
> > 
> > [no record of /dev/md_d0] ...?
> > 
> > hjm
> > 
> 
> md_d0 is another name for md/d0.  The former probably only gets created when
> the array becomes active.
> So use
>    mdadm --stop /dev/md/d0


Perfect!  That did it.  The other RAID is now initializing.
That goes in the personal HowTos..
Many thanks!

hjm

