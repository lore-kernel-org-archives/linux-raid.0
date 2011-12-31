From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Sat, 31 Dec 2011 04:12:19 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1112310410290.808@uplift.swm.pp.se>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com> <4EFD1B42.3040009@gmail.com> <CALFpzo7bo_DijDNRKJzPP+ecvcZkeFOwHp52TqmXi4zkszrbJg@mail.gmail.com> <alpine.DEB.2.00.1112300549430.808@uplift.swm.pp.se>
 <CALFpzo4GynxhdBT7vO4EmjpavkZ7HGqdbeMiYmj9-z4UQgN+7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo4GynxhdBT7vO4EmjpavkZ7HGqdbeMiYmj9-z4UQgN+7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: Zdenek Kaspar <zkaspar82@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 29 Dec 2011, Marcus Sorensen wrote:

>> Poster already said they're not partitioned.
>
> Correct. using partitioning allows you to adjust the alignment, so for
> example if the MD superblock at the front moves the start of the
> exported MD device out of alignment with the base disks, you could
> compensate for it by starting your partition on the correct offset.

Unless he has used the XP jumper, it's impossible to misalign MD if 
running without partitions, afaik.

> If he's writing full stripes he doesn't need to calculate parity by 
> reading. I'm not sure how the MD layer determines this though, unless 
> he's adding a sync or o_direct flag to his test he should be writing 
> full stripes regardless of the blocksize he sets.

I've seen MD do 10% reads in this situation, I believe the handling of 
this is not optimal and sometimes there will be reads. Niel can probably 
tell a lot more about what might be going on.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
