From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: 5400 vs 7200 RPM IDE drives
Date: Tue, 8 Oct 2002 16:33:16 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1021008160627.21928A-100000@Maggie.Linux-Consulting.com>
References: <anvm48$l42$1@main.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <anvm48$l42$1@main.gmane.org>
To: "David U." <davidu@everydns.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya

most of the disks that are dead and sitting on my desks
are ibm deskstars ( 20,30,40 GB )  and the other batch
is similarly sized WesternDigital cavalier(?)...

- have a couple WD 120GB disks w/ 8MB disk cache..
( so far no problem with it )

and those disk failures are 10-20% disk failures at one company
that tried to save a few $$$ by buying WDs... 

ibm just screwed up their manufacturing/qa processes w/ the deskstars

( now i just buy seagate/maxtors in those sizes )

jury still out for me on the 8MB cache WD 120s

btw... add a cooling fan for each 7200rpm disk

c ya
alvin


-- i'd use 3 disks as raid5 ...
	- when one disk dies... it continues in degraded mode...
	( you can add the replacement disk ... and it will resync

	- but you lose backup disks  ( need another system for backups )

-- if using 2 disks as mirroring
	- when one disk dies... it continues in degraded mode...
	( you can add the replacement disk ... and it will resync

	and you have a backup of it too

- i dont use "spare disks" .... i rather have a 2nd system that is mirror
  of the first set of "important data" ( usually warm swap w/ new ip#
  to retire the flaky/dying system w/  the warm-backup )


On Tue, 8 Oct 2002, David U. wrote:

> Hi friends,
> 
> I was just wondering what the most current opinions were with regard to 5400
> vs 7200 RPM drives.
> 
> Also, have people been happy with the Western Digital 100gig Special Edition
> drives?
> 
> What are other people using?
> 
> fwiw, I'm planning on running three WD1000JB's. Two of them mirrored and the
> third as a backup until needed as a spare.  This is for a remote colo so in
> the event a drive dies I need lots of time to be able to get a new drive in,
> so raid5 is out. (I can't only fit in three drives)
> 
> Thanks,
> David U.
> 
> --
> "Never doubt that a small group of thoughtful citizens can change the
> world. Indeed, it is the only thing that ever has." --Margaret Mead
> 
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

