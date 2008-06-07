From: robert.koeppl@knapp.com
Subject: how can I access a disk marked as failed
Date: Sat, 07 Jun 2008 21:25:15 +0200
Message-ID: <484ae09b.rYL3iK0Iacbytrpy%robert.koeppl@knapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: robert.koeppl@knapp.com
List-Id: linux-raid.ids

Hi all!=20
I am quite desperate with the following scenario:=20
A SW raid 1 consisting of two LUNs on two SAN Storages, running on a Cl=
uster of two machines Active/passive.=20
the connection to one LUN was interrupted for some time, then the machi=
ne went down as went the second SAN with the good data.=20
the other clusternode came up, took over the RAID, but could only acces=
s the old data. This is where we reckognized the problem.=20
After the second server and SAN where back online, we shut down the fir=
st node and started the second one. It showed a degraded Raid so we sta=
rted a resync using mdadm /dev/md1 --add /dev/sdc1. Shortly after that =
we recognized, that it was old data being replicated, not the nwe one, =
so we stopped the resync using mdadm /dev/md2 --fail /dev/sdc1 We then =
shut down the san containing the old, but consistent data. Now we need =
to somwhow access the data on the Image that was partially overwritten.=
 I know, that that data, that has actually been overwritten is lost, bu=
t that is a minor problem, as the first part of the device contained da=
ta that could be restored rather easyly. However most of the Data in th=
e rest of the Disk has not yet been backed up because of other failures=
 on site and is fairly important. Is there any way to access it?=20
Here is the output of mdadm -E of one of the inaccessible drives:=20

k1276kc2:~ # mdadm -E /dev/sdc1=20
/dev/sdc1:=20
          Magic : a92b4efc=20
        Version : 00.90.00=20
           UUID : b61d9303:b5140405:96ac5af7:b39a199b=20
  Creation Time : Tue Apr 15 18:05:00 2008=20
     Raid Level : raid1=20
  Used Dev Size : 132359424 (126.23 GiB 135.54 GB)=20
     Array Size : 132359424 (126.23 GiB 135.54 GB)=20
   Raid Devices : 2=20
  Total Devices : 2=20
Preferred Minor : 2=20

    Update Time : Sat Jun  7 14:00:40 2008=20
          State : clean=20
 Active Devices : 1=20
Working Devices : 2=20
 Failed Devices : 1=20
  Spare Devices : 1=20
       Checksum : f6d7f01c - correct=20
         Events : 0.53858=20


      Number   Major   Minor   RaidDevice State=20
this     2       8       33        2      spare   /dev/sdc1=20

   0     0       8       81        0      active sync   /dev/sdf1=20
   1     1       0        0        1      faulty removed=20
   2     2       8       33        2      spare   /dev/sdc1=20


The interesting thing is, that /dev/sdf1 is in fact inaccesible because=
 it is on the SAN that is powered off. I would need to somehow get /dev=
/sdc1 up and access the LVM that lies on that device.=20

Thanks in advance for your help.=20
 =20
Robert K=C3=B6ppl
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
