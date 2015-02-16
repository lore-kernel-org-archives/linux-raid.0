From: Chris <email.bug@arcor.de>
Subject: desktop disk's error recovery timouts (was: re-add POLICY)
Date: Mon, 16 Feb 2015 16:15:19 +0000 (UTC)
Message-ID: <loom.20150216T165111-551@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil Turmel <philip <at> turmel.org> writes:

> On 02/16/2015 07:23 AM, Chris wrote:
> > .... with raid members that got pulled and are save to
> > re-sync. (e.g. after the occasional bad block error that gets remapped by
> > the hardrives firmware)
> 
> This should not be part of your concern here, as MD will handle
> occassional UREs by reconstructing them and rewriting them on the fly,


Phil, thank you for dropping in with this hint. It very likly applies to
the disks in the docking station. I searched the mailing list, most hits
said to search for the keywords, though. ;-) 

To understand the issue, I think
https://en.wikipedia.org/wiki/Error_recovery_control
was good.

It would be good if this configuration information could be available there
or at https://raid.wiki.kernel.org

Cheers,
Chris

----

I compiled some snippets from your messages, that could serve as a basis to
correction/completion by someone knowledgeable:



The default linux controller timeout is 30 seconds.  Drives
that spend longer than the timeout in recovery will be reset.  If they
don't respond to the reset (because they're busy in recovery) when the
raid tries to write the correct data back to them, they will be kicked
out of the array.

You *must* set ERC shorter than the
timeout, or set the driver timeout longer than the drive's worst-case
recovery time.  The defaults for desktop drives are *not* suitable for
linux software raid.

I strongly encourage you to run "smartctl -l scterc /dev/sdX" for each
of your drives.  For any drive that warns that it doesn't support SCT
ERC, set the controller device timeout to 180 like so:

echo 180 >/sys/block/sdX/device/timeout

If the report says read or write ERC is disabled, run "smartctl -l
scterc,70,70 /dev/sdX" to set it to 7.0 seconds.

You then set up a boot-time script to do these adjustments at every restart,
and make sure you performing regular scrub runs to ...?


You might not want that kind of long device timeout, but then you shouldn't
use desktop drives in md RAID.

Anyone using desktop drives which don't support SCT ERC in md RAID is 
liable to see long timeouts on the simplest bad sector, and they 
probably prefer to keep the drive in the array AND have the sector 
rewritten after reconstruction than have the drive failed out of the array.




