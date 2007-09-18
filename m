From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mke2fs stuck in D state while creating filesystem on md*
Date: Tue, 18 Sep 2007 13:54:54 -0400
Message-ID: <46F010EE.3000202@tmr.com>
References: <op.txtvfnrh88izfi@barton2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.txtvfnrh88izfi@barton2>
Sender: linux-raid-owner@vger.kernel.org
To: Wiesner Thomas <thomas@bau-konform.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wiesner Thomas wrote:
> Before running Linux software raid on a production system, I'm trying 
> to get the hang of it and use
> 4 loopback devices on which I play with RAID5.
>
> I've:
>     * mdadm - v2.6.3 - 20th August 2007
>     * mke2fs 1.37 (21-Mar-2005) Using EXT2FS Library version 1.37
>     * Linux hazard 2.6.22.5 #2 PREEMPT Wed Aug 29 13:06:26 CEST 2007 
> i686 GNU/Linux
>
> The HDD can transfer appriximately 40MB/s and the loopback files are 
> only 200 to 350MB.
>
> Well when I create a MD with
>     mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 
> /dev/loop0 /dev/loop1 /dev/loop2
> and try to create the filesystem on it with
>     mke2fs /dev/md0
> mke2fs gets stuck in D state. Not always but sometimes. It hangs there 
> for different amounts of time, at least a
> Minute or two. (Far longer than the filesystem creation process itself 
> takes.) Afterwards, the process continues and finishes.
> Sometimes it hangs at 6/65 blocks, sometimes earlier, sometimes later, 
> but always quite early.
>
> The interesting line of a "ps ax" looks like:
>     1609 tty2     D+     0:00 mke2fs -j /dev/md0
>
> It doesn't seem to be a real showstopper, but I think it's not a 
> normal behaviour.
> While stuck, I don't see any CPU or disk activity. Trying to kill the 
> mke2fs seems to lead to
> a completely stuck mke2fs (doesn't get out of D state) but I don't 
> know that for sure, because I did
> that only once and didn't wait very long before I rebooted.
>
> The base System is a 3.1 (Sarge) with a plain Vanilla 2.6.22.5 kernel 
> and latest mdadm.
>
> If you need additional info or I should try something, I'm willing to 
> do that, because I've some time ATM.

Has there been any progress on this? I think I saw it, or something 
similar, during some testing of recent 2.6.23-rc kernels, on mke2fs took 
about 11 min longer than all the others (~2 min) and it was not 
repeatable. I worry that process of more interest will have the same hang.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

