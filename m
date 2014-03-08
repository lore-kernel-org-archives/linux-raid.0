From: Federico Foschini <undicizeri@gmail.com>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sat, 8 Mar 2014 21:23:26 +0100
Message-ID: <CAFRU1Xs+hKhsJnRap2cARc=Z8W13sftna728WLJs3MGOM+VZag@mail.gmail.com>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
 <531AF967.60500@grumpydevil.homelinux.org> <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com>
 <531B0229.7030800@grumpydevil.homelinux.org> <CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com>
 <531B1098.8080305@grumpydevil.homelinux.org> <531B6EA2.8080702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531B6EA2.8080702@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your help. Unfortunatly the server rebooted before I
could run the update-initramfs command and now this is my current
state:

root@petra:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sdd[3](S)
      2930135512 blocks super 1.2

md0 : active linear sdb[0] sda[1]
      2930277152 blocks super 1.2 0k rounding

unused devices: <none>

root@petra:~# mdadm --examine --scan
ARRAY /dev/md0 UUID=e151ea2f:37b942a4:e368bf24:bd0fce41
ARRAY /dev/md/0 metadata=1.2 UUID=952ad074:4039f24a:2ec1808e:d555a88c
name=petra:0
ARRAY /dev/md/md1 metadata=1.2
UUID=03c85017:15cecfb6:13d059bc:a8ff8779 name=petra:md1

root@petra:~# mdadm --examine /dev/md0
/dev/md0:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 03c85017:15cecfb6:13d059bc:a8ff8779
           Name : petra:md1  (local to host petra)
  Creation Time : Sun Feb 16 12:21:56 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 5860292160 (2794.41 GiB 3000.47 GB)
     Array Size : 2930135360 (2794.39 GiB 3000.46 GB)
  Used Dev Size : 5860270720 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ae9da3ed:c4d422cb:06cf927d:b75bfc36

    Update Time : Sat Mar  8 18:14:00 2014
       Checksum : 51e09d97 - correct
         Events : 74578


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

What is going on? Why /dev/md1 is now inactive and /dev/sdd is busy?
And i don't understand why when I examine /dev/md0 the "Name" is
"petra:md1". Also in "--examine --scan" it says I have /dev/md0
/dev/md/0 and /dev/md/1 when on the filesystem only exist /dev/md0 and
/dev/md1



2014-03-08 20:25 GMT+01:00 Can Jeuleers <can.jeuleers@gmail.com>:
> On 03/08/2014 01:44 PM, Rudy Zijlstra wrote:
>> To solve this, you need to update the initrd. Please google for this, i
>> do not use ubuntu so am not the best to give instructions on it.
>
> sudo update-initramfs -u -k all
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Federico Foschini.
