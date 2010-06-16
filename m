From: Neil Brown <neilb@suse.de>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 17 Jun 2010 07:26:31 +1000
Message-ID: <20100617072631.09641f48@notabene.brown>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
	<20100611005231.401529c0@natsu>
	<20100610195851.GA8408@libra.CS.Berkeley.EDU>
	<4C18F39E.8010600@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C18F39E.8010600@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Gilad Arnold <arnold@cs.berkeley.edu>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Jun 2010 11:54:06 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> Gilad Arnold wrote:
> > Thanks for your response, Roman.
> >
> > On Fri, Jun 11, 2010 at 12:52:30AM +0600, Roman Mamedov wrote:
> >   
> >>> I have been using RAID5 on a desktop machine using a couple of 500
> >>> GB drives.  My original intent was to grow the array by adding more
> >>> drives, as the need arises.
> >>>       
> >> Do you currently run RAID5 with just 2 drives, in degraded mode, or
> >> maybe you meant something else?
> >>     
> >
> > No, it is not degraded, it's a clean 2-drive RAID5. I know it doesn't
> > make much sense as it is ;-)  the intent was to grow the array later,
> > relying on mdadm's grow feature. Right now, I'm guessing that it
> > operates like a RAID1 for all practical purposes.
> >
> >   
> I have the feeling that you will then get a lot of read, alter, rewrite 
> (RAW) operations on the parity chuck, where you would just get writes of 
> a copy for raid{1,10} configuration.

Nup.  When there are just two devices, every write will be a full-stripe write
so it will just calculate the parity and write.
If you try to write less than one (aligned) page it will need to pre-read to
get the rest of the page, but that is unlikely.  There will definitely be no
pre-reading of parity.

A RAID5 on 2 devices would be a little slower than RAID1 on two devices as
there is more copying of data around in memory, and there is no read
balancing, but it shouldn't be much slower.

However with recent mdadm and kernel you can trivially convert a 2 drive
RAID1 to a 2 drive RAID5 while the array is online, so it should be easy to
experiment and change you mind about how you want it configured.

>                                        The performance of raid5 is poor, 
> but with 4-5 drives it gives you some fault tolerance. With even three 
> drives the write performance is poor by algorithm, and the read 
> performance is poor by implementation (I see no reason for reading at 
> the speed of just one drive).
> 
> I think your upgrade will fail, but feel free to see if a two drive 
> raid5 will start with only one drive, I could be wrong.

A two-drive RAID5 will definitely work with just one drive present.

NeilBrown

> 
> If it were me, I would leave the raid up, install the new drive, and 
> just copy the data to it. That way you have error tolerance on the 
> original data, while your method doesn't. After doing that and reading 
> the entire new drive to be sure it's valid, configure the two original 
> drives as a degraded three drive raid10. After that's done AND TESTED to 
> see that the data are still all valid, then you add the new drive to the 
> raid10 and get full operation.
> 
> Actually, if it were me I'd have a backup, too. And be damn sure to run 
> on a UPS.
> 

