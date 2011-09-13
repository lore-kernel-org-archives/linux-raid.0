From: Andriano <chief000@gmail.com>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 16:33:36 +1000
Message-ID: <CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110913082511.3c34dec9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>> Hello Linux-RAID mailing list,
>>
>> I have an issue with my RAID6 array.
>> Here goes a short description of the system:
>>
>> opensuse 11.4
>> Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2011
>> (a432f18) x86_64 x86_64 x86_64 GNU/Linux
>> Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
>> AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.21
>> running mdadm 3.2.2, single array consists of 10 2T disks, 8 of them
>> connected to the HBA, 2 - motherboard ports
>>
>> I had some issues with one of the onboard connected disks, so tried =
to
>> plug it to different ports, just to eliminate possibly faulty port.
>> After reboot, suddenly other drives got kicked out from the array.
>> Re-assembling them gives weird errors.
>>
>> --- some output ---
>> [3:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32 =A0=
/dev/sdb
>> [5:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32 =A0=
/dev/sdc
>> [8:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 CC3=
4 =A0/dev/sdd
>> [8:0:1:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 CC3=
4 =A0/dev/sde
>> [8:0:2:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 CC3=
4 =A0/dev/sdf
>> [8:0:3:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 CC3=
4 =A0/dev/sdg
>> [8:0:4:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 CC3=
4 =A0/dev/sdh
>> [8:0:5:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32 =A0=
/dev/sdi
>> [8:0:6:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32 =A0=
/dev/sdj
>> [8:0:7:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32 =A0=
/dev/sdk
>>
>> #more /etc/mdadm.conf
>> DEVICE partitions
>> ARRAY /dev/md0 level=3Draid6 UUID=3D82ac7386:a854194d:81b795d1:76c9c=
9ff
>>
>> #mdadm --assemble --force --scan /dev/md0
>> mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
>> mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
>> mdadm: failed to add /dev/sdh to /dev/md0: Invalid argument
>> mdadm: /dev/md0 assembled from 7 drives - not enough to start the ar=
ray.
>>
>> dmesg:
>> [ 8215.651860] md: sdc does not have a valid v1.2 superblock, not im=
porting!
>> [ 8215.651865] md: md_import_device returned -22
>> [ 8215.652384] md: sdb does not have a valid v1.2 superblock, not im=
porting!
>> [ 8215.652388] md: md_import_device returned -22
>> [ 8215.653177] md: sdh does not have a valid v1.2 superblock, not im=
porting!
>> [ 8215.653182] md: md_import_device returned -22
>>
>> mdadm -E /dev/sd[b..k] gives exactly the same Magic number and Array
>> UUID for every disk, all checksums are correct,
>> the only difference is - =A0Avail Dev Size : 3907028896 is the same =
for
>> 9 disks, and 3907028864 for sdc
>
> Please provide that output so we can see it too - it might be helpful=
=2E
>
> NeilBrown


# mdadm --assemble --force --update summaries /dev/md0 /dev/sdc
mdadm: --update=3Dsummaries not understood for 1.x metadata


>
>>
>> mdadm --assemble --force --update summaries /dev/sd.. - didn't impro=
ve anything
>>
>>
>> I would really appreciate if someone could point me to the right dir=
ection.
>>
>> thanks
>>
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
