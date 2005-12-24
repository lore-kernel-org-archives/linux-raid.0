From: Henrik <henrik.holst@idgmail.se>
Subject: Re: moving failing system disk to 2xnew RAID1
Date: Sat, 24 Dec 2005 09:53:16 +0100
Message-ID: <8241650853653d3c5425104a1fb228b0@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Max

If you are moving you data archives it is "that simple". If you want to run your entire system on top of a software RAID1 I suggest one of the many "run-root-ontop-of-software-raid" tutorials out there.

http://www.tcm.phy.cam.ac.uk/~mr349/ide_raid_howto.html (one of them). 

A bunch of others: http://www.tldp.org/HOWTO/HOWTO-INDEX/os.html
(search for "root" inside document).

If you are using debian you are (as usual?) blessed: http://alioth.debian.org/download.php/668/rootraiddoc.97.html

That will get you started and we'll wait for the "not so simple" questions that might arise.

Obviously the easist way is to first get the RAID1 running, than copy the data and finally- the delicate details of making a bootup possible from the RAID1.

Good luck and merry christmas by the way! :-)

/Henrik Holst

-----Original message-----
From: Max Waterman davidmaxwaterman+gmane@fastmail.co.uk
Date: Sat, 24 Dec 2005 09:07:19 +0100
To: linux-raid@vger.kernel.org
Subject: Re: moving failing system disk to 2xnew RAID1

> Andy Smith wrote:
> > On Sat, Dec 24, 2005 at 09:27:28AM +0800, Max Waterman wrote:
> >> Max Waterman wrote:
> >>> What would the procedure be for moving the data off my (single) Maxtor 
> >>> onto a RAID1 of 2 WD800JBs?
> >>>
> >>> Max.
> >> Well, I didn't get a response to this question :|
> > 
> > All three disks are in the same machine?  If so, create the RAID 1
> > and then copy the files over onto it..  Sorry this seems too simple
> > so I probably have misunderstood the question.
> 
> Maybe, maybe not...
> 
> The gotcha, in my mind, is that this is the boot disk (to all intents 
> and purposes, the only disk in the machine).
> 
> But maybe it's still simple?
> 
> Max.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
