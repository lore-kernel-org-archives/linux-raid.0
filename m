From: Leon Woestenberg <leonw@mailcan.com>
Subject: Re: Raid-5 rebuild
Date: Fri, 24 Dec 2004 17:39:40 +0100
Message-ID: <41CC464C.3020309@mailcan.com>
References: <41CC1794.7050607@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41CC1794.7050607@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Brad,

Brad Campbell wrote:

> G'day all,
>
> I'm using a 2.6.10-rc1 (ish.. some BK just after that) kernel and I 
> have a 10 drive raid-5 /dev/md0.
> I noticed SMART telling me I have some pending reallocations on 
> /dev/sdj, so I decided to force the matter with a
> mdadm --fail /dev/md0 /dev/sdj1
> mdadm --remove /dev/md0 /dev/sdj1
> mdadm --add /dev/md0 /dev/sdj1
>
> Fine.. all going well, but I noticed using iostat that instead of 
> doing read-compare cycles, the kernel is rebuilding the drive regardless.
>
> I thought (and I may be wrong) that adding a drive to a raid-5 
> triggered the kernel to read each stripe, and only write out new 
> parity info if the stripe contents are wrong. 


Nope, standard software RAID in the Linux kernel is dumb regarding 
rebuilding. It has the "benefit" of touching every 'pending' or 'offline 
uncorrectable' blocks
on the platters of the resyncing drive, for the cost of being 
non-redundant for a large amount of (rebuild)time.

There is the "FastRAID5" project on Sourceforge which does partial 
resyncs. However, you will lose the soft-read/bad block re-allocations.  
See "fr5" on
Sourceforge.

Ideally, we would have SMART detect 'pending' or 'offline-uncorrectable' 
block LBAs, calculate the resulting block number on the disk partition,
calculate the resulting md block number, and mark it dirty in some to be 
written "fr5" user-tool.

However, I have asked on this list about calculating block numbers from 
md to partition to LBA and vice versa, but this seems deeply hidden in the
different RAID algorithms... On the other hand, I haven't looked real hard.

Regards,

Leon.
