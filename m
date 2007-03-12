From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Help with chunksize on raid10 -p o3 array
Date: Mon, 12 Mar 2007 15:46:19 +0100
Message-ID: <45F567BB.3090804@rabbit.us>
References: <45ED4FE1.5020105@rabbit.us> <17908.55047.408840.852816@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17908.55047.408840.852816@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> The different block sizes in the reads will make very little
> difference to the results as the kernel will be doing read-ahead for
> you.  If you want to really test throughput at different block sizes
> you need to insert random seeks.
> 

Neil, thank you for the time and effort to answer my previous email. 
Excellent insights. I thought that read-ahead is filesystem specific, 
and subsequently I would be safe to use the raw device. I will 
definitely test with bonnie again.

>> * Why although I have 3 identical chunks of data at any time, dstat 
>> never showed simultaneous reading from more than 2 drives. Every dd run 
>> was accompanied by maxing out one of the drives at 58MB/s and another 
>> one was trying to catch up to various degrees depending on the chunk 
>> size. Then on the next dd run two other drives would be (seemingly 
>> random) selected and the process would repeat.
> 
> Poor read-balancing code.  It really needs more thought.
> Possibly for raid10 we shouldn't try to balance at all.  Just read
> from the 'first' copy in each case....

Is this anywhere near the top of the todo list, or for now raid10 users 
are bound to a maximum read speed of a two drive combination?

And a last question - earlier in this thread Bill Davidsen suggested to 
play with the stripe_cache_size. I tried to increase it (did just two 
tests though) with no apparent effect. Does this setting apply to 
raid1/10 at all or it is strictly in the raid5/6 domain? If so, are 
there any tweaks apart from the chunk size and the layout that can 
affect raid10 performance?

Once again thank you for the help.

Peter
