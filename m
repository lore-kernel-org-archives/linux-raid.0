From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid 5 always degraded!
Date: Sun, 27 Jun 2004 08:58:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16605.65410.732438.763886@cse.unsw.edu.au>
References: <533299FD-C7A4-11D8-BDC2-000A959A30DC@postbox.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Birkinshaw on Saturday June 26
To: Chris Birkinshaw <chris@postbox.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 26, chris@postbox.org.uk wrote:
> 
> 
> Whenever I reboot my computer the RAID5 comes back in degraded mode, 
> and mdadm outputs the following info:
> 
>        Number   Major   Minor   RaidDevice State
> this     0      34        1        0      active sync   /dev/hdg1
>     0     0      34        1        0      active sync   /dev/hdg1
>     1     1      34       65        1      active sync   /dev/hdh1
>     2     2      33        1        2      active sync   /dev/hde1
>     3     3      33       65        3      active sync   /dev/hdf1
>     4     4      22        1        4      active sync   /dev/hdc1
>     5     5       0        0        5      faulty removed
>     6     6       3       65        6      active sync   /dev/hdb1
> 
> If I do a mdadm /dev/md0 --add /dev/hdd3 the missing disk is re-added 
> and everything seems fine after it has worked away for a few hours - 
> however after another reboot the disk has gone again.
> 
> Does anyone have any idea what is going on?

At a guess, I'd say  that you are relying on auto-detection of raid
arrays using  raid-auto-detect partition types, and that /dev/hdd3
isn't set to raid-auto-detect.
If that isn't it, some kernel log messages would probably help, along
with more details of why you expect it to work (e.g. are you using
raidstart, mdadm, autodetect, etc).

NeilBrown
