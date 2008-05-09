From: michael@estone.ca
Subject: Re: partitioned mirror vs. mirrors of partitions?
Date: Thu, 08 May 2008 23:15:59 -0700
Message-ID: <20080508231559.3ewh3sdao8gs44ks@estone.ca>
References: <4823A238.4080205@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4823A238.4080205@sandeen.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Eric Sandeen <sandeen@sandeen.net>:

> Hi, I hope this isn't a FAQ, I did do a little searching first...
>
> I'm looking at using a couple of large disks to mirror a system which
> currently has a few different filesystems; I'll use partitions on the
> disks to contain the different fileystems.
>
> It looks like I could mirror sda and sdb, and partition the resulting
> md_d0.  Or, I could partition sda and sdb, and create mirrors md0, md1,
> etc from the partitions on the underlying disks.
>
> Is there any technical reason to choose one method vs the other?  It
> seems to me that perhaps on a system with several active partitions from
> the same disk, partitioning a single large raid device might allow
> better read balancing?

As far as I know, there shouldn't be much difference.
However, if one drive dies, it will be easier to re-construct the  
md_d0 array when you add your new disk in. Just one command to repair  
the array, and all filesystems will be good to go, instead of  
repairing md0, and then md1 and so on.
IIRC, the Debian mdadm docs have some more info on this.

Cheers,
Mike
