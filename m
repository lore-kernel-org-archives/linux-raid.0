From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Wed, 02 Aug 2006 21:53:19 -0400
Message-ID: <44D1570F.4020406@steeleye.com>
References: <44C5BA6F.3010404@steeleye.com> <17617.21634.568180.436250@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17617.21634.568180.436250@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> Is 'bitmap' the best name for the sysfs file?
> It seems a bit generic to me.
> 
>   write-bits-here-to-dirty-them-in-the-bitmap
> 
> is probably (no, definitely) too verbose.
> 
>  dirty-in-bitmap
> maybe?
>  bitmap-set-bits

> Any better suggestions?

I like "bitmap-set-bits" or "bitmap-dirty" maybe. I had thought about 
this, but never changed the name. I agree, something more than just 
"bitmap" is probably appropriate, so that if we ever add a generic 
bitmap output or input (to clear bits, maybe) then we still have 
"bitmap" available, and also because (as you said) "bitmap" is a little 
too generic for what this interface really does.

Thanks,
Paul
