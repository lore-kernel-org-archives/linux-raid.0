From: NeilBrown <neilb@suse.de>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Fri, 8 Apr 2011 22:05:28 +1000
Message-ID: <20110408220528.40971e55@notabene.brown>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
	<20110407221334.16604ufejmh3q9s0@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110407221334.16604ufejmh3q9s0@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: rob pfile <rpfile@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 07 Apr 2011 22:13:34 +0200 Nagilum <nagilum@nagilum.org> wrote:

> Hmm, I think you could:
>   - add a disk,
>   - reshape your raid5 to raid6 while using the layout where the raid5  
> disks aren't really changed

That would be
  mdadm --grow /dev/md0 --level=6 --parity=preserve
(I think).

>   - let it finish syncing
>   - reshape the raid6 to raid5 taking one of the bad disks out

I don't think that makes sense. (what command would you use exactly?)
It would be better to remove the bad device and replace it with another good
device (which means more dollars of course...)

> 
> I'm sure Neil will let us know if this is nonsense. ;)

Only half ;-)

NeilBrown


> Alex.
> 
> ----- Message from rpfile@gmail.com ---------
>      Date: Wed, 6 Apr 2011 18:45:15 -0700
>      From: rob pfile <rpfile@gmail.com>
>   Subject: 4-disk raid5 with 2 disks going bad: best way to proceed?
>        To: linux-raid@vger.kernel.org
> 
> > is there a way to construct a clean copy of one of the disks even if  
> > there are raid-correctable read errors?
> 
> ----- End message from rpfile@gmail.com -----
> 
> 
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

