From: Gordon Henderson <gordon@drogon.net>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 14:43:23 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
References: <Pine.LNX.4.55.0306270920010.6883@datavibe.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0306270920010.6883@datavibe.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 Jun 2003, Rev. Jeffrey Paul wrote:

> I'd done some quick searches for "3ware" on ebay, having heard good things
> about their ide-raid cards.  The 7xxx series are too expensive for the
> project I'm working on at the moment.  It's either an older card, or
> software RAID1 (and, with all due respect, I don't want to use linux
> software raid in -this sort- of production environment).

Er.. Why not?

> We're currently looking at raid1 across two 80-120GB disks for a samba
> file server in an office that does a lot of graphic design.

I've setup several small servers doing just this with 2 x IDE drives
mirrored (RAID1) using the on-board controllers on the motherboard
concerned. Make both drives masters, connect them up, pick your Linux
distribution and off you go..

There is the problem that the dual on-board IDE controllers are usually
inside the same physical chip, and if that fails you'll lose both drives
until you replace the mobo, but you are in the same boat if a plug-in PCI
RAID card fails too. I've not (yet?) had problems with a failed drive
stopping the 2nd drive from working, as long as they are on separate
controllers (ie 2 masters off the mobo controller) I have seen one failed
drive take out a 2nd on the same bus though, so thats not recomended.
(once the failed drive was removed, the other did work correctly though)

Eg. the PC I'm currently typing this email on is 100 miles away and I
don't particularly want to drive to it to fix it if a disk fails...

gordon @ unicorn: df -h /
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              236M   20M  204M   9% /

gordon @ unicorn: cat /proc/mdstat
...
md0 : active raid1 hdc1[1] hda1[0]
      249856 blocks [2/2] [UU]
...

I've been using Linux software RAID1 on this particular machine for well
over 2 years now. This is one of my own personal servers and 2.5 years ago
I had to think hard about spending the extra on a 2nd drive. These days I
wouldn't think twice about doing it.

Gordon

