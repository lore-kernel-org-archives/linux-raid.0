From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Force parity resync on raid5?
Date: Thu, 12 Aug 2004 00:06:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408120406.i7C46s309087@watkins-home.com>
References: <Pine.LNX.4.56.0408100958470.1665@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408100958470.1665@lion.drogon.net>
To: 'Gordon Henderson' <gordon@drogon.net>, 'Philip Molter' <philip@corp.texas.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ouch!  No!!

This would re-build data from parity!!!
He thinks his parity is bad.
He wants to re-build the parity from the data!
I don't know if this can even be done!
Recovering from a power failure does force a re-build (2.4), but from what I
remember the system looks like it is re-building a failed disk, which is not
what he wants to do.  If the parity was good, re-building any 1 disk would
be fine.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gordon Henderson
Sent: Tuesday, August 10, 2004 5:04 AM
To: Philip Molter
Cc: linux-raid@vger.kernel.org
Subject: Re: Force parity resync on raid5?

On Mon, 9 Aug 2004, Philip Molter wrote:

> How do I force a parity resync on a raid5 array?  Under 2.4, I would do
> this by hard cycling the box and when it came back up, it would
> automatically resync the array.  Under 2.6, this appears to have gone
away.

I don't know about 2.6, (still living with 2.4) but can't you simply do:

  raidhotremove /dev/mdX /dev/hdYZ

followed by

  raidhotadd /dev/mdX /dev/hdYZ

or /dev/sdYZ if SCSI disks...

However, picking the right disk to remove might be tricky... And if you
were at all unsure about data on the disks, maybe rebooting and doing a
hard fsck of the partition(s) in maintenance mode might be a good thing
too...

Good luck!
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

