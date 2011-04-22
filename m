From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID6
Date: Fri, 22 Apr 2011 11:05:44 +0100
Message-ID: <BANLkTi=1niLpTqtGRK-GUW5QhQ1U=nuUuA@mail.gmail.com>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
	<4DA58CB0.3020109@anonymous.org.uk>
	<BANLkTinAUbMdh=FE8s9Qp6QJyfgp_pvCpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinAUbMdh=FE8s9Qp6QJyfgp_pvCpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22 April 2011 10:39, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wr=
ote:
> On 13 April 2011 12:44, John Robinson <john.robinson@anonymous.org.uk=
> wrote:
>> (Subject line amended by me :-)
>>
>> On 12/04/2011 17:56, Mathias Bur=C3=A9n wrote:
>> [...]
>>>
>>> I'm approaching over 6.5TB of data, and with an array this large I'=
d
>>> like to migrate to RAID6 for a bit more safety. I'm just checking i=
f I
>>> understand this correctly, this is how to do it:
>>>
>>> * Add a HDD to the array as a hot spare:
>>> mdadm --manage /dev/md0 --add /dev/sdh1
>>>
>>> * Migrate the array to RAID6:
>>> mdadm --grow /dev/md0 --raid-devices 7 --level 6
>>
>> You will need a --backup-file to do this, on another device. Since y=
ou are
>> keeping the same number of data discs before and after the reshape, =
the
>> backup file will be needed throughout the reshape, so the reshape wi=
ll take
>> perhaps twice as long as a grow or shrink. If your backup-file is on=
 the
>> same disc(s) as md0 is (e.g. on another partition or array made up o=
f other
>> partitions on the same disc(s)), it will take way longer (gazillions=
 of
>> seeks), so I'd recommend a separate drive or if you have one a small=
 SSD for
>> the backup file.
>>
>> Doing the above with --layout=3Dpreserve will save you doing the res=
hape so
>> you won't need the backup file, but there will still be an initial s=
ync of
>> the Q parity, and the layout will be RAID4-alike with all the Q pari=
ty on
>> one drive so it's possible its performance will be RAID4-alike too i=
=2Ee.
>> small writes never faster than the parity drive. Having said that, s=
treamed
>> writes can still potentially go as fast as your 5 data discs, as per=
 your
>> RAID5. In practice, I'd be surprised if it was faster than about twi=
ce the
>> speed of a single drive (the same as your current RAID5), and as Nei=
l Brown
>> notes in his reply, RAID6 doesn't currently have the read-modify-wri=
te
>> optimisation for small writes so small write performance is liable t=
o be
>> even poorer than your RAID5 in either layout.
>>
>> You will never lose any redundancy in either of the above, but you w=
on't
>> gain RAID6 double redundancy until the reshape (or Q-drive sync with
>> --layout=3Dpreserve) has completed - just the same as if you were re=
placing a
>> dead drive in an existing RAID6.
>>
>> Hope the above helps!
>>
>> Cheers,
>>
>> John.
>>
>>
>
> Hi,
>
> Thanks for the replies. Allright, here we go;
>
> =C2=A0$ mdadm --grow /dev/md0 --bitmap=3Dnone
> =C2=A0$ mdadm --manage /dev/md0 --add /dev/sde1
> =C2=A0$ mdadm --grow /dev/md0 --verbose --layout=3Dpreserve =C2=A0--r=
aid-devices 7
> --level 6 --backup-file=3D/root/md-raid5-to-raid6-backupfile.bin
> mdadm: level of /dev/md0 changed to raid6
>
> $ cat /proc/mdstat
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 F=
ri Apr
> 22 10:37:44 2011
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sde1[7] sdg1[0] sdh1[6] sdf1[5] sdc1[3] sdd1[4] sd=
b1[1]
> =C2=A0 =C2=A0 =C2=A09751756800 blocks super 1.2 level 6, 64k chunk, a=
lgorithm 18
> [7/6] [UUUUUU_]
> =C2=A0 =C2=A0 =C2=A0[>....................] =C2=A0reshape =3D =C2=A00=
=2E0% (224768/1950351360)
> finish=3D8358.5min speed=3D3888K/sec
>
> unused devices: <none>
>
> And in dmesg:
>
>
> =C2=A0--- level:6 rd:7 wd:6
> =C2=A0disk 0, o:1, dev:sdg1
> =C2=A0disk 1, o:1, dev:sdb1
> =C2=A0disk 2, o:1, dev:sdd1
> =C2=A0disk 3, o:1, dev:sdc1
> =C2=A0disk 4, o:1, dev:sdf1
> =C2=A0disk 5, o:1, dev:sdh1
> RAID conf printout:
> =C2=A0--- level:6 rd:7 wd:6
> =C2=A0disk 0, o:1, dev:sdg1
> =C2=A0disk 1, o:1, dev:sdb1
> =C2=A0disk 2, o:1, dev:sdd1
> =C2=A0disk 3, o:1, dev:sdc1
> =C2=A0disk 4, o:1, dev:sdf1
> =C2=A0disk 5, o:1, dev:sdh1
> =C2=A0disk 6, o:1, dev:sde1
> md: reshape of RAID array md0
> md: minimum _guaranteed_ =C2=A0speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than
> 200000 KB/sec) for reshape.
> md: using 128k window, over a total of 1950351360 blocks.
>
> IIRC there's a way to speed up the migration, by using a larger cache
> value somewhere, no?
>
> Thanks,
> Mathias
>

Increasing stripe cache on the md device from 1027 to 32k or 16k
didn't make a difference, still around 3800KB/s reshape. Oh well,
we'll see if it's still alive in 5.5 days!

Cheers,
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
