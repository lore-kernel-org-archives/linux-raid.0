From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: diskspotting (how to tell the dead one?)
Date: Thu, 30 Oct 2008 10:25:17 -0400
Message-ID: <87f94c370810300725m75bf0667r44e540ee9886c6a0@mail.gmail.com>
References: <200810300719.40816.Dexter.Filmore@gmx.de>
	 <490955DD.1030607@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490955DD.1030607@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 30, 2008 at 2:36 AM, Richard Scobie <richard@sauce.co.nz> wrote:
> Dexter Filmore wrote:
>>
>> Assuming one has 6 disks on two controllers and one dies, how does one
>> tell the dead one? Which controller/port?
>
> There are probably more elegant ways, but I use smartctl -a on the failed
> drive to find it's serial number and use this to find the location based on
> where I installed the drives initially, which I note in a text file or a
> label attached to the exterior of the case on machines with removable drive
> trays.
>

Agreed, the best way is to know in advance what is what.

At this point the safest thing to do is likely to create you
documentation for the 5 working drives and assume the other one is the
dead one.

Unfortunately the only truly safe way to do that I know involves
stopping the raid service.  (You can try with it running but data
destroying kernel bugs do occasionally show up when you read low-level
data at the same time as you access the raid via live filesystem
activity.)

So I would:

1) Stop the raid (via mdadm I assume)

2) Try to read the serial number directly from your first drive.

ie: hdparm -I /dev/sdb

repeat for all 6.  One should fail I assume.  Make note of it.

3) If this is sata, pull the sata power cable for one of the drives.
Repeat step 2, but when a new drive shows up failed, note which one it
is physically.

4) Repeat until done.

5) Power off your system, hook everything back up exactly like it was
and reboot.  Make sure everything is like it was when you started.

6) And you now know which drive is failed.  Sorry, but it is the only
way I know.

FYI: Disk racks that are made to hold raid arrays typically have an
LED for each position.  Then there is "find", "locate", or "blink"
command that will cause that LED to blink.  It is used for exactly
this purpose.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
