From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: help with bad performing raid6
Date: Wed, 29 Jul 2009 11:08:33 -0400
Message-ID: <4A7065F1.3060203@tmr.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-suse@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> I have a raid6 which is exposed via LVM (and parts of which are, in
> turn, exposed via NFS) and I'm having some really bad performance
> issues, primarily with large files. I'm not sure where the blame lies.
> When performance is bad "load" on the server is insanely high even
> though it's not doing anything except for the raid6 (it's otherwise
> quiescent) and NFS (to typically just one client).
>
> This is a home machine, but it has an AMD Athlon X2 3600+ and 4 fast SATA disks.
>
> When I say "bad performance" I mean writes that vary down to 100KB/s
> or less, as reported by rsync. The "average" end-to-end speed for
> writing large (500MB to 5GB) files hovers around 3-4MB/s. This is over
> 100 MBit.
>
> Often times while stracing rsync I will see rsync not make a single
> system call for sometimes more than a minute. Sometimes well in excess
> of that. If I look at the load on the server the top process is
> md0_raid5 (the raid6 process for md0, despite the raid5 in the name).
> The load hovers around 8 or 9 at this time.
>
>   
I really suspect disk errors, I assume nothing in /var/log/messages?

> Even during this period of high load, actual disk I/O is fairly low.
> I can get 70-80MB/s out of the actual underlying disks the entire time.
> Uncached.
>
> vmstat reports up to 20MB/s writes (this is expected given 100Mbit and
> raid6) but most of the time it hovers between 2 and 6 MB/s.
>   

Perhaps iostat looking at the underlying drives would tell you 
something. You might also run iostat with a test write load to see if 
something is unusual:
  dd if=/dev/zero bs=1024k count=1024k of=BigJunk.File conv=fdatasync
and just see if iostat or vmstat or /var/log/messages tells you 
something. Of course if it runs like a bat out hell, it tells you the 
problem is elsewhere.

Other possible causes are a poor chunk size, bad alignment of the whole 
filesystem, and many other things too ugly to name. The fact that you 
use LVM make alignment issue more likely (in the sense of "one more 
level which could mess up"). Checked the error count on the array?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


