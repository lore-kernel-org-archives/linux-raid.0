From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 12:25:54 +0100
Message-ID: <20429.60634.655908.243729@tree.ty.sabi.co.UK>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
	<CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
	<CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>>>> I tested this by creating 24 devices in RAM, used different
>>>> chunk sizes, and then copied the linux kernel source. Test
>>>> script can be found on [ ... ] By doing it in RAM the
>>>> results are not affected by physical disks or disk
>>>> controller. So the only change is the speed of computing
>>>> checksums. This can also be seen as the time the process
>>>> md0_raid0 is running.

>>> When I set the disks up as a 24 disk software RAID6

It does not change much of the conclusions as to the (euphemism)
audacity of your conclusions), but you have created a 21+2 RAID6
set, as the 24th block device is a spare:

  seq 24 | parallel -X --tty mdadm --create --force /dev/md0 -c $CHUNK =
--level=3D6 --raid-devices=3D23 -x 1 /dev/loop{}

>>> I get 400 MB/s write and 600 MB/s read. It seems to be due
>>> to checksuming, as I have a single process (md0_raid6)
>>> taking up 100% of one CPU.

[ ... ]

> The 900 MB/s was based on my old controller. I re-measured
> using my new controller and get closer to 2000 MB/s in raw
> (non-RAID) performance, which is close to the theoretical
> maximum for that controller (2400 MB/s). This indicated that
> hardware is not a bottleneck.

A 21+2 drive RAID6 set is (euphemism) brave, and perhaps it
matches the (euphemism) strategic insight that only checksumming
withing MD could account for 100% CPU time in a single threaded
way.

But as a start you could try running your (euphemism) "test"
with O_DIRECT:

  http://www.sabi.co.uk/blog/0709sep.html#070919

While making sure that the IO is stripe aligned (21 times the
chunk size).

Your (euphemism) tests could also probably benefit from more
care about (euphemism) details like commit semantics, as the use
of 'sync' in your scripts seems to me based on (euphemism)
unconventional insight, for example this:

 =ABseq 10 | time parallel mkdir -p /mnt/md0/{}\;tar -x -C /mnt/md0/{} =
-f linux.tar\; sync=BB

But also more divertingly:

 =ABseq 24 | parallel dd if=3D/dev/zero of=3Dtmpfs/disk{} bs=3D500k cou=
nt=3D1k
  seq 24 | parallel losetup /dev/loop{} tmpfs/disk{}
  sync
  sleep 1;
  sync=BB

and even:

 =ABmount /dev/md0 /mnt/md0
  sync=BB

Perhaps you might also want to investigate the behaviour of
'tmpfs' and 'loop' devices, as it seems quite (euphemism)
creative to me to have RAID set member block devices as 'loop's
over 'tmpfs' files:

 =ABmount -t tmpfs tmpfs tmpfs
  seq 24 | parallel dd if=3D/dev/zero of=3Dtmpfs/disk{} bs=3D500k count=
=3D1k
  seq 24 | parallel losetup /dev/loop{} tmpfs/disk{}=BB

Put another way, most aspects of your (euphemism) tests seem to
me rather (euphemism) imaginative.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
