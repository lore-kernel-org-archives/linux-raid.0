From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with failed raid 5
Date: Sun, 05 May 2013 17:52:34 -0400
Message-ID: <5186D4A2.2090509@turmel.org>
References: <51853C95.5030008@cronosx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51853C95.5030008@cronosx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Frederick Gnodtke <FGnodtke@cronosx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Frederick,

On 05/04/2013 12:51 PM, Frederick Gnodtke wrote:
> Hi,
> 
> I hope someone can help me with this as I am struggling with it since
> this morning.

We may be able to help you.  Some critical information is missing.  For
the record, running raid5 when you have a hot spare available to make it
a raid6 is pretty much insane.

> The following scenario: I have a softwareraid 5 created using mdadm.
> It consisted out of 5 Disks, each of them 2000GB with one as spare-drive.
> The original mdadm.conf looked like this:

[trim /]

> Everything was fine until this morning I tried to open a file and got an
> I/O-Error. I rebooted the computer, stopped the raid, did an smartctl -t
> long on all drives belonging to the raid, but they all seem to run quiet
> well.

> Reassembling it using mdadm --assemble --scan --force did not lead to
> anything so I tried to recreate it using "mdadm --create /dev/md0
> --assume-clean --raid-devices=5 --level=5 /dev/sd[abdef]

Really bad choice.  Advice to use "--create --assume-clean" is scattered
around the 'net, but there are terrible pitfalls.

> It created an array but there was no filesystem to mount.
> fsck could not detect an filesystem and I didn't relocate any "bad
> blocks" as I was afraid this might reduce my chance to repair the raid
> to zero.

The device order you specified is certainly wrong, based on your
original superblocks.

> The original Superblocks of all disks befor recreating the array looked
> like this (The raid already failed when I captured this):

[trim /]

You don't show the original superblock for /dev/sda.  We need it.

From the given superblocks, your order would be /dev/sd{?,f,e,?,d,?},
where the question marks would be various combinations of a, b, and c.

The roles of sdb and sdc show as spare, either of which could have been
the original spare.

Please look in your system's syslog to see if you can find the raid
assembly report from the last boot before the problem surfaced.  It
would be an alternate source of drive roles.

If you find that in syslog, there's a good chance you will also be able
to find the drive error reports in syslog for the kickout of your
drives.  Show us the excerpts.

> Is there any chance to recover the raid?

Yes.

> Has anybody any idea?

You may have to try multiple combinations of drive orders if it cannot
be figured out from other information.  You *must* not mount your
filesystem until we are certain the order is correct.

> As I am just a poor student I didn't quiet have the money to do backups
> so my private data would be lost if the raid failed.

Excuses don't really matter.  Either we can help you or we can't.
Everyone has limited funds, to some extent.  I recommend you prioritize
your personal data as to that which gets backed up and that which
doesn't.  Most people can't afford to *not* back up at least part of
their data, but don't know until they lose it.

> I would really appreciate your help!

When people report array problems for drives that all appear healthy,
certain suspicions arise.  Please also provide:

1) "smartctl -x" output for each drive.
2) "uname -a" output
3) "mdadm --version" output

Phil
