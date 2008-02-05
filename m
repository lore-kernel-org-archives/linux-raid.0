From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: recommendations for stripe/chunk size
Date: Tue, 5 Feb 2008 19:24:21 +0100
Message-ID: <20080205182421.GA32250@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I am looking at revising our howto. I see a number of places where a
chunk size of 32 kiB is recommended, and even recommendations on
maybe using sizes of 4 kiB. 

My own take on that is that this really hurts performance. 
Normal disks have a rotation speed of between 5400 (laptop)
7200 (ide/sata) and 10000 (SCSI) rounds per minute, giving an average
spinning time for one round of 6 to 12 ms, and average latency of half
this, that is 3 to 6 ms. Then you need to add head movement which
is something like 2 to 20 ms - in total average seek time 5 to 26 ms,
averaging around 13-17 ms. 

in about 15 ms you can read on current SATA-II (300 MB/s) or ATA/133 
something like between 600 to 1200 kB, actual transfer rates of
80 MB/s on SATA-II and 40 MB/s on ATA/133. So to get some bang for the buck,
and transfer some data you should have something like 256/512 kiB
chunks. With a transfer rate of 50 MB/s and chunk sizes of 256 kiB
giving about a time of 20 ms per transaction
you should be able with random reads to transfer 12 MB/s  - my
actual figures is about 30 MB/s which is possibly because of the
elevator effect of the file system driver. With a size of 4 kb per chunk 
you should have a time of 15 ms per transaction, or 66 transactions per 
second, or a transfer rate of 250 kb/s. So 256 kb vs 4 kb speeds up
the transfer by a factor of 50. 

I actually  think the kernel should operate with block sizes
like this and not wth 4 kiB blocks. It is the readahead and the elevator
algorithms that save us from randomly reading 4 kb a time.

I also see that there are some memory constrints on this.
Having maybe 1000 processes reading, as for my mirror service,
256 kib buffers would be acceptable, occupying 256 MB RAM.
That is reasonable, and I could even tolerate 512 MB ram used.
But going to 1 MiB buffers would be overdoing it for my configuration.

What would be the recommended chunk size for todays equipment?

Best regards
Keld
