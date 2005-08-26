From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: number of global spares?
Date: Fri, 26 Aug 2005 18:21:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0508261744030.16239-100000@coffee.psychology.mcmaster.ca>
References: <1125082848.25483.23.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1125082848.25483.23.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I've been working on a RAID setup with dual RAID controllers and
> three expansion boxes - 48 disks in all, including data, parity and
> global spares.

the first question you should ask is whether you're actually
winning by using HW raid.  yes, you already paid for it, but
SW raid offers some noticably better flexibility.

> Please be sure to use a fixed-pitch font when viewing the tables found
> below.  BTW, if people weren't so terrified of HTML, I could just make a
> nice HTML table for easy reading without silly font requirements...

it's not a matter of terror - many people still prefer ascii email.
(naturally, we also use fixed-pitch fonts for this.)

> global spares: 0,16,32,48
> 
> Raidset	Disks used	                  Data:parity ratio
> 0	      1,2,3,4,5,6,7,8,9,10          9:1
> 1	      11,17,18,19,20,21,22,23,24,25	9:1
> 2	      26,27,33,34,35,36,37,38,39,40	9:1
> 3	      41,42,43,49,50,51,52,53,54,55	9:1
> 4	      56,57,58,59                   3:1

why the magic numbers?  (5 raidsets, 9:1, etc)
you have 48 disks and "dual RAID controllers" (one channel each?) 
in 3 boxes, but what are your actual constraints?

also, if you have dual controllers, can you truely have global spares?
that is, a controller can use a spare disk that it's not connected to?

9:1 is nothing to be scared of, though it means that to do a full-stripe
write, you'll need quite large blocks.  I'd be tempted to use raid6
rather than 5+spares, though.

> And the vendor is suggesting that we move to something like:
> 
> global spares: 0
> 
> Raidset	Disks used	                  Data:parity ratio
> 0	      1,2,3,4,5,6,7,8,9,10          9:1
> 1	      11,17,18,19,20,21,22,23,24,25	9:1
> 2	      26,27,33,34,35,36,37,38,39,40	9:1
> 3	      41,42,43,49,50,51,52,53,54,55	9:1
> 4	      56,57,58,59,16,32,48          3:1

well, it just means that if you get a failure, you'll run in degraded
mode for a while, which is a window of vulnerability.

> ...or...:
> 
> global spares: 0,16
> 
> Raidset	Disks used	                  Data:parity ratio
> 0	      1,2,3,4,5,6,7,8,9,10          9:1
> 1	      11,17,18,19,20,21,22,23,24,25	9:1
> 2	      26,27,33,34,35,36,37,38,39,40	9:1
> 3	      41,42,43,49,50,51,52,53,54,55	9:1
> 4	      56,57,58,59,32,48             3:1

2 spares seems OK to me, assuming a reasonable failure rate (>2 years
aggregate mtbf)

> Does anyone have any comments on:
> 
> 1) The sanity of these 10 disk RAID 5's?

if you're not worried about write performance, then sure.
I had an 18x raid5 for a while, but decided it was too hostile
to writes (iirc, a whole-stripe write was > 1MB)

> 2) The degree of loss of reliability incurred by moving 3 disks from
> global spare to data?

spares do not increase reliability, they reduce the window of 
vulnerability when you do have a "partial lack of reliability"...

> 3) The degree of loss of reliability incurred by moving 2 disks from
> global spare to data?

MTBF/ndisks hasn't changed here, at least for a particular raidset.
the chance of simultaneous failures of 2+ disks in multiple raidsets
seems pretty small...

> They don't feel that the storage has to be blazing fast, and 100% uptime
> isn't paramount, however they very much do not want to lose their data.

but their "very much" doesn't extend to two-site mirroring, eh?
there are unfortunate phenomena that can lead to bad behavior in 
a server like this, even when you do the due-dilligence (mtbf calcs,
spares, etc).  for instance, in the event of r5 failure, the spare
will trigger a rebuild, which can stress the surviving disks enough 
to cause further failures.  oops!  I guess that's the main reason 
I like raid6 better.

> The filesystem will not be backed up - we simply don't have anything large
> enough to back it up -to-, so if the some part of the storage solution
> goes kerflooey, we're totally...  er...  out of luck, and they'll probably
> be looking at me (the primary sysadmin on the storage configuration),
> wondering why their data is gone.

this is a sticky subject, to be sure.  I tell people not to think about 
backups, or if they do, to think more in terms of mirroring.  perhaps that 
reflects scars I bear from dealing with finicky/flakey/frustrating tape
systems.  one good thing for you is that you say the files are fairly small,
so you *could* spew them onto something like DVD's.  I'd treat that as 
an archive, not a backup, and not abandon normal raid5-6 practices.

