From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 06/14] md/bcache: Use %pS printk format for direct
 addresses
Date: Thu, 7 Sep 2017 17:05:19 +0900
Message-ID: <20170907080519.GB533@jagdpanzerIV.localdomain>
References: <1504729681-3504-1-git-send-email-deller@gmx.de>
 <1504729681-3504-7-git-send-email-deller@gmx.de>
 <29e5f2a8-c829-0aba-5b06-1501c98690a6@coly.li>
 <30e9400c-b95d-5720-f9a0-6086f08ecd4a@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <30e9400c-b95d-5720-f9a0-6086f08ecd4a@gmx.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: Coly Li <i@coly.li>, linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On (09/07/17 09:42), Helge Deller wrote:
> >> -		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
> >> +		seq_printf(f, "%p: %pS -> %pf p %p r %i ",
> >>  			   cl, (void *) cl->ip, cl->fn, cl->parent,
> >>  			   r & CLOSURE_REMAINING_MASK);
> >>  
> >> @@ -187,7 +187,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
> >>  			   r & CLOSURE_SLEEPING	? "Sl" : "");
> >>  
> >>  		if (r & CLOSURE_WAITING)
> >> -			seq_printf(f, " W %pF\n",
> >> +			seq_printf(f, " W %pS\n",
> >>  				   (void *) cl->waiting_on);
> >>  
> >>  		seq_printf(f, "\n");
> >>
> > 
> > It is unclear to me, that if %pF is used, on ia64/ppc64/parisc64 a
> > function descriptor conversion happens, what negative effect exactly
> > takes place ?
> 
> On ia64/ppc64/parisc64 the kernel will crash here in the worst case, because
> vsprintf() will try to read a pointer from that address and resolve it. 

probe_kernel_address() handles the page fault and returns -EFAULT if
you give it bad pointer. module_address_lookup() and get_symbol_pos()
seems to be smart enough not to crash on bad pointer as well. what am
I missing? could you please explain where we will crash?

	-ss
