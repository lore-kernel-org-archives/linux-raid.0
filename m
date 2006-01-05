From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: ANNOUNCE: mdadm 2.2 - A tool for managing Soft RAID under Linux
Date: Thu, 05 Jan 2006 17:00:31 +1100
Message-ID: <87zmmb2ozk.fsf@rimspace.net>
References: <17299.55654.747972.455172@cse.unsw.edu.au>
	<20051206145939.GD26862@skl-net.de>
	<00a201c6119b$25f58bd0$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"David M. Strang" <dstrang@shellpower.net> writes:

[...]

> I'm not very initrd savvy; and I'm having a heck of a time making the
> initramfs instructions in mdadm work. Does anyone have a working example
> of them?

[...]

> I've added a /dev directory to the init.cpio.gz as well. It seems like I
> may have some cart before the horse syndrome tho, as mdadm cannot find
> /dev/sdb1... which I'm assuming is because udev hasn't started.

Perhaps you would be better served by starting with a fully functional
initramfs (or initrd) implementation that is in active use, then
extending (or adapting) it to do what you wanted?

Ubuntu Linux and Debian unstable have the 'initramfs-tools' package
which currently boots a number of software RAID machines for me, and
seems a fairly reasonably understandable implementation of the concept.

Regards,
        Daniel


