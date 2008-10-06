From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID issue (Fedora 9 issue?)
Date: Mon, 06 Oct 2008 15:28:17 -0400
Message-ID: <48EA66D1.6050703@tmr.com>
References: <48E81A7A.4080703@bubble.org> <48E88DB2.9060503@dgreaves.com> <48E89E27.3030102@bubble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48E89E27.3030102@bubble.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeffrey Ross <jeff@bubble.org>
Cc: David Greaves <david@dgreaves.com>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeffrey Ross wrote:
>
>
> David Greaves wrote:
>>
>>> I have verified the contents of the
>>> /etc/mdadm.conf file that the UUID's are correct
>>>     
>>
>> Which mdadm.conf? The one on /dev/md6?
>> Youy need to check/update the one in the initrd.
>>
>> Shouldn't have changed though unless you did a rebuild or something.
>>   
>
> uh... you nailed it... the mdadm.conf in the initrd (which I didn't 
> realize existed) was out of sync with the /etc/mdadm.conf and had the 
> incorrect UUID numbers.  I had mistakenly updated it installed a 
> kernel update then realized it was wrong corrected it back but didn't 
> rebuild the initrd file.

I suggested that the config in the initrd was wrong in the same post 
which suggested that you ask in linux-raid. In the previous sentence, as 
a matter of fact.

>>> What has changed?  Not 100% sure, I have installed a handful of new
>>> patches recently since the last reboot and unfortunately I don't know
>>> which ones so there are a lot of possibilities.
>>>     
>> OK
>> Kernel patches? Or rpms?
>>   
> The answer is yes to both, but obviously it was due to my (incorrect) 
> tinkering.
>> David
>>
>>   
> Thank you again... its always nice to learn something new about the 
> system.


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


