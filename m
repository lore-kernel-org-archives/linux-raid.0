From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 12:21:48 +0100
Message-ID: <57A719CC.6080301@youngman.org.uk>
References: <57A69012.1010406@youngman.org.uk>
 <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/16 10:54, Mikael Abrahamsson wrote:
> On Sun, 7 Aug 2016, Wols Lists wrote:
> 
>> I also can't run the array :-(
> 
> What does "cat /proc/mdstat" say?

The vm is shut down right now, but it said inactive, four drives,
[UUU_], iirc. I'll post it when I get it back up. Didn't mention raid
type, so that could be messed up somewhere.

Two drives are mirrored, it should be rebuilding on to third, and a
fourth is spare (ready to rebuild into raid6)
> 
> Have you tried "--continue"?
> 
The last paragraph before the one you quoted said "yes". Actually,
multiple times.

Cheers,
Wol
