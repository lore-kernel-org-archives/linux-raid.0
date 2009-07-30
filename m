From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: help with bad performing raid6
Date: Thu, 30 Jul 2009 09:15:02 -0400
Message-ID: <4A719CD6.1060801@tmr.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com> <4A7065F1.3060203@tmr.com> <002801ca1066$7f30be90$7d923bb0$@id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002801ca1066$7f30be90$7d923bb0$@id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: 'Jon Nelson' <jnelson-suse@jamponi.net>, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steven Haigh wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Bill Davidsen
>> Sent: Thursday, 30 July 2009 1:09 AM
>> To: Jon Nelson
>> Cc: LinuxRaid
>> Subject: Re: help with bad performing raid6
>>
>> Jon Nelson wrote:
>>     
>>> I have a raid6 which is exposed via LVM (and parts of which are, in
>>> turn, exposed via NFS) and I'm having some really bad performance
>>> issues, primarily with large files. I'm not sure where the blame
>>>       
>> lies.
>>     
>>> When performance is bad "load" on the server is insanely high even
>>> though it's not doing anything except for the raid6 (it's otherwise
>>> quiescent) and NFS (to typically just one client).
>>>
>>> This is a home machine, but it has an AMD Athlon X2 3600+ and 4 fast
>>>       
>> SATA disks.
>>     
>>> When I say "bad performance" I mean writes that vary down to 100KB/s
>>> or less, as reported by rsync. The "average" end-to-end speed for
>>> writing large (500MB to 5GB) files hovers around 3-4MB/s. This is
>>>       
>> over
>>     
>>> 100 MBit.
>>>
>>> Often times while stracing rsync I will see rsync not make a single
>>> system call for sometimes more than a minute. Sometimes well in
>>>       
>> excess
>>     
>>> of that. If I look at the load on the server the top process is
>>> md0_raid5 (the raid6 process for md0, despite the raid5 in the name).
>>> The load hovers around 8 or 9 at this time.
>>>
>>>
>>>       
>> I really suspect disk errors, I assume nothing in /var/log/messages?
>>
>>     
>>> Even during this period of high load, actual disk I/O is fairly low.
>>> I can get 70-80MB/s out of the actual underlying disks the entire
>>>       
>> time.
>>     
>>> Uncached.
>>>
>>> vmstat reports up to 20MB/s writes (this is expected given 100Mbit
>>>       
>> and
>>     
>>> raid6) but most of the time it hovers between 2 and 6 MB/s.
>>>
>>>       
>> Perhaps iostat looking at the underlying drives would tell you
>> something. You might also run iostat with a test write load to see if
>> something is unusual:
>>   dd if=/dev/zero bs=1024k count=1024k of=BigJunk.File conv=fdatasync
>> and just see if iostat or vmstat or /var/log/messages tells you
>> something. Of course if it runs like a bat out hell, it tells you the
>> problem is elsewhere.
>>
>> Other possible causes are a poor chunk size, bad alignment of the whole
>> filesystem, and many other things too ugly to name. The fact that you
>> use LVM make alignment issue more likely (in the sense of "one more
>> level which could mess up"). Checked the error count on the array?
>>     
>
> Keep in mind it may also be CPU/memory throughput as a bottleneck...
>
> I have been debugging an issue with my 5 SATA disk RAID5 system running on a
> P4 3Ghz CPU. It's an older style machine with DDR400 RAM and a socket 472(?)
> age CPU. Many, many tests were done on this setup
>
> For example, read speeds of a single drive, I get:
> # dd if=/dev/sdc of=/dev/null bs=1M count=1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 15.3425 seconds, 68.3 MB/s
>
> Then when reading from the RAID5, I get:
> # dd if=/dev/md0 of=/dev/null bs=1M count=1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 14.2457 seconds, 73.6 MB/s
>
> Not a huge increase, but this is where things become interesting. Write
> speeds are a complete new thing - as raw writes to the individual drive can
> top 50MB/sec. When put together in a RAID5, I was maxing out at 30MB/sec. As
> soon as the hosts RAM buffers filled up, things got ugly. Upgrading the CPU
> to a 3.2Ghz CPU gave me a slight performance increase to between 35-40MB/sec
> writes.
>
> I tried many, many combinations of drives to controllers, kernel versions,
> chunk sizes, filesystems and more - yet I couldn't get things any faster.
>   

I have done some ad-hoc tests related to using the stride-size and 
stripe-width features of ext2. I'm not ready to give guidance on this 
yet, but I have seen some significant improvement (and degradation) 
using these. If you use ext3 you will probably get a boost in 
performance from putting the journal on an external fast device (SSD 
comes to mind).

If you feel like characterizing this it's a place to start. I was not at 
all strict in my testing, I just wanted to see if those features made a 
difference, and they seem to, 2-5x change in performance. What I didn't 
do is investigate what values work best, record numbers, etc, etc. I 
tested ext4 not at all.

Good luck.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


