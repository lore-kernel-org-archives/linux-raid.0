From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 19:27:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408302327.i7UNRd306606@watkins-home.com>
References: <4133A769.5090408@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4133A769.5090408@corp.texas.net>
To: 'Philip Molter' <philip@corp.texas.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes! That was my plan, I just did not take the time to explain.
When md re-syncs the disk, the write to the "bad" disk should fix/re-locate
the bad blocks.

or

What he said (Philip), but be very careful!
dd if=/dev/zero of=/dev/hde3
dd if=/dev/hde3 of=/dev/null

SCSI disk have the same bad block issue.  md does not support bad blocks. :(

You should test the disks once per day!  In my opinion!

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Philip Molter
Sent: Monday, August 30, 2004 6:17 PM
To: linux-raid@vger.kernel.org
Subject: Re: The right way to recover from md partition failure?

David Greaves wrote:
> I think a better approach might be:
> 
> mdadm /dev/md1 -r /dev/hde3
> dd if=/dev/hde3 of=/dev/null
> check logs for nasty errors and only continue if there weren't any :)
> mdadm /dev/md1 -a /dev/hde3

Normally, for this I:

dd if=/dev/zero of=/dev/hde3
dd if=/dev/hde3 of=/dev/null

The write will usually cause the hard drive to internally relocate any 
bad sectors, which is usually what causes RAID failures on IDE drives 
(in my experience).
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

