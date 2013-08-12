From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Mon, 12 Aug 2013 14:25:24 -0500
Message-ID: <520936A4.8070806@hardwarefreak.com>
References: <loom.20130725T120703-146@post.gmane.org> <alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se> <loom.20130727T221553-552@post.gmane.org> <CALFpzo71sjK6Cd=jZ_iQG8rRk5TatGsJ5FznD75ayTm1A5kH-g@mail.gmail.com> <51F4B034.3040801@hardwarefreak.com> <loom.20130812T104037-602@post.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130812T104037-602@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wes <wt75@gazeta.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/12/2013 3:43 AM, Wes wrote:
> Stan Hoeppner <stan <at> hardwarefreak.com> writes:
> 
> 
>> ~$ cat /sys/block/sda/queue/scheduler
>> [CFQ] noop deadline
>> Wes, yours will show CFQ probably as the default on RHEL/CentOS.  You'll
>> want deadline for best seek and all around performance.  So:
>> ~$ echo deadline > /sys/block/sda/queue/scheduler
>> Add that to an init script or cron entry so it sets on every boot.
>> Barriers are not an issue with this test.
>>
> 
> Thank you all. The issue is now closed.
> RHEL5 was not doing cache flush right. It was only corrected in 2.6.32+
> After removing O_SYNC from seekmark the results are now comparable.

Glad you got it figured out.

> Actually it is hard to find a linux raw device random R/W benchmark tool and

FIO is good for raw IO benchmarking.  Can do file based IO as well.
Very flexible, but maybe a bit complicated for first time users.

> seekmark being the most popular fails when comparing pre and post 2.6.32
> systems (unless you remove O_SYNC).

Dunno about seekmark being the most popular.  I'd never heard of it
until this thread.  I'd have guessed FIO was most popular.  But then
again I don't get out much. ;)

-- 
Stan

