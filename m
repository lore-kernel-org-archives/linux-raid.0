From: Adam Radford <aradford@3WARE.com>
Subject: RE: 3ware 7500-12, bad write speed
Date: Thu, 26 Sep 2002 10:50:31 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A1964EDB64C8094DA12D2271C04B812672C703@tabby>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Jason' <bind@swift-web.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jason,

If you're using the 7.5.1 codeset, you can add a jbod with the following
command:

tw_cli maint add c0 p0 jbod

By default, you get a cbod, so you must specify jbod's and spare's.

-Adam

-----Original Message-----
From: Jason [mailto:bind@swift-web.com]
Sent: Wednesday, September 25, 2002 11:43 PM
To: Mikael Abrahamsson
Cc: linux-raid@vger.kernel.org
Subject: RE: 3ware 7500-12, bad write speed


> Yes, don't use the 3Ware BIOS RAID.
> Run it in JBOD mode, and use Linux RAID.
> Neil's md tools make this very nice, and if you go to the 3Ware site and
> look in the downloads they have CLI tools to support hotswap and other
> useful things.
> On a set of 16 Maxtor 160GB disk, and a pair of 3Ware 8 port cards we
> regularly get RAID5 writes (using a 4GB block/file size measured by
> bonnie++) of over 75MB/sec and reads over 160MB/sec.
>
> I do think you should be seeing better results with the card and it's
> native BIOS RAID, but I still think that software Linux RAID is a lot
> faster and more flexible.

I'm with Maurice on this one.  I changed over from using 3wares BIOS RAID to
using Linux software RAID and my write speeds went up to from 15mb/sec
(pathetic) to almost 120mb/sec which almost matches my read speeds (using
Bonnie++).  This was using 4x40GB Maxtor drives in a RAID 5 configuration.

One downside to using the drives in JBOD mode is with 3wares current drivers
if you use their software to remove the drive and then put it back in, it
then recognizes it as a CBOD drive of which then is unrecognizable by the
software RAID.  3ware had a few suggestions that simply were not working so
I placed the drive in a separate machine and ran fdisk to remove all
partitions.  Then upon putting it back in with a reboot rather than using
the software it was again seen as a JBOD drive.  This means no hot swapping
but a reboot would be required.  The good news is 3ware has told me they are
attempting to make a workaround in their drivers so you can add and remove a
JBOD drive without a shutdown.

Jay
>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
