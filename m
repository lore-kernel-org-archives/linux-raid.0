From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Sun, 18 Jun 2006 07:55:11 +1000
Message-ID: <17556.31295.280083.533342@cse.unsw.edu.au>
References: <449250ED.7090302@irule.net>
	<17554.21119.487820.638171@cse.unsw.edu.au>
	<4492D5B1.60004@nigelterry.net>
	<4492D8D9.7010101@irule.net>
	<17555.12441.42212.93049@cse.unsw.edu.au>
	<4493330E.30501@nigelterry.net>
	<17555.13409.834439.80361@cse.unsw.edu.au>
	<44945643.3070300@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nigel J. Terry on Saturday June 17
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 17, nigel@nigelterry.net wrote:
> 
> Any ideas what I should do next? Thanks
> 

Looks like you've probably hit a bug.  I'll need a bit more info
though.

First:

> [root@homepc ~]# cat /proc/mdstat
> Personalities : [raid5] [raid4]
> md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
>       490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3] 
> [UUU_]
>       [=>...................]  reshape =  6.9% (17073280/245111552) 
> finish=86.3min speed=44003K/sec
> 
> unused devices: <none>

This really makes it look like the reshape is progressing.  How
long after the reboot was this taken?  How long after hdc1 has hot
added (roughly)?  What does it show now?

What happens if you remove hdc1 again?  Does the reshape keep going?

What I would expect to happen in this case is that the array reshapes
into a degraded array, then the missing disk is recovered onto hdc1.

NeilBrown
