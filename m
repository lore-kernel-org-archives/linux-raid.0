From: Neil Brown <neilb@suse.de>
Subject: Re: Ok, dumb question time ...
Date: Fri, 8 Oct 2010 15:54:48 +1100
Message-ID: <20101008155448.19d46db6@notabene>
References: <4CAE9C13.3060002@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CAE9C13.3060002@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 08 Oct 2010 00:20:35 -0400
Joe Landman <landman@scalableinformatics.com> wrote:

> Not having much luck with this.  Let me explain ...
> 
> Imagine we have a RAID1 with 3 elements.  It was originally a RAID1 with 
> 2 elements, and we added a 3rd using
> 
> 	mdadm /dev/md0 --add /dev/loop1
> 
> What I want to do is conceptually very simple.  I want to permanently 
> remove loop1, without having the array become dirty, or degraded.  That 
> is, I would like
> 
> 	mdadm /dev/md0 --fail /dev/loop1 --remove /dev/loop1
> 
> to result in a clean array with two members.
> 
> It doesn't.  The array is marked as being in the "clean, degraded" 
> state.  Which, as it is the root file system array, has the unfortunate 
> side effect of not allowing the RAID1 to properly assemble at boot (that 
> degraded state).
> 
> So ... can I force the array to either remove the extra unneeded loop1 
> device, and update its metadata properly ... or force it into a clean, 
> active state without the loop1 device, or force the assembly on boot to 
> occur regardless of what it thinks it should have?
> 
> This is quite disconcerting ... I thought it would be simple.

It is.

You want the array to think that it only has two devices?

  mdadm --grow /dev/md0 --raid-devices=2

Done.

NeilBrown
