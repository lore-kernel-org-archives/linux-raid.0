From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Performance question
Date: Sat, 17 Jan 2009 23:08:49 +0100
Message-ID: <20090117220849.GB29866@rap.rap.dk>
References: <20090117171806.GA9432@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090117171806.GA9432@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 17, 2009 at 06:18:06PM +0100, Piergiorgio Sartor wrote:
> Hi all,
> 
> I'll have to setup some machines with two HDs (each)
> in order to get some redundancy.
> 
> Reading the MD features I noticed there are several
> possibilities to create a mirror.
> I was wondering which one offer the best perfomances
> and/or what are the compromises to accept between
> the different solutions.
> 
> One possibility is a classic RAID-1 mirror.
> Another is a RAID-10 far.
> There would also be the RAID-10 near, but I guess
> this is equivalent to RAID-1.

Yes, raid10,n2 is quite the same as raid1 for 2 drives,
That is the disk layout is the same. There may be some 
differences due to the use of different drivers, tho. It was reported at
some time that there were some errors that one of the drivers handled
better than the other. I am not sure which one was the better.
Also syncing and rebuilding etc. may have different performance.

> Any suggestion on which method offers higher "speed"?
> Or there are other possibilities with 2 HDs (keeping
> the redundancy, of course)?

raid10,f2 offers something like double the speed for sequential read,
while probably being a little faster on random read, and with a file
system about equal in performance on writes. Degraded performance (in
tha case that one disk is failing) could be worse for raid10,f2, but in
real life, with the fs elevator in operation, the penalty may be
minimal. IMHO you could normally replace raid1 and raid10,n2, and
raid1+0 with raid10,f2, except for boot devices.

Theoretically there is another possibility in raid5 with 2 drives,
but I am not sure it even works out in practice, and there is imho no
gain in it, except that you can expand the array with more disks.
Furthermore there is raid10,o2 which is viable, but does not
perform as well as raid10,f2.

For linux raid performance have a look at
http://linux-raid.osdl.org/index.php/Performance

For setting up a system with 2 disks so you can survive that one disk
fails, see
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

I am the main author of both wiki pages, so I am interested in feedback.

Best regards
Keld
