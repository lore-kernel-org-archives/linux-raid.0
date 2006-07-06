From: Neil Brown <neilb@suse.de>
Subject: Re: second controller: what will my discs be called, and does it matter?
Date: Fri, 7 Jul 2006 08:20:51 +1000
Message-ID: <17581.36035.456544.967672@cse.unsw.edu.au>
References: <200607062012.14684.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Thursday July 6
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 6, Dexter.Filmore@gmx.de wrote:
> Currently I have 4 discs on a 4 channel sata controller which does its job 
> quite well for 20 bucks. 
> Now, if I wanted to grow the array I'd probably go for another one of these.
> 
> How can I tell if the discs on the new controller will become sd[e-h] or if 
> they'll be the new a-d and push the existing ones back?

No idea.  Probably depends on where you plug it in, but also on the
phase of the moon :-)

> 
> Next question: assembling by UUID, does that matter at all?

No.

> (And while talking UUID - can I safely migrate to a udev-kernel? Someone on 
> this list recently ran into trouble because of such an issue.)

Depends on what you mean by 'safely'.

If you mean "can I change something that fundamental and expect
everything will just work perfectly without me having to think" , then
"no". 

If you mean "should it be fairly easy to fix anything that breaks, and
can I be confident that my data will be safe even if something does
break", then "yes".

NeilBrown
