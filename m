From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: recommendations for stripe/chunk size
Date: Tue, 5 Feb 2008 14:19:04 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802051418280.9790@p34.internal.lan>
References: <20080205182421.GA32250@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1958478426-1202239144=:9790"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205182421.GA32250@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1958478426-1202239144=:9790
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 5 Feb 2008, Keld J=F8rn Simonsen wrote:

> Hi
>
> I am looking at revising our howto. I see a number of places where a
> chunk size of 32 kiB is recommended, and even recommendations on
> maybe using sizes of 4 kiB.
>
> My own take on that is that this really hurts performance.
> Normal disks have a rotation speed of between 5400 (laptop)
> 7200 (ide/sata) and 10000 (SCSI) rounds per minute, giving an average
> spinning time for one round of 6 to 12 ms, and average latency of half
> this, that is 3 to 6 ms. Then you need to add head movement which
> is something like 2 to 20 ms - in total average seek time 5 to 26 ms,
> averaging around 13-17 ms.
>
> in about 15 ms you can read on current SATA-II (300 MB/s) or ATA/133
> something like between 600 to 1200 kB, actual transfer rates of
> 80 MB/s on SATA-II and 40 MB/s on ATA/133. So to get some bang for the bu=
ck,
> and transfer some data you should have something like 256/512 kiB
> chunks. With a transfer rate of 50 MB/s and chunk sizes of 256 kiB
> giving about a time of 20 ms per transaction
> you should be able with random reads to transfer 12 MB/s  - my
> actual figures is about 30 MB/s which is possibly because of the
> elevator effect of the file system driver. With a size of 4 kb per chunk
> you should have a time of 15 ms per transaction, or 66 transactions per
> second, or a transfer rate of 250 kb/s. So 256 kb vs 4 kb speeds up
> the transfer by a factor of 50.
>
> I actually  think the kernel should operate with block sizes
> like this and not wth 4 kiB blocks. It is the readahead and the elevator
> algorithms that save us from randomly reading 4 kb a time.
>
> I also see that there are some memory constrints on this.
> Having maybe 1000 processes reading, as for my mirror service,
> 256 kib buffers would be acceptable, occupying 256 MB RAM.
> That is reasonable, and I could even tolerate 512 MB ram used.
> But going to 1 MiB buffers would be overdoing it for my configuration.
>
> What would be the recommended chunk size for todays equipment?
>
> Best regards
> Keld
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

My benchmarks concluded that 256 KiB to 1024 KiB is optimal, too much=20
below or too much over that range results in degradation.

Justin.
---1463747160-1958478426-1202239144=:9790--
