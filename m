From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Looking for the cause of poor I/O performance
Date: Wed, 8 Dec 2004 17:25:24 -0500
Message-ID: <200412082225.iB8MPT915415@www.watkins-home.com>
References: <20041208220004.GA13541@hamachi.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041208220004.GA13541@hamachi.us>
Sender: linux-raid-owner@vger.kernel.org
To: 'Steven Ihde' <x-linux-raid@hamachi.dyndns.org>
Cc: 'David Greaves' <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good question!
"One other point -- apparently 2.6 allows one to set the read-ahead on a
per-device basis (maybe 2.4 does too, I don't know).  So would it make sense
to set read-ahead on the disks low (or zero), and read ahead on the MD
device high?  Perhaps this could allow us to avoid the overhead of reading
unnecessary parity chunks.  As the number of disks increases this would be
less and less significant."

I was wondering about this myself.

I have read other people have played with the numbers, but I can't.
# blockdev --getra /dev/md2
1024
# blockdev --setra 2048 /dev/md2
BLKRASET: Invalid argument
# blockdev --setra 1024 /dev/md2
BLKRASET: Invalid argument

I can change read ahead on each drive.  I can set read ahead from 0 to 255
on my disks, but this seems to have no effect.  My performance using "hdparm
-t /dev/md2" stays about the same.

Odd, I just tried other sizes with md2.  I can change read ahead from 0 to
255 also.  But it was 1024.  With read ahead set to 0 on all of my disks and
on md2, I still get the same performance.  I guess on on-disk cache read
ahead does just fine.

My kernel is 2.4.28.

Guy

-----Original Message-----
From: Steven Ihde [mailto:x-linux-raid@hamachi.dyndns.org] 
Sent: Wednesday, December 08, 2004 5:00 PM
To: Guy
Cc: 'David Greaves'; linux-raid@vger.kernel.org
Subject: Re: Looking for the cause of poor I/O performance


OK, between your discussion of read-ahead and Monday's post by Morten
Olsen about /proc/sys/vm/max-readahead, I think I get it now.  

I'm using kernel 2.6 so /proc/sys/vm/max-readahead doesn't exist, but
"blockdev --getra/--setra" seems to do the trick.  By increasing
readahead on my array device from 256 (the default) to 1024, I can
achieve 80MB/sec sequential read throughput (where before I could get
only 40MB/sec, same as a single disk).

As you point out while it helps sequential reads it may hurt random
reads, so I'll test a little more and see.

One other point -- apparently 2.6 allows one to set the read-ahead on
a per-device basis (maybe 2.4 does too, I don't know).  So would it
make sense to set read-ahead on the disks low (or zero), and readahead
on the MD device high?  Perhaps this could allow us to avoid the
overhead of reading unecessary parity chunks.  As the number of disks
increases this would be less and less significant.

-Steve

On Wed, 08 Dec 2004 13:31:27 -0500, Guy wrote:
> "read balancing" will help regardless of random or sequential disk access.
> It can double your performance (assuming 2 disks).
> 
> "read ahead" only helps sequential access, it hurts random access.
> 
> Yes, I understand "read balancing" to be balancing the IO over 2 or more
> disks, when only 1 disk is really needed.  So, you need 2 or more copies
of
> the data, as in RAID1.
> 
> About read ahead...
> The physical disks read ahead.
> md does read ahead.
> Since the disks and md are doing read ahead, you should have more than 1
> disk reading at the same time.  The physical disks are not very smart
about
> RAID5, when reading ahead, they will also read the parity data, which is
> wasted effort.
> 
> With all of the above going on you should get more than 1 disk reading
data
> at the same time.
> 
> With RAID(0, 4, 5 and 6) no one can choose which disk(s) to read.  You
can't
> balance anything.  You can only predict what data will be needed before it
> is requested.  Read ahead does this for large files (sequential reads).  I
> would not consider this to be "read balancing", just read ahead.
> 
> Guy
> 
> -----Original Message-----
> From: David Greaves [mailto:david@dgreaves.com] 
> Sent: Wednesday, December 08, 2004 4:24 AM
> To: Guy
> Cc: 'Steven Ihde'; linux-raid@vger.kernel.org
> Subject: Re: Looking for the cause of poor I/O performance
> 
> My understanding of 'readahead' is that when an application asks for 312 
> bytes of data, the buffering code will anticipate more data is required 
> and will fill a buffer (4096 bytes). If we know that apps are really 
> greedy and read *loads* of data then we set a large readahead which will 
> cause the buffer code (?) to fill a further n buffers/kb according to 
> the readahead setting. This will all be read sequentially and the 
> performance boost is because the read heads on the drive get all the 
> data in one 'hit' - no unneeded seeks, no rotational latency.
> 
> That's not the same as raid5 where when asked for 312 bytes of data, the 
> buffering code wil fill the 4k buffer and then will issue a readahead on 
> the next n kb of data - which is spread over multiple disks, which read 
> in parallel, not sequentially.
> 
> Yes, the readahead triggers this behaviour - but you say "RAID5 can't do 
> read balancing." - which I thought it could through this mechanism.
> 
> It depends whether the original use of "read balancing" in this context 
> means "selecting a drive to obtain the data from according to the 
> drive's read queue" (no) or "distributing reads amongst the drives to 
> obtain a throughput greater than that of one individual drive" (yes)
> (OK, the terminology is not quite exact but...)
> 
> do we agree? Or have I misunderstood something?
> 
> David
> 
> Guy wrote:
> 
> >Yes.  I did say it reads ahead!
> >
> >Guy
> >
> >-----Original Message-----
> >From: linux-raid-owner@vger.kernel.org
> >[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
> >Sent: Monday, December 06, 2004 4:10 PM
> >To: Guy
> >Cc: 'Steven Ihde'; linux-raid@vger.kernel.org
> >Subject: Re: Looking for the cause of poor I/O performance
> >
> >but aren't the next 'n' blocks of data on (about) n drives that can be 
> >read concurrently (if the read is big enough)
> >
> >Guy wrote:
> >
> >  
> >
> >>RAID5 can't do read balancing.  Any 1 piece of data is only on 1 drive.
> >>However, RAID5 does do read ahead, my speed is about 3.5 times as fast
as
> a
> >>single disk.  A single disk: 18 M/sec, my RAID5 array, 65 M/sec.
> >>
> >>Guy
> >>
> >>-----Original Message-----
> >>From: linux-raid-owner@vger.kernel.org
> >>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Steven Ihde
> >>Sent: Monday, December 06, 2004 12:49 PM
> >>To: linux-raid@vger.kernel.org
> >>Subject: Re: Looking for the cause of poor I/O performance
> >>
> >>On Sat, 04 Dec 2004 17:00:08 -0800, Steven Ihde wrote:
> >>[snip]
> >> 
> >>
> >>    
> >>
> >>>A possible clue is that when tested individually but in parallel, hda
> >>>and hdc both halve their bandwidth:
> >>>
> >>>/dev/hda:
> >>>Timing cached reads:   1552 MB in  2.00 seconds = 774.57 MB/sec
> >>>Timing buffered disk reads:   68 MB in  3.07 seconds =  22.15 MB/sec
> >>>/dev/hdc:
> >>>Timing cached reads:   784 MB in  2.00 seconds = 391.86 MB/sec
> >>>Timing buffered disk reads:   68 MB in  3.02 seconds =  22.54 MB/sec
> >>>/dev/sda:
> >>>Timing cached reads:   836 MB in  2.00 seconds = 417.65 MB/sec
> >>>Timing buffered disk reads:  120 MB in  3.00 seconds =  39.94 MB/sec
> >>>
> >>>Could there be contention for some shared resource in the on-board
> >>>PATA chipset between hda and hdc?  Would moving one of them to a
> >>>separate IDE controller on a PCI card help?
> >>>
> >>>Am I unreasonable to think that I should be getting better than 37
> >>>MB/sec on raid5 read performance, given that each disk alone seems
> >>>capable of 40 MB/sec?
> >>>   
> >>>
> >>>      
> >>>
> >>To answer my own question... I moved one of the PATA drives to a PCI
> >>PATA controller.  This did enable me to move 40MB/sec simultaneously
> >>    
> >>
> >>from all three drives.  Guess there's some issue with the built-in
> >  
> >
> >>PATA on the ICH5R southbridge.
> >>
> >>However, this didn't help raid5 performance -- it was still about
> >>35-39MB/sec.  I also have a raid1 array on the same physical disks,
> >>and observed the same thing there (same read performance as a single
> >>disk with hdparm -tT, about 40 MB/sec).  So:
> >>
> >>2.6.8 includes the raid1 read balancing fix which was mentioned
> >>previously on this list -- should this show up as substantially better
> >>hdparm -tT numbers for raid1 or is it more complicated than that?
> >>
> >>Does raid5 do read-balancing at all or am I just fantasizing?
> >>
> >>Thanks,
> >>
> >>Steve

