From: Tudor Holton <tudor@smartguide.com.au>
Subject: Re: Mixing WD red with older seagates
Date: Mon, 09 Sep 2013 13:50:21 +1000
Message-ID: <522D457D.1000900@smartguide.com.au>
References: <522D4369.80404@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522D4369.80404@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Completely anecdotal evidence, but I was mixing WD Reds and Seagates in 
a QNAP RAID 6 each 3TB for a total of 6TB, and the Seagates kept making 
sounds like they were about to hurl.  Testing each drive individually 
with badblocks and smart came up with all drives OK.  But it kept 
chucking the WDs one by one.  Eventually I removed the Seagates and 
replaced them with WDs and since then no drives have been thrown out.

I can only theorise that there may be a timing issue between WD Reds and 
Seagate.

On 09/09/13 13:41, Timothy D. Lenz wrote:
> well, another drive going down. This time sdc. I have a vdr system 
> with 2 pairs of seagate 500Gb drives set up as mirrors. a/b are boot, 
> swap, and data. c/d are single partition data. I have done at least 4 
> rma's on these drives and warranty was nearly up on the last one to go 
> down just 6 months ago. So warranty or not, I'm done with seagate. I 
> only have about $100 saved up (was saving for something else:( ). I'd 
> like to get a WD red 1Tb drive and set it up to act as a 3rd for a/b 
> and replace sdc mirroring sdd. Then at some point remove sda or b 
> (maybe in another 6 months when one of them goes).
>
> I read that the red line WD's had some problems with the 1Gb drives 
> when they first come out. Anyone get any lately know if they are 
> reliable now? Also, any problems pairing one of these with the seagates?
>
> Any red flags in these that will cause problems? I have to refigure 
> all this stuff out each time.
>
> ------------------------------------------------
> menu.lst: http://pastebin.com/7WWHajsc
> ------------------------------------------------
> device.map:
>
> (fd0)    /dev/fd0
> (hd0)    /dev/disk/by-id/ata-ST3500413AS_Z3T69GCE
> (hd1)    /dev/disk/by-id/ata-ST3500418AS_5VMJ49P1
> (hd2)    /dev/disk/by-id/ata-ST3500320AS_9QM35MY5
> (hd3)    /dev/disk/by-id/ata-ST3500820AS_9QM6V6JF
> ------------------------------------------------
> I know there was some command to auto update device.map, but I forget 
> what it was.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

