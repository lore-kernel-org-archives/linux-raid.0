From: Nate Byrnes <nate@qabal.org>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Mon, 17 Apr 2006 15:29:34 -0400
Message-ID: <4443EC9E.9010502@qabal.org>
References: <1145106091.18173.18.camel@nemo.qabal.org>	<17474.51499.479497.322081@cse.unsw.edu.au>	<1145242458.18173.49.camel@nemo.qabal.org>	<17475.1455.344850.506978@cse.unsw.edu.au>	<1145268508.18173.61.camel@nemo.qabal.org> <17475.28176.159396.519547@cse.unsw.edu.au> <444386C6.2070201@qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444386C6.2070201@qabal.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, List,
    Am I just out of luck? Perhaps a full reboot? Something else?
    Thanks,
    Nate

Nate Byrnes wrote:
> Hi Neil,
>    Nothing references hdf as you can see below.  I have also rmmod'ed 
> md and raid5 modules and modprobed them back in. Thoughts?
>
>    Thanks again,
>    Nate
>
> root@finn:~# cat /proc/swaps
> Filename                                Type            Size    
> Used    Priority
> /dev/sdb2                               partition       1050616 
> 1028    -1
>
> root@finn:~# cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / ext3 rw 0 0
> proc /proc proc rw,nodiratime 0 0
> sysfs /sys sysfs rw 0 0
> none /dev ramfs rw 0 0
> /dev/sdb1 /usr ext3 rw 0 0
> devpts /dev/pts devpts rw 0 0
> nfsd /proc/fs/nfsd nfsd rw 0 0
> usbfs /proc/bus/usb usbfs rw 0 0
>
> root@finn:~# cat /proc/mdstat
> Personalities : [raid5]
> md0 : inactive hdh[2] hdg[3] hde[1]
>      234451968 blocks
>
> unused devices: <none>
>
>
> Neil Brown wrote:
>> On Monday April 17, nate@qabal.org wrote:
>>  
>>>> What is /dev/hdf busy? Is it in use? mounted? something?
>>>>
>>>>       
>>> Not that I am aware of. Here is the mount output:
>>>
>>> root@finn:/etc# mount
>>> /dev/sda1 on / type ext3 (rw)
>>> proc on /proc type proc (rw)
>>> sysfs on /sys type sysfs (rw)
>>> /dev/sdb1 on /usr type ext3 (rw)
>>> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
>>> nfsd on /proc/fs/nfsd type nfsd (rw)
>>> usbfs on /proc/bus/usb type usbfs (rw)
>>>
>>> lsof | grep hdf does not return any results.
>>>
>>> is there some other way to find out?
>>>     
>>
>>  cat /proc/swaps
>>  cat /proc/mounts
>>  cat /proc/mdstat
>>
>> as well as 'lsof' should find it.
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>   
>
> !DSPAM:444386c978211215816793!
>
