From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 + smartctl + uncorrectable read error + single-block-resync ?
Date: Thu, 3 Jun 2004 15:56:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406031956.i53Ju5315341@watkins-home.com>
References: <40BF7D45.3020403@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40BF7D45.3020403@h3c.com>
To: 'Michael Hardy' <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You got it!  A write to the bad sector should cause the drive to re-map the
bad sector.  Not all drives do this.  My drives (ST118202LC with EMC
firmware B801) required me to change an option in the firmware to allow this
to occur.

I wish md could do this automatically!  It would save a lot of down time.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Hardy
Sent: Thursday, June 03, 2004 3:34 PM
To: linux-raid@vger.kernel.org
Subject: raid5 + smartctl + uncorrectable read error + single-block-resync ?


I've got smartd running (great tool: http://smartmontools.sf.net) and it 
just alerted me to an unreadable sector in one drive on a software raid5 
array I have (linux kernel 2.4.18, I believe, I know its old)

smartctl is capable of telling me exactly what LBA on the drive is 
unreadable, and I was reading this, which indicates it would be possible 
to remap that single block:

http://cgi.cse.unsw.edu.au/~neilb/me/SoftRaid/01084418693

...but I'm guessing that's just an idea, since its from May 13th 2004 
and there a couple of indications of kernel hacking in it ("maintain a 
list of bad blocks", check thresholds, work on the recovery thread, etc)

Is there any motion to get raid to implement this?

If there is, I guess my only input (I'm a sysadmin level hacker, not a 
kernel hacker) would be to say - there should be some interface for 
external utilities to "educate" the linux raid module that a specific 
disk has a specific sector going bad.

That way you could script smartd to take the results of a failed offline 
SMART test and send the bad LBAs to the raid module for read tests and 
resync

Oh, and I want a pony. ;-) I couldn't resist asking that, since this is 
basically a gigantic feature request

In the meantime, I guess logically failing the drive and re-adding it is 
the only way to remap the sectors, right?

-Mike
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


