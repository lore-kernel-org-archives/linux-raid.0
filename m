From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Thu, 4 Oct 2007 10:09:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <20071003211910.439ded54@alpha.digital-domain.net>
 <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
 <20071004150831.6edbf926@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071004150831.6edbf926@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is NCQ enabled on the drives?

On Thu, 4 Oct 2007, Andrew Clayton wrote:

> On Wed, 3 Oct 2007 13:36:39 -0700, David Rees wrote:
>
>> Not bad, but not that good, either. Try running xfs_fsr into a nightly
>> cronjob. By default, it will defrag mounted xfs filesystems for up to
>> 2 hours. Typically this is enough to keep fragmentation well below 1%.
>
> I ran it last night on the raid array, it got the fragmentation down
> to 1.07%. Unfortunately that doesn't seemed to have helped.
>
>> -Dave
>
> Cheers,
>
> Andrew
>
