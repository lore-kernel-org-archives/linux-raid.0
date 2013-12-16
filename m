From: Wolfgang Denk <wd@denx.de>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Mon, 16 Dec 2013 17:07:43 +0100
Message-ID: <20131216160743.73CE838465B@gemini.denx.de>
References: <52A98FAF.4000205@insync.za.net> <52A9A1B3.5080706@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <52A9A1B3.5080706@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: Pieter De Wit <pieter@insync.za.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Benjamin,

In message <52A9A1B3.5080706@mpstor.com> you wrote:
> On several more RAID specific SoC (like the PowerPC 440x/460x) a XOR 
> engine is included to speed up RAID calculations (effectively a hardware 
> RAID engine).
> 
> I think Intel Atom CPUs were planned/got a similar engine added, but 
> with the advance in CPU efficiencies and frequencies, these XOR engines 
> are practically obsolete: You will barely use 5% of your CPU (if a high 
> end CPU) for the parity calculation on RAID5.
> 
> These days it seems that the overhead from the parity calculations are 
> so small that they become insignificant.

I fully agree here.

Even on a not so fresh desktop CPU (Intel Core2 Quad CPU Q9550 at
2.83GHz) I see this in the kernel logs:

...
[   15.944466] xor: measuring software checksum speed
[   15.983008]    prefetch64-sse: 11592.000 MB/sec
[   16.020008]    generic_sse: 10232.000 MB/sec
[   16.045623] xor: using function: prefetch64-sse (11592.000 MB/sec)
...

So for each percent of CPU bandwith I offer I get 115 MB/s bandwith
for parity calculations.  None of the RAID arrays I have running would
ever need even close to 10 % of my CPU (in theory, at least).

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I can't say I've ever been lost, but I was bewildered once for  three
days.                                     - Daniel Boone (Attributed)
