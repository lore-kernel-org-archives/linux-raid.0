From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Idea for new RAID type - background extended recovery
 information
Date: Wed, 9 Dec 2009 11:53:18 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912091143350.23464@uplift.swm.pp.se>
References: <4877c76c0912090106i684924edn7915c6609ab574f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912090106i684924edn7915c6609ab574f5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 9 Dec 2009, Michael Evans wrote:

> keeps a checksum for every storage segment.  However that conflicts
> with the 'zero it before creation and assume-clean works' idea.  It
> also very likely has extremely poor write performance.

Generally, my experience has been that total disk failures are fairly 
rare, instead with the much larger disks today, I get single block/sector 
failures, meaning 512 bytes (or 4 k, I don't remember) can't be read. Is 
there any data to support this?

Would it make sense to add 4k to every 64k of raid chunk (non-raid1) for 
some kind of "parity" information. Since I guess all writes involves 
re-writing the whole chunk, adding 4k here shouldn't make the write 
performance be worse?

The problem I'm trying to address is the raid5 "disk failure and then 
random single block/sector error on the rest of the drives".

For arrays with few drives this would be much more efficient than going to 
raid6...?

An 8 disk raid6 with 1TB you get 6 TB of usable data, for an 8 disk raid5p 
(p for parity, I just made that up), it would be 7*64/68=6.59 TB.

For 6 disk raid6 = 4TB and raid5p makes this 5*64/68=4.71TB.

For 4 disk raid5 = 2TB and raid5p makes this 3*64=68=2.82TB.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
