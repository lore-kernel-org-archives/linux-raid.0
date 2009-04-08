From: Iustin Pop <iusty@k1024.org>
Subject: Re: Can't resolve mismatch_count > 0 for a raid 1 array
Date: Thu, 9 Apr 2009 00:00:42 +0200
Message-ID: <20090408220042.GA30278@teal.hq.k1024.org>
References: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz> <49DD1C36.1000306@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49DD1C36.1000306@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Steven Ellis <steven@openmedia.co.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 08, 2009 at 05:50:46PM -0400, Bill Davidsen wrote:
> Steven Ellis wrote:
>> I've resolved most of my raid issues by re-housing the affected system  
>> and replacing the motherboard, but across the 3 boards I've tried I  
>> always have an issue with my /dev/md1 array producing mismatch_count  
>> of 128 or 256.
>>
>> System is running Centos 5.2 with a Xen Dom0 kernel
>>
>> This md1 volume is a pair of 40GB HDs raid1 on an IDE controller which  
>> I them have a bunch of LVM's that are my Xen guests.
>>
>> Is there any chance that these mismatch_count values are due to swap  
>> partitions for the Xen guests?
>
> That's the cause, and since md code doesn't currently have a clue which  
> copy is "right" it's always a problem if you do something like suspend  
> to disk. You probably don't do that with xen images, but swap and raid1  
> almost always have a mismatch.

But only because (for non-xen guests) the raid1 code and the swap code /
data live in the same address space, and could be changed in between the
two writes.

I would be surprised if this happens for xen guests, where the address
space is not shared; once the xen guest initiates a write, dom0 gets the
data and writes it from its internal buffer, not the domU's one which
could be modified.

At least, that's how I think things happen.

regards,
iustin
