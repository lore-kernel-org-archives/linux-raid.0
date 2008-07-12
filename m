From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: resync'ing - what is going on
Date: Sat, 12 Jul 2008 13:50:45 +0200
Message-ID: <20080712115044.GA30938@rap.rap.dk>
References: <20080710165459.GA17542@rap.rap.dk> <18550.59093.835573.290313@notabene.brown> <20080711222927.GA10862@rap.rap.dk> <18552.35616.626230.236249@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18552.35616.626230.236249@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 12, 2008 at 08:44:48PM +1000, Neil Brown wrote:
> On Saturday July 12, keld@dkuug.dk wrote:
> > I took the information here and made something for the wiki.
> > Comments welcome.  /keld
> 
> Thanks for doing that.  I'm not motivated to work on the wiki myself,
> but I'm more than happy for anyone to take any secrets I divulge in
> emails and publish them there.
> 
> > 
> > = recovery and resync =
> > 
> > The following is a recollection of what Neil Brown and others have
> > written 
> > on the linux-raid mailing list.
> > 
> > "resync" and "recovery" are handled very differently in raid10.
> > "check" and "repair" are special cases of "resync".
> > 
> > == recovery ==
> > 
> > The purpose of the recovery process is to fill a new disk with the
> > relevant 
> > information from a running array.
> > 
> > The assumption is that all data do the new disk needs to be written.
> > 
> > "recovery" walks addresses from the start to the end of the component
> > drives.
> ...
> > 
> > == resync ==
> ...
> > 
> > "resync" walks the addresses from the start to end of the array.
> 
> It's probably worth noting that this difference between recovery and
> resync in specific to raid10.
> 
> recovery always follows the address space of component drives.
> 
> resync:
>   on raid10, follows the address space of the array
>   on raid4/5/6, follows the address space of component drives.
>   on raid1, the two address spaces are the same.
> 
> Another way to say it is that raid10-resync follows the address space
> of the array, everything else follows the component drives.

OK, I added that info:
For raid10 "resync" walks the addresses from the start to end of the
array. (For all other raid types "resync" follows the component drives).

I also added that for recovery, it is assumed
that the running drives are in sync. Is that true? I wrote it as:

The assumption is that all data on the new disk needs to be written, and
that the other data on the running array is correct.


I also wrote this to indicate the difference between a component drive
walk, and a full array walk:

"recovery" walks addresses from the start to the end of the component
drives. Thus only data for the specific component drive is adressed.
