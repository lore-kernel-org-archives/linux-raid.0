From: Phil Turmel <philip@turmel.org>
Subject: Re: Last working drive in RAID1
Date: Thu, 05 Mar 2015 15:00:18 -0500
Message-ID: <54F8B5D2.8070304@turmel.org>
References: <54F7633F.3020503@gmail.com>	<20150305084634.2d590fe4@notabene.brown>	<54F78BD9.403@gmail.com> <20150305102622.016ec792@notabene.brown> <54F87C7C.8020501@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F87C7C.8020501@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.de>, Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/05/2015 10:55 AM, Wols Lists wrote:
> Sorry to butt in, but I'm finding this conversation a bit surreal ...
> take everything I say with a pinch of salt. But the really weird bit
> was "what does linux do if /dev/sda disappears?"
> 
> In the old days, with /dev/hd*, the * had a hard mapping to the
> hardware. hda was the ide0 primary, hdd was the ide1 secondary, etc
> etc. I think I ran several systems with just hdb and hdd. Not a good
> idea, but.
> 
> Nowadays, with sd*, the letter is assigned in order of finding the
> drive. So if sda is removed, linux moves all the other drives and what
> was sdb becomes sda.

On reboot, yes.  Not live.  If /dev/sda has anything using it when
unplugged, it stays there and gives errors.  Existing devices retain
their names, and new devices are added to the end.  Only if all users
are completely unhooked will a kernel name get re-used live.

> Which is why you're advised now to always refer
> to drives by their BLKDEV or whatever, as linux provides no guarantees
> whatsoever about sd*. The blockdev may only be a symlink to whatever
> the sd*n code of the disk is, but it makes sure you get the disk you
> want when the sd*n changes under you.

Correct, but once assembled or mounted, the kernel names are locked.

> Equally surreal is the comment about "what does raid1 do with no
> working devices?". Surely it will do nothing, if there's no spinning
> rust or whatever underneath it? You can't corrupt it if there's
> nothing there to corrupt?

It has to stay there to give errors to the upper layers that are still
hooked to it.  When they are administratively "unhooked", aka unmounted
or disassociated with mdadm --remove.

Or, quite possibly, the device is plugged back in, at which point the
device name is there for it (as long as you use the same port, of
course).  In which case the filesystem may very well resume successfully.

> Sorry again if this is inappropriate, but you're coming over as so
> buried in the trees that you can't see the wood.

Sometimes the expanded view is appropriate :-)

Regards,

Phil Turmel

