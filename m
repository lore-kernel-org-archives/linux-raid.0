From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question
Date: Tue, 6 Dec 2005 11:56:52 +0100
Message-ID: <002b01c5fa53$cd3d3fa0$0400a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs><17300.56329.638969.509384@cse.unsw.edu.au><004201c5f9fe$50cc41a0$0400a8c0@dcccs> <17300.58327.193597.248431@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > I know, it is some chance to leave some incorrect parity information on
the
> > array, but may be corrected by next write.
>
> Or it may not be corrected by the next write.  The parity-update
> algorithm assumes that the parity is correct.

Hmm.
If it works with parity-update algorithm, instead of parity "rewrite
algorithm", you have right.
But it works block-based, and if the entire block is written, the parity is
turned to de correct, or not? :-)
What is the block size?
It isequal to chunk-size?
Thanks the warning again!

> > (One possible way:
> > in this time rebuild the array with "--force-skip-resync" option or
> > something similar...)
>
> If you have mdadm 2.2. then you can recreate the array with
> '--assume-clean', and all your data should still be intact.  But if
> you get corruption one day, don't complain about it - it's your
> choice.

Ahh, thats what i want. :-)
(But reading this letter looks like unneccessary in this case...)


> > What does this exactly?
>
> Divides the array into approximately 200,000 sections (all a power of
> 2 in size) and keeps track (in a bitmap) of which sections might have
> inconsistent parity.  if you crash, it only syncs sections recorded in
> the bitmap.
>
> > Changes the existing array's structure?
>
> In a forwards/backwards compatible way (makes use of some otherwise
> un-used space).

What unused space?
In the raid superblock?
The end of the drives or the end of the array?
It leaves the raid structure unchanged except the superblocks?

>
> > Need to resync? :-D
>
> You really should let your array sync this time.  Once it is synced,
> add the bitmap.  Then next time you have a crash, the cost will be
> much smaller.

This looks like really good idea!
With this bitmap, the force skip resync is really unnecessary....

>
> > To use some checkpoints in ext file or device to resync an array?
> > And the better handling of half-synced array?
>
> I don't know what these mean.

(a little background:
I have write a little stat program, using /sys/block/#/stat -files, to find
performance bottlenecks.
In the stat files i can see, if the device is reads or writes, and the
needed times for these.)

One time while my array is really rebuild one disk (paralel normal
workload), i see, the new drive in the array *only* writes.
i means with "better handling of half-synced array" is this:
If read request comes to the ?% synced array, and if the read is on the
synced half, only need to read from *new* device, instead reading all other
to calculate data from parity.

On a working system this can be a little speed up the rebuild process, and
some offload the system.
Or i'm on a wrong clue? :-)

Cheers,
Janos

>
> NeilBrown

