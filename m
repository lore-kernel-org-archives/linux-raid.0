From: Tom Walsh <tom@openhardware.net>
Subject: Re: array always resyncs on boot
Date: Wed, 03 Dec 2008 00:14:31 -0500
Message-ID: <493615B7.1010503@openhardware.net>
References: <4931B2C5.5060403@openhardware.net> <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan> <4931E75D.5080905@openhardware.net> <493422E1.8080207@tmr.com> <493426FD.4060201@openhardware.net> <49357372.5030304@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49357372.5030304@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Tom Walsh wrote:
>> Bill Davidsen wrote:
>>>
> 
>>> Just for grins, could you post the partition table for each disk? 
>>> Maybe just the output of "fdisk -l" to show everything? I always 
>>> worry when using drives of "almost" the same size.
>>>
>>
>> Sure, identical tables for all six drives:
>> Disk /dev/sda: 320.0 GB, 320071851520 bytes
>> 255 heads, 63 sectors/track, 38913 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x733f1de9
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1   *           1        2433    19543041   fd  Linux raid 
>> autodetect
>> /dev/sda2            2434        2677     1959930   82  Linux swap / 
>> Solaris
>> /dev/sda3            2678       38900   290961247+   5  Extended
>> /dev/sda5            2678       38900   290961216   fd  Linux raid 
>> autodetect
>>
> Okay, I was just looking at the sizes of the drives, since they are not 
> the same, and wondering if the HPA used to make them look the same was 
> in any way leaking and making the HPA area visible. Looks like the 
> "assembled at the wrong time" is the issue, and any of the fixes will 
> probably solve the issue.
>>


Oh yes, the addition of the bitmap cured the resync problems.  I am so 
happy that you guys helped resolving this!  This box is to become a 
primary work machine for me and the problem with the array was driving 
me crazy. I hate having computers doing bad things without an 
explanation. Reason #73 that I don't use the Brand-M O/S...  ;-)


-- 
Tom Walsh - WN3L - Embedded Systems Consultant
http://openhardware.net http://cyberiansoftware.com http://openzipit.org
"Windows? No thanks, I have work to do..."
----------------------------------------------------

