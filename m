From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 22:57:11 +0200
Message-ID: <CA+4vN7xoNyvK5VnVX0DsP9T-g1_mYoN49gKOTR+Ff8=5nCCBOA@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
 <CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com> <20429.60634.655908.243729@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20429.60634.655908.243729@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 5, 2012 at 1:25 PM, Peter Grandi <pg@lxra2.for.sabi.co.uk> =
wrote:
:
> It does not change much of the conclusions as to the (euphemism)
> audacity of your conclusions), but you have created a 21+2 RAID6
> set, as the 24th block device is a spare:
>
> =A0seq 24 | parallel -X --tty mdadm --create --force /dev/md0 -c $CHU=
NK --level=3D6 --raid-devices=3D23 -x 1 /dev/loop{}

That is correct. It reflects the physical setup of the 24 physical driv=
es.

>>>> I get 400 MB/s write and 600 MB/s read. It seems to be due
>>>> to checksuming, as I have a single process (md0_raid6)
>>>> taking up 100% of one CPU.
>
> [ ... ]
>
>> The 900 MB/s was based on my old controller. I re-measured
>> using my new controller and get closer to 2000 MB/s in raw
>> (non-RAID) performance, which is close to the theoretical
>> maximum for that controller (2400 MB/s). This indicated that
>> hardware is not a bottleneck.
>
> A 21+2 drive RAID6 set is (euphemism) brave, and perhaps it
> matches the (euphemism) strategic insight that only checksumming
> withing MD could account for 100% CPU time in a single threaded
> way.

It is not a guess that md0_raid6 takes up 100% of 1 core. It is
reported by 'top'.

But maybe you are right: The 100% that md0_raid6 uses could be due to
something other than checksumming. But the test clearly show that
chunk size has a huge impact on the amount of CPU time md0_raid6 has
to use.

> But as a start you could try running your (euphemism) "test"
> with O_DIRECT:
>
> =A0http://www.sabi.co.uk/blog/0709sep.html#070919
>
> While making sure that the IO is stripe aligned (21 times the
> chunk size).

It is unclear to me how to change the timed part of the test script to
use O_DIRECT and make it stripe aligned:

seq 10 | time parallel mkdir -p /mnt/md0/{}\;tar -x -C /mnt/md0/{} -f
linux.tar\; sync
seq 10 | time parallel mkdir -p /mnt/md0/{}\;cp linux.tar /mnt/md0/{} \=
; sync

Please advice.

> Your (euphemism) tests could also probably benefit from more
> care about (euphemism) details like commit semantics, as the use
> of 'sync' in your scripts seems to me based on (euphemism)
> unconventional insight, for example this:
>
> =A0=ABseq 10 | time parallel mkdir -p /mnt/md0/{}\;tar -x -C /mnt/md0=
/{} -f linux.tar\; sync=BB

=46eel free to substitute with:

seq 10 | time parallel mkdir -p /mnt/md0/{}\;tar -x -C /mnt/md0/{} -f l=
inux.tar
time sync

Here you will have to add the two durations.

With that modification I get:

Chunk size	Time to copy 10 linux kernel sources as files	Time to copy
10 linux kernel sources as a single tar file
16        29s        13s
32        28s        11s
64        29s        13s
128        34s        10s
256        41s        11s
4096        1m35s        2m15s (!)

Most numbers are comparable to the original results
http://oletange.blogspot.dk/2012/05/software-raid-performance-on-24-dis=
ks.html

The 2m15s result for the 4096 big-file test was a bit surprising, so
I re-ran that test and got 2m36s.

> But also more divertingly:
>
> =A0=ABseq 24 | parallel dd if=3D/dev/zero of=3Dtmpfs/disk{} bs=3D500k=
 count=3D1k
> =A0seq 24 | parallel losetup /dev/loop{} tmpfs/disk{}
> =A0sync
> =A0sleep 1;
> =A0sync=BB

Are you aware that this part is for the setup of the test? It is not
the timed section and thus it does not affect the validity of the
test.

> and even:
>
> =A0=ABmount /dev/md0 /mnt/md0
> =A0sync=BB

Yeah that part was a bit weird, but I had 1 run where the script
failed without the 'sync'. And again: Are you aware that this part is
for the setup of the test? It is not the timed section and thus does
not change the validity of the test.

> Perhaps you might also want to investigate the behaviour of
> 'tmpfs' and 'loop' devices, as it seems quite (euphemism)
> creative to me to have RAID set member block devices as 'loop's
> over 'tmpfs' files:
>
> =A0=ABmount -t tmpfs tmpfs tmpfs
> =A0seq 24 | parallel dd if=3D/dev/zero of=3Dtmpfs/disk{} bs=3D500k co=
unt=3D1k
> =A0seq 24 | parallel losetup /dev/loop{} tmpfs/disk{}=BB

How would YOU design the test so that:

* it is reproducible for others?
* it does not depend on controllers and disks?
* it uses 24 devices?
* it uses different chunk sizes?
* it tests both big and small file performance?

> Put another way, most aspects of your (euphemism) tests seem to
> me rather (euphemism) imaginative.

Did you run the test script? What were your numbers? Did md0_raid6
take up 100% CPU of 1 core during the copy? And if so: Can you explain
why md0_raid6 would take up 100% CPU of 1 core?


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
