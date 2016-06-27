From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Reshapeing after 4 Days with 0.0% progress
Date: Mon, 27 Jun 2016 13:52:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1606271349280.28955@uplift.swm.pp.se>
References: <loom.20160627T131058-485@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20160627T131058-485@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: iggy <info@kit-it.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Jun 2016, iggy wrote:

> Hello Guys,
>
> i wanted to grow my raid 5 with 3 3tb devices to 4 of 3tb devices.
>
> 1) i add a new device
> 2) i grow (please ask me not why i do this) with the help of the button in
> webmin instead of the cli
>
>
> cat /proc/mdstat:....
>
> After 3 Days of 0.0% of reshaping progress i decided to abort this procedure
> - because for me it seems like an error!
>
>
> Now my raid disapears and i'm not able to mount and backup my data, because
> of degraded. So i have no backup file during reshaping.
>
> is there any way to mount my md0 to backup a fews of data before i complete
> recreate my raid array?
>
> i hofe for answers..
> THANKS!

There are multiple threads here about this problem. What you should have 
done is read them before you "aborted".

http://www.spinics.net/lists/raid/msg49846.html is one example of such a 
thread. There you can also see examples of information needed to help you.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
