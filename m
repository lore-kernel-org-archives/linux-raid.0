From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: 2.6.31-rc5-git2 crash on a idle system.
Date: Thu, 06 Aug 2009 19:03:37 +0530
Message-ID: <4A7ADBB1.3050906@in.ibm.com>
References: <4A78292A.5000607@in.ibm.com>	 <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1249465934.18245.54.camel@pasglop>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Benjamin Herrenschmidt wrote:
> Thanks. Since it's a memory corruption (or seems to be) however, it's
> possible that the bisection will mislead you. IE. The culprit could be
> somewhere else, and the commit you'll find via bisection just happens to
> move things around in the kernel in such a way that the corruption hits
> that code path instead of another rarely used one.
>
> I would suggest using printk to print out the content of memory where
> the code appears to have been smashed at different stages during boot
> (maybe even in the initcalls loop in init/main.c) to try to point out
> what appears to be causing the corruption.
>   
By the time machine is up and running the particular memory location
in question is already overwritten. So seems like the corruption occurs
during the boot.

I added few printks in the initcall debug code patch. The o/p suggests
that by the time first initicall debug message is printed the code is
already corrupted. Further debug suggests, when start_kernel() is
called the code at address(0xc000000000600000) is already corrupted.
About 28 bytes of code starting from the above address is overwritten. 

I will try to add few more debug statements to find the place where
this corruption might me happening.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

