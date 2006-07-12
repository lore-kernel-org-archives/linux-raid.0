From: "Andrew Skolarz" <pletopia@gmail.com>
Subject: Re: PLEASE HELP ... raid5 array degraded ...
Date: Tue, 11 Jul 2006 22:16:14 -0500
Message-ID: <51adc5d50607112016u428b48efx335dc704bb91dfb7@mail.gmail.com>
References: <51adc5d50607112009v476d680fqe9918d607b90def4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51adc5d50607112009v476d680fqe9918d607b90def4@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i performed mdadm -E on the devices in the array

myth ~ # mdadm -E /dev/hdi1
/dev/hdi1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 9ab2395c:b39cfe1c:ba195ea0:0505eb9d
  Creation Time : Mon Dec 26 13:41:06 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jul 10 21:43:11 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 4aaf93b4 - correct
         Events : 0.428721

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0      56        1        0      active sync   /dev/hdi1

   0     0      56        1        0      active sync   /dev/hdi1
   1     1      56       65        1      active sync   /dev/hdj1
   2     2      57        1        2      active sync   /dev/hdk1
   3     3      57       65        3      active sync   /dev/hdl1


myth ~ # mdadm -E /dev/hdj1
/dev/hdj1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 9ab2395c:b39cfe1c:ba195ea0:0505eb9d
  Creation Time : Mon Dec 26 13:41:06 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jul 10 21:43:11 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 4aaf93f6 - correct
         Events : 0.428721

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      56       65        1      active sync   /dev/hdj1

   0     0      56        1        0      active sync   /dev/hdi1
   1     1      56       65        1      active sync   /dev/hdj1
   2     2      57        1        2      active sync   /dev/hdk1
   3     3      57       65        3      active sync   /dev/hdl1


myth ~ # mdadm -E /dev/hdk1
/dev/hdk1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 9ab2395c:b39cfe1c:ba195ea0:0505eb9d
  Creation Time : Mon Dec 26 13:41:06 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jul 10 21:43:11 2006
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 4aa90908 - correct
         Events : 0.428722

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      57        1        2      active sync   /dev/hdk1

   0     0      56        1        0      active sync   /dev/hdi1
   1     1      56       65        1      active sync   /dev/hdj1
   2     2      57        1        2      active sync   /dev/hdk1
   3     3      57       65        3      active sync   /dev/hdl1


myth ~ # mdadm -E /dev/hdl1
/dev/hdl1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 9ab2395c:b39cfe1c:ba195ea0:0505eb9d
  Creation Time : Mon Dec 26 13:41:06 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jul 10 21:43:11 2006
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 4aa9094a - expected 4aa908c4
         Events : 0.428722

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       0        0        0      spare

   0     0      56        1        0      active sync   /dev/hdi1
   1     1      56       65        1      active sync   /dev/hdj1
   2     2      57        1        2      active sync   /dev/hdk1
   3     3      57       65        3      active sync   /dev/hdl1


it does report as hdk having a bad checksum .. but the other 3 drives
seem okay .. hopefully i can restore my data ... but why isn't it
loading up in a 3 drive config ??
