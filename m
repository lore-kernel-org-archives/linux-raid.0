From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What layout with 6x2TB, Intel Atom?
Date: Mon, 04 Feb 2013 17:15:01 -0600
Message-ID: <511040F5.1020407@hardwarefreak.com>
References: <CADNH=7EUc7z-E=uo74-QqaKEUcrZiAYKaZqtSfFVbLKpfvt7og@mail.gmail.com> <CADNH=7FxeF1qjYVpGcU1rW6LYDx=6e_LRa5+AUJqyV-hZ2K=XQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FxeF1qjYVpGcU1rW6LYDx=6e_LRa5+AUJqyV-hZ2K=XQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46orgot to reply-all.

On 2/4/2013 2:29 PM, Mathias Bur=E9n wrote:
> On 4 February 2013 20:27, Mathias Bur=E9n <mathias.buren@gmail.com> w=
rote:
>> Hi list,
>>
>> I've an Intel Atom 330 running 32-bit Ubuntu, ~3.5GB RAM. The intent
>> is to store large media files (>4GB) for streaming by maximum 3
>> clients at any time. Very read heavy.
>> 6x 2TB HDDs are available, the crux is that 3 HDDs are on the on-boa=
rd
>> SATA controller, the other 3 are on a Marvel PCI-E adapter
>>
>> cat /proc/mdstat
>>
>> Personalities : [raid10]
>> md125 : active raid10 sdg[1] sdf[0]
>>       1953382400 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU=
]
>>       [>....................]  resync =3D  1.1% (22074880/1953382400=
)
>> finish=3D642.2min speed=3D50114K/sec
>>
>> md126 : active raid10 sde[1] sdd[0]
>>       1953382400 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU=
]
>>       [>....................]  resync =3D  1.6% (31473408/1953382400=
)
>> finish=3D398.6min speed=3D80354K/sec
>>
>> md127 : active raid10 sdc[1] sdb[0]
>>       1953382400 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU=
]
>>       [>....................]  resync =3D  1.1% (22630912/1953382400=
)
>> finish=3D617.9min speed=3D52073K/sec
>>
>> unused devices: <none>
>>
>> create commands:
>>   105  sudo mdadm --verbose --create md0 --level=3D10 --layout=3Df2
>> --raid-devices=3D2 /dev/sdb /dev/sdc
>>   106  sudo mdadm --verbose --create md1 --level=3D10 --layout=3Df2
>> --raid-devices=3D2 /dev/sdd /dev/sde
>>   107  sudo mdadm --verbose --create md2 --level=3D10 --layout=3Df2
>> --raid-devices=3D2 /dev/sdf /dev/sdg
>>   111  sudo mdadm --verbose --create md3 --level=3D10 --layout=3Df2
>> --raid-devices=3D3 /dev/md/md0 /dev/md/md1 /dev/md/md2
>>   118  sudo mdadm --stop /dev/md124 # to stop seek of death until th=
e
>> above finishes resyncing
>>
>> I read that the far layout gives faster read performance compared to
>> standard RAID1 in a 2 HDD array, so that's why I used it. I then
>> created yet another RAID10 f2 layout of the 3x 2 disk RAID10 volumes=
,
>> giving me /dev/md124. Filesystem doesn't matter, I need something
>> that's stable with good performance over the RAID set.
>> I just realized that out of 12 TB raw space I now only have 3TB
>> available, heh. So I suppose I'm going for a different layout.
>>
>> Any opinions?

=46irst, the Atom 330 is a 64 bit dual core chip.  Use a 64 bit kernel
(preferably 3.0 or later, 2.6.39 minimum) and user space, unless you
have an old 32 bit app that won't run.  The 64 bit kernel will give
better performance for an IO server, yes, even if you have less than 4G=
B
of RAM.

Second, given your workload description, it is a good match for RAID6,
which will give you 8TB capacity.  Given the slow rotational speed of
those disks the default 512KB chunk should be fine as it will tend to
minimize seeks.  With those drives head movement is far more expensive
that rotation.

Third, use XFS, and format with alignment to the md device:
~$ mkfs.xfs -d su=3D512k,sw=3D4

=46ourth, even if your Marvell SATA card is PCIe x1 1.0 and limited to
250MB/s, 500MB/s duplex, that shouldn't cause problems in daily use,
though it may very well slow down RAID operations such as rebuilds and
reshapes.  If it's a 2.0 card operating in 2.0 mode, it's 500/1000 MB/s=
,
exceeding the bandwidth of the 3 drives, and is ample.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
