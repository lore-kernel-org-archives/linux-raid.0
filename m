From: Bill Cizek <cizek@rcn.com>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Wed, 14 Jun 2006 10:46:09 -0500
Message-ID: <44902F41.8030300@rcn.com>
References: <20060614085354.GA18106@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060614085354.GA18106@rigacci.org>
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Niccolo Rigacci wrote:

>Hi to all,
>
>I have a new IBM xSeries 206m with two SATA drives, I installed a 
>Debian Testing (Etch) and configured a software RAID as shown:
>
>Personalities : [raid1]
>md1 : active raid1 sdb5[1] sda5[0]
>      1951744 blocks [2/2] [UU]
>
>md2 : active raid1 sdb6[1] sda6[0]
>      2931712 blocks [2/2] [UU]
>
>md3 : active raid1 sdb7[1] sda7[0]
>      39061952 blocks [2/2] [UU]
>
>md0 : active raid1 sdb1[1] sda1[0]
>      5855552 blocks [2/2] [UU]
>
>I experience this problem: whenever a volume is reconstructing 
>(syncing), the system stops responding. The machine is alive, 
>because it responds to the ping, the console is responsive but I 
>cannot pass the login prompt. It seems that every disk activity 
>is delayed and blocking.
>
>When the sync is complete, the machine start to respond again 
>perfectly.
>
>Any hints on how to start debugging?
>  
>

I ran into a similar problem using kernel 2.6.16.14 on an ASUS 
motherboard:  When I
mirrored two SATA drives it seemed to block all other disk I/O until the 
sync was complete.

My symptoms were the same:  all consoles were non-responsive and when I 
tried to login
it just sat there until the sync was complete.

I was able to work around this by lowering 
/proc/sys/dev/raid/speed_limit_max to a value
below my disk thruput value (~ 50 MB/s) as follows:

$ echo 45000 > /proc/sys/dev/raid/speed_limit_max

That kept my system usable but didn't address the underlying problem of 
the raid
resync not being appropriately throttled.  I ended up configuring my 
system differently
so this became a moot point for me.

Hope this helps,
Bill




