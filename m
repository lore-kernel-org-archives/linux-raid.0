From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape
Date: Mon, 19 Jun 2006 17:42:41 -0400
Message-ID: <44971A51.6050008@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net>	<17555.13409.834439.80361@cse.unsw.edu.au>	<44945643.3070300@nigelterry.net>	<17556.31295.280083.533342@cse.unsw.edu.au>	<44947BCA.9040305@nigelterry.net>	<44947C98.6060809@nigelterry.net>	<17556.32630.611922.294047@cse.unsw.edu.au>	<44948002.3050706@nigelterry.net>	<44954DB7.2000305@nigelterry.net> <17558.1521.522659.91428@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17558.1521.522659.91428@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday June 18, nigel@nigelterry.net wrote:
>   
>> This from dmesg might help diagnose the problem:
>>
>>     
>
> Yes, that helps a lot, thanks.
>
> The problem is that the reshape thread is restarting before the array
> is fully set-up, so it ends up dereferencing a NULL pointer.
>
> This patch should fix it.
> In fact, there is a small chance that next time you boot it will work
> without this patch, but the patch makes it more reliable.
>
> There definitely should be no data-loss due to this bug.
>
> Thanks,
> NeilBrown
>
>   
Neil

That seems to have fixed it. The reshape is now progressing and there are no apparent errors in dmesg. Details below.

I'll send another confirmation tomorrow when hopefully it has finished :-)

Many thanks for a great product and great support.

Nigel

[root@homepc ~]# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
      490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3] 
[UUU_]
      [=>...................]  reshape =  7.9% (19588744/245111552) 
finish=6.4min speed=578718K/sec

unused devices: <none>
[root@homepc ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.91.03
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
     Array Size : 490223104 (467.51 GiB 501.99 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jun 19 17:38:42 2006
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Reshape Status : 8% complete
  Delta Devices : 1, (3->4)

           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
         Events : 0.3287189

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       3       65        2      active sync   /dev/hdb1
       3       0        0        3      removed

       4      22        1        -      spare   /dev/hdc1
[root@homepc ~]#

