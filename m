From: Frank Jenkins <fjenkins873@yahoo.com>
Subject: Re: raid5 recover after a 2 disk failure
Date: Sun, 8 Jul 2007 02:54:46 -0700 (PDT)
Message-ID: <852300.80170.qm@web57312.mail.re1.yahoo.com>
References: <4677C27A.80006@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4677C27A.80006@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First, I'd like to extend a HUGE thank you. I was able
to get some irreplaceable family photos off my raid
array before things went south. 

Sadly, another disk seems to have died, so now it
seems completely dead. There is one thing I'm confused
about.

The Events number has gone way up on the disks I was
using for that array. From 0.67378 to 0.78038. Isn't
the event number only updated when the array is
written to? I thought I mounted the array read-only,
so I'm not sure why that would have gone up.

Thanks, Frank



--- David Greaves <david@dgreaves.com> wrote:

> All looked OK, a few comments...
> 
> Frank Jenkins wrote:
> Logically this comes first...
> > This should force the array back into a useable
> state,
> > yes? 
> > (assuming that I'm correct and sde isn't really
> > busted).
> correct.
> Since you have a spare you may want to use ddrescue
> to transfer data from sde to 
> the spare as a 'backup'. That way, if you do get
> problems with sde you have the 
> best chance of recovery.
> 
> If you do that, then you can use the backup as your
> new sde.
> 
> either way...
> 
> > I think what I need to do is run:
> > mdadm -ARf /dev/md1 missing /dev/sd[baed]1
> I don't think you want -R.
> If enough drives are present to provide data then it
> will run with a -f.
> 
> If you get the order wrong here, it won't damage
> anything *provided you have a 
> missing disk and the array is degraded* (which you
> do) so there is no need to 
> worry about having rw devices.
> 
> The event counts from abcdf are the same and sde is
> only slightly off so you 
> should find it assembles just fine.
> 
> At this point can copy data off the disks - bear in
> mind you may have fs or data 
> corruption due to the inconsistency in sde.
> 
> If you are confident that sde is actually OK, you
> can now add in the spare:
>    mdadm /dev/md1 --add /dev/sdc1
> and allow a rebuild.
> 
> Then do an xfs_repair (or ext3 or whatever).
> You can do this whilst the resync is running.
> 
> At that point you should be back up and running - no
> need for a restore.
> 
> 
> > And more importantly, if anyone can tell me how to
> > lock down the 
> > disks so they are readonly so I can play around
> with
> > mdadm 
> > re-assembly options without having to worry about
> > compeletly 
> > destroying the array, that'd be awesome.
> Not sure you can do this.
> 
> > As usual, any help would be greatly appreciated.
> > 
> > I'll include the -E output from the drives in
> their
> > current state, if that helps:
> It did.
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 



 
____________________________________________________________________________________
Be a PS3 game guru.
Get your game face on with the latest PS3 news and previews at Yahoo! Games.
http://videogames.yahoo.com/platform?platform=120121
