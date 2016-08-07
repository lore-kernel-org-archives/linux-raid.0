From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 17:50:36 +0100
Message-ID: <57A766DC.4000207@youngman.org.uk>
References: <57A69012.1010406@youngman.org.uk>
 <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
 <57A719CC.6080301@youngman.org.uk> <57A724ED.5070808@youngman.org.uk>
 <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/16 15:31, Mikael Abrahamsson wrote:
> On Sun, 7 Aug 2016, Wols Lists wrote:
> 
> Please --stop it, then --assemble with verbose output and include output
> from that command plus anything in dmesg at the same time. What happens
> when you then try to --run it?
> 
Output below ...


kanga:/home/anthony/mdadm # ./mdadm --stop /dev/md127
mdadm: stopped /dev/md127
kanga:/home/anthony/mdadm # mdadm -v --assemble /dev/md127 /dev/sdb
/dev/sdc /dev/sdd /dev/sde
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdd is identified as a member of /dev/md127, slot -1.
mdadm: /dev/sde is identified as a member of /dev/md127, slot 2.
mdadm: added /dev/sdc to /dev/md127 as 1
mdadm: added /dev/sde to /dev/md127 as 2
mdadm: added /dev/sdd to /dev/md127 as -1
mdadm: added /dev/sdb to /dev/md127 as 0
mdadm: failed to RUN_ARRAY /dev/md127: Invalid argument
kanga:/home/anthony/mdadm #



[17372.305472] md: md127 stopped.
[17372.305483] md: unbind<sdc>
[17372.312124] md: export_rdev(sdc)
[17372.312198] md: unbind<sde>
[17372.317792] md: export_rdev(sde)
[17372.317868] md: unbind<sdb>
[17372.320344] md: export_rdev(sdb)
[17431.701768] md: md127 stopped.
[17431.710474] md: bind<sdc>
[17431.711203] md: bind<sde>
[17431.712843] md: bind<sdd>
[17431.713735] md: bind<sdb>
[17431.752149] md/raid:md127: reshape_position too early for
auto-recovery - aborting.
[17431.752155] md: pers->run() failed ...
[17431.752289] md: md127 stopped.
[17431.752297] md: unbind<sdb>
[17431.760544] md: export_rdev(sdb)
[17431.760602] md: unbind<sdd>
[17431.772124] md: export_rdev(sdd)
[17431.772144] md: unbind<sde>
[17431.780125] md: export_rdev(sde)
[17431.780144] md: unbind<sdc>
[17431.792163] md: export_rdev(sdc)
[17431.909807] md: bind<sde>
[17431.942187] md: bind<sdc>
[17431.962809] md: bind<sdd>
[17431.989609] md: bind<sdb>
[17432.026378] md/raid:md127: reshape_position too early for
auto-recovery - aborting.
[17432.026385] md: pers->run() failed ...
anthony@kanga:/mnt/anthony>


