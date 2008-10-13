From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Distributed spares
Date: Tue, 14 Oct 2008 01:29:21 +0200
Message-ID: <20081013232921.GB22265@rap.rap.dk>
References: <48F3C2A1.3080607@tmr.com> <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan> <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 13, 2008 at 05:30:49PM -0500, Billy Crook wrote:
> Just my two cents....  Those daily smart tests or regularly running
> badblocks are fine, but they're not 'real' load.  A test can't prove
> everything is right, it can at best only prove it didn't find anything
> wrong.  Distributed spare would exert 'real' load on the spare because
> the spare disks ARE the live disks.
> 
> 
> On a side note, it would be handy to have a daemon that could run in
> the background on large raid1's, or raid6', and once a month, pull
> each disk out of the array sequentially, completely overwrite it,
> check it with badblocks several times, do the smart tests, etc...,
> then rejoin it, reinstall grub, wait an hour and move on.  The point
> being, of course, to kill weak drives off early and in a controlled
> manor.  It would be even nicer if there were a way to hot-transfer one
> raid component to another without setting anything faulty.  I suppose
> you could make all the components of the real array be single disk
> raid1 arrays for that purpose.  Then you could have one extra disk set
> aside for this sort of scrubbing, and never even be down one of your
> parities.  I guess I should add that onto my todo list....

I have also been thinking a little on this. My idea is that if bit
errors develop on disks, then there is first maybe one bit error, and
the crc check on the disk sectors then finds and corrects these.

If you rewrite such bit errors, then that bit error will be corrected,
and you prevent the one-bit error from developing to a two-bit error
that is not correctable by the CRC. 

Is there some merit to this idea?

Furthermore, if bad luck has striken, then in the case of mirrored RAIDs
you could - when crc fails, then see that this is the block in error and
recreate it from the redundant info, Would be good for raid1, raid10,
raid5, raid6. If the block then could not be written without errors,
then it could be added to a bad blocks list and remapped.

I think there is nothing novel in a scheme like this, but I would like
to know if it is implemented somewhere. Articles say that bit errors on
disks are becoming more and more frequent, so schemes like this may help
the scary scenarion somewhat.

best regards
keld
