From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
Date: Tue, 9 Jun 2009 09:36:30 +1000
Message-ID: <18989.41086.680592.282765@notabene.brown>
References: <18980.48553.328662.80987@notabene.brown>
	<alpine.LNX.2.01.0906031749270.15124@filesrv1.baby-dragons.com>
	<18983.12764.413037.150661@notabene.brown>
	<4A2AF885.6060309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Saturday June 6
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday June 6, davidsen@tmr.com wrote:
> Neil Brown wrote:
> > On Wednesday June 3, babydr@baby-dragons.com wrote:
> >   
> >>  	Hello Neil ,  I am getting a interesting Error during compiling 3.0 .
> >>  	Is there a particular version of kernel that 3.0 is supposed to be 
> >> compiled with ?
> >>     
> >
> > This has nothing to do with kernel version.  You must be using a
> > different compiler version - it is picking up an error that might
> > didn't.
> >
> > The fix is below.
> > Thanks,
> > NeilBrown
> >
> >
> >   
> >>  		Tia ,  JimL
> >>
> >> gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
> >> -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
> >> -o super-intel.o super-intel.c
> >> cc1: warnings being treated as errors
> >> super-intel.c: In function 'mark_failure':
> >> super-intel.c:3632: warning: comparison is always false due to limited range of 
> >> data type
> >> make: *** [super-intel.o] Error 1
> >>
> >>     
> >
> > commit 4291d691b66f65695b5b4be22b80fd00da73b544
> > Author: NeilBrown <neilb@suse.de>
> > Date:   Thu Jun 4 12:29:21 2009 +1000
> >
> >     super-intel: fix test on failed_disk_num.
> >     
> >     We sometimes set failed_disk_num to ~0.
> >     However we cannot test for equality with that as  failed_disk_num
> >     is 8bit and ~0 is probably 32bit with lots of 1's.
> >     So test if ~failed_disk_num is 0 instead.
> >     
> >     Reported-By: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
> >     Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 73fe5fa..7e2a086 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -3629,7 +3629,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
> >  
> >  	disk->status |= FAILED_DISK;
> >  	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
> > -	if (map->failed_disk_num == ~0)
> > +	if (~map->failed_disk_num == 0)
> >  		map->failed_disk_num = slot;
> >  	return 1;
> >  }
> >   
> 
> I still don't think this is really portable, the zero should be cast 
> using typeof.

????

zero is zero is zero.
A cast will either add zero bits or remove zero bits, the net result
is always the same.

"-1" is different.  Casting it could add zeros or ones depending on
whether it seems to be signed at the time.  That was the original
problem.  failed_disk_num is unsigned 8 bits.  So when we assign ~0
to it, it becomes 0b11111111.
But when it is implicitly cast to an int for the comparison, it
becomes
   0b00000000000000000000000011111111
which is very different from ~0 which is
   0b11111111111111111111111111111111

So I stand by the new code.

Thanks,
NeilBrown
