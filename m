From: Mike Hardy <mhardy@h3c.com>
Subject: Re: mdadm source rpm build error + command-line parsing error + resync
 reporting problem
Date: Thu, 08 Dec 2005 21:16:16 -0800
Message-ID: <43991320.5080509@h3c.com>
References: <4399121F.9060906@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4399121F.9060906@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Mike Hardy wrote:

> Finally, and I think was reported once before, but I don't recall a
> resolution for it, I got this once I specified that it grow to maximum size:
> 
> [root@istanbul mdadm-2.1]# cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sdb1[0] sda1[1]
>       98176 blocks [2/2] [UU]
> 
> md1 : active raid1 sdb3[0] sda3[1]
>       70573440 blocks [2/2] [UU]
>       [=========>...........]  resync = 49.9% (35220224/70573440)
> finish=0.2min speed=2515730K/sec
> 
> md0 : active raid1 sdb2[0] sda2[1]
>       977856 blocks [2/2] [UU]
> 
> unused devices: <none>
> 
> This is a dual Xeon (so it looks like a 4-CPU machine). Not sure what's
> causing that though...

Sorry to reply to myself, but I just did the same thing on a different
machine (with an older mdadm) and I also got an..."optimistic" resync
speed reading on it after the grow, when it 'resumed from checkpoint'.

Oddly, these machines reported normal speeds during the resyncs that
occurred when I rotated larger drives into the machines.

Perhaps it has something to do with resumption from checkpoints?

Anyway, I hope all the reports help.

-Mike
