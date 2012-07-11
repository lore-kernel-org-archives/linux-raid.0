From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: commit backport request
Date: Wed, 11 Jul 2012 15:07:40 -0700
Message-ID: <20120711220740.GE10930@kroah.com>
References: <20120709140230.3cf926ec@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120709140230.3cf926ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stable <stable@vger.kernel.org>, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 09, 2012 at 02:02:30PM +1000, NeilBrown wrote:
> 
> Hi Mr Stable,
> 
>  please apply patch
> 
> commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> Author: Shaohua Li <shli@kernel.org>
> Date:   Tue Jul 3 15:57:19 2012 +1000
> 
>     raid5: delayed stripe fix
> 
> 
> to 3.4.y and 3.2.y.
> 
> It fixes a deadlock in RAID5 which can cause all IO to hang.
> It has been demonstrated to fix a real-life problem (the race is not
> theoretical).

Is it also needed for 3.0.x?  It seems to apply there just fine.

thanks,

greg k-h
