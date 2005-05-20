From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm: Automatically determine maximum possible size for --grow?
Date: Fri, 20 May 2005 15:57:59 +1000
Message-ID: <17037.31847.350519.355603@cse.unsw.edu.au>
References: <d6ifeg$j7m$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario 'BitKoenig' Holbe on Thursday May 19
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 19, Mario.Holbe@TU-Ilmenau.DE wrote:
> Hello,
> 
> would it be very hard for mdadm to determine the maximum size a given
> RAID can be grown to automagically like with --create?
> All the resize tools I know about can do this. And I'm quite sure this
> could help the average user who just replaced his disks with bigger
> ones.

I see it isn't in the man page, but
   --grow --size=max
works.

> 
> And btw. - do I need a 2.6 kernel to grow a RAID1's size or does this
> work with 2.4 too?

2.4 doesn't support online --grow.  You need 2.6.

NeilBrown
