From: Coly Li <i@coly.li>
Subject: Re: [PATCH 06/14] md/bcache: Use %pS printk format for direct
 addresses
Date: Thu, 7 Sep 2017 15:49:57 +0800
Message-ID: <928ff0ac-41e3-7e5e-45f4-bee69c6a4503@coly.li>
References: <1504729681-3504-1-git-send-email-deller@gmx.de>
 <1504729681-3504-7-git-send-email-deller@gmx.de>
 <29e5f2a8-c829-0aba-5b06-1501c98690a6@coly.li>
 <30e9400c-b95d-5720-f9a0-6086f08ecd4a@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <30e9400c-b95d-5720-f9a0-6086f08ecd4a@gmx.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/9/7 下午3:42, Helge Deller wrote:
> On 07.09.2017 06:50, Coly Li wrote:
>> On 2017/9/7 上午4:27, Helge Deller wrote:
>>> Use the %pS instead of the %pF printk format specifier for printing symbols
>>> from direct addresses. This is needed for the ia64, ppc64 and parisc64
>>> architectures.
>>>
>>> Signed-off-by: Helge Deller <deller@gmx.de>
>>> Cc: linux-bcache@vger.kernel.org
>>> Cc: linux-raid@vger.kernel.org
>>> ---
>>>  drivers/md/bcache/closure.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
>>> index 864e673..0b0c9bc 100644
>>> --- a/drivers/md/bcache/closure.c
>>> +++ b/drivers/md/bcache/closure.c
>>> @@ -175,7 +175,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
>>>  	list_for_each_entry(cl, &closure_list, all) {
>>>  		int r = atomic_read(&cl->remaining);
>>>  
>>> -		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
>>> +		seq_printf(f, "%p: %pS -> %pf p %p r %i ",
>>>  			   cl, (void *) cl->ip, cl->fn, cl->parent,
>>>  			   r & CLOSURE_REMAINING_MASK);
>>>  
>>> @@ -187,7 +187,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
>>>  			   r & CLOSURE_SLEEPING	? "Sl" : "");
>>>  
>>>  		if (r & CLOSURE_WAITING)
>>> -			seq_printf(f, " W %pF\n",
>>> +			seq_printf(f, " W %pS\n",
>>>  				   (void *) cl->waiting_on);
>>>  
>>>  		seq_printf(f, "\n");
>>>
>>
>> It is unclear to me, that if %pF is used, on ia64/ppc64/parisc64 a
>> function descriptor conversion happens, what negative effect exactly
>> takes place ?
> 
> On ia64/ppc64/parisc64 the kernel will crash here in the worst case, because
> vsprintf() will try to read a pointer from that address and resolve it. 
> But you hand over a return address (_RET_IP_) which should be 
> resolved directly to a symbol. For that you need to use the %pS specifier,
> which is what my patch does.
> 
> The patch has no negative effect on any platform. Output will still be the
> same on x86/mips/arm/... as it has been before with %pF. The only positive
> effect of the patch is that the seq_printf will now show correct output on 
> ia64/ppc64/parisc64 too.

Oh I see. The patch is OK to me, but could you please add the above
information in the commit log, it will help other bcache developers to
understand the patch. Thanks in advance for doing this.

BTW, I also suggest to fix vsprintf() for this issue. For most of
developers, we don't have sense for such issue on ia64/ppc64/parisc64,
it is still very probably someone else makes similar mistake in future.
If vsprintf() can be fixed, the potential risk can be safe.


-- 
Coly Li
