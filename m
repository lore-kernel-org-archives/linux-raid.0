From: Neil Brown <neilb@suse.de>
Subject: Re: what does this mean: ioctl lock interrupted
Date: Mon, 5 Dec 2005 13:54:46 +1100
Message-ID: <17299.44022.145167.504614@cse.unsw.edu.au>
References: <43915D75.5040601@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Saturday December 3
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday December 3, eyal@eyal.emu.id.au wrote:
> I am testing my Promise SATA-II-150-TX4.
> 
> I ran 'e2fsck -f' for a few hours and all is well.
> I then wanted some writing to so I changed to 'e2fsck -cc'.
> 
> I am seeing the following messages. Is this a problem?
> It seems to continue unharmed though.
> 
> Dec  3 18:24:09 eyal kernel: [4322441.538000] md: ioctl lock interrupted, reason -4, cmd 4705
> Dec  3 18:35:23 eyal kernel: [4323115.688000] md: ioctl lock interrupted, reason -4, cmd 4705
> Dec  3 18:36:42 eyal kernel: [4323194.933000] md: ioctl lock interrupted, reason -4, cmd 4705
> Dec  3 18:36:54 eyal kernel: [4323207.259000] md: ioctl lock interrupted, reason -4, cmd 4705
> Dec  3 18:37:59 eyal kernel: [4323271.650000] md: ioctl lock interrupted, reason -4, cmd 4705
> Dec  3 18:38:21 eyal kernel: [4323293.902000] md: ioctl lock interrupted, reason -4, cmd 4705
> Dec  3 19:04:03 eyal kernel: [4324835.969000] md: ioctl lock interrupted, reason -4, cmd 4705
> 

It is strange.  It means that some process got signalled while trying
to perform an 'ioctl' on an md device that was busy in some way that
prevented any ioctl.  However md devices are not 'busy' in this way
for extended periods of time, so getting interrupted while waiting for
the lock would be quite unusual.

The ioctl in question is number 4705, or 0x1261.
This means that '0x12' group of ioctls, number 0x61.

All md ioctls are group '9', so it isn't an md ioctl.

It might help to know what command was causing it...

If you feel adventurous, you could edit drivers/md/md.c, find
where it prints that message, and get it to print the string
  current->comm
as well. 

If not, probably don't worry about it.
I suspect it is harmless, though it is puzzling.

NeilBrown

