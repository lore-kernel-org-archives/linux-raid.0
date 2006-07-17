From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Hardware assisted parity computation - is it now worth it?
Date: Mon, 17 Jul 2006 14:05:21 -0400
Message-ID: <44BBD161.5030609@tmr.com>
References: <1152778739.26511.65.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1152778739.26511.65.camel@swtf.comptex.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Burn Alting <burn@goldweb.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Burn Alting wrote:

>Last year, there were discussions on this list about the possible
>use of a 'co-processor' (Intel's IOP333) to compute raid 5/6's
>parity data.
>
>We are about to see low cost, multi core cpu chips with very
>high speed memory bandwidth. In light of this, is there any
>effective benefit to such devices as the IOP333?
>  
>

Was there ever? Unless you're running on a really slow CPU, like 386, 
with a TB of RAID attached, and heavy CPU load, could anyone ever see a 
measureable performance gain? I haven't seen any such benchmarks, 
although I haven't looked beyond reading several related mailing lists.

>Or in other words, is a cheaper (power, heat, etc) cpu with
>higher memory access speeds, more cost effective than a
>bridge/bus device (ie hardware) solution (which typically
>has much lower memory access speeds)?
>
An additional device is always more complex, and less tunable than a CPU 
based solution. Except in the case above where there is very little CPU 
available, I don't see much hope for a cost (money and complexity) 
effective non-CPU solution.

Obviously my opinion only.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

