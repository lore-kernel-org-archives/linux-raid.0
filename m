From: Neil Brown <neilb@suse.de>
Subject: Re: slow sequential read on partitioned raid6
Date: Wed, 17 Mar 2010 09:22:19 +1100
Message-ID: <20100317092219.35393819@notabene.brown>
References: <4B9FD689.8060700@abcpages.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9FD689.8060700@abcpages.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolae Mihalache <mache@abcpages.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Mar 2010 20:05:45 +0100
Nicolae Mihalache <mache@abcpages.com> wrote:

> Hello,
> 
> I have created a partitioned raid6 array over 6x1TB SATA disks using the
> command (from memory): mdadm --create --auto=mdp --level=6
> --raid-devices /dev/md_d1 /dev/sd[b-g].
> 
> When I run a sequential read test using
> dd if=/dev/md_d1p1 of=/dev/null bs=1M
> I get low read speeds of around 80MB/s but only when the partition is
> mounted.
> 
> If I unmount, the speed is around 350MB/s. The filesystems I tried are
> ext3 and xfs.

Thanks for reporting this.

I just did some testing and I get the reverse!!

When a filesystem is mounted I get 135MB/s.  When it isn't mounted
I get 64MB/s.

I cannot think what could cause this.  I will have to explore.
Can you please double check you results and confirm that it definitely
is  faster then unmounted.


>  
> The partitions have been created with gparted, the partition table being
> of type GPT.
> 
> If I create normal /dev/sdx1 partitions on each disk and then make a
> /dev/md1 raid6 array over them, the read speed is ok.
> 
> I played with different read ahead settings and while they changed the
> read speed, it's only marginally around the values reported above.
> 
> Can somebody explain what is the difference when accessing a raw disk
> when it is mounted or not? Also when playing with those read ahead
> settings it was not clear how/if the read ahead of the individual disks
> are taken into account.

Only the read-ahead value of the array is considered.  The read-ahead settings
of the individual devices in the array are ignored.


NeilBrown

> 
> When setting big values of read ahead, I could see with iostat that tps
> for the individual disks is double when accessing the mounted disk as
> opposed to when accessing it unmounted (despite the speed being three
> times lower).
> It's like when accessing the mounted partition, it reads some other
> parts of the disks. I could not find a way to print the blocks read from
> the individual disks. The sysctl vm.block_dump=1 makes the kernel print
> the block numbers on the md array but not on the components of the array.
> 
> The system is debian 5 with kernel 2.6.26-2-686.
> 
> Thanks for any hint on how to further debug the problem.
> 
> nicolae
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

