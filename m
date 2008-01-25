From: Clemens Koller <clemens.koller@anagramm.de>
Subject: Re: Error mounting a reiserfs on renamed raid1
Date: Fri, 25 Jan 2008 20:56:50 +0100
Message-ID: <479A3F02.3010403@anagramm.de>
References: <479931E0.3020909@anagramm.de> <20080125085741.GA581@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080125085741.GA581@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill schrieb:
> On Fri Jan 25, 2008 at 01:48:32AM +0100, Clemens Koller wrote:
> 
>> Hi there.
>>
>> I am new to this list, however didn't find this effect nor a
>> solution to my problem in the archives or with google:
>>
>> short story:
>> ------------
>> A single raid1 as /dev/md0 containing a reiserfs (with important data)
>> assembled during boot works just fine:
>> $ cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1]
>> md0 : active raid1 hdg1[1] hde1[0]
>>       293049600 blocks [2/2] [UU]
>>
>> The same raid1 moved to another machine as a fourth raid can be
>> assembled manually as /dev/md3 (to work around naming conflicts),
>> but it cannot be mounted anymore:
>> $ mdadm --assemble /dev/md3 --update=super-minor -m0 /dev/hde /dev/hdg
>> does not complain. /dev/md3 is created. But
>>
> It looks like you should be assembling the partitions, not the disks.
> Certainly the mdstat entry above shows the array being formed from the
> disks.  Try:
>   mdadm --assemble /dev/md3 --update=super-minor -m0 /dev/hde1 /dev/hdg1

Argh, that was too simple. I thought I've tried to assemble the
partitions (/dev/hdx1) too instead of the whole disks but I guess
I was wrong.

A simple
mdadm --assemble /dev/md3 /dev/hde1 /dev/hdg1
did the job

Thank you!

Regards,

Clemens

