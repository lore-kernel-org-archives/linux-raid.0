From: Ken Causey <ken@ineffable.com>
Subject: Re: Can't add missing member back in???
Date: 26 Jun 2002 13:14:19 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1025115259.594.25.camel@temp>
References: <1025111457.596.13.camel@temp>
	<15642.855.558011.545081@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15642.855.558011.545081@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2002-06-26 at 13:09, Neil Brown wrote:
> On  June 26, ken@ineffable.com wrote:
> > Hi,
> > 
> > Interesting problem.  I'm setting up an all software RAID system and
> > after a few fits and starts have reached some success.  I started to do
> > some testing and have run into a problem.  What I was doing is I was one
> > by one unplugging one of the SCSI drives and then powering up the system
> > to make sure it would power up properly.  The first time I did this
> > everything worked great.  I plugged the drive back up and used
> > raidhotadd to recover and got everything to UUU.  I then powered off and
> > unplugged another drive, system boots up great with only two drives. 
> > Now its time to plug the drive back in and rebuild the array to be ready
> > to unplug the last of the three drives for a thorough test.  Only, now I
> > can ONLY boot up if I DO NOT have the missing drive plugged in.  This is
> > really weird.  If I have all three devices attached then it claims that
> > 2/3 of the devices that make up md2 (my root) are unavailable and well
> > then we are screwed.  WTF?
> 
> Let me guess... you are using "raidstart" to start the arrays?

Exactly.

>  If so, that is your problem.  It is broken.

Ok.  Good to know.

>  Either change the partition type to use auto-detect, or use
>  mdadm:
>    http://www.cse.unsw.edu.au/~neilb/source/mdadm/
>

mdadm it will have to be.  I'm using an initrd kernel and autodetection
is very specifically removed in the raid modules.
 
> If you aren't using raidstart, tell me and I try harder.

This is a very good start and I suspect it will fix me.  Now if only
mkinitrd would use mdadm automatically rather than raidstart...  Oh
well, that's  a battle for another day.

Ken Causey

> 
> NeilBrown
> 


