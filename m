From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 12:58:39 +0200
Message-ID: <5ed0b31a-4f46-5a23-a3a4-35e4190bcfad@thelounge.net>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 14.07.2017 um 12:46 schrieb Gionatan Danti:
> Il 14-07-2017 02:32 Reindl Harald ha scritto:
>> because you won't be that happy when the kernel spits out a disk each
>> time a random SATA command times out - the 4 RAID10 disks on my
>> workstation are from 2011 and showed them too several times in the
>> past while they are just fine
>>
>> here you go:
>> http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/ 
>>
> 
> Hi, so a premature/preventive drive detachment is not a silver bullet, 
> and I buy it. However, I would at least expect this behavior to be 
> configurable. Maybe it is, and I am missing something?

dunno, maybe it is, but it wouldn't be wise because in case of a RAID5 
rebuilding after a disk-failure would become even more dangerous on a 
large array as it is already

> Anyway, what really surprise me is *not* the drive to not be detached, 
> rather permitting that corruption make its way into real data. I naively 
> expect that when a WRITE_QUEUED or CACHE_FLUSH command aborts/fails 
> (which *will* cause data corruption if not properly handled) the I/O 
> layer has the following possibilities:

given that i have seen at least SD-cards confirming over hours sucessful 
writes with no single error in the syslog maybe it was one of the rare 
cases where the hardware lied and if that is the case you have nearly no 
chance on the software layer except verify each write with a uncached 
read of the block which would have a unacceptable impact on performance
