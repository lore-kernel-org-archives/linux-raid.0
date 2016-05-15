From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Sun, 15 May 2016 20:25:24 +0200
Message-ID: <20160515182524.7B12D100A8E@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160515153121.GA11365@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

thanks for the quyick reply, and on a Sunday...

In message <20160515153121.GA11365@EIS.leimen.priv> you wrote:
> On Sun, May 15, 2016 at 03:37:40PM +0200, Wolfgang Denk wrote:
> > Trying to follow the overlay method in [1], I run into errors; guess I
> > must be missing something:
> >
> > [1] https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
> 
> I think you mixed two approaches to the same thing, the wiki shows
> a) how to create overlays manually and b) offers some convenience 
> functions that do the same thing (the overlay create remove functions, 
> you define those functions once and then you can repeatedly call them, 
> basically giving you two commands overlay_create and overlay_remove).

Yes, you are right.  I now realized this, too.

> And then call 'overlay_create' when you want your overlays, 
> and 'overlay_remove; overlay create' when an experiment 
> failed and you want to reset them to their original state.
> 
> At the time you remove the overlays, all things using them 
> must also be gone, so mdadm --stop before overlay_remove. 
> (And make sure no raid is running for the disks you're 
> overlaying...)

Thanks - this was the key that got me working.

After creating the overlys, the system would automatically start the
(incorrect) RAID arrays.  After manually stopping these, I had write
access to the overlays.

Recovering my data was (fortunately) simple:

1) I zeroed the incorrect superblocks on all devices:

	# mdadm --zero-superblock /dev/mapper/sda
	# mdadm --zero-superblock /dev/mapper/sdb
	# mdadm --zero-superblock /dev/mapper/sdc
	# mdadm --zero-superblock /dev/mapper/sdd
	# mdadm --zero-superblock /dev/mapper/sde
	# mdadm --zero-superblock /dev/mapper/sdf

2) Then I forced an assemble of the array:

	# mdadm --assemble --force --verbose /dev/md2 --metadata=1.2
	# $overlays
	mdadm: looking for devices for /dev/md2
	mdadm: /dev/mapper/sda is identified as a member of /dev/md2, slot 1.
	mdadm: /dev/mapper/sdb is identified as a member of /dev/md2, slot 0.
	mdadm: /dev/mapper/sdc is identified as a member of /dev/md2, slot 2.
	mdadm: /dev/mapper/sdd is identified as a member of /dev/md2, slot 3.
	mdadm: /dev/mapper/sde is identified as a member of /dev/md2, slot 5.
	mdadm: /dev/mapper/sdf is identified as a member of /dev/md2, slot 4.
	mdadm: added /dev/mapper/sda to /dev/md2 as 1
	mdadm: added /dev/mapper/sdc to /dev/md2 as 2
	mdadm: added /dev/mapper/sdd to /dev/md2 as 3
	mdadm: added /dev/mapper/sdf to /dev/md2 as 4
	mdadm: added /dev/mapper/sde to /dev/md2 as 5
	mdadm: added /dev/mapper/sdb to /dev/md2 as 0
	mdadm: /dev/md2 has been started with 6 drives.

And me was happy again.

I owe you a beer or two.  Please don't hesitate to remind me whenever
we meet...  Thanks again.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"You can have my Unix system when you  pry  it  from  my  cold,  dead
fingers."                                                - Cal Keegan
