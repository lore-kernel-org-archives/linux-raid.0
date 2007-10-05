From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 09:18:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710050918440.8433@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <20071003211910.439ded54@alpha.digital-domain.net>
 <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
 <20071004150831.6edbf926@zeus.pccl.info> <Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
 <Pine.LNX.4.64.0710041009530.8275@p34.internal.lan> <20071004154441.31addcfe@zeus.pccl.info>
 <Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>
 <20071004192653.25eb333b@alpha.digital-domain.net>
 <Pine.LNX.4.64.0710050621350.8433@p34.internal.lan> <20071005115719.4a71ab89@zeus.pccl.info>
 <Pine.LNX.4.64.0710050707490.8433@p34.internal.lan> <20071005135312.04856211@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071005135312.04856211@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Oct 2007, Andrew Clayton wrote:

> On Fri, 5 Oct 2007 07:08:51 -0400 (EDT), Justin Piszcz wrote:
>
>> The mount options are from when the filesystem was made for
>> sunit/swidth I believe.
>>
>>         -N     Causes the file system parameters  to  be  printed
>> out  without really creating the file system.
>>
>> You should be able to run mkfs.xfs -N /dev/md0 to get that
>> information.
>
> Can't do it while it's mounted. would xfs_info show the same stuff?
>
>> /dev/md3        /r1             xfs
>> noatime,nodiratime,logbufs=8,logbsize=262144 0 1
>>
>> Try using the following options and the AS scheduler and let me know
>> if you still notice any 'hangs'
>
> OK, I've remounted (mount -o remount) with those options.
> I've set the strip_cache_size to 8192
> I've set the nr_requests back to 128
> I've set the schedulers to anticipatory.
>
> Unfortunately problem remains.
>
> I'll try the noop scheduler as I don't think I ever tried that one.
>
>> Justin.
>
> Andrew
>

How are you measuring the problem?  How can it be reproduced?

Justin.
