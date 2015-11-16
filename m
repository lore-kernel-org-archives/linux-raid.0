From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 18:27:31 +0100
Message-ID: <20151116182731.Horde.4rj0hKH2I4Q0KSxmbRtF3Es@www3.nde.ag>
References: <22090.1097.258820.65463@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22090.1097.258820.65463@quad.stoffel.home>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi John,

Zitat von John Stoffel <john@stoffel.org>:
> Guys,
>
> I'm starting to get tons of errors on my various mixed 1 and 2Tb
> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
> It's time to start replacing them and I think I want to either go with
> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
> SSDs to use with lvmcache for speedup.
>
> Any comments?

How are the drives to be attached to the server?

We started with a bunch of 1TB WD Reds (2.5") connected to a  
SuperMicro server (2028TP-DECR, with 12 disk bays) via SAS3  
extender... bad choice. We saw random hangs under various loads,  
letting disks drop out of the RAID6. SuperMicro support blames the  
disks as such ("not enterprise-grade"), WD responded that the SAS  
extender is the source of trouble, despite being said to support SATA  
drives. SCTERC was set to 7 seconds.

WD's response matches our own observations: Using the same drives in a  
non-extender environment (older SuperMicro servers) gives us no  
trouble at all.

We found these WD Reds to be a bit slow, but really liked the power  
consumption / heat aspects of the drives and of course the price per  
GB. As we paired the disks with SSD caching, actual disk speed was no  
issue in our case.

Regards,
Jens

