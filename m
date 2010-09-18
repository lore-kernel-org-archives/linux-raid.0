From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: some non critical problems... (1. mdadm segfault -> write-mostly,
 2. smart?)
Date: Sat, 18 Sep 2010 14:01:31 -0400
Message-ID: <4C94FE7B.1050009@tmr.com>
References: <20100906143308.2e1a9291@atak.bl.pg.gda.pl>	<20100908114415.6ac8bcb9@atak.bl.pg.gda.pl> <20100914151347.3c387cbd@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100914151347.3c387cbd@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Janek Kozicki said:     (by the date of Wed, 8 Sep 2010 11:44:15 +0200)
>
>    
>> Umm... to reiterate one of my questions in above email:
>>
>>
>>      
>>> md1 : active raid1 sdc1[3](W) sdb1[5](W)
>>>        9767416 blocks super 1.0 [2/2] [UU]
>>>        bitmap: 6/150 pages [24KB], 32KB chunk
>>>        
>> Is it possible to disable that (W) --write-mostly flag? Does it
>> decrease performance or something, if both devices in the array are
>> set to (W) ?
>>      
> this seems to have fixed it:
>
>   mdadm --fail /dev/md1 /dev/sdb1
>   mdadm --remove /dev/md1 /dev/sdb1
>   mdadm --zero-superblock /dev/sdb1
>   mdadm --add --readwrite /dev/md1 /dev/sdb1
>
>
>    
Sorry for a late question, but in adding this to my notes, I realized I 
wasn't clear on why this flag moved to the other partitions. Are you, 
and if so can you clarify?


-- 
Bill Davidsen<davidsen@tmr.com>
   "We can't solve today's problems by using the same thinking we
    used in creating them." - Einstein

