From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID1 problems
Date: Mon, 24 Feb 2003 09:40:48 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15961.19952.717406.146896@notabene.cse.unsw.edu.au>
References: <1045747209.795.7.camel@localhost.localdomain>
	<15957.28314.314427.191061@notabene.cse.unsw.edu.au>
	<002801c2db4b$6cac0c40$8400a8c0@jrc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jean-Rene Cormier on Thursday February 20
To: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 20, jean-rene.cormier@cipanb.ca wrote:
> >
> > I cannot explain the mounting problem.  Maybe if you give more
> > specifics....
> 
> Well what I did was:
> 
> mdadm -Cv -l2 -n2 /dev/hde1 /dev/hdg1 /dev/md0
> mke2fs -j /dev/md0
> mount /dev/md0 /home
> 
> then I unmounted it and when I tried to mount it again right after
> unmounting it I got the Wrong FS type error and I get a bunch of error
> message on the console.

If that is really what you did, no wonder it didn't work.  The md
device must be listed first, not last.

However if it is a typo, and you really listed /dev/md0 first, it is
strange.  Maybe if you could include the 'bunch of error messages' - 
   dmesg > /tmp/afile
should get them for you.

NeilBrown
