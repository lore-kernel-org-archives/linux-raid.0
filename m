From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: What does this mean?
Date: Wed, 05 Mar 2003 01:37:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E659B32.A8268302@SteelEye.com>
References: <05ac01c2e2d3$72280f40$1400020a@mike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Michael Paul <radius.mp@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Paul wrote:
> 
>     Hi there...
> 
>  I get the following message when cat'ing /proc/mdstat:
> 
> md0 : active linear [dev 08:30] [8]  [dev 08:20] [7] 

                           ^^^^^            ^^^^^

Well, you're in luck, because these numbers are the major and minors for
sdc and sdd:

$ ls -l /dev/sdd
brw-rw----    1 root     disk       8,  48 May  5  1998 /dev/sdd
$ ls -l /dev/sdc
brw-rw----    1 root     disk       8,  32 May  5  1998 /dev/sdc

(hex 20 and 30 => decimal 32 and 48)

I'm not sure why md sometimes puts the major:minor instead of the device
name. Perhaps has something to do with the driver for your sdc and sdd?
I'm guessing here...

--
Paul




 hdj[6]  hdi[5]  hdh[4]
> hdg[3]  hde[2]  hdc[1]  hdb[0]
> 182485184 blocks 4k rounding
> 
>  In my raidtab file, sdc = 7 and sdd = 8. Is there some type of error here?
> The linear seems to be working properly, but since I'm such a newbie, I
> can't tell for sure. I wish there was a better way to check on the raid
> status.
> 
> Thanks,
> Michael
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
