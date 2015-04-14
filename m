From: Emanuel Domingos <emanuelsdrock@gmail.com>
Subject: Re: Recovery Raid6 Degraded
Date: Tue, 14 Apr 2015 15:06:06 -0300
Message-ID: <CACsoFmiCoZGRoUWpxg_PLw6hyhW1mAB0TZFO94MZ6Kix-DxMOA@mail.gmail.com>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
	<alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
	<CACsoFmiCXw1dgpqtz33rA5ejMhYsndi68L63OdpRoU_XyCfFFg@mail.gmail.com>
	<alpine.DEB.2.02.1504141617220.16871@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504141617220.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks! worked perfectly

=46ollow results

#mdadm --stop /dev/md/ubuntu\:md-raid6_primary

#mdadm --assemble --force /dev/md/ubuntu\:md-raid6_primary /dev/sdaa
/dev/sdac /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdz


 cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md124 : active raid6 sdf[0] sdz[5] sdj[8] sdi[3] sdh[2] sdg[1]
      11721077760 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/6] [UUUUUU__]

md125 : active (auto-read-only) raid1 sdag[1]
      97684688 blocks super 1.2 [2/1] [_U]

md126 : active raid6 sdad[1] sdv[2] sdy[5] sdw[3] sdx[4]
      7814051840 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/5] [_UUUUU]

md127 : inactive sdd[13] sdc[15] sde[14] sda[10] sdb[11] sdt[4] sdr[2]
sdq[1] sdm[7] sdk[5] sdo[9] sdn[8]
      23442162720 blocks super 1.2

unused devices: <none>


Adding two disks that were removed [8/6]


mdadm --manage /dev/md124 --add /dev/sdaa

mdadm --manage /dev/md124 --add /dev/sdac


cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md124 : active raid6 sdac[10] sdaa[9] sdf[0] sdz[5] sdj[8] sdi[3] sdh[2=
] sdg[1]
      11721077760 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/6] [UUUUUU__]
      [>....................]  recovery =3D  0.4% (8112408/1953512960)
finish=3D6234.6min speed=3D5200K/sec

md125 : active (auto-read-only) raid1 sdag[1]
      97684688 blocks super 1.2 [2/1] [_U]

md126 : active raid6 sdad[1] sdv[2] sdy[5] sdw[3] sdx[4]
      7814051840 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/5] [_UUUUU]

md127 : inactive sdd[13] sdc[15] sde[14] sda[10] sdb[11] sdt[4] sdr[2]
sdq[1] sdm[7] sdk[5] sdo[9] sdn[8]
      23442162720 blocks super 1.2

unused devices: <none>


mdadm --detail /dev/md124
/dev/md124:
        Version : 1.2
  Creation Time : Thu Sep 27 11:39:20 2012
     Raid Level : raid6
     Array Size : 11721077760 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Tue Apr 14 14:37:56 2015
          State : clean, degraded, recovering
 Active Devices : 6
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 0% complete

           Name : ubuntu:md-raid6_primary  (local to host ubuntu)
           UUID : cee8d180:d6275a41:599064c6:8894819e
         Events : 1093711

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf
       1       8       96        1      active sync   /dev/sdg
       2       8      112        2      active sync   /dev/sdh
       3       8      128        3      active sync   /dev/sdi
       8       8      144        4      active sync   /dev/sdj
       5      65      144        5      active sync   /dev/sdz
       9      65      160        6      spare rebuilding   /dev/sdaa
      10      65      192        7      spare rebuilding   /dev/sdac

Just wait for the complete rebuild! Great work. Thanks














2015-04-14 11:19 GMT-03:00 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Tue, 14 Apr 2015, Emanuel Domingos wrote:
>
>> Hi, Mikael, hi guys!
>>
>>
>> Follow the errors found after building the new version of mdadm:
>>
>> #mdadm --stop /dev/md/ubuntu\:md-raid6_primary
>>
>> #mdadm --assemble --force /dev/md/ubuntu\:md-raid6_primary /dev/sdaa
>> /dev/sdac
>> /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdz
>>
>> mdadm: device /dev/md/ubuntu:md-raid6_primary exists but is not an m=
d
>> array.
>
>
> Please call it /dev/md124 and not the above ubuntu: name. I have no i=
dea
> what it is you're trying to do with that name. Also use --verbose whe=
n
> trying to do the assembly and see if you get any further information.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Emanuel Domingos

Cursando Bacharelado em Ci=C3=AAncia da Computa=C3=A7=C3=A3o - IFCE Cam=
pus Maracana=C3=BA
T=C3=A9cnico em Conectividade - IFCE Campus Maracana=C3=BA
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
