From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Thu, 4 Oct 2007 12:20:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <20071003211910.439ded54@alpha.digital-domain.net>
 <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
 <20071004150831.6edbf926@zeus.pccl.info> <Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
 <Pine.LNX.4.64.0710041009530.8275@p34.internal.lan> <20071004154441.31addcfe@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071004154441.31addcfe@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 4 Oct 2007, Andrew Clayton wrote:

> On Thu, 4 Oct 2007 10:10:02 -0400 (EDT), Justin Piszcz wrote:
>
>
>> Also, did performance just go to crap one day or was it gradual?
>
> IIRC I just noticed one day that firefox and vim was stalling. That was
> back in February/March I think. At the time the server was running a
> 2.6.18 kernel, since then I've tried a few kernels in between that and
> currently 2.6.23-rc9
>
> Something seems to be periodically causing a lot of activity that
> max's out the stripe_cache for a few seconds (when I was trying
> to look with blktrace, it seemed pdflush was doing a lot of activity
> during this time).
>
> What I had noticed just recently was when I was the only one doing IO
> on the server (no NFS running and I was logged in at the console) even
> just patching the kernel was crawling to a halt.
>
>> Justin.
>
> Cheers,
>
> Andrew
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Besides the NCQ issue your problem is a bit perpelxing..

Just out of curiosity have you run memtest86 for at least one pass to make 
sure there were no problems with the memory?

Do you have a script showing all of the parameters that you use to 
optimize the array?

Also mdadm -D /dev/md0 output please?

What distribution are you running? (not that it should matter, but just 
curious)

Justin.
