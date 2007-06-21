From: Michael <big_green_jelly_bean@yahoo.com>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Thu, 21 Jun 2007 03:40:02 -0700 (PDT)
Message-ID: <983630.30385.qm@web54109.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The power consumption is allot more then I anticipated.  Now I know why thoose adaptec cards have staggered spin up features.  I really should look into the new Seagate drives power requirements closer.  Thank you for the heads up.  Finding a PSU with large 12v rails is going to be interesting, though probably well worth it.  I never figured these drives would pull so much power.  My father is running a server with an array of I think around 8 drives.  He does this with a 350w PSU's.  Some 1000w PSU's come with 4 rails,l which may be the perfect solution, even though I will not be pushing 1000w (since the 5v and 3v rails will not be needed.

I was thinking of a Intel P65G MB with 6 SATA connections.  The G has a graphics card, and would free up a few PCI-Express slots.  The 8 drive MoBo's often use a Micron device with a PATA controller card.  The obvious issue with this is the numerous reports of SATA II cards conflicting with other SATA adapters.  I hope I can find a solution.

The limit to the speed of the machine should be the limit of the South Bridge ability to handle the load.  It probably is around 533 mhz since that seems to be the core duo processor FSB.  Hardware arrays are a great solution for people who are doing web services , data warehouses, and other process intensive applications that also require many hundreds of simultaneous connections.  I may have 4 connections to this box at one time, with only 1upto 2 or 3 people pulling data off.

The output question is an issue when faced with HD programming.  A HD disk is usually around 20g, and supports many hours (and sound tracks) of audio and video.  The problem is, the programs (like power DVD, don't support network paths.  You can trick it with a maped network drive, jpwever I am still experimenting with this and have had some issues.  The issues may have been involved in a bad drive that was bringing my machine to its knees.  There was no data on this drive, but the failure clearly destroyed windows performance to the point of loosing control over the mousse movements.

Multiple, smaller PSU's may also be the answer, though I will have to do a product analysis.,as for the drive arry I should probably stagger the development, so that each controller card is hit one timethen moved onto the next controller card..

Does this allsound ok?

thansk
Mike

----- Original Message ----
From: Brad Campbell <brad@wasp.net.au>
To: Michael <big_green_jelly_bean@yahoo.com>
Sent: Thursday, June 21, 2007 5:45:00 AM
Subject: Re: Software based SATA RAID-5 expandable arrays?

Michael wrote:
> Thank you;
> 
> Not that I want to, but where did you find a SATA PCI card that fit 15 drives?

I didn't. I have 2 boxes. One has 4 Promise TX4 cards, the other has 3 Promise TX4 cards and the 
on-board VIA SATA ports.

> The most expensive part of the build has been finding drive controllers....  Also, how did you come up with that power requirement.  Seems like allot of power for 29 drives....  I will be able to fit near that many in the case Im buying...

I didn't "come up" with the power requirement as such. The first box had a 480W PSU in it and it's 
been flawless (if it ain't broke!). The second I built with a 400W PSU that would shutdown 2 seconds 
into the spinup cycle so I replaced it with a 600W with Dual 12V rails. That still had an issue as 
it tried to power all the drives from a single 12V rail, so I had to open it up and spread the 12V 
drive connectors across both rails. Running consumption of the machine after spinup at full load is 
about 350W, but it hits about 500W for 10 seconds while it spins up.

> I have SATA drives, not PATA, which is a shame cause the controllers cost so much... As for windows, its just familiar to me... I know it like the back of my hand... BUT... it is about time I learn more of Linux.  I have been getting away with IT departments, and simply putting in server change/software installation requests for MySQL   Its kinda nice.. I dont even need to figure out the connection string.

Not really, if you are looking at the cheaper end of the market the controllers are pretty cost 
effective given you are not after hardware raid. Trust me, I started on a box with 8 PATA drives and 
the cabling was a nightmare.

> I knew DOS very well, but Linux is frustrating for me...  I just don't have anyone to goto for quick answers.... especially when I dont know the question or whats wrong...  "The computer just hangs randomly" doesnt get very far in forum discussions...

Google is the wonder cure for most Linux questions, as is freenode.net.

> Again, thank you for your insight...  I am VERY serous about doing this, and am running out of time (aka disk space) every day.

Yeah, me too. I've had to cobble another storage server together to get me another 500GB until I can 
  get some new drives. I never thought I'd fill 6TB this quickly.

If you are doing cheapo storage arrays, linux just can't be beaten on the performance / features / 
cost ratios..

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams





      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


