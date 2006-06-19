From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid5 reshape
Date: Mon, 19 Jun 2006 16:29:53 -0700
Message-ID: <44973371.6060701@h3c.com>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net>	<17555.13409.834439.80361@cse.unsw.edu.au>	<44945643.3070300@nigelterry.net>	<17556.31295.280083.533342@cse.unsw.edu.au>	<44947BCA.9040305@nigelterry.net>	<44947C98.6060809@nigelterry.net>	<17556.32630.611922.294047@cse.unsw.edu.au>	<44948002.3050706@nigelterry.net>	<44954DB7.2000305@nigelterry.net>	<17558.1521.522659.91428@cse.unsw.edu.au>	<44971A51.6050008@nigelterry.net> <17559.10564.840472.525999@cse.unsw.edu.au> <44972AF1.8040500@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44972AF1.8040500@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Nigel J. Terry wrote:

> One comment - As I look at the rebuild, which is now over 20%, the time
> till finish makes no sense. It did make sense when the first reshape
> started. I guess your estimating / averaging algorithm doesn't work for
> a restarted reshape. A minor cosmetic issue - see below
> 
> Nigel
> [nterry@homepc ~]$ cat /proc/mdstat
> Personalities : [raid5] [raid4]
> md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
>      490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3]
> [UUU_]
>      [====>................]  reshape = 22.7% (55742816/245111552)
> finish=5.8min speed=542211K/sec


Unless something has changed recently the parity-rebuild-interrupted /
restarted-parity-rebuild case shows the same behavior.

It's probably the same chunk of code (I haven't looked, bad hacker!
bad!), but I thought I'd mention it in case Neil goes looking

The "speed" is truly impressive though. I'll almost be sorry to see it
fixed :-)

-Mike
