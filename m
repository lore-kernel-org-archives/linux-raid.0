From: Neil Brown <neilb@suse.de>
Subject: Re: Fw: mdadm options, and man page
Date: Tue, 24 Jan 2006 13:55:49 +1100
Message-ID: <17365.38709.642096.294321@cse.unsw.edu.au>
References: <044201c62016$c9524820$1400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Monday January 23
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 23, djani22@dynamicweb.hu wrote:
> 
> ----- Original Message ----- 
> From: "Neil Brown" <neilb@suse.de>
> To: "JaniD++" <djani22@dynamicweb.hu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Thursday, January 19, 2006 3:09 AM
> Subject: Re: mdadm options, and man page
> 
> 
> > On Tuesday January 17, djani22@dynamicweb.hu wrote:
> > > Hello, Neil,
> > >
> > > Some days before, i read the entire mdadm man page.
> >
> > Excellent...
> >
> > >
> > > I have some ideas, and questions:
> > >
> > > Ideas:
> > > 1. i think, it is neccessary, to make another one mode to mdadm like
> "nop"
> > > or similar, just for bitmaps, and another options, that only works with
> > > assemble, and create (or grow) modes.
> >
> > This sounds like the 'misc' mode.  What exactly would you want to do
> > with it?
> 
> Example:
> I have one raid5 array, without bitmap, on already replaced bigger drives.
> (for planned growing)
> The array is online, dont want to stop, and need to create the bitmap
> without to do the resizing of array.

'--grow' doesn't always change the size of an array.  It can also
'grow' the amount of redundancy, or 'grow' a bitmap in an array...
Possibly a confusing name choice, but it worked for me...
Anyway, to add a bitmap to an active array you can e.g.:

   mdadm --grow /dev/mdX --bitmap=internal

This will not change the size of the array, just add a bitmap.
The 'size' will only change if you ask it to, e.g.
   mdadm --grow /dev/mdX --size=max


> 
> >
> > >
> > > 2. i think the raid5 creation virtual spare drive technique necessary to
> be
> > > standalone option, to avoid more people to data lost, with re-creating
> the
> > > raid5 arrays, and who did'nt read carefully the entire man.
> >
> > I don't see why this could cause loss of data.  Can you explain?
> 
> One time i almost do that:
> One big (2TB) raid5 array, the system crashed. (no bitmap at this time in
> the array)
> After the reboot, the system starts to resync, and don't want to wait until
> its done, but with high workload and resync is too much work to the system.
> (Yes, i know it is possible to set the minimum and maximum kb/s in proc...)
> This time i plan to do that:
> Stop the resync, with recreating the array, with --assume-clean, to stop the
> resyncing.
> After the weekend load is gone, recreate the array, with normal parameters,
> to resync the entire parity infos, and this time if i dont know this
> exception, i will loose some data!
> The raid will overwrite the last disk, from half-clean parity
> information.

Hmmm.... I see you point, but I don't find it very convincing.  People
who try to do something like what you did without reading "the spots
off" the documentation are asking for trouble.... and you really
should have just set the 'min' resync speed down to near-zero.

> >
> > >
> > > 3. i think it will be an usefull thing, set the recovery, resyncing
> > > order(eg. from the end of the drive to the beginning) of array, or set
> the
> > > "from" and "to" limits for it, or stop, restart(retry) this function, if
> it
> > > is possible again.
> > > (only experimental, it will be allow very easy to loose data.)
> > > This is useful in very big arrays, wich takes some days to resync.
> > > Yes, i know this caused to write the bitmap code, but i think the linux
> is
> > > beautiful because it is very configurable. :-)
> > > ... i did not like the automated things, what i cannot controll....
> >
> > Why would you want to resync from the end to the beginning?
> >
> > I am looking into make raid1 be usable on a cluster and that would
> > require better control of resyncing, but I'm not sure what exactly it
> > is that you want, or how it would be useful.
> 
> Again big arrays...
> I guess, you know this feeling, if the N TB array is synced about 95%, and
> the system crashes again. :-)
> 
> 1 pass sync the array from 0-95%, than crash, reboot.
> 2 pass sync the array from 100% to 90%, and marked to be clean by
> hand. :-)

This would be a very silly thing to do.  I wouldn't want to encourage
it.

> 
> Additional info:
> I use currently 4x 2TB disk nodes, and if i need to repair, change, or sg
> the nodes, the only way is to riad1 resync with the spare node.
> On the online system, the 2TB resync between the nodes, takes some days.
> I am really happy, if the raid1 starts to resync from the beginning, after
> crash. :-)
> 
> Another issue:
> The man pages did not contains info about the the spare drive in raid1 and
> parity on raid4!
> I mean wich drive will be the source, and wich the copy on raid1, and wich
> the parity on raid4.
> This is neccessary to avoid data lost on create (build) arrays, on pre
> existent devices...

raid4:  The last drive is the parity drive.  Yes, it isn't documented.

raid1: people keep asking this question, but it really is a
non-question.  You really don't need to know the answer.
If you are creating a raid1 array using a drive with known-good data,
you create a degraded array with just that drive and all other slots
'missing'.  Then you hot-add the drives that you want data to be
copied on to.  If you do it this way, there is no way it could matter
which device is used as the source for resync, as you never do a
resync, only a recovery.

NeilBrown
