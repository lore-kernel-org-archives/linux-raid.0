From: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Thu, 30 Jun 2011 16:05:51 +0200
Message-ID: <4E0C82BF.6050206@gmx.de>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org> <4E0C7196.1070307@gmx.de> <4E0C7B4B.7090404@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C7B4B.7090404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil
>
> So the first layout is the one you wanted.  Each drive is ~4GB ?  Or is this just a test setup?
It's not a test setup. Historical reasons. I started whith Linux around 1995 and
use software raid a long time. So I have this 4GB partition a long time and when
I decide to upgrade storage or a hd says goodby, I use a new 4GB partition...
Later I put more raid-arrays under a lvm, so I have no trouble with space on a
single partition.
>> Are there any experiences in which percentage the performance penalty is to expect?
>
> I don't have percentages to share, no.  They would vary a lot based on number of disks
> and type of CPU.  As an estimate though, you can expect raid6 to be about as fast as
> raid5 when reading from a non-degraded array.  Certain read workloads could even be faster,
> as the data is spread over more spindles.  It will be slower to write in all cases.
> The extra "Q" parity for raid6 is quite complex to calculate.  In a single disk failure situation,
> both raid5 and raid6 will use the "P" parity to reconstruct the missing information, so
> their single-degraded read performance will be comparable.  With two disk failures,
> raid6 performance plummets, as every read requires a complete inverse "Q" solution.
> Of course, two disk failures in raid5 stops your system.  So running at a crawl, with data intact, is better than no data.
That's the reason to think about a spare disc
> You should also consider the odds of failure during rebuild, which is a serious concern for large raid5 arrays.
> This was discussed recently on this list:
>
> http://marc.info/?l=linux-raid&m=130754284831666&w=2

> If your CPU has free cycles, I suggest you run raid6 instead of raid5+spare.
>
> Phil
>
I think there are free cycles, so I should try it.
Thanks
        Karsten

