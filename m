From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Thu, 18 Oct 2012 18:11:39 +0100
Message-ID: <CADNH=7HEBDGrN+2SpLB30mAN0nW0ky=KGwCgnxeY4OSejFr1yw@mail.gmail.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
	<C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
	<CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
	<235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com>
	<CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com>
	<D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com>
	<CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com>
	<507FEE52.50103@hardwarefreak.com>
	<CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 October 2012 13:17, Mathias Bur=C3=A9n <mathias.buren@gmail.com> =
wrote:
> On 18 October 2012 12:56, Stan Hoeppner <stan@hardwarefreak.com> wrot=
e:
>> On 10/17/2012 2:03 PM, Mathias Bur=C3=A9n wrote:
>>
>>> There are no CRC errors so I doubt the cable is at fault. In any wa=
y,
>>> I've RMA'd drives for less, and an RMA is underway for this drive.
>>> Just need to wait for the reshape to finish so I can get in the
>>> server. Btw, with a few holes drilled this bad boy holds 7 3.5" HDD=
s
>>> no problem: http://www.antec.com/productPSU.php?id=3D30&pid=3D3
>>
>> It would seem you didn't mod the airflow of the case along with the
>> increased drive count.  The NSK1380 has really poor airflow to begin
>> with: a single PSU mounted 120mm super low RPM fan.  Antec is curren=
tly
>> shipping the NSK1380 with an additional PCI slot centrifugal fan to =
help
>> overcome the limitations of the native design.
>>
>> You bought crap drives, WD20EARS, then improperly modded a case to h=
ouse
>> more than twice the design limit of HDDs.
>>
>> I'd say you stacked the deck against yourself here Mathias.
>>
>> --
>> Stan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Now now, the setup is working like a charm. Disk failures happen all
> the time. There's an additional 120mm at the bottom, blowing up
> towards the 7 HDDs. I bought "crap" drives because they were cheap.
>
> In the 2 years a total of 3 drives have failed, but the array has
> never failed. I'm very pleased with it (HTPC, with an ION board and 4=
x
> SATA PCI-E controller for E10)
>
> Mathias

Just to follow up, the reshape succeeded and I'll now shutdown and RMA
/dev/sde. Thanks all for the answers.

[748891.476091] md: md0: reshape done.
[748891.505225] RAID conf printout:
[748891.505235]  --- level:6 rd:7 wd:5
[748891.505241]  disk 0, o:0, dev:sde1
[748891.505246]  disk 1, o:1, dev:sdf1
[748891.505251]  disk 2, o:1, dev:sdb1
[748891.505257]  disk 3, o:1, dev:sdd1
[748891.505263]  disk 4, o:1, dev:sdc1
[748891.505268]  disk 5, o:1, dev:sdg1
[748891.535219] RAID conf printout:
[748891.535229]  --- level:6 rd:7 wd:5
[748891.535236]  disk 0, o:0, dev:sde1
[748891.535242]  disk 1, o:1, dev:sdf1
[748891.535246]  disk 2, o:1, dev:sdb1
[748891.535251]  disk 3, o:1, dev:sdd1
[748891.535256]  disk 4, o:1, dev:sdc1
[748891.535261]  disk 5, o:1, dev:sdg1
[748891.548477] RAID conf printout:
[748891.548483]  --- level:6 rd:7 wd:5
[748891.548487]  disk 1, o:1, dev:sdf1
[748891.548491]  disk 2, o:1, dev:sdb1
[748891.548494]  disk 3, o:1, dev:sdd1
[748891.548498]  disk 4, o:1, dev:sdc1
[748891.548501]  disk 5, o:1, dev:sdg1
ion ~ $ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sde1[0](F) sdg1[8] sdc1[5] sdd1[3] sdb1[4] sdf1[9]
      9751756800 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/5] [_UUUUU_]

unused devices: <none>
ion ~ $ sudo mdadm -D /dev/md0
[sudo] password for:
/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Thu Oct 18 11:19:35 2012
          State : clean, degraded
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 8678539

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       9       8       81        1      active sync   /dev/sdf1
       4       8       17        2      active sync   /dev/sdb1
       3       8       49        3      active sync   /dev/sdd1
       5       8       33        4      active sync   /dev/sdc1
       8       8       97        5      active sync   /dev/sdg1
       6       0        0        6      removed

       0       8       65        -      faulty spare   /dev/sde1
ion ~ $ sudo mdadm --manage /dev/md0 --remove /dev/sde1
mdadm: hot removed /dev/sde1 from /dev/md0
ion ~ $ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Thu Oct 18 18:09:54 2012
          State : clean, degraded
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 8678542

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       9       8       81        1      active sync   /dev/sdf1
       4       8       17        2      active sync   /dev/sdb1
       3       8       49        3      active sync   /dev/sdd1
       5       8       33        4      active sync   /dev/sdc1
       8       8       97        5      active sync   /dev/sdg1
       6       0        0        6      removed
ion ~ $
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
