From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: best effort rebuild with 1 failed, 1 marginal disks in raid5?
Date: Sun, 28 Nov 2004 13:09:19 -0500
Message-ID: <200411281809.iASI9ON00369@www.watkins-home.com>
References: <41AA002C.8030203@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41AA002C.8030203@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>, 'Brian Ristuccia' <bristuccia@starentnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When you look at the archive, make sure you keep clicking "next in thread"
to see the complete story.  It did end well!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
Sent: Sunday, November 28, 2004 11:43 AM
To: Brian Ristuccia
Cc: linux-raid@vger.kernel.org
Subject: Re: best effort rebuild with 1 failed, 1 marginal disks in raid5?

Brian Ristuccia wrote:

>I have a 3 disk raid5 array which recently suffered catastrophic failure of
>one disk. While the array was degraded, one more disk failed out of the
>array due to a bad block. Investigation with badblocks reveals the marginal
>disk has only a handful of bad blocks.
>
>What I'd like to do is start the array with the good disk and the marginal
>disk, add a 3rd known good disk, and rebuild the array as best as possible.
>Then I'd fail the marginal disk and install another good disk.
>
Well, first of all - don't do anything without verifying it first.

There's a good chance you can recover quite some data if you don't screw 
it up by 'having a go' (I speak from experience :) )

Instead of your plan, can I suggest you try to duplicate the 
disk/partition showing a few bad blocks onto a known good disk.
Then forcefully reassemble the array, then add another good disk for 
reconstruction.

Useful tools include dd_rhelp and dd_rescue

Take a look in the archives as this kinda hit me recently.
http://marc.theaimsgroup.com/?l=linux-raid&m=110025421113782&w=2

David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

