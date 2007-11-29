From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 reshape/resync
Date: Thu, 29 Nov 2007 16:48:47 +1100
Message-ID: <18254.21183.807123.642613@notabene.brown>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
	<20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nagilum on Sunday November 25
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 25, nagilum@nagilum.org wrote:
> ----- Message from nagilum@nagilum.org ---------
>      Date: Sat, 24 Nov 2007 12:02:09 +0100
>      From: Nagilum <nagilum@nagilum.org>
> Reply-To: Nagilum <nagilum@nagilum.org>
>   Subject: raid5 reshape/resync
>        To: linux-raid@vger.kernel.org
> 
> > Hi,
> > I'm running 2.6.23.8 x86_64 using mdadm v2.6.4.
> > I was adding a disk (/dev/sdf) to an existing raid5 (/dev/sd[a-e] -> md0)
> > During that reshape (at around 4%) /dev/sdd reported read errors and
> > went offline.

Sad.

> > I replaced /dev/sdd with a new drive and tried to reassemble the array
> > (/dev/sdd was shown as removed and now as spare).

There must be a step missing here.
Just because one drive goes offline, that  doesn't mean that you need
to reassemble the array.  It should just continue with the reshape
until that is finished.  Did you shut the machine down or did it crash
or what

> > Assembly worked but it would not run unless I use --force.

That suggests an unclean shutdown.  Maybe it did crash?


> > Since I'm always reluctant to use force I put the bad disk back in,
> > this time as /dev/sdg . I re-added the drive and could run the array.
> > The array started to resync (since the disk can be read until 4%) and
> > then I marked the disk as failed. Now the array is "active, degraded,
> > recovering":

It should have restarted the reshape from whereever it was up to, so
it should have hit the read error almost immediately.  Do you remember
where it started the reshape from?  If it restarted from the beginning
that would be bad.

Did you just "--assemble" all the drives or did you do something else?

> >
> > What I find somewhat confusing/disturbing is that does not appear to
> > utilize /dev/sdd. What I see here could be explained by md doing a
> > RAID5 resync from the 4 drives sd[a-c,e] to sd[a-c,e,f] but I would
> > have expected it to use the new spare sdd for that. Also the speed is

md cannot recover to a spare while a reshape is happening.  It
completes the reshape, then does the recovery (as you discovered).

> > unusually low which seems to indicate a lot of seeking as if two
> > operations are happening at the same time.

Well reshape is always slow as it has to read from one part of the
drive and write to another part of the drive.

> > Also when I look at the data rates it looks more like the reshape is
> > continuing even though one drive is missing (possible but risky).

Yes, that is happening.

> > Can someone relief my doubts as to whether md does the right thing here?
> > Thanks,

I believe it is do "the right thing".

> >
> ----- End message from nagilum@nagilum.org -----
> 
> Ok, so the reshape tried to continue without the failed drive and  
> after that resynced to the new spare.

As I would expect.

> Unfortunately the result is a mess. On top of the Raid5 I have  

Hmm.  This I would not expect.

> dm-crypt and LVM.
> Although dmcrypt and LVM dont appear to have a problem the filesystems  
> on top are a mess now.

Can you be more specific about what sort of "mess" they are in?

NeilBrown


> I still have the failed drive, I can read the superblock from that  
> drive and up to 4% from the beginning and probably backwards from the  
> end towards that point.
> So in theory it could be possible to reorder the stripe blocks which  
> appears to have been messed up.(?)
> Unfortunately I'm not sure what exactly went wrong or what I did  
> wrong. Can someone please give me hint?
> Thanks,
> Alex.
> 
> ========================================================================
> #    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
> #   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
> #  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
> # /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
> #           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
> ========================================================================
> 
> 
> ----------------------------------------------------------------
> cakebox.homeunix.net - all the machine one needs..
> 
