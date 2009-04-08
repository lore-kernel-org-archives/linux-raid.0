From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Can't resolve mismatch_count > 0 for a raid 1 array
Date: Wed, 08 Apr 2009 17:50:46 -0400
Message-ID: <49DD1C36.1000306@tmr.com>
References: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Ellis <steven@openmedia.co.nz>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steven Ellis wrote:
> I've resolved most of my raid issues by re-housing the affected system 
> and replacing the motherboard, but across the 3 boards I've tried I 
> always have an issue with my /dev/md1 array producing mismatch_count 
> of 128 or 256.
>
> System is running Centos 5.2 with a Xen Dom0 kernel
>
> This md1 volume is a pair of 40GB HDs raid1 on an IDE controller which 
> I them have a bunch of LVM's that are my Xen guests.
>
> Is there any chance that these mismatch_count values are due to swap 
> partitions for the Xen guests?

That's the cause, and since md code doesn't currently have a clue which 
copy is "right" it's always a problem if you do something like suspend 
to disk. You probably don't do that with xen images, but swap and raid1 
almost always have a mismatch.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


