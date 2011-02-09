From: Doug Dumitru <doug@easyco.com>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 11:15:48 -0800
Message-ID: <AANLkTi=+w-q8s-y-K-24ZwSLsLrJ44Oh9LiF3ReeyYdP@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
	<AANLkTim-S0nTC8-r1U2xQ9Gw3EVAZHDjSxT=tnNnHmCT@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim-S0nTC8-r1U2xQ9Gw3EVAZHDjSxT=tnNnHmCT@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: "Scott E. Armitage" <launchpad@scott.armitage.name>, Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I work with SSDs arrays all the time, so I have a couple of thoughts
about trim and md.

'trim' is still necessary.  SandForce controllers are "better" at
this, but still need free space to do their work.  I had a set of SF
drives drop to 22 MB/sec writes because they were full and scrambled.
It takes a lot of effort to get them that messed up, but it can still
happen.  Trim brings them back.

The bottom line is that SSDs do block re-organization on the fly and
free space makes the re-org more efficient.  More efficient means
faster, and as importantly less wear amplification.

Most SSDs (and I think the latest trim spec) are deterministic on
trim'd sectors.  If you trim a sector, they read that sector as zeros.
 This makes raid much "safer".

raid/0,1,10 should be fine to echo discard commands down to the
downstream drives in the bio request.  It is then up to the physical
device driver to turn the discard bio request into an ATA (or SCSI)
trim.  Most block devices don't seem to understand discard requests
yet, but this will get better over time.

raid/4,5,6 is a lot more complicated.  With raid/4,5 with an even
number of drives, you can trim whole stripes safely.  Pieces of
stripes get interesting because you have to treat a trim as a write of
zeros and re-calc parity.  raid/6 will always have parity issues
regardless of how many drives there are.  Even worse is that
raid/4,5,6 parity read/modify/write operations tend to chatter the FTL
(Flash Translation Layer) logic and make matters worse (often much
worse).  If you are not streaming long linear writes, raid/4,5,6 in a
heavy write environment is a probably a very bad idea for most SSDs.

Another issue with trim is how "async" it behaves.  You can trim a lot
of data to a drive, but it is hard to tell when the drive actually is
ready afterwards.  Some drives also choke on trim requests that come
at them too fast or requests that are too long.  The behavior can be
quite random.  So then comes the issue of how many "user knobs" to
supply to tune what trims where.  Again, raid/0,1,10 are pretty easy.
Raid/4,5,6 really requires that you know the precise geometry and
control the IO.  Way beyond what ext4 understands at this point.

Trim can also be "faked" with some drives.  Again, looking at the
SandForce based drives, these drive internally de-dupe so you can fake
write data and help the drives get free space.  Do this by filling the
drive with zeros (ie, dd if=/dev/zero of=big.file bs=1M), do a sync,
and then delete the big.file.  This works through md, across SANs,
from XEN virtuals, or wherever.  With SandForce drives, this is not as
effective as a trim, but better than nothing.  Unfortunately, only
SandForce drives and Flash Supercharger understand zero's this way.  A
filesystem option that "zeros discarded sectors" would actually make
as much sense in some deployment settings as the discard option (not
sure, but ext# might already have this).  NTFS has actually supported
this since XP as a security enhancement.

Doug Dumitru
EasyCo LLC

ps:  My background with this has been the development of Flash
SuperCharger.  I am not trying to run an advert here, but the care and
feeding of SSDs can be interesting.  Flash SuperCharger breaks most of
these rules, but it does know the exact geometry of what it is driving
and plays excessive games to drives SSDs at their exact "sweet spot".
One of our licensees just sent me some benchmarks at > 500,000 4K
random writes/sec for a moderate sized array running raid/5.

pps:  Failures of SSDs are different than HDDs.  SSDs can and do fail
and need raid for many applications.  If you need high write IOPS, it
pretty much has to be raid/1,10 (unless you run our Flash SuperCharger
layer).

ppps:  I have seen SSDs silently return corrupted data.  Disks do this
as well.  A paper from 2 years ago quoted disk silent error rates as
high as 1 bad block every 73TB read.  Very scary stuff, but probably
beyond the scope of what md can address.
