From: Henrik Holst <holst@matmech.com>
Subject: Re: raid1 does not seem faster
Date: Sun, 01 Apr 2007 14:27:57 +0200
Message-ID: <1175430477.24477.2.camel@morticia.matmech.com>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2007-04-01 at 14:19 +0200, Jan Engelhardt wrote:
> Hello list,
> 
> 
> normally, I'd think that combining drives into a raid1 array would give 
> me at least a little improvement in read speed. In my setup however, 
> this does not seem to be the case.
> 
> 14:16 opteron:/var/log # hdparm -t /dev/sda
>  Timing buffered disk reads:  170 MB in  3.01 seconds =  56.52 MB/sec
> 14:17 opteron:/var/log # hdparm -t /dev/md3
>  Timing buffered disk reads:  170 MB in  3.01 seconds =  56.45 MB/sec
> (and dd_rescue shows the same numbers)
> 
> The raid array was created using
> # mdadm -C /dev/md3 -b internal -e 1.0 -l 1 -n 2 /dev/sd[ab]3
> 
> 
> Jan

From section 9.5 in [FAQ]

"To check out speed and performance of your RAID systems, do NOT use
hdparm. It won't do real benchmarking of the arrays." <snip>

I might recommend bonnie++. I think I've seen accepted benchmarks here
using bonnie++.

[FAQ] http://tldp.org/HOWTO/html_single/Software-RAID-HOWTO/#s9

-- 
Henrik Holst <holst@matmech.com>
