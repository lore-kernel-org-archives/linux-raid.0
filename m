From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Docs and operation of RAID10, size limitations on 0.90
Date: Wed, 30 Jul 2008 12:18:06 -0400
Message-ID: <4890943E.5060608@tmr.com>
References: <20080728143553.GE30681@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080728143553.GE30681@nexus.edgeofthenet.org>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Michael wrote:
> Hello list,
>
> I'm building a new system with 8 disks, in two RAID5 arrays of 4 disks
> each, and a RAID1 array across them.  (Then LVM2 on top of the RAID1
> array.)
>
> I approached it this way for two reasons:
>
> 1/ It feels "cleanest"; in the sense that it's not a special case, it's
> just RAID1 with two devices, which happen to be RAID5.
>
> 2/ I have a particular usage in mind: I need to be able to split the
> mirror and remove half; return it later and resync.  Therefore, I want
> to know which disks comprise which halves.
>
> However, I'm rethinking toward RAID10.  However, I can't find much
> documentation about layout, etc.  I believe this was recently discussed
> on the list.
>
>
> Can someone with RAID10 experience enlighten me?  Can it be cleaned
> split, half moved to another host, or rejoined with the first half, etc.
> How about performance?  (Not a huge issue, but it is better than nested
> arrays as I first considered?)
>   

10,f2 read performance is very good, write performance is okay. AFAIK 
you can't do a split, the object is to spread head motion and improve 
performance.
>
> Aside, I'd like it to be bootable.  I was told grub only supports
> booting from 0.90 superblocks, but that 0.90 has a 2TB limitation?
> Meaning, I need /boot with 0.90 and another partition (LVM) with a 1.0
> superblocks?
>   

I usually create a 100MB or so partition, raid1, on my drives and boot 
off that using 0.90 superblock. The rest of the storage can be anything 
you want.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


