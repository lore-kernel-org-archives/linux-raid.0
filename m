From: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH] md/raid1: add error handling of read error from FailFast device
Date: Fri, 4 May 2018 10:38:38 +0200
Message-ID: <CAJX1YtYc=TANNCUr+Sj3_zjR55ed9VYx9KAi9iEpg2M5=YZ3gw@mail.gmail.com>
References: <20180502110811.10886-1-gi-oh.kim@profitbricks.com> <CAJX1YtYhbutYFC-cT+dRoRvjqkOY_qSWtU_tSUZ99Q9-yGUF_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJX1YtYhbutYFC-cT+dRoRvjqkOY_qSWtU_tSUZ99Q9-yGUF_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: linux-raid.ids

On Wed, May 2, 2018 at 2:11 PM, Gi-Oh Kim <gi-oh.kim@profitbricks.com> wrot=
e:
> On Wed, May 2, 2018 at 1:08 PM, Gioh Kim <gi-oh.kim@profitbricks.com> wro=
te:
>> Current handle_read_error() function calls fix_read_error()
>> only if md device is RW and rdev does not include FailFast flag.
>> It does not handle a read error from a RW device including
>> FailFast flag.
>>
>> I am not sure it is intended. But I found that write IO error
>> sets rdev faulty. The md module should handle the read IO error and
>> write IO error equally. So I think read IO error should set rdev faulty.

Hi Mr. Neil Brown.

Could you please inform me if it is a bug or feature that md module
does not set device faulty after read IO error?
My company product uses failfast flag to create md devices for a
virtual machine.
Even if storage get failed and the virtual machine fails to read data,
I cannot check which md device is faulty with mdadm tool.
If it is intended, I need to disable failfast flag.

Thank you in advance.

>>
>> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
>> ---
>>  drivers/md/raid1.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index e9e3308cb0a7..4445179aa4c8 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2474,6 +2474,8 @@ static void handle_read_error(struct r1conf *conf,=
 struct r1bio *r1_bio)
>>                 fix_read_error(conf, r1_bio->read_disk,
>>                                r1_bio->sector, r1_bio->sectors);
>>                 unfreeze_array(conf);
>> +       } else if (mddev->ro =3D=3D 0 && test_bit(FailFast, &rdev->flags=
)) {
>> +               md_error(mddev, rdev);
>>         } else {
>>                 r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>>         }
>> --
>> 2.14.1
>>
>
> I think it would be helpful to show how I tested it.
>
> As following I used Ubuntu 17.10 and mdadm v4.0.
> # cat /etc/lsb-release
> DISTRIB_ID=3DUbuntu
> DISTRIB_RELEASE=3D17.10
> DISTRIB_CODENAME=3Dartful
> DISTRIB_DESCRIPTION=3D"Ubuntu 17.10"
> # uname -a
> Linux ws00837 4.13.0-16-generic #19-Ubuntu SMP Wed Oct 11 18:35:14 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> # mdadm --version
> mdadm - v4.0 - 2017-01-09
>
> Following is how I generated the read IO error and checked md device.
> After read IO, no device was set as faulty
>
> # modprobe scsi_debug num_parts=3D2
> # man mdadm
> # mdadm -C /dev/md111 --failfast -l 1 -n 2 /dev/sdc1 /dev/sdc2
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=3D0.90
> mdadm: largest drive (/dev/sdc2) exceeds size (3904K) by more than 1%
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md111 started.
> # mdadm -D /dev/md111
> /dev/md111:
>         Version : 1.2
>   Creation Time : Wed May  2 10:55:35 2018
>      Raid Level : raid1
>      Array Size : 3904
>   Used Dev Size : 3904
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Wed May  2 10:55:36 2018
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            Name : ws00837:111  (local to host ws00837)
>            UUID : 9f214193:03cf7c97:3208da22:d6ab8a13
>          Events : 17
>
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync failfast   /dev/sdc1
>        1       8       34        1      active sync failfast   /dev/sdc2
> # cat /proc/mdstat
> Personalities : [raid1]
> md111 : active raid1 sdc2[1] sdc1[0]
>       3904 blocks super 1.2 [2/2] [UU]
>
> unused devices: <none>
> # echo -1 > /sys/module/scsi_debug/parameters/every_nth && echo 4 >
> /sys/module/scsi_debug/parameters/opts
> # dd if=3D/dev/md111 of=3D/dev/null bs=3D4K count=3D1 iflag=3Ddirect &
> [1] 6322
> # dd: error reading '/dev/md111': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes copied, 124,376 s, 0,0 kB/s
>
> [1]+  Exit 1                  dd if=3D/dev/md111 of=3D/dev/null bs=3D4K
> count=3D1 iflag=3Ddirect
> # mdadm -D /dev/md111/dev/md111:
>         Version : 1.2
>   Creation Time : Wed May  2 10:55:35 2018
>      Raid Level : raid1
>      Array Size : 3904
>   Used Dev Size : 3904
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Wed May  2 10:55:36 2018
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync failfast   /dev/sdc1
>        1       8       34        1      active sync failfast   /dev/sdc2
>
>
> Following is how I generated the write IO error and checked md device.
> After write IO error, one device was set as faulty.
>
> gohkim@ws00837:~$ sudo modprobe scsi_debug num_parts=3D2
> gohkim@ws00837:~$ sudo mdadm -C /dev/md111 --failfast -l 1 -n 2
> /dev/sdc1 /dev/sdc2
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=3D0.90
> mdadm: largest drive (/dev/sdc2) exceeds size (3904K) by more than 1%
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md111 started.
> gohkim@ws00837:~$ sudo mdadm -D /dev/md111
> /dev/md111:
>         Version : 1.2
>   Creation Time : Wed May  2 14:03:30 2018
>      Raid Level : raid1
>      Array Size : 3904
>   Used Dev Size : 3904
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Wed May  2 14:03:31 2018
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            Name : ws00837:111  (local to host ws00837)
>            UUID : ba51fe65:c517a25a:a381ccc5:3617322b
>          Events : 17
>
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync failfast   /dev/sdc1
>        1       8       34        1      active sync failfast   /dev/sdc2
> gohkim@ws00837:~$ echo -1 | sudo tee /sys/module/scsi_debug/parameters/ev=
ery_nth
> -1
> gohkim@ws00837:~$ echo 4 | sudo tee /sys/module/scsi_debug/parameters/opt=
s
> 4
> gohkim@ws00837:~$ sudo dd if=3D/dev/zero of=3D/dev/md111 bs=3D4K count=3D=
1
> oflag=3Ddirect &
> [1] 13081
> gohkim@ws00837:~$ dd: error writing '/dev/md111': Input/output error
> 1+0 records in
> 0+0 records out
> 0 bytes copied, 184,523 s, 0,0 kB/s
>
> [1]+  Exit 1                  sudo dd if=3D/dev/zero of=3D/dev/md111 bs=
=3D4K
> count=3D1 oflag=3Ddirect
> gohkim@ws00837:~$ sudo mdadm -D /dev/md111
> /dev/md111:
>         Version : 1.2
>   Creation Time : Wed May  2 14:03:30 2018
>      Raid Level : raid1
>      Array Size : 3904
>   Used Dev Size : 3904
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Wed May  2 14:07:47 2018
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync failfast   /dev/sdc1
>        -       0        0        1      removed
>
>        1       8       34        -      faulty failfast   /dev/sdc2
>
>
>
> --
> GIOH KIM
> Linux Kernel Entwickler
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Tel:       +49 176 2697 8962
> Fax:      +49 30 577 008 299
> Email:    gi-oh.kim@profitbricks.com
> URL:      https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Ste=
ffens



--=20
GIOH KIM
Linux Kernel Entwickler

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 176 2697 8962
Fax:      +49 30 577 008 299
Email:    gi-oh.kim@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
