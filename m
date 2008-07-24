From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Out of sync mirrors
Date: Thu, 24 Jul 2008 18:37:55 -0400
Message-ID: <48890443.5000003@tmr.com>
References: <e6432b760807240903s57815b2aib5547d35b701ca70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e6432b760807240903s57815b2aib5547d35b701ca70@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ana Paula <anapaula@cs.rutgers.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ana Paula wrote:
> Hi,
> I am using linux 2.6.8 for my research on raid systems.
>
> I need to have the disks of an array out of sync for a while.
> I want to be able to stop a disk request queue (blk_stop_queue) and
> start it sometime later. Meanwhile its mirrors should be serving r/w
> as if this mirror was up.
> Whenever the stopped mirror comes back it will serve all the requests
> already sent to it.
>
> I am queueing up the requests sent to all others while my mirror queue
> is stopped.
>
> The problem is that the other mirrors stop serving as well. Even if I
> don't stop the queue, only delay its request a little bit, still the
> others also slow down.
>
> Question: how do I get raid to allow mirrors to be out of sync?
>
> Obviously, I am missing something out in the code.
>
> Any clues?
>   

Take a look at "write-mostly" and see if creative use of it will assist. 
I suspect you're doing something which needs a bitmap, as well.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


