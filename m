From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 18:44:07 +0100
Message-ID: <20151116184407.Horde.3ODJYoTBtNA8WapjnAfIhkr@www3.nde.ag>
References: <22090.1097.258820.65463@quad.stoffel.home>
 <20151116182731.Horde.4rj0hKH2I4Q0KSxmbRtF3Es@www3.nde.ag>
 <22090.4914.784452.360948@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22090.4914.784452.360948@quad.stoffel.home>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi John,

Zitat von John Stoffel <john@stoffel.org>:
>>>>>> "Jens-U" == Jens-U Mozdzen <jmozdzen@nde.ag> writes:
>
> Jens-U> Hi John,
> Jens-U> Zitat von John Stoffel <john@stoffel.org>:
>>> Guys,
>>>
>>> I'm starting to get tons of errors on my various mixed 1 and 2Tb
>>> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
>>> It's time to start replacing them and I think I want to either go with
>>> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
>>> SSDs to use with lvmcache for speedup.
>>>
>>> Any comments?
>
> Jens-U> How are the drives to be attached to the server?
>
> I'm planning on just hooking them into the:
>
>   Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008
>   PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)

according to WD support, hooking the Reds to the SAS adapter directly  
should be no problem. It's said to be the extender to cause the trouble.

> [...]
> Jens-U> We found these WD Reds to be a bit slow, but really liked the
> Jens-U> power consumption / heat aspects of the drives and of course
> Jens-U> the price per GB. As we paired the disks with SSD caching,
> Jens-U> actual disk speed was no issue in our case.
>
> Were you using lvmcache?  How did you like it?  Any problems or
> issues?  SSD prices are down enough now to make it really tempting to
> just get a pair of big 4Tb drives and then the smaller SSDs for
> caching, but I'm concerned about reliability and durability.  Which is
> why I tend to triple mirror my RAID1 drives...

we're using bcache, which is working nicely for us, but required lots  
of work to get there (bug fixes are mostly on the corresponding  
mailing list, not upstream. And there were some nasty bugs, indeed).

We're using both read & write caching, with really positive results:  
iowait without caching easily is above 25% on the machine, but drops  
down to 4% with SSD caching. Since even when moving dirty buffers from  
SSD to HDD, the SSD cache responds to most of the read requests, user  
experience is fairly good.

We've set up RAID6 for the HDD backing store and a 2-SSD-RAID1 for the  
cache... and on top of each logical volume we have DRBD replication to  
a backup server (which originally was for running backups, but served  
nicely when the RAID6 went down).

The SSD cache is 128GB, with typically less than 4GB dirty cache lines  
- so plenty of read cache, too.

Regards,
Jens

