From: Chris Eddington <chrise@synplicity.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Fri, 09 Nov 2007 13:23:49 -0800
Message-ID: <4734CFE5.8070305@synplicity.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4732E5F0.7080805@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks David.

I've had cable/port failures in the past and after re-adding the drive, 
the order changed - I'm not sure why, but I noticed it sometime ago but 
don't remember the exact order.

My initial attempt to assemble, it came up with only two drives in the 
array.  Then I tried assembling with --force and that brought up 3 of 
the drives.  At that point I thought I was good, so I tried mount 
/dev/md0 and it failed.  Would that have written to the disk?  I'm using 
XFS.

After that, I tried assembling with different drive orders on the 
command line, i.e. mdadm -Av --force /dev/md0 /dev/sda1, ... thinking 
that the order might not be right.

At the moment I can't access the machine, but I'll try fsck -n and send 
you the other info later this evening.

Many thanks,
Chris

David Greaves wrote:
> Chris Eddington wrote:
>   
>> Hi,
>>     
> Hi
>   
>> While on vacation I had one SATA port/cable fail, and then four hours
>> later a second one fail.  After fixing/moving the SATA ports, I can
>> reboot and all drives seem to be OK now, but when assembled it won't
>> recognize the filesystem.
>>     
>
> That's unusual - if the array comes back then you should be OK.
> In general if two devices fail then there is a real data loss risk.
> However if the drives are good and there was just a cable glitch, then unless
> you're unlucky it's usually fsck fixable.
>
> I see
> mdadm: /dev/md0 has been started with 3 drives (out of 4).
>
> which means it's now up and running.
>
> And:
> sda1        Events : 0.4880374
> sdb1        Events : 0.4880374
> sdc1        Events : 0.4857597
> sdd1        Events : 0.4880374
>
> so sdc1 is way out of date... we'll add/resync that when everything else is working.
>
> but:
>   
>>  After futzing around with assemble options
>> like --force and disk order I couldn't get it to work.
>>     
>
> Let me check... what commands did you use? Just 'assemble' - which doesn't care
> about disk order - or did you try to re-'create' the array - which does care
> about disk order and leads us down a different path...
> err, scratch that:
>   
>>  Creation Time : Sun Nov  5 14:25:01 2006
>>     
> OK, it was created a year ago... so you did use assemble.
>
>
> It is slightly odd to see that the drive order is:
> /dev/mapper/sda1
> /dev/mapper/sdb1
> /dev/mapper/sdd1
> /dev/mapper/sdc1
> Usually people just create them in order.
>
>
> Have you done any fsck's that involve a write?
>
> What filesystem are you running? What does your 'fsck -n' (readonly) report?
>
> Also, please report the results of:
>  cat /proc/mdadm
>  mdadm -D /dev/md0
>  cat /etc/mdadm.conf
>
>
> David
>
>   

