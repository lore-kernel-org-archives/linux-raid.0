From: dechris@koli.kando.hu (Deak Krisztian)
Subject: Re: 2 partition kicked from 6 raid5
Date: Tue, 30 Aug 2005 21:57:56 +0200
Message-ID: <20050830195756.GA11280@koli.kando.hu>
References: <20050830181015.GA24181@koli.kando.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050830181015.GA24181@koli.kando.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry, the attachement was missing.


On Tue, Aug 30, 2005 at 08:10:15PM +0200, dechris wrote:
> Hi,
> 
> i have a big problem. A had a sw raid5 array with 6 partition. The array
> has been damaged because problems of power connectors. 2 partitions/disks don't work,
> because during the time the SATA power connections didn't work. 
> Some write/read operations where running. Now when i want to
> run the array loading the kernel, i get the next message:
> 
> raid5: device sdl1 operational as raid disk 0
> raid5: device sdj1 operational as raid disk 5
> raid5: device sdh1 operational as raid disk 3
> raid5: device sdg1 operational as raid disk 2
> raid5: not enough operational devices for md0 (2/6 failed)
> RAID5 conf printout:
>  --- rd:6 wd:4 fd:2
>  disk 0, o:1, dev:sdl1
>  disk 2, o:1, dev:sdg1
>  disk 3, o:1, dev:sdh1
>  disk 5, o:1, dev:sdj1
> raid5: failed to run raid set md0
> 
> I think, that the dammaged partitions have to be used anyway, to get the
> datas back.
> 
> I attached the result of "mdadm --examine".
> Could somebody help me?
> 
> Chris     

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=raid

/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 19745837:e74d1c46:842c4d41:b427d24d
  Creation Time : Fri Jul 22 01:45:23 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Mon Aug 29 11:19:59 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 7196c5c4 - correct
         Events : 0.559485

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       97        2      active sync   /dev/sdg1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       8      145        5      active sync   /dev/sdj1
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 19745837:e74d1c46:842c4d41:b427d24d
  Creation Time : Fri Jul 22 01:45:23 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Mon Aug 29 11:19:59 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 7196c5d6 - correct
         Events : 0.559485

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      113        3      active sync   /dev/sdh1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       8      145        5      active sync   /dev/sdj1
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 19745837:e74d1c46:842c4d41:b427d24d
  Creation Time : Fri Jul 22 01:45:23 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Mon Aug 29 10:14:59 2005
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 71969cd2 - correct
         Events : 0.556184

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      129        4      active sync   /dev/sdi1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       8      145        5      active sync   /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 19745837:e74d1c46:842c4d41:b427d24d
  Creation Time : Fri Jul 22 01:45:23 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Mon Aug 29 11:19:59 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 7196c5fa - correct
         Events : 0.559485

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      145        5      active sync   /dev/sdj1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       8      145        5      active sync   /dev/sdj1
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 19745837:e74d1c46:842c4d41:b427d24d
  Creation Time : Fri Jul 22 01:45:23 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Sun Jul 31 17:40:32 2005
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 71604ecd - correct
         Events : 0.16054

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8      161        1      active sync   /dev/sdk1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       8      145        5      active sync   /dev/sdj1
/dev/sdl1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 19745837:e74d1c46:842c4d41:b427d24d
  Creation Time : Fri Jul 22 01:45:23 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Mon Aug 29 11:19:59 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 7196c600 - correct
         Events : 0.559485

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8      161        0      active sync   /dev/sdk1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       0        0        1      faulty removed
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       8      145        5      active sync   /dev/sdj1

--cWoXeonUoKmBZSoM--
