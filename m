From: Neil Brown <neilb@suse.de>
Subject: Re: Starting RAID 5
Date: Thu, 21 May 2009 08:28:32 +1000
Message-ID: <18964.33808.165395.134435@notabene.brown>
References: <20090515021521914.KSFT13751@cdptpa-omta01.mail.rr.com>
	<adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>
	<4A117B0D.5040804@tmr.com>
	<bd12c2abf38ab775bf40fd52654daa36.squirrel@neil.brown.name>
	<4A145DEB.2080602@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday May 20
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 20, davidsen@tmr.com wrote:
> NeilBrown wrote:
> > On Tue, May 19, 2009 1:13 am, Bill Davidsen wrote:
> >   
> >> NeilBrown wrote:
> >>     
> >>> On Fri, May 15, 2009 12:15 pm, Leslie Rhorer wrote:
> >>>
> >>>       
> >>>> OK, I've torn down the LVM backup arraqy and am rebuilding it as a RAID
> >>>> 5.
> >>>> I've had problems with this before, and I'm having them, again.  I
> >>>> created
> >>>> the array with:
> >>>>
> >>>> mdadm --create /dev/md0 --raid-devices=7 --metadata=1.2 --chunk=256
> >>>> --level=5 /dev/sd[a-g]
> >>>>
> >>>> whereupon it creates the array and then immediately removes /dev/sdg
> >>>> and
> >>>> makes it a spare.  I think I may have read where this is normal
> >>>> behavior.
> >>>>
> >>>>         
> >>> Correct. Maybe you read it in the mdadm man page.
> >>>
> >>>
> >>>
> >>>       
> >> While I know about that, I have never understood why that was desirable,
> >> or even acceptable, behavior. The array sits half created doing nothing
> >> until the system tries to use the array, at which time it's slow because
> >> it's finally getting around to actually getting the array into some
> >> sensible state. Is there some benefit to wasting time so the array can
> >> be slow when needed?
> >>     
> >
> > Is the "that" which you refer to the content of the previous paragraph,
> > or the following paragraph.
> >
> >   
> The problem in the following paragraph is caused by the behavior in the 
> first. I don't understand what benefit there is to bringing up the array 
> with a spare instead of N elements needing a rebuild. Is adding a spare 
> in place of the failed device the best (or only) way to kick off a resync?

Really, the two are independent.  The "wait until someone writes"
would affect resync as well as recover.

The "benefit" is, as I explained, that one is faster (in general) than
the other.
If you want to create a raid5 that have exactly the drive you specify
and not a spare, use the --force flag.
If it would have started read-auto without the --force, it would with
the --force too.  This is controlled by
   /sys/module/md_mod/parameters/start_ro 
If the drives had not been part of a raid5 before, the resync will be
slower than a recovery would have been.


> 
> > The content of your comment suggests the following paragraph which,
> > as I hint, is a misfeature that should be fixed by having mdadm
> > "poke it out of that" (i.e. set the array to read-write if it is
> > read-mostly).
> >
> > But the positioning of your comment makes it seem to refer to
> > the previous paragraph which is totally unrelated to your complaint,
> > but I will explain anyway.
> >
> > When a raid5 performs a 'resync' it reads every block, tests parity,
> > then if the parity is wrong, it writes out the correct parity block.
> > For an array with mostly correct parity, this involves sequential
> > reads across all devices in parallel and so is as fast as possible.
> > For an array with mostly incorrect parity (as is quite likely at
> > array creation) there will be many writes to parity block as well
> > as the reads, which will take a lot longer.
> >
> > If we instead make one drive a spare then raid5 will perform recovery
> > which involves reading N-1 drives and writing to the Nth drive.
> > All sequential IOs.  This should be as fast as resync on a mostly-clean
> > array, and much faster than resync on a mostly-dirty array.
> >   
> 
> It's not the process I question, just leaving the resync until the array 
> is written by the user rather than starting it at once so the create 
> actually results in a fully functional array. I have the feeling that 
> raid6 did that, but I haven't hardware to test today.

No.  You really need a resync first, or your data is not safe.
Just writing data does not set the parity correctly, unless it was
already create before hand. (it might, but there is no guarantee).
So if you get a drive failure before the initial resync or recovery is
complete, you have possibly lost data.
The difference is that in the default case (make a spare and force
recovery), you know that you have lost data.  In the other case (no
magic spares, just do a resync) you can believe that you haven't, but
you might be wrong.

RAID6 is different in that it always calculates new parity and Q.
So you don't need to initial resync to get the parity correct.
And I don't think mdadm fiddles with spares for RAID6.

Just to clarify:  it is perfectly OK to write data to an array before
the initial resync/recovery is finished.  But, on raid5, that data is
not safe from a single-drive-failure until the resync/recovery is
complete.

NeilBrown


