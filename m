From: Phil Turmel <philip@turmel.org>
Subject: Re: Trouble adding disk to degraded array
Date: Wed, 09 Jan 2013 12:55:22 -0500
Message-ID: <50EDAF0A.7030903@turmel.org>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com> <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Nicholas Ipsen(Sephiroth_VII)" <sephiroth7vii@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/09/2013 12:21 PM, Nicholas Ipsen(Sephiroth_VII) wrote:
> I recently had mdadm mark a disk in my RAID5-array as faulty. As it
> was within warranty, I returned it to the manufacturer, and have now
> installed a new drive. However, when I try to add it, recovery fails
> about halfway through,  with the newly added drive being marked as a
> spare, and one of my other drives marked as faulty!
> 
> I seem to have full access to my data when assembling the array
> without the new disk using --force, and e2fsck reports no problems
> with the filesystem.
> 
> What is happening here?

You haven't offered a great deal of information here, so I'll speculate:
 an unused sector one of your original drives has become unreadable (per
most drive specs, occurs naturally about every 12TB read).  Since
rebuilding an array involves computing parity for every stripe, the
unused sector is read and triggers the unrecoverable read error (URE).
Since the rebuild is incomplete, mdadm has no way to generate this
sector from another source, and doesn't know it isn't used, so the drive
is kicked out of the array.  You now have a double-degraded raid5, which
cannot continue operating.

If you post the output of dmesg, "mdadm -D /dev/mdX", and "mdadm -E
/dev/sd[a-z]" (the latter with the appropriate member devices), we can
be more specific.

BTW, this exact scenario is why raid6 is so popular, and why weekly
scrubbing is vital.

It's also possible that you are experiencing the side effects of an
error timeout mismatch between your drives (defaults vary) and the linux
driver stack (default 30s).  Drive timeout must be less than the driver
timeout, or good drives will eventually be kicked out of your array.
Enterprise drives default to 7 seconds.  Desktop drives all default to
more than 60 seconds, and it seems most will spend up to 120 seconds.

Cheap desktop drives cannot change their timeout.  For those, you must
change the driver timeout with:

echo 120 >/sys/block/sdX/device/timeout

Better desktop drives will allow you to set a 7 second timeout with:

smartctl -l scterc,70,70 /dev/sdX

Either solution must be executed on each boot, or drive hot-swap.

HTH,

Phil
