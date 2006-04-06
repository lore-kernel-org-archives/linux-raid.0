From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: Partitioning md devices versus partitioining underlying devices
Date: Thu, 6 Apr 2006 13:20:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0604061311420.10280-100000@firewall2.tmr.com>
References: <443532DA.7090809@aol.com>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <443532DA.7090809@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 Apr 2006, andy liebman wrote:

> Hi,
> 
> I have a fundamental question about WHERE it is best to do partititioning.
> 
> Here's a concrete example. I have two 3ware RAID-5 arrays, each made up 
> of 12 500 GB drives. When presented to Linux, these are /dev/sda and 
> /dev/sdb -- each 5.5 TB in size.
> 
> I want to stripe the two arrays together, so that 24 drives are all 
> operating as one unit. However, I don't want an 11 TB filesystem. I want 
> to keep my filesystems down below 6 TB.
> 
> It seems I have two choices:
> 
> 1)  partition the 3ware devices to make /dev/sda1, /dev/sda2, /dev/sdb1 
> and /dev/sdb2.  Then I can create TWO md RAID-0 devices -- /dev/sda1 + 
> /dev/sdb1 = /dev/md1, /dev/sda2 + /dev/sdb2 = /dev/md2
> 
> OR
> 
> 2) create /dev/md1 from the entire 3ware devices -- /dev/sda + /dev/sdb 
> = /dev/md1 -- and then partition /dev/md1 into two devices.
> 
> The question is, are these essentially equivalent alternatives? Is there 
> any theoretical reason why one choice would be better than the other -- 
> in terms of security, performance, memory usage, etc.
> 
> A knowledgeable answer would be appreciated. Thanks in advance.

There is one advantage to partitioning sda and sdb and then building 
devices using the partitions... you can use different stripe sizes on each 
md drive built on the partition. *IF* you have different things going on 
in the filesystems, you may be able to improve performance and spread head 
motion by using tuned stripe sizes.

I did this for an application which had and index of 128 bytes index 
records to a bunch of 500-1000k data records. I used a small stripe size 
on the index and large on the data, and was able to reduce time from 
request to data delivery by more than 20%. I was doing RAID-0 over six 
SCSI drives.

Assuming that you do the same thing on both filesystems, I see no benefit 
to one way over the other, I was just answering your question as to a 
possible benefit. Use of LVM or dm to do the same thing might allow you to 
change f/s sizes and such after the fact, I have only tried that as a 
learning exercise, so I can't say how well it works in practice, or which 
is better for you.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

