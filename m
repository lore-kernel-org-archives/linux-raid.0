From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Fri, 21 Sep 2007 13:01:14 -0700 (PDT)
Message-ID: <20070921200114.45CE410237E@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan> <20070919014919.DF19D10215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan> <20070919174956.9497310209D@medulla.enet.sharplabs.com> <46F292E2.1090700@tmr.com> <20070920184738.441FD10208C@medulla.enet.sharplabs.com> <46F2E159.9030806@msgid.tls.msk.ru> <20070921005851.44E8910236D@medulla.enet.sharplabs.com> <46F3C058.1050701@tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <46F3C058.1050701@tmr.com> (message from Bill Davidsen on Fri, 21
	Sep 2007 09:00:08 -0400)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Bill Davidsen wrote:
  Dean Messing wrote:
: > I understand I only get the speed of a single drive was I was not
: > aware of the safety factor.  I had intended to use snapshotting off
: > to a cheap USB drive each evening.  Will that not keep me safe within a
: > day's worth of data change?  I only learned about "snapshots" yesterday.
: > I'm utterly new to the disk array/LVM game.
: >   
: 
: But your read speed need not be limited if you tune the readahead. 
: There's also the question of how much transfer speed you actually 
: *need*. If your application is CPU-bound faster will not be the same as 
: "runs in less time," and random access is limited by the seek speed of 
: your drives, although some RAID tuning does apply to random writes.

This is my main workstation.  I do many things on it, not just "an
application".  I live on the machine.  It will run XP on top of
VMware.  It will transcode video. It will run map software, emacs,
mail, mplayer, re-compile large applications like ImageMagick,
Transcode, and Scilab, and much more.

The video/image processing (whch can be random access) is just an
example.  Increasing readahead does increase the sequential read speed
for RAID5.  But the random read speed suffers and the write speed
suffers a loss of 20% over single disk writes (according to the
bonnie++ numbers).  RAID0 on the other machine "spoiled me", I'm
afraid.

Question: From what I've read, when reading in RAID5, parity is not
read.  Why then does read speed suffer so badly with the default
Readahead parameter?

: When you process video and monitor the system with vmstat, do you see 
: significant iowait time? No, neither do I, with a modest readahead I am 
: totally CPU limited. If you are searching your mail database, if you 
: just use a text tool which reads everything, that's pure sequential 
: access. And unless you actually *use* the locate command, building that 
: database is just a way to beat your disks (and it's more sequential than 
: you would expect). You can turn it off and do your bit to avoid global 
: warming.

I have not used vmstat, but I am dealing with 4Kx2K 24bit uncompressed
video frames.  mplayer, for one, is quite disk i/o limited.  So are
several spatio-temporal adaptive interpolation algorithms we work on
for upscaling video (part of my research).  I can see this from the
gkrellm disk meter both during video i/o and when swap space is
getting used.

Funny you should mention "locate".  I use it heavily to find stuff.  I
typically generate results on any of 4 different machines, and then
`scp' the results around between the machines.  So I rebuild the
database relatively often.  On another machine that I bought from
Dell, configured with RAID0, everything is very snappy.

Rebuilding the "locate" db simply flew.  It is that uniform snappiness
I was hoping (against hope?) to duplicate on this current workstation
with a third drive and RAID5.

: > : If no, maybe raid10 over
: > : the same 3 drives will give better results.
: >
: > Does RAID10 work on three drives?  I though one needed 4 drives,
: > with striping across a pair of mirrored pairs.
: 
: No, that's 0+1, RAID-10 works across any number of drives.
:
: Have you actually take 10-15 minutes to read "man md" and get the 
: overview of how RAID works, or are you reading bits and pieces about 
: individual features?

I confess I have not read the md man page.  (I shall, right after
this.)  I have read the mdadm page pretty thoroughly.  And I've read
parts of lots of other stuff in the last few days.  It has all
uniformly said that RAID-10 is "striped mirrors" and requires 4
drives.

One such example (which I just googled) is:

<http://www.pcguide.com/ref/hdd/perf/raid/levels/multLevel01-c.html>
<http://www.pcguide.com/ref/hdd/perf/raid/levels/multXY-c.html>

I suppose Linux Software Raid is more general and allows 3 drives
in a RAID-10 config.  I'll find out in a few minutes.


In my last note I asked:

> : 
> : "Putting three disks together as a big LV" - that's exactly what
> : "linear" md module.  
> : It's almost as unsafe as raid0, but with
> : linear read/write speed equal to speed of single drive...
>
> I understand I only get the speed of a single drive but I was not
> aware of the safety factor.  I had intended to use snapshotting off
> to a cheap USB drive each evening.  Will that not keep me safe within a
> day's worth of data change?  I only learned about "snapshots" yesterday.
> I'm utterly new to the disk array/LVM game.

<snip>

> For that matter why not run a RAID-0 + LVM  across two of the three drives
> and snapshot to the third?

What do you think about the RAID-0 + LVM plus daily snapshots?  I am
not running a server.  In the (fairly remote) chance that I do have a
RAID 0 failure, I can tolerate the couple of hours it will take to
rebuild the file system and be back up and running (in ordinary
non-RAID mode).

Dean
