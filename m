From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Tue, 15 Jan 2013 22:31:43 -0700
Message-ID: <201301152231.43704.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301142052.06390.thomas@fjellstrom.ca> <50F5157A.2080308@hardwarefreak.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F5157A.2080308@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue Jan 15, 2013, Stan Hoeppner wrote:
> On 1/14/2013 9:52 PM, Thomas Fjellstrom wrote:
> ...
> 
> > I haven't been comparing it against my other system, as its kind of
> > apples and oranges. My old array, on somewhat similar hardware for the
> > most part, but uses older 1TB drives in RAID5.
> 
> ...
> 
> > It is working. And I can live with it as is, but it does seem like
> > something isn't right. If thats just me jumping to conclusions, well
> > thats fine then. But 600MB/s+ reads vs 200MB/s writes seems a tad off.
> 
> It's not off.  As myself and others stated previously, this low write
> performance is typical of RAID6, particularly for unaligned or partial
> stripe writes--anything that triggers a RMW cycle.

That gets me thinking. Maybe try a test with the record test size set to the 
stripe width, that would hopefully show some more accurate numbers.

If that large of a difference between reads and writes is perfectly normal, I 
can accept that. I am wondering what kinds of numbers others see, real world 
wise.

> > I'm running the same iozone test on the old array, see how it goes. But
> > its currently in use, and getting full (84G free out of 5.5TB), so I'm
> > not positive how well it'll do as compared to if it was a fresh array
> > like the new nas array.
> 
> ...
> 
> > Preliminary results show similar read/write patterns (140MB/s write,
> > 380MB/s read), albeit slower probably due to being well aged, in use,
> > and maybe the drive speeds (the 1TB drives are 20-40MB/s slower than the
> > 2TB drives in a straight read test, I can't remember the write
> > differences).
> 
> Yes, the way in which the old filesystem has aged, and the difference in
> single drive performance, will both cause lower numbers on the old
> hardware.
> 
> What you're really after, what you want to see, is iozone numbers from a
> similar system with a 7 drive md/RAID6 array with XFS.  Only that will
> finally convince you, one way or the other, that your array is doing
> pretty much as well as it can, or not.  However, even once you've
> established this, it still doesn't inform you as to how well the new
> array will perform with your workloads.

In the end, the performance I am getting is more than I currently use day to 
day. So its not a huge problem I need to solve, rather its something I thought 
was odd, and wanted to figure out.

> On that note, someone stated you should run iozone using O_DIRECT writes
> to get more accurate numbers, or more precisely, to eliminate the Linux
> buffer cache from the equation.  Doing this actually makes your testing
> LESS valid, because your real world use will likely include all buffered
> IO, and no direct IO.

I didn't think it'd be a very good test of real world performance, but it 
can't hurt to be thorough. Though I just checked on it, that one run is still 
going, and it seems like it may be quite a while.

> What you should be concentrating on right now is identifying if any of
> your workloads make use of fsync.  If they do not, or if the majority do
> not (Samba does not by default IIRC, neither does NFS), then you should
> be running iozone with fsync disabled.  In other words, since you're not
> comparing two similar systems, you should be tweaking iozone to best
> mimic your real workloads.  Running iozone with buffer cache and with
> fsync disable should produce higher write numbers, which should be
> closer to what you will see with your real workloads.

I doubt very much of my workload uses fsync, though if I move some p2p stuff 
to it /may/ use fsync, to be honest, I'm not sure which (if any) p2p clients 
use fsync. Or if I particularly care in that case. P2P performance really 
depends on decent random writes of 512KB-4MB which an array like this isn't 
exactly going to excel at.

P2P is one reason I was interested in ssd caching (tried playing with bcache, 
it seemed to cut read speeds down to 200MB/s or something crazy, likely a 
misconfig on my part, I still have to finish looking into that, the author 
suggested changing the cache mode).

I've found it incredibly annoying when video playback stutters due to other 
activity on the array. It used to happen often enough due to the different 
jobs I had it doing. At one point it held VM images, regular rsnapshot 
backups, all of my media, and some torrent downloads. Over the past while I've 
slowly pulled one job after another off the old array till all that its really 
doing now is storing random downloads, p2p and media file streaming.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
