From: "Mark Klarzynski" <mark.k@computer-design.co.uk>
Subject: RE: Good news / bad news - The joys of RAID
Date: Sun, 21 Nov 2004 21:28:25 -0000
Message-ID: <03c101c4d011$09b9a7c0$030a0a0a@musicroom>
References: <Pine.LNX.4.44.0411201655400.19120-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0411201655400.19120-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have no idea as to what the tier1 vendors say as I have only worked
within the storage business.. the figures I quoted are based on the last
time I consulted on this are would been provided by IBM / Seagate as
these are the only two scsi vendors we use.   If you really want to dig,
then ask Seagate, they are respected in both camps and will openly
justify the technology and price difference.  They produce extremely
in-depth docs on the testing methods and assumptions.

In terms of reset I am not sure what you mean... we and all raid
manufacturers will reset a scsi bus on scsi timeouts.. this is normal
practice and simple to achieve.  It is not achievable on sata..  I have
not used pata much, but I do not recall a reset line that we could
trigger from firmware level.

RAID in isolation does not increase the i/o load as we all know... but
the reality is that raid applications do.  Non of us can refuse the cost
effective nature of sata drives, this means we can often use raid in
places where we could not afford or justify scsi.  Add multiple users
and the stress on the drives increase dramatically.  

If you want a real life situation... one of our scsi designs is used
around the world and has probably 10m+ users (many systems).. in some
cases these have been running for 4 / 5 years and therefore we have to
look at drive replacement. For a trial we used sata to obviously see if
we could save costs or offer an intermediate solution.  We could not
keep a single system going for more than 14 days. The load varied
between 10-250 users at any one time.. we tried Maxtor and IBM.  There
was also a 40% occurrence of fatal state errors.. this was simple the
rate that the drives were failing meant it was likely to fail whilst in
rebuild state and obviously die.

Take the sata box and stick it in many applications and it will last you
to your dying day.

You may be right that there has been ata and scsi drive manufactured
with the same components excluding the interface.... but the last time I
saw this was a bearing shortage in 95... I don't know of any
manufactures today that even hint at this. But I could well be wrong..

The discussion could probably go on forever, but the point is that we
are not stupid... sata solutions are probably 30% of the cost of the
scsi..... there is a difference and we know it. the important thing is
accepting the difference and using the right technology for the right
application. 





-----Original Message-----
From: Mark Hahn [mailto:hahn@physics.mcmaster.ca] 
Sent: 20 November 2004 21:58
To: Mark Klarzynski
Subject: RE: Good news / bad news - The joys of RAID

> SATA / IDE drives have an MTBF similar to that of SCSI / Fibre. But
this
> is based upon their expected use... i.e. SCSI used to be [power on
hours
> = 24hr] [use = 8 hours].. whilst SATA used to be [power on = 8 hours]
> and [use = 20 mins].

can you cite a source for these numbers?  the vendors I talk to
(tier1 system vendors, not disk vendors) usually state 24x7 100%
duty cycles for scsi/fc, and 100% poweron, 20% duty cycles for
PATA/SATA.





