From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Typical RAID5 transfer speeds
Date: Sat, 19 Dec 2009 01:38:03 -0800
Message-ID: <4877c76c0912190138o7c9c515cn53f5bd0b6151a5e8@mail.gmail.com>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
	 <200912190205.04407.bs_lists@aakef.fastmail.fm>
	 <200912190130.42585.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912190130.42585.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 19, 2009 at 12:30 AM, Thomas Fjellstrom <tfjellstrom@shaw.c=
a> wrote:
> On Fri December 18 2009, Bernd Schubert wrote:
>> On Saturday 19 December 2009, Matt Tehonica wrote:
>> > I have a 4 disk RAID5 using a 2048K chunk size and using XFS
>>
>> 4 disks is a bad idea. You should have 2^n data disks, but you have =
2^1 +
>> =A01 =3D 3 data disks. As parity information are calculated in the p=
ower of
>> =A0two and blocks are written in the power of two, you probably have=
 read
>> =A0operations, when you only want to write.
>>
>> > filesystem. =A0Typical file size is about 2GB-5GB. I usually get a=
round
>> > 50MB/sec transfer speed when writting files to the array. Is this
>> > typcial or is it below normal? =A0A friend has a 20 disk RAID6 usi=
ng the
>> > same filesystem and chunk size and gets around 150MB/sec. Any inpu=
t on
>> > this??
>>
>> I would remove two disks, to get 16 + 2 drives (2^4). Performance
>> =A0probably would be limited by CPU speed then. 150MB/s for 18 drive=
s is
>> =A0also bad, this is only the performance of two single raid0 drives=
=2E
>
> I'd have to agree. My 5 disk raid5 array gets me 200-400MB/s, dependi=
ng on
> the kernel. I'm using a 512K chunk size, formatted with XFS, with 32 =
AGs,
> and xfs_info reporting: sunit=3D128 swidth=3D512 blks (which should b=
e
> right...), and mounted with:
> noatime,nodiratime,logbufs=3D8,allocsize=3D512m,largeio,swalloc
>
> oh, not quite 200MB/s, iozone is showing 112MB/s write, and 300MB/s r=
ead.
> I'm pretty sure that has something to do with the writeback stuff tho=
ugh,
> and aught to be improved in 2.6.32+ (I have yet to find a good time t=
o
> upgrade my server). I know I have seen the SAS card, and an initial a=
rray
> handle more throughput than that when I was first testing stuff month=
s and
> months ago. It was more like 200-350 write, and 400-550 read.
>
> But yeah, 50MB/s is pretty bad for a raid array. The individual disks=
 in my
> array are all capable of more than that each. =A0(Yes, I know raid5 w=
ill not
> give a linear improvement when adding more drives, but it aught to be=
 a heck
> of a lot better than a decrease in performance)
>
>>
>> Cheers,
>> Bernd
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Thomas Fjellstrom
> tfjellstrom@shaw.ca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

It is possible that in your setup memory speed could be the
bottleneck; have you considered that maybe the issue is the size of
your processor's cache compared to the size of the stripe?  I know
server chips from Intel and AMD typically have larger caches, and that
in the consumer end the Intel chips typically also have more cache.
It could be that your selection of stripe size is simply larger than
the cache size and thus you actually notice the cost of dipping down
to memory speeds when you're processor is starved for new data (or if
it's really thrashed with other tasks).  I'm not sure how much of an
issue this is for me, since the idea size of my cache is only a little
larger than it actually is, and DDR-2 might still be fast enough in a
burst mode to read ahead of the end of the request.  I do know that in
my case performance is more than sufficent and the main concern as
simply not loosing all of that data.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
