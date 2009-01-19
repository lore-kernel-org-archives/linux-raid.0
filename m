From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Raid6 write performance
Date: Mon, 19 Jan 2009 13:50:46 +0100
Message-ID: <49747726.1090103@rabbit.us>
References: <49742E74.9090502@rabbit.us> <8CB482475EFC01A-17F0-256E@webmail-dx12.sysops.aol.com> <20090119124837.GC23623@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090119124837.GC23623@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>
Cc: thomas62186218@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen wrote:
> On Mon, Jan 19, 2009 at 03:10:01AM -0500, thomas62186218@aol.com wrot=
e:
>> I tested RAID 5 and RAID 6 with 12 x 15K SAS drives on Ubuntu 8.04=20
>> 64-bit and found their performance to be about the same. I used 256 =
K=20
>> chunk size, v1.0 superblocks, stripecachesize of 16384, and readahea=
d=20
>> of 65536.
>>
>> RAID 5 reads: 774 MB/sec
>> RAID 5 writes: 585 MB/sec
>>
>> RAID 6 reads: 742 MB/sec
>> RAID 6 writes: 559 MB/sec
>>
>> My CPU utilization remains under 10% though during writes, and I'm=20
>> wondering what can be done to get write performance closer to read=20
>> performance. I have dual quad-core CPUs so there's plenty of CPU to =
go=20
>> around. Any ideas on that front?
>=20
> Seems like it is the same equipment that you also did the raid10,f2
> tests for. I think it would be interesting to have a consolidated lis=
t
> of performance comparisons, when you have completed your tweakings.
> Is that part of your plan?
>=20
> best regards
> keld

Not on this machine, but yes, I am planning to do something like this o=
n
my workstation. I need to get my drives/arrays in order first (got
bitten by the 7200.11 fiasco).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
