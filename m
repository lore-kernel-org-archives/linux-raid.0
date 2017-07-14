From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 03:10:19 +0200
Message-ID: <49bbf267-54b8-31e9-b5b7-fb03c2c2b727@thelounge.net>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <76d8e93f-a9cc-5df4-e086-5d2884a589d0@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <76d8e93f-a9cc-5df4-e086-5d2884a589d0@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Gionatan Danti <g.danti@assyoma.it>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 14.07.2017 um 02:52 schrieb Anthony Youngman:
> On 14/07/17 01:32, Reindl Harald wrote:
>>
>>
>> Am 14.07.2017 um 00:34 schrieb Gionatan Danti:
>>> Il 13-07-2017 23:34 Reindl Harald ha scritto:
>>>> maybe because the disk is, well, not in a good shape and don't know
>>>> that by itself
>>>
>>> But the kernel *does* know that, as the dmesg entries clearly show. 
>>> Basically, some SATA commands timed-out and/or were aborted. As the 
>>> kernel reported these erros in dmesg, why do not use these 
>>> information to stop a failing disk?
>>
>> because you won't be that happy when the kernel spits out a disk each 
>> time a random SATA command times out - the 4 RAID10 disks on my 
>> workstation are from 2011 and showed them too several times in the 
>> past while they are just fine
>>
> Except, in the context of this thread, the alternative is CORRUPTED 
> DATA. I certainly know which one I would prefer, and that is a crashed 
> array!
> 
> If a *write* fails, then a failed array may well be the least of the 
> user's problems - and silent failure merely makes matters worse!

i doubt that you would repeat that if for whatever load condition a 
random SATA timeout occours on both disks of a mirror and you lose some 
TB of data while in *that case* not silent corruption or anything else 
bad would have happened except a short lag

did you really read 
http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/ 
or just ignored it on purpose?

> I know, the problem is that linux isn't actually that good at 
> propagating errors back to user space, and I believe that's a fault of 
> POSIX. So fixing the problem might be a massive job - indeed I think it is.
> 
> But that's no excuse for mocking someone just because they want to be 
> told that the system has just gone and lost their work for them ...

nobody is mocking someone, i just explained why things are not as simple 
as they appear and with a 2 disk mirror they are always complicated in 
any error case by lack of quorum

> Oh - and isn't that what raid is *supposed* to do? Kick a disk on a 
> write failure?

if things only would be that easy in the real world...

in doubt with a mirrored RAID without data checksums *you have no way* 
to guarantee what is the correct data if something flips and "Except, in 
the context of this thread" is nice but won't help in general and trying 
to handle each and every bordercase with some workarounds would lead nowhere

yes, agreed, silent corruption is bad, hardware lying about data written 
is bad, but if things would be that easy all that won't happen and 
nobody would have spent time for develop checksummed filesystems


