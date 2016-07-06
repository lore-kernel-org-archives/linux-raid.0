From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Request for assistance
Date: Wed, 6 Jul 2016 11:55:06 +1000
Message-ID: <577C64FA.6050504@websitemanagers.com.au>
References: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/07/16 10:13, o1bigtenor wrote:
> Greetings
>
> Running a Raid 10 array with 4 - 3 TB drives. Have a UPS but this area
> gets significant lightning and also brownout (rural power) events.
>
> Found the array was read only this morning. Thought that rebooting the
> system might correct things - - - it did not as the array did not
> load.
>
> commands used followed by system response
>
> mdadm --detail /dev/md0
>     mdadm:  md device /dev/md0 does not appear to be active.
>
> cat /proc/mdstat
>     md0  : inactive sdc1[5](S) sdf1[8](S) sde1[7](S) sdb1[4](S)
>
> mdadm -E /dev/sdb1
>                         sdc1
>                         sde1
>                         sdf1
>
> everything is the same except for 2 items
>
> sde and sdf have uptime listed from July 04 05:50:46
>                            events 64841
>                            array state of AAAA
>
> sdb and sdc have uptime listed from July 05 01:57:38
>                             events 64844
>                             array state of AAA.
>
>
>
> Do I just re-create the array?
>
No, not if you value your data. Only re-create the array if you are told 
to by someone (knowledgeable) on the list.

In your case, I think you should stop the array.
mdadm --stop /dev/md0
Make sure there is nothing listed in /proc/mdstat
Then try to assemble the array, but force the events to match:
mdadm --assemble /dev/md0 --force /dev/sd[bcef]1

If that doesn't work, then include the output from dmesg as well as 
/proc/mdstat and any commandline output generated.

You might also want to examine why two drives dropped, referring to logs 
or similar might assist.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
