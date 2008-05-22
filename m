From: "David Lethe" <david@santools.com>
Subject: RE: Proposal: non-striping RAID4
Date: Thu, 22 May 2008 17:10:08 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C76F854@34093-C3-EVS3.exchange.rackspace.com>
References: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Tony Germano <tony_germano@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I personally have a real problem with sleepy drives.  There is no ANSI
specification, and no drive vendors are making disks (today) that are
engineered for this.  Granted spinning down disks saves power & heat,
but since disks aren't yet engineered for frequent spin-ups, then there
are industry-wide concerns about disk life.

Without benefit of an ANSI spec for this mode (and why stop at sleep,
have several lower-RPM speeds that sacrifice performance for heat/power
savings), then I just see too many problems for general use, so it would
have to be limited to an appliance.  The appliance vendor would probably
have to carefully test & qualify disks, and insure that applications
won't constantly spin disks up and have problems with 30+ sec timeouts
and such.

I think best next step is to write a bunch of emails to the various ANSI
T10, T11, and T13 committee members and have them work out a spec so we
have rules, and disks that are designed for this purpose.

 Undoubtedly there is a need, but without standards it will be a kludge.


David lethe

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tony Germano
Sent: Thursday, May 22, 2008 4:16 PM
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

