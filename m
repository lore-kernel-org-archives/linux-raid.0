From: keld@keldix.com
Subject: Re: Request for assistance
Date: Wed, 6 Jul 2016 09:39:34 +0200
Message-ID: <20160706073934.GA8404@www5.open-std.org>
References: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What operating system and version are you  running?

Best regards
keld

On Tue, Jul 05, 2016 at 07:13:23PM -0500, o1bigtenor wrote:
> Greetings
> 
> Running a Raid 10 array with 4 - 3 TB drives. Have a UPS but this area
> gets significant lightning and also brownout (rural power) events.
> 
> Found the array was read only this morning. Thought that rebooting the
> system might correct things - - - it did not as the array did not
> load.
> 
> commands used followed by system response
> 
> mdadm --detail /dev/md0
>    mdadm:  md device /dev/md0 does not appear to be active.
> 
> cat /proc/mdstat
>    md0  : inactive sdc1[5](S) sdf1[8](S) sde1[7](S) sdb1[4](S)
> 
> mdadm -E /dev/sdb1
>                        sdc1
>                        sde1
>                        sdf1
> 
> everything is the same except for 2 items
> 
> sde and sdf have uptime listed from July 04 05:50:46
>                           events 64841
>                           array state of AAAA
> 
> sdb and sdc have uptime listed from July 05 01:57:38
>                            events 64844
>                            array state of AAA.
> 
> 
> 
> Do I just re-create the array?
> 
> TIA
> 
> Dee
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
