From: Dave Jiang <djiang@mvista.com>
Subject: Re: udev and mdadm -- I'm lost
Date: Tue, 08 Nov 2005 16:40:23 -0700
Message-ID: <43713767.1060602@mvista.com>
References: <1b9.203c2461.30a28d17@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b9.203c2461.30a28d17@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

AndyLiebman@aol.com wrote:
> I see there is an mdadm  --auto option now, but I don't feel confident I know 
> how to use it. Can someone  tell me the correct way to create or assemble an 
> array with the --auto option?  
> 
> i.e, 
> 
> mdadm -Av -a1 --uuid=xxxxx  /dev/sd*
> or 
> mdadm -Av -a /dev/md1 --uuid=xxxxx /dev/sd*
> 
> I'm not in  the mood to guess... 
> 
> Thanks. 
> 
> Andy Liebman  

Just use --auto or --auto=yes and it should take care of the device node 
  creations. I have a /etc/mdadm.conf so I just do:
mdadm -As --auto=yes and it brings everything up over udev.

Although if you want to use the scan option with auto you may want to 
use mdadm 1.12.0 or later as on some of the earlier version the 
combination doesn't work.

-- 

------------------------------------------------------
Dave Jiang
Software Engineer, Carrier Grade Software
MontaVista Software, Inc.
http://www.mvista.com
------------------------------------------------------

