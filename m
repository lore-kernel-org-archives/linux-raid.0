From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 01:52:39 +0100
Message-ID: <76d8e93f-a9cc-5df4-e086-5d2884a589d0@youngman.org.uk>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Gionatan Danti <g.danti@assyoma.it>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 14/07/17 01:32, Reindl Harald wrote:
> 
> 
> Am 14.07.2017 um 00:34 schrieb Gionatan Danti:
>> Il 13-07-2017 23:34 Reindl Harald ha scritto:
>>> maybe because the disk is, well, not in a good shape and don't know
>>> that by itself
>>
>> But the kernel *does* know that, as the dmesg entries clearly show. 
>> Basically, some SATA commands timed-out and/or were aborted. As the 
>> kernel reported these erros in dmesg, why do not use these information 
>> to stop a failing disk?
> 
> because you won't be that happy when the kernel spits out a disk each 
> time a random SATA command times out - the 4 RAID10 disks on my 
> workstation are from 2011 and showed them too several times in the past 
> while they are just fine
> 
Except, in the context of this thread, the alternative is CORRUPTED 
DATA. I certainly know which one I would prefer, and that is a crashed 
array!

If a *write* fails, then a failed array may well be the least of the 
user's problems - and silent failure merely makes matters worse!

I know, the problem is that linux isn't actually that good at 
propagating errors back to user space, and I believe that's a fault of 
POSIX. So fixing the problem might be a massive job - indeed I think it is.

But that's no excuse for mocking someone just because they want to be 
told that the system has just gone and lost their work for them ...

Oh - and isn't that what raid is *supposed* to do? Kick a disk on a 
write failure?

Cheers,
Wol
