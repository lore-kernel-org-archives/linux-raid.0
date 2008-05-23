From: "Chris Green" <cgreen@valvesoftware.com>
Subject: RE: Proposal: non-striping RAID4
Date: Fri, 23 May 2008 08:47:23 -0700
Message-ID: <BC2A76AABABF8741A8ADEE62DB1350F80384C383@exchange2.valvesoftware.com>
References: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Tony Germano <tony_germano@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would really like to have this functionality. Honestly, its pretty
much perfect for the "home server" application (which I have several
of), where:

   - writes are far less common than reads,
   - The system goes hours without any reads and days without any
writes.
   - single drive read speed is plenty for the applications that are
sitting on the other side
   - a lot of the data is too voluminous to backup (media that can just
be re-ripped or downloaded).
   - you want some redundancy beyond a single drive copy, but don't want
to spend a lot of drives on it. The model of "if you lose 1 disk, you
lose nothing, if you lose 2 disks you lose a portion" is better than the
raid5 model of losing everything with a double-disk failure.
   - a common access pattern is to do a long sequential read at a slow
rate that takes hours to go through a few gigs (playing media).
 
-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tony Germano
Sent: Thursday, May 22, 2008 2:16 PM
To: linux-raid@vger.kernel.org
Subject: Re: Proposal: non-striping RAID4


I would like to bring this back to the attention of the group (from
November 2007) since the conversation died off and it looks like a few
key features important to me were left out of the discussion... *grin*

The original post was regarding "unRAID" developed by
http://lime-technology.com/

I had an idea in my head, and "unRAID" has features almost identical to
what I was thinking about with the exception of a couple deal breaking
design decisions. These are due to the proprietary front end, not the
modified driver.

Bad decision #1) Implementation is for a NAS Appliance. Files are only
accessible through a Samba share. (Though this is great for the hoards
of people that use it as network storage for their windows media center
pcs.)

Bad decision #2) Imposed ReiserFS.

Oh yeah, and it's not free in either sense of the word.

The most relevant uses I can think of for this type of array are archive
storage and low use media servers. Keeping that in mind...

Good Thing #1)
"JBOD with parity." Each usable disk is seen separately and has its own
filesystem. This allows mixed sized disks and replacing older smaller
drives with newer larger ones one at a time while utilizing the extra
capacity right away (after expanding the filesystem.) In the event that
two or more disks are lost, surviving non-parity disks still have 100%
of their data. (Adding a new disk larger than the parity disk is
possible, but takes multiple steps of converting it to the new parity
disk and then adding the old parity disk back to the array as a regular
disk... acceptable to me)

Good Thing #2)
You can spin down idle disks. Since there is no data striping and file
systems don't [have to] span drives, reading a file only requires 1 disk
to be spinning. Writing only requires 1 disk + parity disk. This is an
important feature to the "GREEN" community. On my mythtv server, I only
record a few shows each week. I would have disks in this setup possibly
not accessed for weeks or even months at a time. They don't need to be
spinning, and performance is of no importance to me as long as it can
keep up with writing HD streams.

Hopefully this brings a new perspective to the idea.

Thanks,
Tony Germano
_________________________________________________________________
Keep your kids safer online with Windows Live Family Safety.
http://www.windowslive.com/family_safety/overview.html?ocid=TXT_TAGLM_WL
_Refresh_family_safety_052008--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
