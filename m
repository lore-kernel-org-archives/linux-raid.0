From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: help diagnosing bad disk
Date: Thu, 20 Dec 2007 09:48:44 -0500
Message-ID: <476A80CC.8000701@tmr.com>
References: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>	 <47696E1E.2060204@tmr.com>	 <fa2952810712191109n41c95dcfl13496eeb48223a9f@mail.gmail.com> <fa2952810712191115k414092cfx1132830fea42f3fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa2952810712191115k414092cfx1132830fea42f3fb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Sabo <jonathan.sabo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Sabo wrote:
> I think I got it now.  Thanks for your help!
>   

Now just make our holiday cheer complete by waiting until the resync is 
complete and rebooting to be sure that everything is *really* back as it 
should be.  ;-)
> root@recoil:/home/illsci# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Mon Jul 30 21:47:14 2007
>      Raid Level : raid1
>      Array Size : 1951744 (1906.32 MiB 1998.59 MB)
>     Device Size : 1951744 (1906.32 MiB 1998.59 MB)
>    Raid Devices : 2
>   Total Devices : 1
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Dec 19 14:15:31 2007
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : 157f716c:0e7aebca:c20741f6:bb6099c9
>          Events : 0.48
>
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       0        0        1      removed
> root@recoil:/home/illsci# mdadm --detail /dev/md1
> /dev/md1:
>         Version : 00.90.03
>   Creation Time : Mon Jul 30 21:47:47 2007
>      Raid Level : raid1
>      Array Size : 974808064 (929.65 GiB 998.20 GB)
>     Device Size : 974808064 (929.65 GiB 998.20 GB)
>    Raid Devices : 2
>   Total Devices : 1
> Preferred Minor : 1
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Dec 19 14:19:06 2007
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : 156a030e:9a6f8eb3:9b0c439e:d718e744
>          Events : 0.1498998
>
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       18        1      active sync   /dev/sdb2
> root@recoil:/home/illsci# mdadm /dev/md0 -a /dev/sdb1
> mdadm: re-added /dev/sdb1
> root@recoil:/home/illsci# mdadm /dev/md1 -a /dev/sda2
> mdadm: re-added /dev/sda2
> root@recoil:/home/illsci# cat /proc/mdstat
> Personalities : [multipath] [raid1]
> md1 : active raid1 sda2[2] sdb2[1]
>       974808064 blocks [2/1] [_U]
>         resync=DELAYED
>
> md0 : active raid1 sdb1[2] sda1[0]
>       1951744 blocks [2/1] [U_]
>       [=================>...]  recovery = 86.6% (1693504/1951744)
> finish=0.0min speed=80643K/sec
>
> unused devices: <none>
> root@recoil:/home/illsci# cat /proc/mdstat
> Personalities : [multipath] [raid1]
> md1 : active raid1 sda2[2] sdb2[1]
>       974808064 blocks [2/1] [_U]
>       [>....................]  recovery =  0.0% (86848/974808064)
> finish=186.9min speed=86848K/sec
>
> md0 : active raid1 sdb1[1] sda1[0]
>       1951744 blocks [2/2] [UU]
>
> unused devices: <none>
>   
-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


