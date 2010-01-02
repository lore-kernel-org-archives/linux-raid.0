From: fibre raid <fibreraid@gmail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Fri, 1 Jan 2010 22:54:11 -0800
Message-ID: <5817fbed1001012254u7adad025od1973e517ca98530@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
	 <66781b10910141234h5fbf5ac3k4adc347621dbc2a1@mail.gmail.com>
	 <200910270428.00768.tfjellstrom@shaw.ca>
	 <200910270511.45834.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910270511.45834.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca, mark delfman <markdelfman@googlemail.com>, Christoph Hellwig <hch@infradead.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

I'm catching up on my thread-reading and saw your performance report
concerning MD on 2.6.30 (running RAID 0 at 1.7GBps) versus layering
XFS on top, which reduces performance about 50%. Having read (what I
think is) the full thread, it does not seem there was any conclusion
on this. Did you reach a conclusion to determine the cause, etc? I am
curious to see what the issue what be as I'm seeing this issue as well
on my end.

Best regards,
-T

On Tue, Oct 27, 2009 at 3:11 AM, Thomas Fjellstrom <tfjellstrom@shaw.ca=
> wrote:
> On Tue October 27 2009, Thomas Fjellstrom wrote:
>> On Wed October 14 2009, mark delfman wrote:
>> > Hi Chris... we tried the direct DD as requested and the problem is
>> > still there...
>> > 1.3GBsec > 325MBsec =A0(even more dromatic)... hopefully this help=
s
>> > narrow it down?
>> >
>> >
>> > Write > MD
>> > linux-poly:~ # dd if=3D/dev/zero of=3D/dev/md0 oflag=3Ddirect bs=3D=
1M
>> > count=3D20000 20000+0 records in
>> > 20000+0 records out
>> > 20971520000 bytes (21 GB) copied, 15.7671 s, 1.3 GB/s
>> >
>> >
>> > Write > XFS > MD
>> > linux-poly:~ # dd if=3D/dev/zero of=3D/mnt/md0/test oflag=3Ddirect=
 bs=3D1M
>> > =A0count=3D20000 20000+0 records in
>> > 20000+0 records out
>> > 20971520000 bytes (21 GB) copied, 64.616 s, 325 MB/s
>>
>> If it helps, I'm seeing the same sort of thing.
>> The most I can seemingly tweak out of my new 5x1TB array is 170MB/s
>> =A0write. Using dd with oflags=3Ddirect drops it down to 31MB/s.
>>
>> Oddly, I see spikes of over 200MB/s write when not using oflags=3Ddi=
rect,
>> but it slows down in between to 11MB/s so over all,
>> it averages a max of 170MB/s. the device itself is capable of over
>> =A0500MB/s. (66% drop?)
>>
>> small test:
>>
>> $ dd if=3D/dev/zero of=3D/mnt/test-data/test.file bs=3D512KiB count=3D=
4096
>> =A0oflag=3Ddirect 4096+0 records in
>> 4096+0 records out
>> 2147483648 bytes (2.1 GB) copied, 71.8088 s, 29.9 MB/s
>>
>> $ dd if=3D/dev/zero of=3D/mnt/test-data/test.file bs=3D512KiB count=3D=
4096
>> 4096+0 records in
>> 4096+0 records out
>> 2147483648 bytes (2.1 GB) copied, 19.7101 s, 109 MB/s
>>
>> $ sudo dd if=3D/dev/md0 of=3D/tmp/test-data.img bs=3D1M count=3D1024
>> 1024+0 records in
>> 1024+0 records out
>> 1073741824 bytes (1.1 GB) copied, 2.39796 s, 448 MB/s
>>
>> $ sudo dd if=3D/tmp/test-data.img of=3D/dev/md0 bs=3D1M count=3D1024
>> 1024+0 records in
>> 1024+0 records out
>> 1073741824 bytes (1.1 GB) copied, 2.05666 s, 522 MB/s
>>
>> $ cd /mnt/test-data/test
>> $ iozone -A -s4G -y512k -q512k
>> =A0 =A0 =A0 =A0...
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 KB =A0reclen =A0 write rewrite =A0 =A0re=
ad =A0 =A0reread
>> =A0 =A0 =A0 =A0 =A04194304 =A0 =A0 512 =A0161732 =A0333316 =A0 38236=
1 =A0 388726
>>
>>
>> [snip]
>>
>>
>>
>> info, if it helps:
>>
>> # mdadm -D /dev/md0
>> /dev/md0:
>> =A0 =A0 =A0 =A0 Version : 1.01
>> =A0 Creation Time : Wed Oct 14 08:55:25 2009
>> =A0 =A0 =A0Raid Level : raid5
>> =A0 =A0 =A0Array Size : 3907049472 (3726.05 GiB 4000.82 GB)
>> =A0 Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
>> =A0 =A0Raid Devices : 5
>> =A0 Total Devices : 5
>> =A0 =A0 Persistence : Superblock is persistent
>>
>> =A0 =A0 Update Time : Tue Oct 27 04:18:50 2009
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0Active Devices : 5
>> Working Devices : 5
>> =A0Failed Devices : 0
>> =A0 Spare Devices : 0
>>
>> =A0 =A0 =A0 =A0 =A0Layout : left-symmetric
>> =A0 =A0 =A0Chunk Size : 512K
>>
>> =A0 =A0 =A0 =A0 =A0 =A0Name : natasha:0 =A0(local to host natasha)
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
>> =A0 =A0 =A0 =A0 =A0Events : 4952
>>
>> =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sde
>> =A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdf
>> =A0 =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>> =A0 =A0 =A0 =A03 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
>> =A0 =A0 =A0 =A05 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdg
>>
>> # xfs_info /dev/md0
>> meta-data=3D/dev/md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isize=3D256 =A0 =A0=
agcount=3D32, agsize=3D30523776
>> =A0blks =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D409=
6 =A0attr=3D2
>> data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D=
4096 =A0 blocks=3D976760832, imaxpct=3D5
>> =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
unit=3D128 =A0 =A0swidth=3D512 blks
>> naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 =
ascii-ci=3D0
>> log =A0 =A0 =A0=3Dinternal =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =
=A0 blocks=3D476934, version=3D2
>> =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
ectsz=3D4096 =A0sunit=3D1 blks, lazy-count=3D0
>> realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D2097152=
 blocks=3D0, rtextents=3D0
>>
>
> ran 4 dd's in parallel all writing to a different file on the array:
>
> 4096+0 records in
> 4096+0 records out
> 2147483648 bytes (2.1 GB) copied, 33.4193 s, 64.3 MB/s
> 4096+0 records in
> 4096+0 records out
> 2147483648 bytes (2.1 GB) copied, 35.5599 s, 60.4 MB/s
> 4096+0 records in
> 4096+0 records out
> 2147483648 bytes (2.1 GB) copied, 36.4677 s, 58.9 MB/s
> 4096+0 records in
> 4096+0 records out
> 2147483648 bytes (2.1 GB) copied, 37.912 s, 56.6 MB/s
>
> iostat showed spikes of up to 300MB/s and it usually hovered over 200=
MB/s.
> I tried bumping it to 8 at a time, but it seems to max out at just ov=
er
> 200MB/s. =A0was hoping that with enough jobs, it might scale up to th=
e devices
> actual max throughput.
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
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
