From: nterry <nigel@nigelterry.net>
Subject: Re: Raid 5 Problem
Date: Tue, 16 Dec 2008 15:39:48 -0500
Message-ID: <49481214.2070700@nigelterry.net>
References: <49450D04.8060703@nigelterry.net>	<4945276E.1010405@ziu.info>	<49456F94.8020100@nigelterry.net>	<49457719.4000009@ziu.info>	<49457BE3.4090200@nigelterry.net> <18758.53532.742930.802728@notabene.brown> <4946E31A.7040803@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4946E31A.7040803@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Michal Soltys <soltys@ziu.info>
List-Id: linux-raid.ids

nterry wrote:
> Neil Brown wrote:
>>
>> An alternate fix in this case would be
>>
>>   mdadm --zero-superblock /dev/sdb
>>
>> to remove the old superblock that is confusing things.
>>
>> NeilBrown
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
> That fails as:
>
> [root@homepc ~]# mdadm --zero-superblock /dev/sdb
> mdadm: Couldn't open /dev/sdb for write - not zeroing
> [root@homepc ~]#
>
> I also discovered that /dev/sdc appears to have a superblock which 
> maybe explains why # mdadm --examine --scan throws up three arrays.  
> Trying to zero the superblock on /dev/sdc gives the same error.
OK, I solved it, but not in a clean manner.  I had to remove /dev/sdb1 
from the array before I could zero the superblock on /dev/sdb  as below:

[root@homepc ~]# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
[root@homepc ~]# mdadm /dev/md0 --remove /dev/sdb1
mdadm: hot removed /dev/sdb1
[root@homepc ~]# mdadm --zero-superblock --verbose /dev/sdb
[root@homepc ~]# mdadm /dev/md0 --re-add /dev/sdb1
mdadm: re-added /dev/sdb1
[root@homepc ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[4] sdd1[0] sdc1[3] sde1[1]
      735334656 blocks level 5, 128k chunk, algorithm 2 [4/3] [UU_U]
      [>....................]  recovery =  0.0% (204800/245111552) 
finish=79.6min speed=51200K/sec
     
unused devices: <none>

I did this on both sdb and sdc and now I only have the one array when I 
mdadm --examine --scan --verbose.  However is there a better way to do 
this that doesn't involve a full recovery?  I thought --re-add would 
handle that?

