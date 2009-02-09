From: Neil Brown <neilb@suse.de>
Subject: Re: [Fwd: Spares not automatically added on boot]
Date: Tue, 10 Feb 2009 08:54:45 +1100
Message-ID: <18832.42533.171994.572163@notabene.brown>
References: <499081ED.4060000@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Ceuleers on Monday February 9
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 9, jan.ceuleers@computer.org wrote:
> Bumping. Sorry 'bout that, but I would like to give this another chance 
> at attracting attention.
> 
> Many thanks, Jan
> 
> -------- Original Message --------
> Date: Sun, 01 Feb 2009 13:10:04 +0100
> From: Jan Ceuleers <jan.ceuleers@computer.org>
> To: linux-raid@vger.kernel.org
> Subject: Spares not automatically added on boot
> 
> All,
> 
> I've been having a long-standing problem with spares not being
> automatically re-added to my raid sets when the system is booted. I
> reported this problem here:
> 
> https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/252365
> 
> The problem appears to be that if spare drives are served by a disk
> controller that is of another type than the one serving the active
> volumes, then the modules for both types of disk controller need to be
> included in the initrd image for things to work properly. This is on
> Ubuntu 7.10 and 8.04.
> 
> I'd be interested in views here as to the real root cause (since the fix
> that works for me and for one other user may not a generic fix).

If only spares are not added at boot then it might sound like a minor
problem, but ofcourse it is a major problem just waiting to happen.
As soon as a device fails it will get rebuilt on to a spare and then
on the next boot it will be a real data device that is missing.

If the problem is fixed by making sure all controller for any devices
in the raid are in the initrd, then it seems likely that the problem
is with the mkinitrd script which creates the initrd in the first
place.  You should probably file the bug against that rather than
again mdadm.

Why changing the DEVICE line would make any difference I cannot
imagine.  Maybe the initrd looks at the DEVICE line when making some
decisions, but that sounds like an odd thing to do.

Short answer:  File a bug against mkinitrd (or whatever it is called)
with Ubuntu.

NeilBrown
