From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Ubuntu crashed during RAID6 grow
Date: Fri, 20 Nov 2015 07:48:35 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1511200745170.24520@uplift.swm.pp.se>
References: <loom.20151119T222250-428@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20151119T222250-428@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nathan Peterson <nathan@uwgrads.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Nov 2015, Nathan Peterson wrote:

> Details after the grow:
>
> md126 : active (auto-read-only) raid6 sdj1[2] sdl1[3] sdf1[9] sdn1[11] (S) sdi1[1] sdg1[10] sde1[8] sdh1[0] sdk1[4] sdo1[12]
>
>  Delta Devices : 1, (8->9)

Please post mdadm --examine from all component drives, but I'd say if you 
try to access your data everything should be there and the grow should 
continue once the array is not auto-read-only anymore (guess from my side 
though).

If you look here:

http://www.linuxquestions.org/questions/linux-server-73/raid-5-mdadm-grow-interrupted-what-to-do-next-602671/

It's a bit old, but here there is also "delta devices" and on the 
component drive there is a "reshape position". If you see that on your 
component drives as well, just try accessing the array and see if the 
reshape continues.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
