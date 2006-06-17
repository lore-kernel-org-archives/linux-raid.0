From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape
Date: Sat, 17 Jun 2006 15:21:39 -0400
Message-ID: <44945643.3070300@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net> <17555.13409.834439.80361@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17555.13409.834439.80361@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday June 16, nigel@nigelterry.net wrote:
>   
>> Thanks for all the advice. One final question, what kernel and mdadm 
>> versions do I need?
>>     
>
> For resizing raid5:
>
> mdadm-2.4 or later
> linux-2.6.17-rc2 or later
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
Ok, I tried and screwed up!

I upgraded my kernel and mdadm.
I set the grow going and all looked well, so as it said it was going to 
take 430 minutes, I went to Starbucks. When I came home there had been a 
power cut, but my UPS had shut the system down. When power returned I 
rebooted. Now I think I had failed to set the new partition on /dev/hdc1 
to Raid Autodetect, so it didn't find it at reboot. I tried to hot add 
it, but now I seem to have a deadlock situation. Although --detail shows 
that it is degraded and recovering, /proc/mdstat shows it is reshaping. 
In truth there is no disk activity and the count in /proc/mdstat is not 
changing. I gues sthe only good news is that I can still mount the 
device and my data is fine. Please see below...

Any ideas what I should do next? Thanks

Nigel

[root@homepc ~]# uname -a
Linux homepc.nigelterry.net 2.6.17-rc6 #1 SMP Sat Jun 17 11:05:52 EDT 
2006 x86_64 x86_64 x86_64 GNU/Linux
[root@homepc ~]# mdadm --version
mdadm - v2.5.1 -  16 June 2006
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

    Update Time : Sat Jun 17 15:15:05 2006
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Reshape Status : 6% complete
  Delta Devices : 1, (3->4)

           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
         Events : 0.3211829

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       3       65        2      active sync   /dev/hdb1
       3       0        0        3      removed

       4      22        1        -      spare   /dev/hdc1
[root@homepc ~]# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
      490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3] 
[UUU_]
      [=>...................]  reshape =  6.9% (17073280/245111552) 
finish=86.3min speed=44003K/sec

unused devices: <none>
[root@homepc ~]#

