From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 and mdadm
Date: Wed, 2 Apr 2003 09:08:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16010.7165.412475.33750@notabene.cse.unsw.edu.au>
References: <A5974D8E5F98D511BB910002A50A66470580D71F@hdsmsx103.hd.intel.com>
	<3E89B947.C3838E0E@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday April 1
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 1, Paul.Clements@SteelEye.com wrote:
> "Cress, Andrew R" wrote:
> 
> > However, you MUST link the md driver into the kernel.  It doesn't work right
> > as a module, even in initrd.
> 
> BTW, it would be nice if this were fixed, so that md could be compiled
> as a module...would the maintainers be willing to accept patches that
> would make "autostart" a module option, so that upon insertion of the md
> module it would do the autostart stuff, or something similar? From what
> I can tell, we basically need to remove some ifndef MODULE stuff and
> make the autostart option call autostart_arrays(), as it is when md is
> linked into the kernel...

No.  I would not accept patches.
Not because I fundamentally disagree with autostart, but because it
wouldn't work.  I suggest you try it.

> 
> Or is there a better way to do this?

Yes.
initrd/initfs is "the right way".
As far as I know, it *does* work.(*)  You do not need md linked into the
kernel.
You have md.o and whatever personalities you want in the initrd image,
then in the initrd script (linuxrc I think) you load the modules, and
use mdadm to assemble the raid arrays.
You then mount the real root and off you go.

NeilBrown

(*) I say "as far as I know" because I have never tried it, because I
have not yet found the need.  However I believe that others have been
successful. 
I have perfectly happy compiling the raid driver into my kernels so
I have never bothered with initrd.
