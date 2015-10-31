From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: quickest way for complex operation?
Date: Sun, 01 Nov 2015 00:33:59 +0100
Message-ID: <20151101003359.Horde.iGfpdRilw8RK4_EEPPLrFjw@www3.nde.ag>
References: <20151030142606.Horde.D8WmIG47kX-kazg2Xb68-wV@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151030142606.Horde.D8WmIG47kX-kazg2Xb68-wV@www3.nde.ag>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Zitat von "Jens-U. Mozdzen" <jmozdzen@nde.ag>:
> [...] Can I both replace and resize in a single (or almost single) step?
>
> I had hoped that something along the following might work:
>
> - fail one of the remaining 4 old drives
> - mark the other three old drives for replace
> - reshape the RAID to 6 disks (which probably will start right away)
> - insert the three new disks and add them as spares

I've tried, and it seems it's handled purely sequentially.

Unfortunately, I've run into totally unrelated problems during above  
steps, that had me reinstall the node completely - and it was much  
quicker to re-create the RAID set with just the new disks instead of  
waiting for the reshape to complete.

Regards,
Jens

