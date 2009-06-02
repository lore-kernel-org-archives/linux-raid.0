From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Awful RAID5 random read performance
Date: Wed, 03 Jun 2009 00:13:05 +0100
Message-ID: <4A25B201.2000705@anonymous.org.uk>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com> <20090602194704.GA30639@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090602194704.GA30639@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/06/2009 20:47, Keld J=F8rn Simonsen wrote:
[...]
> My perception is that raid10,f2 is probably the fastest also for smal=
l random
> reads because of the lower latency, and faster transfer times due to =
only
> using the outer disk sectors. For writes the elevator evens out the
> ramdom access. Benchmarks may not show this effect as they are often
> done on clean file systems, where the files are allocated in the
> beginning of the fs.
>=20
> For cases where you need cheap disk space, and have big files like
> .iso's then raid5 could be a good choice because it has the most spac=
e
> while maintaining fair to good performance for big files.=20
>=20
> In your case, using 3 disks, raid5 should give about 210 % of the nom=
inal
> single disk speed for big file reads, and maybe 180 % for big file
> writes. raid10,f2 should give about 290 % for big file reads and 140%
> for big file writes. Random reads should be about the same for raid5 =
and
> raid10,f2 - raid10,f2 maybe 15 % faster, while random writes should b=
e
> mediocre for raid5, and good for raid10,f2.

I'd be interested in reading about where you got these figures from=20
and/or the rationale behind them; I'd have guessed differently...

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
