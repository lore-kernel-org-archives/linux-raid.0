From: Steven Dake <sdake@mvista.com>
Subject: Re: readonly start of Linux RAID
Date: Wed, 29 Jan 2003 09:53:39 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E380713.7090709@mvista.com>
References: <3E36C2C3.3070101@shaolinmicro.com> <3E36CBB5.6050904@mvista.com> <3E37445F.5020609@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E37445F.5020609@shaolinmicro.com>
To: David Chow <davidchow@shaolinmicro.com>
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David,

The changes to the md driver itself are minimal to support clustering 
and I think they are likely to make kernel.org (the ability to set 
read-only or write mode with some extensions to support resyncs between 
cluster nodes).  The significant changes are to the userland utilities.

I also have an implementation of raid multihost locking, which locks a 
RAID array to a specific host ID (based upon geographical address, 
fibrechannel host's wwn, or scsi host id).  This ensures that a RAID 
cannot be shared between hosts and will prevent other hosts from 
starting the raid or causing any problems with it.

Regards,
-steve

David Chow wrote:

> Steve,
>
> Thanks for replying.  The message you given talked about a cluster 
> implemetation of MD driver which is completely out of the scope of 
> linux raid. I do think such implementation belongs to some cluster 
> file system or volume management systems, and it seems such 
> implementation of md will be very hard to get into the stock kernel . 
> What I am asking is a generic simple enhancement of the md which might 
> be useful in lot of areas (shared storage is just one example), and 
> even administration on preventing some md being rebuild immediate 
> after an unclean shutdown or similar senarios. The work to do is 
> mimimal comparing the work on a cluster md driver implementation.
>
> Someone talk about this...
> http://marc.theaimsgroup.com/?l=linux-raid&m=103300356601897&w=2
>
> Neil talked about this before too...
> http://marc.theaimsgroup.com/?l=linux-raid&m=102669565104333&w=2
>
> Please give pointer to access information so that I can keep track the 
> read-only stuff if it exists. Thanks.
>
> regards,
> David
>
> Steven Dake wrote:
>
>> David,
>>
>> Read this regarding enhancing the MD driver to work in a shared 
>> storage environment.
>>
>> http://marc.theaimsgroup.com/?l=linux-raid&m=104170749423143&w=2
>>
>> David Chow wrote:
>>
>>> Hi Neil,
>>>
>>> I've been reading some archives in the Linux RAID mailing list. 
>>> Someone ask for implementing a readonly mode instead of degraded 
>>> mode in RAID-1/5 setups. I'm falling into a similar problem . I 
>>> think it is important to have a readonly mode on starting a RAID 
>>> device or operating on a RAID device. Think of systems that didn't 
>>> want to rebuild their RAID immediately after an unclean shutdown... 
>>> Calling autorun() ioctls will make all devices starting rebuild 
>>> themselves in case of any available disk exists. In case we are on a 
>>> shared storage system, the active cluster might have using the RAID 
>>> disks which seems to be unclean on the other standby cluster. The 
>>> standby cluster might want to have a read-only inspection of the 
>>> shared storage. In case of a high availability cluster system 
>>> failover, the standby cluster might want to determine to start full 
>>> read/write access by some tools instead of forced automatic at 
>>> system boot (initrd calling raidautorun). In such circumstances, the 
>>> curr!
>>> !
>>> ent md driver cannot be used. This also prohibits many 
>>> implementation of a high availability system from implement linux 
>>> RAID on a shared storage on an HA system which is extremely 
>>> important. I guess, this problem also comes with LVM and other 
>>> similar volume management system. I'm currently studying the md.c 
>>> code in a 2.4.19 kernel which I see implementing a read-only mode 
>>> for md is possible. Please give advice or anything happening, so 
>>> that I don't spend duplicated efforts. Thanks.
>>>
>>>
>>> regards,
>>> David Chow
>>>
>>>
>
>
>

