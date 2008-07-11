From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: resync'ing - what is going on
Date: Sat, 12 Jul 2008 00:29:27 +0200
Message-ID: <20080711222927.GA10862@rap.rap.dk>
References: <20080710165459.GA17542@rap.rap.dk> <18550.59093.835573.290313@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18550.59093.835573.290313@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I took the information here and made something for the wiki.
Comments welcome.  /keld

= recovery and resync =

The following is a recollection of what Neil Brown and others have
written 
on the linux-raid mailing list.

"resync" and "recovery" are handled very differently in raid10.
"check" and "repair" are special cases of "resync".

== recovery ==

The purpose of the recovery process is to fill a new disk with the
relevant 
information from a running array.

The assumption is that all data do the new disk needs to be written.

"recovery" walks addresses from the start to the end of the component
drives.

At each address, it considers each drive which is being recovered and
finds a place on a different device to read the block for the current
(drive,address) from.  It schedules a read and when the read request
completes it schedules the write.

On an f2 layout, this will read one drive from halfway to the end,
then from the start to halfway, and will write the other drive
sequentially.

== resync ==

The purpose of resync is to ensure that all data on the array is
syncronized.

There is an assumption that most, if not all, of the data is allready
OK.

"resync" walks the addresses from the start to end of the array.

At each address it reads every device block which stores that
array block.  When all the reads complete the results are compared.
If they are not all the same, the "first" block is written out 
to the others. 

Here "first" means (I think) the block with the earliest device
address, and if there are several of those, the block with the least
device index.

So for f2, this will read from both the start and the middle of
both devices.  It will read 64K (the chunk size) at a time, so you
should get at least
a 32K read at each position before a seek (more with a larger chunk
size).

Clearly this won't be fast.

The reason this algorithm was chosen was that it makes sense for every
possible raid10 layout, even though it might not be optimal for some
of them.

Were I to try to make it fast for f2, I would probably shuffle the
bits in each request so that it did all the 'odd' chunks first, then
all the even chunks.
e.g. map
 
  0 1 2 3 4 5 6 7 8 ...
to

  0 1 4 5 8 9 .....  2 3 6 7 10 11 ....
(assuming a chunk size of '2').

The problem with this is that if you shutdown while part way though a
resync,  and then boot into a kernel which used a different
sequence, it would finish the resync checking the wrong blocks.
This is annoying but should not be insurmountable.

This way we leave the basic algorithm the same, but introduce
variations in the sequence for different specific layouts.

Another idea would be to read a number of chunks from one part of the f2
mirror,
say 10 MB, and then read then corresponding 10 MB from the other half of
the f2 
array. This would on current disk technology (80 MB/s) mean 125 ms spent
reading, 
and then 8 ms spent moving heads. 

raid1 does resync simply by reading one device and writing all the
others, and this is conceptually easiest. 

When repairing, there is no "good" block - if they are different, then
all are wrong.
md/raid just tries to return a consistent value, and leave it up to
the filesystem to find and correct any errors. 
md/raid does not try to take advantage of information on failed CRC on
disk 
hardware, should that info be available to the kernel. 

If any inconsistency is found during a resync of raid4/5/6 the parity
blocks are changed to remove the inconsistency.  This may not be
"right", but it is least likely to be "wrong".

On Fri, Jul 11, 2008 at 02:51:33PM +1000, Neil Brown wrote:
> On Thursday July 10, keld@dkuug.dk wrote:
> > I would like to know what is going on wrt resyncing, how it is done.
> > This is because I have some ideas to speed up the process. 
> > I have noted for a 4 drive raid10,f2 array that only about 25 % of the
> > IO speed is used during the rebuid, I would like to have something like
> > 90 % as a goal.
> 
> "resync" and "recovery" are handled very differently in raid10.
> "check" and "repair" are special cases of "resync".
> 
> "recovery" walks addresses from the start to the end of the component
> drives.
> At each address, it considers each drive which is being recovered and
> finds a place on a different device to read the block for the current
> (drive,address) from.  It schedules a read and when the read request
> completes it schedules the write.
> 
> On an f2 layout, this will read one drive from halfway to the end,
> then from the start to halfway, and will write the other drive
> sequentially.
> 
> "resync" walks the addresses from the start to end of the array.
> At each address it reads every device block which stores that
> array block.  When all the reads complete the results are compared.
> If they are not all the same, the "first" block is written out
> to the others.  (I think I might have told you before that it reads
> one block and writes the others.  I checked the code and what is
> wrong).
> 
> Here "first" means (I think) the block with the earliest device
> address, and if there are several of those, the block with the least
> device index.
> 
> So for f2, this will read from both the start and the middle of
> both devices.  It will read 64K at a time, so you should get at least
> a 32K read at each position before a seek (more with a larger chunk
> size).
> 
> Clearly this won't be fast.
> 
> The reason this algorithm was chosen was that it makes sense for every
> possible raid10 layout, even though it might not be optimal for some
> of them.
> 
> > 
> > This is especially for raid10,f2, where I think I can make it much
> > better, but posssibly also for other raid types, as input to an
> > explanation on the wiki of what is really going on. 
> 
> Were I to try to make it fast for f2, I would probably shuffle the
> bits in each request so that it did all the 'odd' chunks first, then
> all the even chunks.
> e.g. map
>    0 1 2 3 4 5 6 7 8 ...
> to
>    0 1 4 5 8 9 .....  2 3 6 7 10 11 ....
> (assuming a chunk size of '2').
> 
> The problem with this is that if you shutdown while part way though a
> resync,  and then boot into a kernel which used a different
> sequence, it would finish the resync checking the wrong blocks.
> This is annoying but should not be insurmountable.
> 
> This way we leave the basic algorithm the same, but introduce
> variations in the sequence for different specific layouts.
> 
> > 
> > Are there references on the net? I tried to look but did not really find
> > something.
> 
> Just the source, sorry.
> 
> > 
> > I don't really understand why resync is going on for raid10,f2.
> > But maybe it checks all of the array, and checks that the two copies are
> > identical. Is that so? I got some communication with Neil that some
> > writing is involved in the resync, I don't understand why. 
> 
> raid1 does resync simply by reading one device and writing all the
> others, and this is conceptually easiest.  I had mistakenly thought
> that I had used the same approach in raid10.
> 
> > 
> > And what happens if a discrepancy is found? Which of the 2 copies are the
> > good one? Maybe one could look if there are any CRC errors, or disk read
> > retries going on. I could understand if it was a raid10,f3 - then if one
> > was different from the 2 other copies - you could correct the odd copy.
> 
> There is no "good" block - if they are different, then all are wrong.
> md/raid just tries to return a consistent value, and leave it up to
> the filesystem to find and correct any errors.
> 
> > 
> > For raid5 and raid6 I could imagine that the parity blocks were cheked.
> 
> If any inconsistency is found during a resync of raid4/5/6 the parity
> blocks are changed to remove the inconsistency.  This may not be
> "right", but it is least likely to be "wrong".
> 
> > 
> > I could of cause read the code, but I would like an overview before
> > dwelving into that part.
> 
> Sensible :-)
> Enjoy your reading.
> 
> NeilBrown
