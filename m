From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 10:43:17 -0400
Message-ID: <4D934185.9020201@meetinghouse.net>
References: <20110330131157.49fd2521@natsu>	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>	<20110330144944.3c87185c@natsu>	<4D933188.30003@hardwarefreak.com> <AANLkTikydoHZxYOOT6Lg1bRPTL3_npG5KgTjDgZMzesn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikydoHZxYOOT6Lg1bRPTL3_npG5KgTjDgZMzesn@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wonder how OCFS (or some other distributed file system) would run over 
btfrs (raid10, no raid6), over AOE or iSCSI block devices.

Roberto Spadim wrote:
> OCFS with DRBD could work very nice in linux
> i didn't tested mdadm with ndb in a production enviroment
> DRBD have brainsplit solutions, since you will run a complex
> filesystem, i consider using working solutions, DRBD and OCFS is nice
> yes, mdadm can run under DRBD
> DRBD = raid1 over network
> OCFS = oracle filesystem (cluster filesystem)
> it works
>
> 2011/3/30 Stan Hoeppner<stan@hardwarefreak.com>:
>    
>> Roman Mamedov put forth on 3/30/2011 3:49 AM:
>>      
>>> On Wed, 30 Mar 2011 11:20:41 +0400
>>> CoolCold<coolthecold@gmail.com>  wrote:
>>>
>>>        
>>>> Looking on your host I think you speak russian, so may be this will be
>>>> somehow helpful for you
>>>> http://community.livejournal.com/ru_root/2216389.html
>>>>          
>>> Thanks -- I have looked through the websites of some distributed filesystems
>>> (Ceph, GlusterFS, MooseFS etc) and checked this thread too, but from what I
>>> could find, all filesystems I read about so far are at most capable of RAID0 or
>>> RAID1-like modes, where fault-tolerance is either not provided, or achieved
>>> only by "all data is replicated across N nodes", which of course divides the
>>> total usable space by N. I haven't found any FS which would do block-level
>>> replication relying not on dumb copies, but on RAID5/6-like parity algorithms
>>> for fault-tolerance. Maybe I missed something?
>>>        
>> You likely won't find any distributed filesystem that performs block
>> level replication over the network, at least not a FOSS one.  These are
>> filesystems, mind you, not distributed block device drivers.  If they
>> perform any replication to afford a level of fault tolerance, it will be
>> at the file level, not the block level.
>>
>> If you want true block level replication over a network, look into DRBD.
>>   However, it is also limited to mirroring.
>>
>> --
>> Stan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>      
>
>
>    


-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


