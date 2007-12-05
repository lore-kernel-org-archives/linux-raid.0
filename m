From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid6 check/repair
Date: Wed, 05 Dec 2007 15:31:14 -0500
Message-ID: <47570A92.1090307@tmr.com>
References: <474431BF.30103@ph.tum.de>	<18244.64972.172685.796502@notabene.brown>	<4745B375.4030500@ph.tum.de>	<18254.21949.441607.134763@notabene.brown>	<474F4880.8080300@eyal.emu.id.au>	<47502140.1080601@ph.tum.de>	<1196650421.14411.10.camel@elara.tcw.local>	<47546019.5030300@ph.tum.de> <18261.49547.588360.436369@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18261.49547.588360.436369@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:
> [ ... on RAID1, ... RAID6 error recovery ... ]
>
> tn> The use case for the proposed 'repair' would be occasional,
> tn> low-frequency corruption, for which many sources can be
> tn> imagined:
>
> tn> Any piece of hardware has a certain failure rate, which may
> tn> depend on things like age, temperature, stability of
> tn> operating voltage, cosmic rays, etc. but also on variations
> tn> in the production process.  Therefore, hardware may suffer
> tn> from infrequent glitches, which are seldom enough, to be
> tn> impossible to trace back to a particular piece of equipment.
> tn> It would be nice to recover gracefully from that.
>
> What has this got to do with RAID6 or RAID in general? I have
> been following this discussion with a sense of bewilderment as I
> have started to suspect that parts of it are based on a very
> large misunderstanding.
>
> tn> Kernel bugs or just plain administrator mistakes are another
> tn> thing.
>
> The biggest administrator mistakes are lack of end-to-end checking
> and backups. Those that don't have them wish their storage systems
> could detect and recover from arbitrary and otherwise undetected
> errors (but see below for bad news on silent corruptions).
>
> tn> But also the case of power-loss during writing that you have
> tn> mentioned could profit from that 'repair': With heterogeneous
> tn> hardware, blocks may be written in unpredictable order, so
> tn> that in more cases graceful recovery would be possible with
> tn> 'repair' compared to just recalculating parity.
>
> Redundant RAID levels are designed to recover only from _reported_
> errors that identify precisely where the error is. Recovering from
> random block writing is something that seems to me to be quite
> outside the scope of a low level virtual storage device layer.
>
> ms> I just want to give another suggestion. It may or may not be
> ms> possible to repair inconsistent arrays but in either way some
> ms> code there MUST at least warn the administrator that
> ms> something (may) went wrong.
>
> tn> Agreed.
>
> That sounds instead quite extraordinary to me because it is not
> clear how to define ''inconsistency'' in the general case never
> mind detect it reliably, and never mind knowing when it is found
> how to determine which are the good data bits and which are the
> bad.
>
> Now I am starting to think that this discussion is based on the
> curious assumption that storage subsystems should solve the so
> called ''byzantine generals'' problem, that is to operate reliably
> in the presence of unreliable communications and storage.
>   
I had missed that. In fact, after rereading most of the thread I *still* 
miss that, so perhaps it's not there. What the OP proposed was that in 
the case where there is incorrect data on exactly one chunk in a raid-6 
slice that the incorrect chunk be identified and rewritten with correct 
data. This is based on the assumptions that (a) this case can be 
identified, (b) the correct data value for the chunk can be calculated, 
(c) this only adds processing or i/o overhead when an error condition is 
identified by the existing code, and (d) this can be done without 
significant additional i/o other than rewriting the corrected data.

Given these assumptions the reasons for not adding this logic would seem 
to be (a) one of the assumptions is wrong, (b) it would take a huge 
effort to code or maintain, or (c) it's wrong for raid to fix errors 
other than hardware, even if it could do so. Although I've looked at the 
logic in metadata form, and the code for doing the check now, I realize 
that the assumptions could be wrong, and invite enlightenment. But 
Thiemo posted metacode which I find appears correct, so I don't think 
it's a huge job to code, and since it is in a code path which currently 
always hides an error, it's hard to understand how added code could make 
things worse than they are.

I can actually see the philosophical argument about doing only disk 
errors in raid code, but at least it should be a clear decision made for 
that reason, and not hidden by arguments that this happens rarely. Given 
the state of current hardware, I think virtually all errors happen 
rarely, the problem is that all problems happen occasionally (ref. 
Murphy's Law). We have a tool (check) which finds these problems, why 
not a tools to fix them?

BTW: if this can be done in a user program, mdadm, rather than by code 
in the kernel, that might well make everyone happy. Okay, realistically 
"less unhappy."

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


