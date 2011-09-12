From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Rotating RAID 1
Date: Mon, 12 Sep 2011 10:20:34 -0400
Message-ID: <4E6E1532.6080700@tmr.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>	<4E497FB5.3030109@ivitera.com>	<CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>	<4E49849E.4030604@ivitera.com>	<20110816084251.2d8e7831@notabene.brown>	<CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com> <20110816095517.757afc07@notabene.brown> <4E4A0F86.6010907@ivitera.com> <4E6A9328.6070801@tmr.com> <4E6D0A37.2000900@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E6D0A37.2000900@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Pavel Hofman wrote:
> Dne 10.9.2011 00:28, Bill Davidsen napsal(a):
>    
>> Pavel Hofman wrote:
>>      
>>> Dne 16.8.2011 01:55, NeilBrown napsal(a):
>>>
>>>        
>>>>    Also, it doesn't have to be a linear stack.  It could be a binary tree
>>>>    though that might take a little more care to construct.
>>>>
>>>>          
>>> Since our backup server being a critical resource needs redundancy
>>> itself, we are running two degraded RAID1s in parallel, using two
>>> internal drives. The two alternating external drives plug into the
>>> corresponding bitmap-enabled RAID1.
>>>
>>>        
>> I wonder if you could use a four device raid1 here, two drives
>> permanently installed and two being added one at a time to the array.
>> That gives you internal redundancy and recent backups as well.
>>      
> I am not sure you could employ the write-intent bitmap then. And the
> bitmap makes the backup considerably faster.
>    

With --bitmap=internal you should have all of the information you need 
to do fast recovery, but I may misunderstand internal bitmap and 
possibly incremental build. What I proposed was creating the array as 
dev1 dev2 dev3 missing, then dev3 or dev4 could be added and brought up 
to current independently because they would be separate devices.

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



