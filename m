From: Mitchell Laks <mlaks@verizon.net>
Subject: RE: 4 questions. Chieftec chassis case CA-01B, resync times, selecting ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 16:28:22 -0500
Message-ID: <200501161628.23034.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you to Gordon, Maarten and Guy for your helpful responses. I learned 
much from each of  your comments.

Maarten: I paid $70 for an antec sl450 power supply. seems better price than 
you are saying ( is your power supply better?). Also I liked the idea of 6 
+3+3 slots on your box, but i dont see it for sale in the us.

Gordon: I get the same output on 2.6.8 sarge kernel for hpt366 driver. I 
notice that running 
hdparm /dev/hde 
that the IO_support is set at default 16 bit while on the other hard drive 
on the natice ide bus 
/dev/hdb
has IO_support at 32bit. 
I wondered if I get the other driver whether that will improve things...

Guy: 

> echo 100000 > /proc/sys/dev/raid/speed_limit_max

>I added this to /etc/sysctl.conf
># RAID rebuild min/max speed K/Sec per device
>dev.raid.speed_limit_min = 1000
>dev.raid.speed_limit_max = 100000


I notice that according to the man page the settings you describe are the 
defaults. Why did you have to adjust them?
Moreover When I cat 
 /proc/sys/dev/raid/speed_limit_max  -> i get ->200000
/proc/sys/dev/raid/speed_limit_min  -> i get -> 1000.

interesting is i didnt adjust them up myself.... Should I adjust the 
speed+limit_max down to 100000???
I wonder where in debian it got adjusted up?
Thanks
