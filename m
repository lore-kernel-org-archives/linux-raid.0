From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: recommendations for stripe/chunk size
Date: Wed, 06 Feb 2008 14:22:15 -0500
Message-ID: <47AA08E7.5000801@tmr.com>
References: <20080205182421.GA32250@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205182421.GA32250@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> Hi
>
> I am looking at revising our howto. I see a number of places where a
> chunk size of 32 kiB is recommended, and even recommendations on
> maybe using sizes of 4 kiB.=20
>
>  =20
Depending on the raid level, a write smaller than the chunk size causes=
=20
the chunk to be read, altered, and rewritten, vs. just written if the=20
write is a multiple of chunk size. Many filesystems by default use a 4k=
=20
page size and writes. I believe this is the reasoning behind the=20
suggestion of small chunk sizes. Sequential vs. random and raid level=20
are important here, there's no one size to work best in all cases.
> My own take on that is that this really hurts performance.=20
> Normal disks have a rotation speed of between 5400 (laptop)
> 7200 (ide/sata) and 10000 (SCSI) rounds per minute, giving an average
> spinning time for one round of 6 to 12 ms, and average latency of hal=
f
> this, that is 3 to 6 ms. Then you need to add head movement which
> is something like 2 to 20 ms - in total average seek time 5 to 26 ms,
> averaging around 13-17 ms.=20
>
>  =20
Having a write not some multiple of chunk size would seem to require a=20
read-alter- wait_for_disk_rotation-write, and for large sustained=20
sequential i/o using multiple drives helps transfer. for small random=20
i/o small chunks are good, I find little benefit to chunks over 256 or=20
maybe 1024k.
> in about 15 ms you can read on current SATA-II (300 MB/s) or ATA/133=20
> something like between 600 to 1200 kB, actual transfer rates of
> 80 MB/s on SATA-II and 40 MB/s on ATA/133. So to get some bang for th=
e buck,
> and transfer some data you should have something like 256/512 kiB
> chunks. With a transfer rate of 50 MB/s and chunk sizes of 256 kiB
> giving about a time of 20 ms per transaction
> you should be able with random reads to transfer 12 MB/s  - my
> actual figures is about 30 MB/s which is possibly because of the
> elevator effect of the file system driver. With a size of 4 kb per ch=
unk=20
> you should have a time of 15 ms per transaction, or 66 transactions p=
er=20
> second, or a transfer rate of 250 kb/s. So 256 kb vs 4 kb speeds up
> the transfer by a factor of 50.=20
>
>  =20
If you actually see anything like this your write caching and readahead=
=20
aren't doing what they should!

> I actually  think the kernel should operate with block sizes
> like this and not wth 4 kiB blocks. It is the readahead and the eleva=
tor
> algorithms that save us from randomly reading 4 kb a time.
>
>  =20
Exactly, and nothing save a R-A-RW cycle if the write is a partial chun=
k.
> I also see that there are some memory constrints on this.
> Having maybe 1000 processes reading, as for my mirror service,
> 256 kib buffers would be acceptable, occupying 256 MB RAM.
> That is reasonable, and I could even tolerate 512 MB ram used.
> But going to 1 MiB buffers would be overdoing it for my configuration=
=2E
>
> What would be the recommended chunk size for todays equipment?
>
>  =20
I think usage is more important than hardware. My opinion only.

> Best regards
> Keld


--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
