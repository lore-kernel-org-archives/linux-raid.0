From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Fri, 30 Dec 2011 05:52:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1112300549430.808@uplift.swm.pp.se>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com> <4EFD1B42.3040009@gmail.com> <CALFpzo7bo_DijDNRKJzPP+ecvcZkeFOwHp52TqmXi4zkszrbJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo7bo_DijDNRKJzPP+ecvcZkeFOwHp52TqmXi4zkszrbJg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: Zdenek Kaspar <zkaspar82@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 29 Dec 2011, Marcus Sorensen wrote:

> My only suggestion would be to experiment with various partitioning,

Poster already said they're not partitioned.

> On Thu, Dec 29, 2011 at 7:00 PM, Zdenek Kaspar <zkaspar82@gmail.com> wrote:
>> Dne 30.12.2011 0:28, Michele Codutti napsal(a):
>>> The drives are not partitioned. I'm using the default chunk size (512K) and the default metadata superblock version (1.2).

My recommendation would be to look into the stripe-cache settings and 
check iostat -x 5 output. What is most likely happening is that when 
writing to the raid5, it's reading some (to calculate parity most likely) 
and not just writing. iostat will confirm if this is indeed the case.

Also, using raid5 for 2TB drives or larger is not recommended, use RAID6 
<http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162>.
