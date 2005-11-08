From: AndyLiebman@aol.com
Subject: Re: udev and mdadm -- I'm lost
Date: Tue, 8 Nov 2005 18:50:12 EST
Message-ID: <67.50ebf0c1.30a293b4@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: djiang@mvista.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Just use --auto or --auto=yes and it should  take care of the device node 
> creations. I have a /etc/mdadm.conf  so I just do:
>mdadm -As --auto=yes and it brings everything up over  udev.
>
>Although if you want to use the scan option with auto you  may want to 
>use mdadm 1.12.0 or later as on some of the earlier version  the 
>combination doesn't work.  

Thank you Dave for your suggestion. Before you wrote back, I went ahead and  
tried out: 
 
mdadm -Av -amd 1 --uuid=xxxxx /dev/sd*
 
and that seemed to work. Is that okay. Unfortunately, "man mdadm" doesn't  
explain in much detail what the "yes" and "no" options do, unless I missed  
something. But the "md" option seems to make mdadm behave like it used to under  
devfs -- right? Only rather than specifing a device with the syntax "/dev/mdXX" 
 you just use "XX" or "X". 
 
It's not complicated, but it would be good to just know I'm doing it right. 
 
Andy
