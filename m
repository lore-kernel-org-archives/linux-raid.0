From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Sat, 30 Jan 2010 22:20:34 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001301546400.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se> <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se> <20100129211719.04595761@notabene> <alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se>
 <alpine.DEB.1.10.1001291326430.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001291326430.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Jan 2010, Mikael Abrahamsson wrote:

> Yes, that solved the problem. Thanks a bunch!

Now I have another problem. Last time one other drive was kicked out 
during the resync due to UNC read errors. I ddrescued this drive to 
another drive on another system, and inserted the drive I copied to. So 
basically I have 5 drives which contain valid information of which one has 
a lower event count, and one drive being resync:ed. This state doesn't 
seem to be ok...

I guess if I removed the drive being resync:ed to and assembled it with 
--force it would update the event count of sdh (the copy of the drive that 
previously had read errors) and all would be fine. The bad part is that I 
don't really know which of the drives was being resync:ed to. Is this 
indicated by the "feature map" (guess 0x2 means partially sync:ed).

(6 hrs later: Ok, I physically removed the 0x2 drive and used --assemble 
--force and then I added a different drive and that seemed to work)

I don't know what the default action should be when there is a partially 
resync:ed drive and a drive with lower event count, but I tend to lean 
towards that it should take the drive with the lower event count and 
insert it, and then start sync:ing to the 0x2 drive. This might require 
some new options to mdadm to handle this behaviour?

root@ub:~/mdadm-3.1.1# ./mdadm --assemble --force /dev/md0
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
root@ub:~/mdadm-3.1.1# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md0 : inactive sde[0] sdd[7] sdc[8] sdf[2] sdb[6]
       9767572240 blocks super 1.2

unused devices: <none>

[27567.806526] md: md0 stopped.
[27567.807713] md: bind<sdb>
[27567.807869] md: bind<sdf>
[27567.807975] md: bind<sdh>
[27567.808093] md: bind<sdc>
[27567.808224] md: bind<sdd>
[27567.808370] md: bind<sde>
[27567.808383] md: kicking non-fresh sdh from array!
[27567.808387] md: unbind<sdh>
[27567.830363] md: export_rdev(sdh)
[27567.831540] raid5: device sde operational as raid disk 0
[27567.831543] raid5: device sdd operational as raid disk 5
[27567.831545] raid5: device sdf operational as raid disk 2
[27567.831547] raid5: device sdb operational as raid disk 1
[27567.832043] raid5: allocated 6384kB for md0
[27567.832067] raid5: not enough operational devices for md0 (2/6 failed)
[27567.832094] RAID5 conf printout:
[27567.832095]  --- rd:6 wd:4
[27567.832097]  disk 0, o:1, dev:sde
[27567.832099]  disk 1, o:1, dev:sdb
[27567.832101]  disk 2, o:1, dev:sdf
[27567.832275]  disk 4, o:1, dev:sdc
[27567.832277]  disk 5, o:1, dev:sdd
[27567.832566] raid5: failed to run raid set md0
[27567.832581] md: pers->run() failed ...
[27567.897468] md0: ADD_NEW_DISK not supported


Linux ub 2.6.31-17-generic #54-Ubuntu SMP Thu Dec 10 17:01:44 UTC 2009 
x86_64 GNU/Linux

root@ub:~/mdadm-3.1.1# ./mdadm --examine /dev/sd[b-h] | grep Event
mdadm: No md superblock detected on /dev/sdg.
          Events : 2742697
          Events : 2742697
          Events : 2742697
          Events : 2742697
          Events : 2742697
          Events : 2742694

root@ub:~/mdadm-3.1.1# ./mdadm --examine /dev/sd[b-h]
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
            Name : swmike-htpc2:0
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
      Array Size : 19535144320 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : d1dc43a5:cabf2c69:980c1fe8:eab041a0

     Update Time : Fri Jan 29 18:16:02 2010
        Checksum : e94019d4 - correct
          Events : 2742697

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 1
    Array State : AAA.AA ('A' == active, '.' == missing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x2
      Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
            Name : swmike-htpc2:0
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
      Array Size : 19535144320 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
Recovery Offset : 2371002368 sectors
           State : clean
     Device UUID : 25996f75:94aabd4b:88929fa5:9052e459

     Update Time : Fri Jan 29 18:16:02 2010
        Checksum : a072888c - correct
          Events : 2742697

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 4
    Array State : AAA.AA ('A' == active, '.' == missing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
            Name : swmike-htpc2:0
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
      Array Size : 19535144320 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b1c39781:50e6c164:76a2f4ab:9c8c9f45

     Update Time : Fri Jan 29 18:16:02 2010
        Checksum : 2a5c98cb - correct
          Events : 2742697

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 5
    Array State : AAA.AA ('A' == active, '.' == missing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
            Name : swmike-htpc2:0
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
      Array Size : 19535144320 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 7fcd2b91:f17ca45a:4d3b0e08:a156c70a

     Update Time : Fri Jan 29 18:16:02 2010
        Checksum : 51149c0e - correct
          Events : 2742697

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 0
    Array State : AAA.AA ('A' == active, '.' == missing)
/dev/sdf:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
            Name : swmike-htpc2:0
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
      Array Size : 19535144320 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : e5689d67:b72d2697:84792201:492598b3

     Update Time : Fri Jan 29 18:16:02 2010
        Checksum : 5ecf51c - correct
          Events : 2742697

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 2
    Array State : AAA.AA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdg.
/dev/sdh:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
            Name : swmike-htpc2:0
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

  Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
      Array Size : 19535144320 (9315.08 GiB 10001.99 GB)
   Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 3086b1fd:0d547803:5229a71a:6903df1c

     Update Time : Fri Jan 29 17:54:24 2010
        Checksum : 8b1dc19c - correct
          Events : 2742694

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 3
    Array State : AAAAAA ('A' == active, '.' == missing)

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
