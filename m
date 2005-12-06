From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question
Date: Tue, 6 Dec 2005 12:05:27 +1100
Message-ID: <17300.58327.193597.248431@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
	<17300.56329.638969.509384@cse.unsw.edu.au>
	<004201c5f9fe$50cc41a0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Tuesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 6, djani22@dynamicweb.hu wrote:
> 
> ----- Original Message ----- 
> From: "Neil Brown" <neilb@suse.de>
> To: "JaniD++" <djani22@dynamicweb.hu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Tuesday, December 06, 2005 1:32 AM
> Subject: Re: RAID5 resync question
> 
> 
> > On Tuesday December 6, djani22@dynamicweb.hu wrote:
> > > Hello, list,
> > >
> > >
> > > Is there a way to force the raid to skip this type of resync?
> >
> > Why would you want to?
> > The array is 'unclean', presumably due to a system crash.  The parity
> > isn't certain to be correct so your data isn't safe against a device
> > failure.  You *want* this resync.
> 
> Thanks for the warning.
> Yes, you have right, the system is crashed.
> 
> I know, it is some chance to leave some incorrect parity information on the
> array, but may be corrected by next write.

Or it may not be corrected by the next write.  The parity-update
algorithm assumes that the parity is correct.


> On my system is very little dirty data, thanks to vm configuration and
> *very* often flushes.
> The risk is low, but the time what takes the resync is bigger problem. :-(
> 
> If i can, i want to break this resync.
> And same on the fresh NEW raid5 array....
> 
> (One possible way:
> in this time rebuild the array with "--force-skip-resync" option or
> something similar...)

If you have mdadm 2.2. then you can recreate the array with
'--assume-clean', and all your data should still be intact.  But if
you get corruption one day, don't complain about it - it's your
choice.

> 
> >
> > If you are using 2.6.14 to later you can try turning on the
> > write-intent bitmap (mdadm --grow /dev/md0 --bitmap=internal).
> > That may impact write performance a bit (reports on how much would be
> > appreciated) but will make this resync-after-crash much faster.
> 
> Hmm.
> What does this exactly?

Divides the array into approximately 200,000 sections (all a power of
2 in size) and keeps track (in a bitmap) of which sections might have
inconsistent parity.  if you crash, it only syncs sections recorded in
the bitmap.

> Changes the existing array's structure?

In a forwards/backwards compatible way (makes use of some otherwise
un-used space).

> Need to resync? :-D

You really should let your array sync this time.  Once it is synced,
add the bitmap.  Then next time you have a crash, the cost will be
much smaller.

> Safe with existing data?

Yes.

> 
> What do you think about full external "log"?

Too much overhead without specialised hardware.

> To use some checkpoints in ext file or device to resync an array?
> And the better handling of half-synced array?

I don't know what these mean.

NeilBrown
