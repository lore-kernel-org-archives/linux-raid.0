From: PAulN <pauln@psc.edu>
Subject: Re: Raid5 Construction Question
Date: Thu, 19 Aug 2004 13:52:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4124E8F5.1010105@psc.edu>
References: <200408191730.i7JHUd313659@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408191730.i7JHUd313659@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy,
thanks for the snappy reply!  I wish my disks were as fast :)
I failed to mention that I had been tweaking those proc values.  Currently
they are:
(root@lcn0:raid)# cat speed_limit_max
200000
(root@lcn0:raid)# cat speed_limit_min
10000

If I'm correct, this means that the min speed is 10MB/sec per device.
I've verified that each device has a seq write speed of about 38MB/sec so
each should be capable of handling 10,000Kbytes sec.  Right after I issue
a raidstart the speed is pretty good (~30MB/sec) but is just falls until 
it hits
around 300K. 

md0 : active raid5 sdh1[7] sdf1[6] sdg1[5] sde1[4] sdd1[3] sdc1[2] 
sdb1[1] sda1[0]
      481949184 blocks level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
      [>....................]  resync =  2.4% (1936280/80324864) 
finish=4261.4min speed=305K/sec

In the docs I saw that "reconstruction" is possible with raidhotadd but 
I didn't
see anything about initialization.   So am I "screwed" until the resync 
is fixed?  I was depeding
on the disks to do some filesystem testing but maybe I'll have to wait a 
few days.. 
Thanks,
Paul


Guy wrote:

>In short... Issue this command:
>echo 100000 > /proc/sys/dev/raid/speed_limit_max
>
>If it does not help issue this command and send the results:
>cat /proc/mdstat
>
>Details below.
>
>These are related to throttling:
>/proc/sys/dev/raid/speed_limit_max
>/proc/sys/dev/raid/speed_limit_min
>
>Do "man md" for more info.
>
>The speed limits are per device, not per array.
>Make sure the max is large enough the permit your disks to go as fast as
>they can.  I use 100000 (100,000K bytes/second).  My disks are not that
>fast, and having too large of a number does not hurt.
>At least as a test, set the min to the same value as max.
>
>I use these commands when I want to change by hand:
>cat /proc/sys/dev/raid/speed_limit_max
>cat /proc/sys/dev/raid/speed_limit_min
>
>echo 100000 > /proc/sys/dev/raid/speed_limit_max
>echo 1000 > /proc/sys/dev/raid/speed_limit_min
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of PAulN
>Sent: Thursday, August 19, 2004 1:25 PM
>To: linux-raid@vger.kernel.org
>Subject: Raid5 Construction Question
>
>Hi,
>So I have a raid 5 which is around ~1TB and the problem I've been having 
>is that
>the resync rate is really bad.  This is understandable given that the 
>raid5 has not
>been initialized.  Does anyone know a way for me to initialize my raid5 
>before I use it so
>that the resync process doesn't run for 3 days?
>thanks
>paul
>
>
>Config:
>-------------------------------------------------
>raiddev             /dev/md0
>raid-level                  5
>nr-raid-disks               7
>nr-spare-disks              1
>chunk-size                  64k
>persistent-superblock       1
>parity-algorithm        left-symmetric
>    device          /dev/sda1
>    raid-disk     0
>    device          /dev/sdb1
>    raid-disk     1
>    device          /dev/sdc1
>    raid-disk     2
>    device          /dev/sdd1
>    raid-disk     3
>    device          /dev/sde1
>    raid-disk     4
>    device          /dev/sdg1
>    raid-disk     5
>    device          /dev/sdf1
>    raid-disk    6
>    device          /dev/sdh1
>    spare-disk     0
>----------------------------------------
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>


