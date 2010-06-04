From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: how to decrease raid5 write penalty in my case?
Date: Fri, 4 Jun 2010 06:47:50 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006040645230.8623@uplift.swm.pp.se>
References: <AANLkTin2zcAMc_grkvJ3rwz4BVtPt2Y0RE9mFyFyX6aW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin2zcAMc_grkvJ3rwz4BVtPt2Y0RE9mFyFyX6aW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 4 Jun 2010, hank peng wrote:

> I created a raid5 array which consists of 4 SATA disks, then I make a
> XFS on it. Now, I pre-allocate a file using posix_fallocate, its size
> is 512MB. So I think the file space allocated by file system is
> sequential. After that , I am filling data into this file from the
> start position, for example, every time I write 64KB data, but there
> are 1 seconds interval between two writes.
>
> As for RAID5 layer in kernel, due to the 1s interval between writes,
> extra read operation(write penalty) maybe caused although the
> following writes is sequential in this file's space.
> So, in my case, is there some parameters to adjust in order to
> decrease this kind of write penalty? Can we tell raid5 layer to delay
> the read operation for that stripe parity computation because we know
> that the following writes start at the previous writes's end point?

Please verify that the reads are actually taking place for instance by 
using "iostat -x 5". I'd imagine the first write will cause reads, but 
after that the whole stripe is going to be in the block cache and thus you 
avoid any other reads for that stripe (you'll of course still have to do 
the writes to disk).

Also, why do you worry about the read operations, unless this is combined 
with a lot of other IO, I don't see how your above usage pattern would 
cause any problems?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
