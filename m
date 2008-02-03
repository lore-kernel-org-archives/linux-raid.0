From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid problem: after every reboot /dev/sdb1 is removed?
Date: Sun, 03 Feb 2008 10:34:13 -0500
Message-ID: <47A5DEF5.5040202@tmr.com>
References: <20080201135220.617194ff@berni> <47A4C8E6.4070402@tmr.com> <20080203023001.066852a6@berni>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080203023001.066852a6@berni>
Sender: linux-raid-owner@vger.kernel.org
To: Berni <wstripes@gmx.at>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Berni wrote:
> Hi
>
> I created the raid arrays during install with the text-installer-cd. 
> So first the raid array was created and then the system was installed on it. 
>
>
> I don't have a extra /boot partition its on the root (/) partition and the root is the md0 in the raid. Every partition for ubuntu (also swap) is in the raid.
>
> What exactly means rerunning grub? (to put both hdd into the mbr)? 
> I can't find the "mkinitrd" into ubuntu. I made a update-initramfs but it didn't help.
>
>   
I think you need some ubuntu guru to help, I always create a small raid1 
for /boot and then use other arrays for whatever the system is doing. I 
don't know if ubuntu uses mkinitrd or what, but it clearly didn't get it 
right without a little help from you.
> thanks 
>   

How about some input, ubuntu users (or Debian, isn't ubuntu really Debian?).
>
> On Sat, 02 Feb 2008 14:47:50 -0500
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>> Berni wrote:
>>     
>>> Hi!
>>>
>>> I have the following problem with my softraid (raid 1). I'm running
>>> Ubuntu 7.10 64bit with kernel 2.6.22-14-generic.
>>>
>>> After every reboot my first boot partition in md0 is not synchron. One
>>> of the disks (the sdb1) is removed. 
>>> After a resynch every partition is synching. But after a reboot the
>>> state is "removed". 
>>>
>>> The disks are new and both seagate 250gb with exactly the same partition table. 
>>>
>>>   
>>>       
>> Did you create the raid arrays and then install on them? Or add them 
>> after the fact? I have seen this type of problem when the initrd doesn't 
>> start the array before pivotroot, usually because the raid capabilities 
>> aren't in the boot image. In that case rerunning grub and mkinitrd may help.
>>
>> I run raid on Redhat distributions, and some Slackware, so I can't speak 
>> for Ubuntu from great experience, but that's what it sounds like. When 
>> you boot, is the /boot mounted on a degraded array or on the raw partition?
>>     


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


