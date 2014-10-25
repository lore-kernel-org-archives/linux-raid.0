From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: storage with "very high Average Read/Write Request Time"
Date: Sat, 25 Oct 2014 23:07:22 +0100
Message-ID: <21580.7962.263904.580366@tree.ty.sabi.co.uk>
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
	<54442A48.6050503@hardwarefreak.com>
	<21579.47082.770855.521224@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21579.47082.770855.521224@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> Hi, I am using xfs on a raid 5 (~100TB) and put log on external ssd
>>> device, the mount information is: /dev/sdc [ ... ] when doing only
>>> reading / only writing , the speed is very fast(~1.5G), but when do
>>> both the speed is very slow (100M), and high r_await(160) and
>>> w_await(200000).

>> There is a ratio of 31 (thirty one) between 'swidth' and 'sunit' and
>> assuming that this reflects the geometry of the RAID5 set and given
>> commonly available disk sizes it can be guessed that with amazing
>> "bravery" someone has configured a RAID5 out of 32 (thirty two) high
>> capacity/low IOPS 3TB drives, or something similar. [ ... ]

>> You apparently have 31 effective SATA 7.2k RPM spindles with 256 KiB
>> chunk, 7.75 MiB stripe width, in RAID5.

That's highly likely, could be nearline SAS drives, but not a big
difference. But given the context SATA is likely as it is cheaper.
Conceivably the storage could also be a chunk of a RAID SAN over a
single FC 16Gb/s link or FCoE over dual bonded roundrobin 10Gb/s links,
but this seems to me to fit less well with the other scant clues
available (e.g. "on a raid 5 (~100TB)" and "log on external ssd
device").

>> That should yield 3-4.6 GiB/s of streaming throughput assuming no
>> cable, expander, nor HBA limitations. You're achieving only 1/3rd to
>> 1/2 of this.

That 1/3 to 1/2 may be not too bad, also considering that the RAID set
is so wide and there will be quite a bit of variance of rotational
positions across it, and that perhaps the hw has channels with a 2GB/s
max chokepoint.

Anyhow these are are some mostly reasonable questions on the details:

>> Which hardware RAID controller is this? What are the specs? Cache
>> RAM, host and back end cable count and type?

I'll do some plausible (hopefully) additional speculation...

The mention of '/dev/sdc' suggests that this is a hw RAID HA (aka HBA),
and the context gives me vibes that:

* The 3TB disks are likely 3.5in, so given typical enclosure geometries
  the likely count of 32 suggests that the disks are in two classic
  16-slot enclosures.

* That the RAID set seems to have 32 drives and there is the ceiling of
  1.5GB/s suggests that there is a single not very recent hw RAID HA an=
d
  the two enclosures are daisy-chained.

* Because oldish RAID HAs typically max at 2GiB/s overall as they have
  8x lane PCIe 1.x host bus connectors; or they are recent PCIe 2.0 one=
s
  but plugged into oldish PCIe 1.x host bus slots (or perhaps even
  plugged into slots with less than 8x lanes).

There is an enormous difference in read vs. write in =ABr_await(160) an=
d
w_await(200000)=BB and the latter is apocalyptic at 200 seconds ('man
iostat' confirms that 'r_await' and 'w_await' are in ms). I have seen
that kind of horror before and it suggests that this is one of several
common types of hw RAID HA which a massively misdesigned buggy IO
scheduler and cache manager in the firmware.

>>> 1. how can I reduce average request time?

Some better alternative geometries have been already suggested, some of
which I don't like...

But overall if the speculation above applies, the current setup seems t=
o
be "audaciously" aimed at the lowest possible upfront price, "targeting=
"
a workload made almost entirely of reads of data archived elsewhere, or
single-stream writes or reads, and that needs changing.

To change that I think that the two main suggestions are:

1. Stop using the hw RAID mode and use instead Linux MD raid.
3. Significantly boost IOPS when doing concurrent read-writes as per
   typical HPC distributed filesystem object stores. If the aim was
   indeed "lowest possible upfront price" that's not to easy.

As to the latter point it depends a bit whether the object store is
meant to hold transient or permanent data, and the nature of cluster
jobs expected, but here are some general thoughts:

*  Ideally reach the same capacity with 1TB drives, as they have a much
   better IOPS-per-GB ratio than 3TB drives. I consider for various
   reasons current 2TB drives as already having a too low IOPS-per-GB
   ratio for most cases of "live" data, for example.

*  Change the geometry of the RAID sets, for example multiple sets with
   each set being:
   - RAID10 with 16 members, or RAID10 with 8 members.
   - RAID5 with 3 members, with hot spares.
   - RAID5 with 5 members, with hot spares.
   - With some reluctance, RAID6 with 6-8-10 members.

*  Some apposite tuning of the MD RAID parameters depending on the RAID
   set geometry and expected workload, the usual on stripe cache sizes,
   elevators, read-ahead, dirty page lifetime and ERC/TLER timeouts.

The reason behind the multiple sets is to reduce correlation, by
reducing RMW, and for example also permitting parallel 'fsck' and
probably also better backups impact.

Having a single very large storage pool per server is particularly
"insipid" if this is meant to be an object store for HPC parallel
filesystems like BeeGFS, because usually they are configured to slice
each files into 1MB segments and distributed these segments across many
available object stores.

>>> 2. can I use ssd as write/read cache for xfs?

I think that if the workload is that of a typical HPC distributed
filesystem object store that's not going to help much as object stores
cannot cache that much because of overall randomish access patterns.
Caches don't "always" increase IOPS across the board. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
